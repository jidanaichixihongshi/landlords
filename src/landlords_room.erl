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
%%% Created : 28. 九月 2018 18:56
%%%-------------------------------------------------------------------
-module(landlords_room).
-auth("cw").

-behaviour(gen_fsm).

-include("server.hrl").
-include("logger.hrl").
-include("protobuf_pb.hrl").

-define(FSMOPTS, [{debug, [trace]}]).

-export([
	start_link/1,
	init/1,
	handle_event/3,
	handle_info/3,
	handle_sync_event/4,
	terminate/3,
	code_change/4
]).


-export([
	wait_for_join/2,
	wait_for_start/2,
	wait_for_loot/2,
	wait_for_play/2,
	wait_for_continue/2,
	wait_for_next/2
]).

%%%----------------------------------------------------------------------
%%% API
%%%----------------------------------------------------------------------
start_link(Args) ->
	gen_fsm:start_link(?MODULE, Args, []).


%% ----------------------------------------------------------------
%% GEN_FSM API
%% ----------------------------------------------------------------
init([]) ->
	{ok, undefined};
init([Args]) ->
	StateData = Args#room_state{
		grade = #{}},
	{ok, wait_for_join, StateData, ?ROOM_TICK_TIME}.


wait_for_join(Msg, StateData) ->
	fsm_next_state(wait_for_join, StateData);
wait_for_join(timeout, StateData) ->
	fsm_next_state(wait_for_join, StateData);
wait_for_join(closed, StateData) ->
	{stop, normal, StateData};
wait_for_join(stop, StateData) ->
	{stop, normal, StateData}.



wait_for_start(Msg, StateData) ->
	fsm_next_state(wait_for_start, StateData);
wait_for_start(timeout, StateData) ->
	fsm_next_state(wait_for_start, StateData);
wait_for_start(closed, StateData) ->
	{stop, normal, StateData};
wait_for_start(stop, StateData) ->
	{stop, normal, StateData}.


wait_for_loot(Msg, StateData) ->
	fsm_next_state(wait_for_play, StateData);
wait_for_loot(closed, StateData) ->
	{stop, normal, StateData};
wait_for_loot(stop, StateData) ->
	{stop, normal, StateData}.


wait_for_play(Msg, StateData) ->
	fsm_next_state(wait_for_play, StateData);
wait_for_play(closed, StateData) ->
	{stop, normal, StateData};
wait_for_play(stop, StateData) ->
	{stop, normal, StateData}.


wait_for_continue(Msg, StateData) ->
	fsm_next_state(wait_for_play, StateData);
wait_for_continue(closed, StateData) ->
	{stop, normal, StateData};
wait_for_continue(stop, StateData) ->
	{stop, normal, StateData}.


wait_for_next(Msg, StateData) ->
	fsm_next_state(wait_for_next, StateData);
wait_for_next(closed, StateData) ->
	{stop, normal, StateData};
wait_for_next(stop, StateData) ->
	{stop, normal, StateData}.




handle_event(Event, StateName, StateData) ->
	?WARNING("undefined event : ~p~n", [Event]),
	fsm_next_state(StateName, StateData).

handle_sync_event(_Event, _From, StateName, StateData) ->
	fsm_reply(ok, StateName, StateData).

handle_info(receive_ack, StateName, StateData) ->
	fsm_next_state(StateName, StateData);
handle_info({fsm_next_state, NewStateName}, _StateName, StateData) ->
	fsm_next_state(NewStateName, StateData);
handle_info(Event, StateName, StateData) ->
	?WARNING("undefined event : ~p~n", [Event]),
	fsm_next_state(StateName, StateData).


terminate(Reason, _StateName, StateData) ->
	ok.

code_change(_OldVsn, StateName, StateData, _Extra) ->
	?INFO("Module ~p code changed ...~n", [?MODULE]),
	{ok, StateName, StateData}.



%% ----------------------------------------------------------------
%% internal api
%% ----------------------------------------------------------------
%% fsm_next_state: Generate the next_state FSM tuple with different
%% timeout, depending on the future state
fsm_next_state(session_established, StateData) ->
	{next_state, session_established, StateData, ?AUTH_TIMEOUT};
fsm_next_state(wait_for_auth, #client_state{retry_times = TetryTimes} = StateData) when TetryTimes >= 1 ->
	{stop, normal, StateData};
fsm_next_state(wait_for_auth, #client_state{retry_times = TetryTimes} = StateData) ->
	{next_state, wait_for_auth, StateData#client_state{retry_times = TetryTimes + 1}, ?AUTH_TIMEOUT};

fsm_next_state(StateName, StateData) ->
	{next_state, StateName, StateData, ?ROOM_TICK_TIME}.

%% fsm_reply: Generate the reply FSM tuple with different timeout,
%% depending on the future state
fsm_reply(Reply, session_established, StateData) ->
	{reply, Reply, session_established, StateData, ?TIMEOUT};
fsm_reply(Reply, StateName, StateData) ->
	{reply, Reply, StateName, StateData, ?TIMEOUT}.














