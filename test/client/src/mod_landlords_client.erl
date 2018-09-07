-module(mod_landlords_client).
-auth("cw").

-behaviour(gen_server).

-include("common.hrl").

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
			io:format("----------------connect success~n", []),
			erlang:register(landlords_client, self()),
			timer:send_interval(?HEART_BREAK_TIME, heartbeat),
			State = #state{
				ip = IP,
				port = Port,
				socket = Socket,
				status = connect},
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


handle_info(heartbeat, State = #state{socket = Socket}) ->
	io:format("------------------------------heartbeat~n", []),
	HeartMsg = mod_msg:packet_heart(),
	gen_tcp:send(Socket, HeartMsg),
	{noreply, State};
handle_info({send_msg, Msg}, State = #state{socket = Socket}) ->
	case mod_msg:packet(Msg) of
		{ok, Data} ->
			io:format("send msg to server :: ~p~n",[Msg]),
			gen_tcp:send(Socket, Data);
		{error, _} ->
			io:format("msg : ~p packet error!~n", [Msg])
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
	io:format("-------------------------~p~n", [Info]),
	{noreply, State}.

terminate(Reason, State) ->
	Socket = State#state.socket,
	io:format("======================================== ~n
		socket ~p terminate, reason: ~p ~n
	======================================== ~n", [Socket, Reason]),
	erlang:unregister(landlords_client),
	gen_tcp:close(Socket),
	ok.

code_change(_OldVsn, State, _Extra) ->
	io:format("------------------------------8~n", []),
	{ok, State}.

















