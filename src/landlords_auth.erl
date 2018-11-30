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
%%% Created : 23. 六月 2018 11:56
%%%-------------------------------------------------------------------
-module(landlords_auth).
-auth("cw").

-behaviour(gen_fsm).

-include("server.hrl").
-include("logger.hrl").
-include("protobuf_pb.hrl").

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
		status = ?STATUS_LOGGING,
		pid = self(),
		node = node(),
		socket = Socket,
		ip = Address,
		port = Port,
		sockmod = SockMod,
		retry_times = 0},
	{ok, wait_for_auth, StateData, ?AUTH_TIMEOUT}.


wait_for_auth(#proto{mt = ?MT_103, sig = ?SIGN1, router = Router, data = Data, ts = Timestamp},
	#client_state{sockmod = SockMod, socket = Socket} = StateData) ->
	TData = binary_to_term(Data),
	Child = binary_to_term(TData#data.children),
	#request{rt = <<"1">>, rm = BinRm} = Child,
	RMaps = lib_change:to_maps(binary_to_term(BinRm)),
	#{uid := Uid,
		device := Device,
		token := Token,
		vsn := Vsn,
		deviceid := DeviceId,
		appid := AppId,
		location := Location,
		phone := Phone} = RMaps,
	NotOverTime = mod_msg:check_msg_timestamp(Timestamp),
	case NotOverTime of
		true ->
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
						location = Location,
						phone = Phone
					},
					NewStateData = StateData#client_state{
						uid = Uid,
						proxy = ProxyPid,
						pid = self(),
						node = node(),
						user_data = UserData},
					reply_auth(Uid, SockMod, Socket, Router, ?ERROR_0),
					fsm_next_state(session_established, NewStateData);
				_ ->
					reply_auth(Uid, SockMod, Socket, Router, ?ERROR_100),
					fsm_next_state(wait_for_auth, StateData)
			end;
		_ ->
			reply_auth(Uid, SockMod, Socket, Router, ?ERROR_113),
			fsm_next_state(wait_for_auth, StateData)
	end;
wait_for_auth(timeout, StateData) ->
	{stop, normal, StateData};
wait_for_auth(closed, StateData) ->
	{stop, normal, StateData};
wait_for_auth(stop, StateData) ->
	{stop, normal, StateData}.

session_established(#proto{mt = ?MT_103, sig = ?SIGN1, data = Data},
	#client_state{user_data = UserData} = StateData) ->
	TData = binary_to_term(Data),
	Child = binary_to_term(TData#data.children),
	if
		Child#request.rt == <<"2">> andalso Child#request.rm == <<"0">> -> %% 登陆成功，更新增量
			landlords_hooks:run(update_session, node(), StateData),
			fsm_next_state(session_established, StateData);
		Child#request.rt == <<"3">> andalso Child#request.rm == <<"0">> -> %% 进入在线状态
			NewStateData = StateData#client_state{
				user_data = UserData#user_data{login_time = lib_time:get_mstimestamp()},
				status = ?STATUS_ONLINE
			},
			fsm_next_state(wait_for_resume, NewStateData);
		true ->
			fsm_next_state(session_established, StateData)
	end;
session_established(timeout, StateData) ->
	fsm_next_state(session_established, StateData);
session_established(closed, StateData) ->
	{stop, normal, StateData};
session_established(stop, StateData) ->
	{stop, normal, StateData}.

%% session success
wait_for_resume(timeout, StateData) ->
	fsm_next_state(wait_for_resume, StateData);
%% 客户端发过来的消息
wait_for_resume(Msg, StateData) ->
	try
		mod_c2s_handle:handle_msg_c2s(Msg, wait_for_resume, StateData)
	catch
		Error ->
			?ERROR("handle msg error : ~p~n reason : ~p~n", [Msg, Error]),
			fsm_next_state(wait_for_resume, StateData)
	end.


handle_event(Event, StateName, StateData) ->
	?WARNING("undefined event : ~p~n", [Event]),
	fsm_next_state(StateName, StateData).

handle_sync_event(_Event, _From, StateName, StateData) ->
	fsm_reply(ok, StateName, StateData).


%% 服务器发过来的消息
handle_info(Msg, StateName, StateData) when is_record(Msg, proto) ->
	try
		mod_c2s_handle:handle_msg_s2s(Msg, StateName, StateData)
	catch
		Error ->
			?ERROR("handle msg error : ~p~n reason : ~p~n", [Msg, Error]),
			fsm_next_state(StateName, StateData)
	end;
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
	?INFO("send tcp msg :: ~p~n", [Reply]),
	{ok, EReply} = mod_proto:packet(Reply),
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



reply_auth(Uid, SockMod, Socket, Router, Pm) ->
	Mid = mod_msg:produce_mid(Uid),
	Child = #push{
		pt = <<"1">>,
		pm = term_to_binary(Pm),
		extend = <<"">>
	},
	NewData = mod_msg:produce_data(2, Mid, Child, null),
	Reply = mod_msg:produce_proto(?MT_103, ?SIGN2, Router, NewData),
	tcp_send(SockMod, Socket, Reply).











