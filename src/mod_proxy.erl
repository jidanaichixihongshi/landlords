%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 八月 2018 16:05
%%%-------------------------------------------------------------------

-module(mod_proxy).
-auth("cw").

-include("proxy.hrl").
-include("logger.hrl").
%% API
-export([
	unregister_client/2,
	register_client/3,

	get_proxy/1
]).

unregister_client(ProxyPid, Uid) ->
	gen_server:cast(ProxyPid, {unregister_client, Uid, self()}).

register_client(Uid, Device, Token) ->
	{_Node, Pid} = get_proxy(Uid),
	gen_server:cast(Pid, {register_client, #proxy_client{pid = self(), device = Device, token = Token}}).


get_proxy(Uid) ->
	case select_proxy(Uid) of
		{ok, Pid} ->
			{node(Pid), Pid};
		_ -> %% 没找着，启动一个proxy
			case create_proxy(Uid) of
				{ok, Pid} ->
					erlang:monitor(process, Pid),
					{node(Pid), Pid};
				Error ->
					?ERROR("start proxy error: ~p~n", [Error]),
					undefined
			end
	end.

%% 启动proxy
create_proxy(Uid) ->
	case landlords_proxy_sup:start_child({landlords_proxy_sup, node()}, [#proxy_state{uid = Uid}]) of
		{ok, Pid} ->
			{ok, Pid};
		Error ->
			?ERROR("create proxy error: ~p~n", [Error]),
			Error
	end.


%% 先在本地ets中找，没找到再去redis中找
select_proxy(Uid) ->
	case landlords_ets:lookup_element_proxy(Uid, #proxy_state.pid) of
		Pid when is_pid(Pid) ->
			{ok, Pid};
		_ ->
			case landlords_redis:get_proxy(Uid) of
				Pid when is_pid(Pid) ->
					{ok, Pid};
				_ ->
					undefined
			end
	end.














