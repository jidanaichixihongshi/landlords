-module(mod_landlords_client).
-auth("cw").

-behaviour(gen_server).

-include("common.hrl").
-include("protobuf_pb.hrl").

-export([start_link/0]).

-export([
	init/1,
	handle_call/3,
	handle_cast/2,
	handle_info/2,
	terminate/2,
	code_change/3]).

-export([tcp_send/2]).

%% API.
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% gen_server.

%% This function is never called. We only define it so that
%% we can use the -behaviour(gen_server) attribute.
init(_Args) ->
	{ok, {IP, Port}} = application:get_env(landlords_client, addrs),
	case gen_tcp:connect(IP, Port, ?TCP_OPTIONS) of
		{ok, Socket} ->
			{ok, Uid} = application:get_env(landlords_client, uid),
			{ok, Nickname} = application:get_env(landlords_client, nickname),
			{ok, Password} = application:get_env(landlords_client, password),
			{ok, Phone} = application:get_env(landlords_client, phone),
			{ok, Version} = application:get_env(landlords_client, version),
			{ok, Device} = application:get_env(landlords_client, device),
			timer:send_interval(?HEART_BREAK_TIME, heartbeat),
			erlang:send_after(2000, self(), start_logon),
			State = #state{
				uid = Uid,
				nickname = Nickname,
				password = Password,
				phone = Phone,
				version = Version,
				device = Device,
				ip = IP,
				port = Port,
				socket = Socket,
				status = connect},
			ets:insert(landlords_client, {state, State}),
			{ok, State};
		{error, Reason} ->
			io:format("-------------connect error~n", []),
			{error, Reason}
	end.

handle_call(Request, _From, State) ->
	io:format("handle_call message ~p ~n", [Request]),
	{reply, ok, State}.

handle_cast(Request, State) ->
	io:format("handle_cast message ~p ~n", [Request]),
	{noreply, State}.

handle_info(start_logon, State) ->
	Msg = msg:get_login(State),
	tcp_send(State#state.socket, Msg),
	{noreply, State};

handle_info(heartbeat, State) ->
	Msg = msg:get_heartbeat(State#state.uid),
	tcp_send(State#state.socket, Msg),
	{noreply, State};
handle_info({send_msg, Msg}, State = #state{socket = Socket}) ->
	case mod_msg:packet(Msg) of
		{ok, Data} ->
			case gen_tcp:send(Socket, Data) of
				ok ->
					io:format("send msg to server :: ~p~n", [Msg]);
				Error ->
					io:format("Error: ~p~n", [Error])
			end;
		{error, _} ->
			io:format("msg : ~p packet error!~n", [Msg])
	end,
	{noreply, State};
handle_info({tcp, Socket, Data}, State) ->
	inet:setopts(Socket, [{active, once}]),
	Msg = mod_msg:unpacket(Data),
	handle_msg(Msg, State),
	{noreply, State};

handle_info({tcp_error, _, Reason}, State) ->
	io:format("------------------------------tcp_error~n", []),
	{stop, Reason, State};
handle_info(timeout, State) ->
	io:format("------------------------------timeout~n", []),
	{stop, normal, State};
handle_info(stop, State) ->
	io:format("------------------------------stop~n", []),
	{stop, normal, State};
handle_info(Info, State) ->
	io:format("undefined msg ~p~n", [Info]),
	{noreply, State}.

terminate(Reason, State) ->
	ets:delete(landlords_ets, state),
	Socket = State#state.socket,
	io:format("socket ~p terminate, reason: ~p ~n", [Socket, Reason]),
	gen_tcp:close(Socket),
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.



tcp_send(Socket, Msg) ->
	io:format("tcp send msg : ~p~n", [Msg]),
	{ok, Packet} = mod_msg:packet(Msg),
	gen_tcp:send(Socket, Packet).


%% process server msg
handle_msg(#proto{mt = 101, sig = 2} = Msg, _State) ->
	io:format("recv heartbeat msg: ~p~n", [Msg]);
handle_msg(#proto{mt = Mt, sig = 2, data = Data} = Msg,
	#state{uid = Uid, socket = Socket} = _State) ->   %% 登录结果
	io:format("recv responselogon msg: ~p~n", [Msg]),
	case Mt of
		102 ->
			case Data of
				<<"0">> ->
					io:format("login success, begin session ...~n", []),
					Reply = term_to_binary({login_success, 0}),
					Response = msg:produce_msg(Uid, <<"">>, Mt, Reply),
					tcp_send(Socket, Response);
				_ ->
					io:format("login faile, close socket ...", []),
					gen_tcp:close(Socket)
			end;
		103 ->
			io:format("session success : ~p~n", [binary_to_term(Data)]),
			Reply = term_to_binary({session_established, 0}),
			Response = msg:produce_msg(Uid, <<"">>, Mt, Reply),
			tcp_send(Socket, Response);
		_ ->
			io:format("undefined msg: ~p~n", [Msg])
	end;
handle_msg(Msg, _State) ->
	io:format("recv unused msg: ~p~n", [Msg]).














