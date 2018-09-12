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
	%%peername(Socket) -> {ok, {Address, Port}} | {error, posix()}
	{ok, {Address, Port}} = inet:peername(Socket),
	State = #client_state{
		status = ?LOGGING,
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
	{reply, ok, State, ?HIBERNATE_TIMEOUT}.

handle_cast({send, Msg}, State = #client_state{socket = Socket, transport = Transport}) ->
	?INFO("send tcp msg ::: ~p~n", [Msg]),
	try
		{ok, SData} = mod_msg:packet(Msg),
		Transport:send(Socket, SData)
	catch
		Reason ->
			?WARNING("packet msg error : ~p~n", [Reason])
	end,
	{noreply, State, ?HIBERNATE_TIMEOUT}.


%% handle socket data
handle_info({tcp, Socket, Data}, State) ->
	Transport = State#client_state.transport,
	Transport:setopts(Socket, [{active, once}]),
	%% 要不要把消息存进内存呢？
	try
		Msg = mod_msg:unpacket(Data),
		?INFO("receive tcp msg ::: ~p~n", [Msg]),
		{ok, NewState} = mod_c2s_handle:handle_c2s_msg(Msg, State),
		{noreply, NewState, ?HIBERNATE_TIMEOUT}
	catch
		Reason ->
			erlang:send_after(500, self(), {error, Reason}),
			{noreply, State, ?HIBERNATE_TIMEOUT}
	end;

%% timout function set opt parms
handle_info(timeout, #client_state{ref = Ref, socket = Socket, transport = Transport} = State) ->
	?DEBUG("------------------------------1~n", []),
	ok = ranch:accept_ack(Ref),
	ok = Transport:setopts(Socket, [{active, once}]),
	%%	lib_normal:set_mem(?MODULE, Socket, self()),
	{noreply, State, ?HIBERNATE_TIMEOUT};
%% 消息错误，关闭socket
handle_info({error, Reason}, #client_state{socket = Socket, transport = _Transport} = State) ->
	Msg = mod_msg:produce_error_msg(error, Reason),
	self() ! {send, Msg},
	erlang:send_after(1500, self(), {tcp_error, Reason, Socket}),
	{noreply, State, ?HIBERNATE_TIMEOUT};
handle_info({tcp_closed, _Socket}, State) ->
	{stop, normal, State};
handle_info({tcp_error, _, Reason}, State) ->
	{stop, Reason, State};
handle_info(timeout, State) ->
	{stop, normal, State};
handle_info(_Info, State) ->
	{stop, normal, State}.

terminate(Reason, State) ->
	#client_state{uid = Uid, proxy = ProxyPid, socket = Socket} = State,
	?WARNING("======================================== ~n
		socket ~p terminate, reason: ~p~n
		======================================== ~n", [Socket, Reason]),
	case is_pid(ProxyPid) andalso mod_proc:is_proc_alive(ProxyPid) of
		true ->
			mod_proxy:unregister_client(ProxyPid, Uid);
		_ ->
			ok
	end,
	lib_normal:del_mem(?MODULE, Socket),
	ok.

code_change(_OldVsn, State, _Extra) ->
	?DEBUG("------------------------------8~n", []),
	{ok, State}.





