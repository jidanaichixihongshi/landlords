%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 六月 2018 16:32
%%%-------------------------------------------------------------------
-module(landlords_proxy_sup).
-auth("cw").

-behaviour(supervisor).

-include("logger.hrl").
-include("proxy.hrl").

-export([
	init/1,
	start_link/0,
	start_child/2]).

-define(CHILD(I, Type), {I, {I, start_link, []}, temporary, 5000, Type, [I]}).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).


start_child(Node, Args) when is_record(Args, proxy_state) ->
	case supervisor:start_child({landlords_proxy, Node}, [Args]) of
		{ok, Pid} ->
			{ok, Pid};
		{error, {already_started, Pid}} ->
			{ok, Pid};
		Error ->
			Error
	end.

init([]) ->
	?DEBUG("init proxy ... ...~n",[]),
	{ok, {{simple_one_for_one, 10000, 1}, [?CHILD(landlords_proxy, supervisor)]}}.













