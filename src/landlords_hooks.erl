%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 7. 九月 2018 11:34
%%%-------------------------------------------------------------------
-module(landlords_hooks).
-auth("cw").

-behaviour(gen_server).

-include("common.hrl").
-include("logger.hrl").

-export([
	start_link/0,
	add/1,
	delete/1,
	delete_all_hooks/0,
	run/2,
	run/3
]).

-export([
	init/1,
	handle_call/3,
	handle_cast/2,
	handle_info/2,
	terminate/2,
	code_change/3]).

-record(hooks_state, {}).

%%%----------------------------------------------------------------------
%%% API
%%%----------------------------------------------------------------------
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

add({Hook, Function, Seq}) when is_function(Function) ->
	add({Hook, global, undefined, Function, Seq});
add({Hook, Node, Function, Seq}) when is_function(Function) ->
	add({Hook, Node, undefined, Function, Seq});
add({Hook, Module, Function, Seq}) ->
	add({Hook, global, Module, Function, Seq});
add({Hook, Node, Module, Function, Seq}) ->
	gen_server:call(landlords_hooks, {add, Hook, Node, Module, Function, Seq}).


%% @doc See del/4.
delete({Hook, Function, Seq}) when is_function(Function) ->
	delete({Hook, global, undefined, Function, Seq});
delete({Hook, Node, Function, Seq}) when is_function(Function) ->
	delete({Hook, Node, undefined, Function, Seq});
delete({Hook, Module, Function, Seq}) ->
	delete({Hook, global, Module, Function, Seq});
delete({Hook, Node, Module, Function, Seq}) ->
	gen_server:call(landlords_hooks, {delete, Hook, Node, Module, Function, Seq}).


-spec delete_all_hooks() -> true.
%% @doc Primarily for testing / instrumentation
delete_all_hooks() ->
	gen_server:call(landlords_hooks, {delete_all}).

-spec run(atom(), list()) -> ok.
%% @doc Run the calls of this hook in order, don't care about function results.
%% If a call returns stop, no more calls are performed.
run(Hook, Args) ->
	run(Hook, global, Args).

run(Hook, Node, Args) ->
	case ets:lookup(hooks, {Hook, Node}) of
		[{_, Ls}] ->
			run1(Ls, Hook, Args);
		[] ->
			ok
	end.


%%%----------------------------------------------------------------------
%%% Callback functions from gen_server
%%%----------------------------------------------------------------------
init([]) ->
	ets:new(hooks, [named_table, {read_concurrency, true}]),
	spawn(fun() -> register_hooks() end),
	{ok, #hooks_state{}}.

register_hooks() ->
	lib_time:sleep(2000),
	lists:foreach(fun(Hooks) -> add(Hooks) end, ?HOOKS_LIST).

handle_call({add, Hook, Node, Module, Function, Seq}, _From, State) ->
	HookFormat = {Seq, Module, Function},
	Reply = handle_add(Hook, Node, HookFormat),
	{reply, Reply, State};
handle_call({add, Hook, Node, Node, Module, Function, Seq}, _From, State) ->
	HookFormat = {Seq, Node, Module, Function},
	Reply = handle_add(Hook, Node, HookFormat),
	{reply, Reply, State};
handle_call({delete, Hook, Node, Module, Function, Seq}, _From, State) ->
	HookFormat = {Seq, Module, Function},
	Reply = handle_delete(Hook, Node, HookFormat),
	{reply, Reply, State};
handle_call({delete, Hook, Node, Node, Module, Function, Seq}, _From, State) ->
	HookFormat = {Seq, Node, Module, Function},
	Reply = handle_delete(Hook, Node, HookFormat),
	{reply, Reply, State};
handle_call({delete_all}, _From, State) ->
	Reply = ets:delete_all_objects(hooks),
	{reply, Reply, State};
handle_call(Request, _From, State) ->
	?DEBUG("unrecognized request type: ~p~n", [Request]),
	Reply = ok,
	{reply, Reply, State}.

handle_cast(Msg, State) ->
	?DEBUG("unrecognized msg type: ~p~n", [Msg]),
	{noreply, State}.

handle_info(Info, State) ->
	?DEBUG("unrecognized msg type: ~p~n", [Info]),
	{noreply, State}.

%%----------------------------------------------------------------------
%% Func: terminate/2
%% Purpose: Shutdown the server
%% Returns: any (ignored by gen_server)
%%----------------------------------------------------------------------
terminate(_Reason, _State) ->
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.


%%%----------------------------------------------------------------------
%%% Internal functions
%%%----------------------------------------------------------------------
%% 在目标节点执行hooks，如果失败执行下一条
-spec run1([local_hook()|distributed_hook()], atom(), list()) -> ok.
run1([], _Hook, _Args) ->
	ok;
run1([{_Seq, Node, Module, Function} | Ls], Hook, Args) ->
	%% MR: Should we have a safe rpc, like we have a safe apply or is bad_rpc enough ?
	case rpc:call(Node, Module, Function, Args, 5000) of
		timeout ->
			?ERROR("Timeout on RPC to ~p~nrunning hook: ~p",
				[Node, {Hook, Args}]),
			run1(Ls, Hook, Args);
		{badrpc, Reason} ->
			?ERROR("Bad RPC error to ~p: ~p~nrunning hook: ~p",
				[Node, Reason, {Hook, Args}]),
			run1(Ls, Hook, Args);
		stop ->
			?INFO("~nThe process ~p in node ~p ran a hook in node ~p.~n"
			"Stop.", [self(), node(), Node]), % debug code
			ok;
		Res ->
			?INFO("~nThe process ~p in node ~p ran a hook in node ~p.~n"
			"The response is:~n~s", [self(), node(), Node, Res]), % debug code
			run1(Ls, Hook, Args)
	end;
run1([{_Seq, Module, Function} | Ls], Hook, Args) ->
	Res = safe_apply(Hook, Module, Function, Args),
	case Res of
		'EXIT' ->
			run1(Ls, Hook, Args);
		stop ->
			ok;
		_ ->
			run1(Ls, Hook, Args)
	end.


safe_apply(Hook, Module, Function, Args) ->
	try if is_function(Function) ->
		apply(Function, Args);
				true ->
					?DEBUG("=========== ~p, ~p, ~p~n~n", [Module, Function, Args]),
					Module:Function(Args)
					%apply(Module, Function, Args)
			end
	catch E:R when E /= exit; R /= normal ->
		?ERROR("Hook ~p crashed when running ~p:~p/~p:~n"
		"** Reason = ~p~n"
		"** Arguments = ~p",
			[Hook, Module, Function, 1, {E, R, get_stacktrace()}, Args]),
		'EXIT'
	end.

-spec handle_add(atom(), atom(), local_hook() | distributed_hook()) -> ok.
%% in-memory storage operation: Handle adding hook in ETS table
handle_add(Hook, Node, El) ->
	case ets:lookup(hooks, {Hook, Node}) of
		[{_, Ls}] ->
			case lists:member(El, Ls) of
				true ->
					ok;
				false ->
					NewLs = lists:merge(Ls, [El]),
					ets:insert(hooks, {{Hook, Node}, NewLs}),
					ok
			end;
		[] ->
			NewLs = [El],
			ets:insert(hooks, {{Hook, Node}, NewLs}),
			ok
	end.

-type local_hook() :: {Seq :: integer(), Module :: atom(), Function :: atom()}.
-type distributed_hook() :: {Seq :: integer(), Node :: atom(), Module :: atom(), Function :: atom()}.
-spec handle_delete(atom(), atom(), local_hook() | distributed_hook()) -> ok.
%% in-memory storage operation: Handle deleting hook from ETS table
handle_delete(Hook, Node, El) ->
	case ets:lookup(hooks, {Hook, Node}) of
		[{_, Ls}] ->
			NewLs = lists:delete(El, Ls),
			ets:insert(hooks, {{Hook, Node}, NewLs}),
			ok;
		[] ->
			ok
	end.

get_stacktrace() ->
	[{Mod, Fun, Loc, Args} || {Mod, Fun, Args, Loc} <- erlang:get_stacktrace()].









