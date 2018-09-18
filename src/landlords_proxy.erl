%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 六月 2018 15:59
%%%-------------------------------------------------------------------
-module(landlords_proxy).
-auth("cw").

-behaviour(gen_server).

-include("server.hrl").
-include("logger.hrl").

-export([start_link/1]).

-export([
	init/1,
	handle_call/3,
	handle_cast/2,
	handle_info/2,
	terminate/2,
	code_change/3]).


start_link(Args) ->
	gen_server:start_link(?MODULE, Args, []).

init(Args) ->
	erlang:process_flag(trap_exit, true),
	State = Args#proxy_state{node = node(), pid = self()},
	Uid = Args#proxy_state.uid,
	case register_proxy(State) of
		{ok, NewState} ->
			?DEBUG("start proxy, uid : ~p~n", [Uid]),
			{ok, NewState, ?HIBERNATE_TIMEOUT};
		{error, Reason} ->
			?ERROR("start proxy error Uid:~p Reason:~p", [Uid, Reason]),
			{stop, {shutdown, Reason}}
	end.

%% ==================================================================================
-spec handle_info(Info :: timeout | term(), State :: term()) -> Result when
	Result :: {noreply, NewState}
	| {noreply, NewState, Timeout}
	| {noreply, NewState, hibernate}
	| {stop, Reason :: term(), NewState},
	NewState :: term(),
	Timeout :: non_neg_integer() | infinity.
%% ==================================================================================
handle_call({get_all_client_pid, Uid}, _From, State) ->
	Reply = get_all_client_pid(Uid, State),
	{reply, Reply, State};
handle_call(Request, _From, State) ->
	?WARNING("unknow call  Request ~p", [Request]),
	{reply, ok, State, ?HIBERNATE_TIMEOUT}.


handle_cast({register_client, Client}, State) when is_record(Client, proxy_client) ->
	NewState = register_client(Client, State),
	{noreply, NewState, ?HIBERNATE_TIMEOUT};
handle_cast({unregister_client, Uid, Pid}, State) ->
	NewState = unregister_client(Uid, Pid, State),
	{noreply, NewState, ?HIBERNATE_TIMEOUT};
handle_cast(Msg, State) ->
	?WARNING("Unknown Msg:~p", [Msg]),
	{noreply, State, ?HIBERNATE_TIMEOUT}.

handle_info({'EXIT', Pid, Reason}, State) ->
	?WARNING("proxy pid ~p exit with reason:~p", [Pid, Reason]),
	{stop, normal, State};
handle_info(Info, State) ->
	?WARNING("Unknown Msg Info:~p", [Info]),
	{noreply, State, ?HIBERNATE_TIMEOUT}.


%% ==================================================================================
-spec terminate(Reason, State :: term()) -> Any :: term() when
	Reason :: normal
	| shutdown
	| {shutdown, term()}
	| term().
%% ==================================================================================
terminate(Reason, State) ->
	?INFO("stop proxy Reason:~p", [Reason]),
	landlords_redis:del_proxy(State#proxy_state.uid),
	ok.

%% ==================================================================================
-spec code_change(OldVsn, State :: term(), Extra :: term()) -> Result when
	Result :: {ok, NewState :: term()} | {error, Reason :: term()},
	OldVsn :: Vsn | {down, Vsn},
	Vsn :: term().
%% ==================================================================================
code_change(_OldVsn, State, _Extra) ->
	{ok, State}.


register_proxy(State) ->
	#proxy_state{uid = Uid, node = Node, pid = Pid} = State,
	landlords_redis:set_proxy(Uid, Node, Pid),
	landlords_ets:set_proxy(State).

unregister_client(Uid, Pid, State) ->
	NewClientL = lists:foldl(
		fun(Client, Acc) ->
			case Client#proxy_client.pid == Pid of
				true ->
					[Client#proxy_client{pid = undefined} | Acc];
				_ ->
					Acc
			end
		end,
		[], State#proxy_state.client),
	landlords_ets:update_proxy(Uid, {#proxy_state.client, NewClientL}),
	State#proxy_state{client = NewClientL}.

%% 如果device存在过，需要替换旧client，如果不存在则直接把新client添加进去
register_client(Client, State) when Client#proxy_client.pid /= undefined ->
	case mod_proc:is_proc_alive(Client#proxy_client.pid) of
		true ->
			CliL =
				lists:foldl(
					fun(Cli, Acc) ->
						if
							Cli#proxy_client.device == Client#proxy_client.device ->
								Acc;
							true ->
								[Cli | Acc]
						end
					end, [], State#proxy_state.client),
			NewClientL = [Client | CliL],
			landlords_ets:update_proxy(State#proxy_state.uid, {#proxy_state.client, NewClientL}),
			State#proxy_state{client = NewClientL};
		_Error ->
			?DEBUG("fail update client , pid ~p unalive!~n", [Client#proxy_state.pid]),
			State
	end;
register_client(Client, State) ->
	CliL =
		lists:foldl(
			fun(Cli, Acc) ->
				if
					Cli#proxy_client.device == Client#proxy_client.device ->
						Acc;
					true ->
						[Cli | Acc]
				end
			end, [], State#proxy_state.client),
	NewClientL = [Client | CliL],
	landlords_ets:update_proxy(State#proxy_state.uid, {#proxy_state.client, NewClientL}),
	State#proxy_state{client = NewClientL}.


%% 获取所有连接pid，顺便检查死掉的连接
get_all_client_pid(Uid, State) ->
	if
		Uid == State#proxy_state.uid ->
			lists:foldl(
				fun(Client, Acc) when is_pid(Client#proxy_client.pid) ->
					case mod_proc:is_proc_alive(Client#proxy_client.pid) of
						true ->
							[Client#proxy_client.pid | Acc];
						false ->
							self() ! {client_update, Client#proxy_client{pid = undefined}},
							Acc
					end;
					(_, Acc) ->
						Acc
				end, [], State#proxy_state.client);
		true ->
			undefined
	end.
















