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
	init(),
	Sup = landlords_sup:start_link(),
	{ok, _} = start_http_link(),
	Sup.

stop(_State) ->
	?INFO("stop landlords server!~n", []),
	ok.

%% 初始化
init() ->
	create_ets(),
	landlords_config:create_config().
%ping_node(?CENTER_NODE).

%% http链接
start_http_link() ->
	?INFO("cowboy start http link ...~n", []),
	Routes = [
		{'_', [
			{"/", landlords_http_handler, []}
		]}
	],
	Dispatch = cowboy_router:compile(Routes),
	{ok, Port} = application:get_env(http_port),
	cowboy:start_http(http, 100, [{port, Port}], [{env, [{dispatch, Dispatch}]}]).

create_ets() ->
	create_ets(?ETS_LIST).

create_ets([]) ->
	?INFO("create ets ok ...~n");
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






