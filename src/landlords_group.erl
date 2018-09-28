%%%-------------------------------------------------------------------
%%% * ━━━━━━神兽出没━━━━━━
%%% * 　　　┏┓　　　┏┓
%%% * 　　┏┛┻━━━┛┻┓
%%% * 　　┃　　　　　　　┃
%%% * 　　┃　　　━　　　┃
%%% * 　　┃　┳┛　┗┳　┃
%%% * 　　┃　　　　　　　┃
%%% * 　　┃　　　┻　　　┃
%%% * 　　┃　　　　　　　┃
%%% * 　　┗━┓　　　┏━┛
%%% * 　　　　┃　　　┃ 神兽保佑
%%% * 　　　　┃　　　┃ 代码无bug　　
%%% * 　　　　┃　　　┗━━━┓
%%% * 　　　　┃　　　　　　　┣┓
%%% * 　　　　┃　　　　　　　┏┛
%%% * 　　　　┗┓┓┏━┳┓┏┛
%%% * 　　　　　┃┫┫　┃┫┫
%%% * 　　　　　┗┻┛　┗┻┛
%%% * ━━━━━━感觉萌萌哒━━━━━━
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 六月 2018 15:59
%%%-------------------------------------------------------------------
-module(landlords_group).
-auth("cw").

-behaviour(gen_server).

-include("group.hrl").
-include("logger.hrl").


-export([start_link/1]).

-export([
	init/1,
	handle_call/3,
	handle_cast/2,
	handle_info/2,
	terminate/2,
	code_change/3]).

-define(HIBERNATE_TIMEOUT, 90000).

start_link(Args) ->
	gen_server:start_link(?MODULE, Args, []).

init(Args) ->
	erlang:process_flag(trap_exit, true),
	State = Args#group_state{setting = #{}, node = node(), pid = self(), out_tick = 0},
	case register_group(State) of
		{ok, NewState} ->
			?DEBUG("start group, gid : ~p~n", [Args#group_state.gid]),
			{ok, NewState, ?HIBERNATE_TIMEOUT};
		{error, Reason} ->
			?ERROR("start group error Gid:~p Reason:~p", [Args#group_state.gid, Reason]),
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
handle_call(Request, _From, State) ->
	?WARNING("unknow call  Request ~p", [Request]),
	{reply, ok, State, ?HIBERNATE_TIMEOUT}.


handle_cast({set, Arg}, State) ->
	NewState = mod_group_handle:set_group(Arg, State),
	{noreply, NewState, ?HIBERNATE_TIMEOUT};
handle_cast({add_group, Uid}, State) ->
	mod_group_handle:add_group(Uid, State),
	{noreply, State, ?HIBERNATE_TIMEOUT};
handle_cast({leave_group, Uid}, State) ->
	mod_group_handle:leave_group(Uid, State),
	{noreply, State, ?HIBERNATE_TIMEOUT};
handle_cast({group_session, Arg}, #group_state{gid = Gid} = State) ->
	UidList =
		if
			Arg == all ->
				mod_group:get_group_members(Gid);
			true ->
				Arg
		end,
	mod_group_handle:group_session(UidList, State),
	{noreply, State, ?HIBERNATE_TIMEOUT};
handle_cast(Msg, State) ->
	?WARNING("Unknown Msg:~p", [Msg]),
	{noreply, State, ?HIBERNATE_TIMEOUT}.


handle_info({chat, Msg}, State) ->
	mod_group_handle:handle_msg(Msg, State),
	{noreply, State, ?HIBERNATE_TIMEOUT};
handle_info(timeout, #group_state{out_tick = OutTick} = State) ->
	if
		OutTick > 10 ->
			{stop, timeout, State};
		true ->
			NewState = State#group_state{out_tick = OutTick + 1},
			{noreply, NewState, ?HIBERNATE_TIMEOUT}
	end;
handle_info({'EXIT', _Pid, Reason}, State) ->
	?WARNING("group ~p exit with reason:~p", [State#group_state.gid, Reason]),
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
	Gid = State#group_state.gid,
	?INFO("stop group, Reason:~p", [Reason]),
	landlords_ets:del_group(Gid),
	landlords_redis:del_group(Gid),
	ok.

%% ==================================================================================
-spec code_change(OldVsn, State :: term(), Extra :: term()) -> Result when
	Result :: {ok, NewState :: term()} | {error, Reason :: term()},
	OldVsn :: Vsn | {down, Vsn},
	Vsn :: term().
%% ==================================================================================
code_change(OldVsn, State, _Extra) ->
	?INFO("~p code change, oldvsn ~p ...~n", [?MODULE, OldVsn]),
	{ok, State}.


%% --------------------------------------------------------------------------------------
%% internal api
%% --------------------------------------------------------------------------------------
register_group(State) ->
	#group_state{gid = Gid, node = Node, pid = Pid} = State,
	landlords_redis:set_group(Gid, Node, Pid),
	landlords_ets:set_group(State).

















