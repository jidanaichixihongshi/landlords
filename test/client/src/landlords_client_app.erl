-module(landlords_client_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================
start(_StartType, _StartArgs) ->
    io:format("--------------------------~n",[]),
    landlords_client_sup:start_link().

stop(_State) ->
    io:format("stop landlords server!~n", []),
    ok.







