-module(landlords_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
	{ok, _} = start_http_link(),
        {ok, Pid} = landlords_sup:start_link(),
        init(),
        {ok, Pid}.

stop(_State) ->
    io:format("stop landlords server!~n",[]),
    ok.

%% 初始化
init() ->
        load_config(),
        load_ets().
        %ping_node(?CENTER_NODE).

%% http链接
start_http_link() ->
        io:format("cowboy start http link ...~n",[]),
        Routes = [
                {'_', [
                        {"/", landlords_http_handler, []}
                ]}
        ],
        Dispatch = cowboy_router:compile(Routes),
        {ok, Port} = application:get_env(http_port),
        cowboy:start_http(http, 100, [{port, Port}], [{env, [{dispatch, Dispatch}]}]).

load_config() ->
	ok.

load_ets() ->
        io:format("load config ok ...~n").


ping_node(CenterNode)->
        case net_adm:ping(CenterNode) of
                pong ->
                        ok;
                pang ->
                        io:format("ping loop: Node:~p~n", [CenterNode]),
                        timer:sleep(1000),
                        ping_node(CenterNode)
        end.






