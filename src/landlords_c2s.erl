%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 六月 2018 11:56
%%%-------------------------------------------------------------------
-module(landlords_c2s).
-auth("cw").

-behaviour(gen_fsm).

-include("server.hrl").
-include("logger.hrl").
-include("protobuf_pb.hrl").

-define(FSMOPTS, [{debug, [trace]}]).

-export([
	start/2,
	stop/1,
	start_link/2,
	close/1,
	init/1,
	handle_event/3,
	handle_info/3,
	handle_sync_event/4,
	terminate/3,
	code_change/4
]).


-export([
	wait_for_auth/2,
	wait_for_resume/2,
	session_established/2,
	tcp_send/3
]).

%%%----------------------------------------------------------------------
%%% API
%%%----------------------------------------------------------------------
start(SockData, _Opts) ->
	gen_fsm:start(?MODULE, [SockData], []).

start_link(SockData, _Opts) ->
	gen_fsm:start_link(?MODULE, [SockData], []).

stop(FsmRef) -> gen_fsm:send_event(FsmRef, stop).
close(FsmRef) -> gen_fsm:send_event(FsmRef, closed).


%% ----------------------------------------------------------------
%% GEN_FSM API
%% ----------------------------------------------------------------
init([]) ->
	{ok, undefined};
init([{SockMod, Socket, _SockPid}]) ->
	{ok, {Address, Port}} = inet:peername(Socket),
	StateData = #client_state{
		status = ?LOGGING,
		node = node(),
		socket = Socket,
		ip = Address,
		port = Port,
		sockmod = SockMod,
		retry_times = 0},
	{ok, wait_for_auth, StateData, ?AUTH_TIMEOUT}.


wait_for_auth(#requestlogon{
	mt = 102,
	mid = Mid,
	sig = ?SIGN1,
	timestamp = Timestamp,
	data = Data} = _AuthData, StateData) ->
	#userdata{
		uid = Uid,
		phone = Phone,
		token = Token,
		device = Device,
		device_id = DeviceId,
		version = Vsn,
		app_id = AppId} = Data,
	IsOverTime = not check_msg_timestamp(Timestamp),

	case IsOverTime of
		false ->
			case mod_proxy:get_proxy(Uid) of
				{_Node, ProxyPid} when is_pid(ProxyPid) ->
					mod_proxy:register_client(ProxyPid, Uid, Device, Token),
					UserData = #user_data{
						uid = Uid,
						nickname = <<"晴天">>,
						level = 0,
						version = Vsn,
						device = Device,
						device_id = DeviceId,
						app_id = AppId,
						token = Token,
						location = <<"北京">>,
						login_time = lib_time:get_mstimestamp(),
						phone = Phone
					},
					NewStateData = StateData#client_state{
						uid = Uid,
						proxy = ProxyPid,
						pid = self(),
						node = node(),
						user_data = UserData},
					Reply = mod_msg:produce_responselogon(Mid, ?ERROR_0),
					tcp_send(StateData#client_state.sockmod, StateData#client_state.socket, Reply),
					fsm_next_state(session_established, NewStateData);
				_ ->
					Reply = mod_msg:produce_responselogon(Mid, ?ERROR_100),
					tcp_send(StateData#client_state.sockmod, StateData#client_state.socket, Reply),
					fsm_next_state(wait_for_auth, StateData)
			end;
		_ ->
			Reply = mod_msg:produce_responselogon(Mid, ?ERROR_102),
			tcp_send(StateData#client_state.sockmod, StateData#client_state.socket, Reply),
			fsm_next_state(wait_for_auth, StateData)
	end;
wait_for_auth(timeout, StateData) ->
	?INFO("-----------------~n", []),
	{stop, normal, StateData};
wait_for_auth(closed, StateData) ->
	{stop, normal, StateData};
wait_for_auth(stop, StateData) ->
	{stop, normal, StateData}.


session_established(#logonsuccess{
	mt = 104,
	sig = ?SIGN1,
	data = ?ERROR_0}, StateData) ->
	%% 更新增量
	landlords_hooks:run(update_session_established, node(), StateData),

	fsm_next_state(session_established, StateData);
session_established(timeout, StateData) ->
	fsm_next_state(session_established, StateData);
session_established(closed, StateData) ->
	{stop, normal, StateData};
session_established(stop, StateData) ->
	{stop, normal, StateData}.

%% session success
wait_for_resume(#sessionsuccess{
	mt = 106,
	sig = ?SIGN1,
	data = ?ERROR_0}, StateData) ->

	fsm_next_state(wait_for_resume, StateData#client_state{status = online});
wait_for_resume(timeout, StateData) ->
	?DEBUG("Timed out waiting for resumption", []),
	{stop, normal, StateData};
wait_for_resume(Event, StateData) ->
	?DEBUG("Ignoring event while waiting for resumption: ~p", [Event]),
	fsm_next_state(wait_for_resume, StateData).



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
	#client_state{
		uid = Uid,
		proxy = ProxyPid,
		socket = Socket,
		sockmod = SockMod} = StateData,
	?INFO("gen_fsm for ~p terminate, reason: ~p~n", [Uid, Reason]),
	case mod_proc:is_proc_alive(ProxyPid) of
		true ->
			mod_proxy:unregister_client(ProxyPid, Uid);
		_ ->
			ok
	end,
	SockMod:close(Socket),
	ok.

code_change(_OldVsn, StateName, StateData, _Extra) ->
	?INFO("Module ~p changed ...~n", [?MODULE]),
	{ok, StateName, StateData}.

tcp_send(Mod, Socket, Reply) ->
	{ok, EReply} = mod_proto:packet(Reply),
	?DEBUG("~p~n",[EReply]),
	Mod:send(Socket, EReply).


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
	{next_state, StateName, StateData, ?HIBERNATE_TIMEOUT}.

%% fsm_reply: Generate the reply FSM tuple with different timeout,
%% depending on the future state
fsm_reply(Reply, session_established, StateData) ->
	{reply, Reply, session_established, StateData, ?TIMEOUT};
fsm_reply(Reply, StateName, StateData) ->
	{reply, Reply, StateName, StateData, ?TIMEOUT}.



check_msg_timestamp(Timestamp) ->
	MsTimestamp = lib_time:get_mstimestamp(),
	Timestamp + ?DATA_OVERTIME > MsTimestamp.











