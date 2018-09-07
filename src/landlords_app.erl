%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 六月 2018 11:34
%%%-------------------------------------------------------------------
-module(landlords_app).
-auth("cw").

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

-include("server.hrl").
-include("proxy.hrl").
-include("logger.hrl").

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
	create_ets(?ETS_LIST),
	{ok, _} = start_http_link(),
	{ok, Tcp_Port} = application:get_env(landlords, tcp_port),
	{ok, ListenNum} = application:get_env(landlords, listen_num),
	{ok, CenterNode} = application:get_env(landlords, center_node),
	{ok, Pid} = landlords_sup:start_link([Tcp_Port, ListenNum]),
	connect_node(CenterNode),
	{ok, Pid}.

stop(_State) ->
	?INFO("**** stop landlords server! ****~n", []),
	try
		disconnect_node()
	catch
		Error ->
			?ERROR("STOP ERROR: ~p~n", [Error])
	after
		?INFO("stop node ok: ~p~n", [node()]),
		init:stop()
	end.

%% http链接
start_http_link() ->
	?INFO("cowboy start http link ...~n", []),
	Routes = [
		{'_', [
			{"/", landlords_http_handler, []}
		]}
	],
	Dispatch = cowboy_router:compile(Routes),
	{ok, Http_Port} = application:get_env(landlords, http_port),
	cowboy:start_http(http, 100, [{port, Http_Port}], [{env, [{dispatch, Dispatch}]}]).

%% 初始化ets表
create_ets([]) ->
	?INFO("create ets ok ...~n", []);
create_ets([{Tab, Cfg} | EtsList]) ->
	case ets:info(Tab) of
		?UNDEFINED ->
			ets:new(Tab, Cfg),
			create_ets(EtsList);
		_ ->
			create_ets(EtsList)
	end.

connect_node(CenterNode) ->
	case net_adm:ping(CenterNode) of
		pong ->
			timer:sleep(500),
			?INFO("ping center node ok", []),
			ok;
		pang ->
			?WARNING("ping node pang, Node:~p~n", [CenterNode]),
			timer:sleep(1000),
			connect_node(CenterNode)
	end.

disconnect_node() ->
	lists:foreach(
		fun(Node) ->
			?DEBUG("disconnect node:~p", [Node]),
			erlang:disconnect_node(Node)
		end, nodes()).







