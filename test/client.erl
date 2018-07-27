%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 六月 2018 11:14
%%%-------------------------------------------------------------------

%% ============================================
%% 先启动
%% ============================================
-module(client).
-auth("cw").

-behaviour(gen_server).

-export([
	init/1,
	handle_call/3,
	handle_cast/2,
	handle_info/2,
	terminate/2,
	code_change/3]).

-export([
	start/0,
	stop/0,
	send/0,
	send/1]).

-define(IP,"192.168.32.17").
-define(PORT, 13657).
-define(TCP_OPTIONS, [binary, {packet, 0}]).
-define(POLL_TIME, 1000).

start() ->
	gen_server:start_link({local,?MODULE},?MODULE,[],[]).

stop() ->
	gen_server:cast(?MODULE,stop).

init([]) ->
	timer:send_interval(?POLL_TIME,self(),loop_interval_event),
	{ok, Socket} = gen_tcp:connect(?IP, ?PORT, ?TCP_OPTIONS),
	State = #{socket => Socket},
	{ok,State}.

send() ->
	Msg = <<"sdf">>,
	send(Msg).

send(Msg) ->
	gen_server:cast(?MODULE,{sendmsg,Msg}).

handle_call(_Val, _From, State) ->
	{reply, ok, State}.

handle_cast({send,Msg}, State) ->
	Socket = maps:get(socket,State),
	gen_tcp:send(Socket, Msg),
	{noreply, State};
handle_cast(stop, State) ->
	Socket = maps:get(socket,State),
	gen_tcp:close(Socket),
	{stop,normal,State};
handle_cast(_Msg,State) ->
	{noreply,State}.

handle_info(loop_interval_event, State) ->
	Socket = maps:get(socket,State),
	case gen_tcp:recv(Socket, 0) of
		{ok, Msg} ->
			io:format("--------Msg: ~p~n",[Msg]);
		_ ->
			ok
	end,
	{noreply, State};
handle_info(_Info,State) ->
	{noreply,State}.

code_change(_OldVsn,State,_Extra) ->
	{ok,State}.

terminate(Reason,_State) ->
	io:format("Reason: ~p~n",[Reason]),
	ok.








