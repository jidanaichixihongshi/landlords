%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 六月 2018 11:56
%%%-------------------------------------------------------------------
-module(landlords_server).
-auth("cw").

-behaviour(gen_server).
-behaviour(ranch_protocol).

-include("server.hrl").
-include("logger.hrl").

-export([start_link/4]).

-export([
	init/1,
	handle_call/3,
	handle_cast/2,
	handle_info/2,
	terminate/2,
	code_change/3]).

-define(SERVER, ?MODULE).


%% API.

start_link(Ref, Socket, Transport, Opts) ->
	gen_server:start_link(?MODULE, [Ref, Socket, Transport, Opts], []).

%% gen_server.

%% This function is never called. We only define it so that
%% we can use the -behaviour(gen_server) attribute.

init([Ref, Socket, Transport, Opts]) ->
	?DEBUG("================== {~p, ~p, ~p, ~p} =================~n", [Ref, Socket, Transport, Opts]),
	%%peername(Socket) -> {ok, {Address, Port}} | {error, posix()}
	timer:send_interval(1000, timertick),
	{ok, {Address, Port}} = inet:peername(Socket),
	State = #state{
		ref = Ref,
		node = node(),
		socket = Socket,
		transport = Transport,
		otp = Opts,
		ip = Address,
		port = Port},
	{ok, State, 0}.

handle_call(_Request, _From, State) ->
	?DEBUG("handle_call message ~p ~n", [_Request]),
	{reply, ok, State}.

handle_cast({chat, Msg}, State = #state{socket = Socket, transport = Transport}) ->
%%	Transport:send(Socket,Msg),
	?DEBUG("handle_cast message ~p ~n", [Msg]),
	{noreply, State}.

%% timout function set opt parms
handle_info(timeout, State = #state{ref = Ref, socket = Socket, transport = Transport}) ->
	?DEBUG("------------------------------1~n", []),
	ok = ranch:accept_ack(Ref),
	ok = Transport:setopts(Socket, [{active, once}]),
	%game_socket_store:insert(self(),Socket),
	{noreply, State};
%% handle socket data
handle_info({tcp, Socket, Data}, State = #state{socket = Socket, transport = Transport}) ->
	?DEBUG("------------------------------ Transport: ~p~nData: ~p~n~n", [Transport, Data]),
	Transport:setopts(Socket, [{active, once}]),
	io:format("~p~n", [Data]),
	lists:foreach(
		fun(Pid) ->
			case Pid =:= self() of
				false ->
					gen_server:cast(Pid, {chat, Data});
				true -> ok
			end
		end,
		game_socket_store:lookall()),
	{noreply, State, ?TIMEOUT};
handle_info(timertick, State = #state{socket = Socket, transport = Transport}) ->
	?DEBUG("------------------------------2~n", []),
	Transport:send(Socket,<<1>>),
	{noreply, State};

handle_info({tcp_closed, _Socket}, State) ->
	?DEBUG("------------------------------3~n", []),
	{stop, normal, State};
handle_info({tcp_error, _, Reason}, State) ->
	?DEBUG("------------------------------4~n", []),
	{stop, Reason, State};
handle_info(timeout, State) ->
	?DEBUG("------------------------------5~n", []),
	{stop, normal, State};
handle_info(_Info, State) ->
	?DEBUG("------------------------------6~n", []),
	{stop, normal, State}.

terminate(_Reason, _State) ->
	?DEBUG("------------------------------7~n", []),
%%	game_socket_store:delete(self()),
	ok.

code_change(_OldVsn, State, _Extra) ->
	?DEBUG("------------------------------8~n", []),
	{ok, State}.





