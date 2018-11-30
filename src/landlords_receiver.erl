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
-module(landlords_receiver).
-auth("cw").

-behaviour(gen_server).
-behaviour(ranch_protocol).

-include("server.hrl").
-include("logger.hrl").
-include("protobuf_pb.hrl").

-export([start_link/4]).

-export([
	init/1,
	handle_call/3,
	handle_cast/2,
	handle_info/2,
	terminate/2,
	code_change/3]).

-record(receiver_state, {
	ref,
	c2s_pid :: pid(),
	socket :: inet:socket(),
	transport,
	opts,
	last_recv_time,
	attack                  %% 数据格式错误超过一定次数被视为恶意攻击
}).


%% API.

start_link(Ref, Socket, Transport, Opts) ->
	gen_server:start_link(?MODULE, [Ref, Socket, Transport, Opts], []).

%% gen_server.
%% This function is never called. We only define it so that
%% we can use the -behaviour(gen_server) attribute.
init([Ref, Socket, Transport, Opts]) ->
	erlang:process_flag(trap_exit, true),
	ok = proc_lib:init_ack({ok, self()}),
	ok = ranch:accept_ack(Ref),
	ok = Transport:setopts(Socket, [{active, once}, {packet, 4}]),
	{ok, Pid} = landlords_auth:start_link({ranch_tcp, Socket, self()}, []),
	?INFO("landlords_c2s init, socket: ~p~n", [Socket]),
	State = #receiver_state{
		ref = Ref,
		c2s_pid = Pid,
		socket = Socket,
		transport = Transport,
		opts = Opts
	},
	gen_server:enter_loop(?MODULE, [], State, ?RECEIVER_HIBERNATE_TIMEOUT).

handle_call(_Request, _From, State) ->
	?DEBUG("handle_call message ~p ~n", [_Request]),
	{reply, ok, State, ?RECEIVER_HIBERNATE_TIMEOUT}.

handle_cast({send, Msg}, #receiver_state{socket = Socket, transport = Transport} = State) ->
	?INFO("send tcp msg ::: ~p~n", [Msg]),
	try
		{ok, SData} = mod_proto:packet(Msg),
		Transport:send(Socket, SData)
	catch
		Reason ->
			?WARNING("packet msg error : ~p~n", [Reason])
	end,
	{noreply, State, ?RECEIVER_HIBERNATE_TIMEOUT}.


%% handle socket data
handle_info({tcp, Socket, Data}, State) ->
	Transport = State#receiver_state.transport,
	Transport:setopts(Socket, [{active, once}]),
	%% 要不要把消息存进内存呢？
	case mod_proto:unpacket(Data) of
		{ok, Msg} ->
			NewState = process_msg(Msg, State),
			{noreply, NewState#receiver_state{attack = 0}, ?RECEIVER_HIBERNATE_TIMEOUT};
		{error, Reason} ->
			Attack = State#receiver_state.attack,
			?DEBUG("unpacket msg ~p faile, reason : ~p，attack : ~p~n", [Reason, Attack]),
			Attack >= ?ATTACK_HEAD_COUNT andalso erlang:send_after(500, self(), stop),
			{noreply, State#receiver_state{attack = Attack + 1}, ?RECEIVER_HIBERNATE_TIMEOUT}
	end;

%% timout function
handle_info(stop, State) ->
	{stop, normal, State};
handle_info(timeout, State) ->
	{stop, timeout, State};
handle_info({'EXIT', _, Reason}, State) ->
	{stop, {'EXIT', Reason}, State};
handle_info({tcp_closed, _Socket}, State) ->
	{stop, tcp_closed, State};
handle_info({tcp_error, _, Reason}, State) ->
	{stop, {tcp_error, Reason}, State};
handle_info(Info, State) ->
	?WARNING("unused info : ~p~n", [Info]),
	{noreply, State, ?RECEIVER_HIBERNATE_TIMEOUT}.

terminate(Reason, State) ->
	#receiver_state{c2s_pid = C2SPid, socket = Socket} = State,
	?INFO("socket ~p terminate, reason: ~p~n", [Socket, Reason]),
	%% 清除连接
	IsAlive = mod_proc:is_proc_alive(C2SPid),
	IsAlive andalso gen_fsm:send_event(C2SPid, closed),
	gen_tcp:close(Socket),
	ok.

code_change(_OldVsn, State, _Extra) ->
	?INFO("Module ~p changed ...~n", [?MODULE]),
	{ok, State}.

%% ACK
process_msg(#proto{mt = ?MT_101, sig = ?SIGN1, ts = MTimestamp} = Msg,
	#receiver_state{transport = Mod, socket = Socket} = State) ->
	MsTimestamp = lib_time:get_mstimestamp(),
	case MTimestamp + ?DATA_OVERTIME > MsTimestamp of
		true ->
			AskMsg = mod_msg:produce_heartbeat(Msg),  %% ASK
			?DEBUG("recv ~p ack ok ... ...~n", [State#receiver_state.socket]),
			landlords_c2s:tcp_send(Mod, Socket, AskMsg),
			State#receiver_state{last_recv_time = MsTimestamp};
		_ ->
			?WARNING("recv overtime msg,~p~n ", [Msg]),
			State#receiver_state{last_recv_time = MsTimestamp}
	end;
process_msg(Msg, #receiver_state{c2s_pid = C2SPid} = State) when is_pid(C2SPid) ->
	?INFO("receive tcp msg ::: ~p~n", [Msg]),
	MsTimestamp = lib_time:get_mstimestamp(),
	catch
		gen_fsm:send_event(C2SPid, Msg),
	State#receiver_state{last_recv_time = MsTimestamp};
process_msg(Msg, State) ->
	MsTimestamp = lib_time:get_mstimestamp(),
	?WARNING("recv unrecognized message :: ~p~n", [Msg]),
	State#receiver_state{last_recv_time = MsTimestamp}.







