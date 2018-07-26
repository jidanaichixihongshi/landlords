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
-include("common.hrl").
-include("logger.hrl").

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
	create_ets(),
	%ping_node(?CENTER_NODE).

	{ok, _} = start_http_link(),
	{ok, Tcp_Port} = application:get_env(landlords, tcp_port),
	{ok, ListenNum} = application:get_env(landlords, listen_num),
	landlords_sup:start_link([Tcp_Port, ListenNum]).

stop(_State) ->
	?INFO("stop landlords server!~n", []),
	ok.

%% http链接
start_http_link() ->
	?INFO("cowboy start http link ...~n", []),
	Routes = [
		{'_', [
			{"/", landlords_http_handler, []}
		]}
	],
	Dispatch = cowboy_router:compile(Routes),
	{ok, Http_Port} = application:get_env(landlords,http_port),
	cowboy:start_http(http, 100, [{port, Http_Port}], [{env, [{dispatch, Dispatch}]}]).

create_ets() ->
	create_ets(?ETS_LIST).

create_ets([]) ->
	?INFO("create ets ok ...~n",[]);
create_ets([{Tab, Cfg} | EtsList]) ->
	case ets:info(Tab) of
		?UNDEFINED ->
			ets:new(Tab, Cfg),
			create_ets(EtsList);
		_ ->
			create_ets(EtsList)
	end.


ping_node(CenterNode) ->
	case net_adm:ping(CenterNode) of
		pong ->
			ok;
		pang ->
			?INFO("ping loop: Node:~p~n", [CenterNode]),
			timer:sleep(1000),
			ping_node(CenterNode)
	end.






