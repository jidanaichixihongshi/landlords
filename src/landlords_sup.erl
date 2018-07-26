%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 六月 2018 11:46
%%%-------------------------------------------------------------------
-module(landlords_sup).
-auth("cw").

-behaviour(supervisor).

%% API
-export([start_link/1]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link([Port,ListenNum]) ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, [Port,ListenNum]).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([Port,ListenNum]) ->
	{ok, {{one_for_one, 5, 10}, [
		ranch:child_spec(landlords_server, ListenNum, ranch_tcp, [{port, Port}], landlords_server, []),
		?CHILD(mod_system_monitor, worker),
		?CHILD(mod_reloader, worker)
	]}}.

