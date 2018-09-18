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
			timer:send_interval(?HEART_BREAK_TIME, heartbeat),
			erlang:send_after(2000, self(), start_logon),
			State = #state{
				ip = IP,
				port = Port,
				socket = Socket,
				status = connect},
			io:format("----------------init success~n", []),
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
	msg:requestlogon(),
	{noreply, State};

handle_info(heartbeat, State) ->
	msg:heartbeat(),
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
handle_info({tcp, _Socket, Data}, State) ->
	case mod_msg:unpacket(Data) of
		{Type, Msg} ->
			handle_msg(Type, Msg);
		_ ->
			io:format("unknow msg : ~p~n", [Data])
	end,
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
	Socket = State#state.socket,
	io:format("======================================== ~n
		socket ~p terminate, reason: ~p ~n
	======================================== ~n", [Socket, Reason]),
	gen_tcp:close(Socket),
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.


%% process server msg
handle_msg(heartbeat, Msg) ->
	io:format("recv heartbeat msg: ~p~n", [Msg]);
handle_msg(responselogon, Msg) ->   %% 登录结果
	io:format("recv responselogon msg: ~p~n", [Msg]),
	case Msg#responselogon.data of
		0 ->
			msg:logonsuccess();
		_ ->
			ok
	end;
handle_msg(responsesession, Msg) ->   %% 增量消息
	io:format("recv responsesession msg: ~p~n", [Msg]),
	msg:sessionsuccess();
handle_msg(_Type, Msg) ->
	io:format("recv unused msg: ~p~n", [Msg]).














