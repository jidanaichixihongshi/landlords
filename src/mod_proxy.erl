%%%-------------------------------------------------------------------
%%% * ━━━━━━神兽出没━━━━━━
%%% * 　　　┏┓　　　┏┓
%%% * 　　┏┛┻━━━┛┻┓
%%% * 　　┃　　　　　　　┃
%%% * 　　┃　　　━　　　┃
%%% * 　　┃　┳┛　┗┳　┃
%%% * 　　┃　　　　　　　┃
%%% * 　　┃　　　┻　　　┃
%%% * 　　┃　　　　　　　┃
%%% * 　　┗━┓　　　┏━┛
%%% * 　　　　┃　　　┃ 神兽保佑
%%% * 　　　　┃　　　┃ 代码无bug　　
%%% * 　　　　┃　　　┗━━━┓
%%% * 　　　　┃　　　　　　　┣┓
%%% * 　　　　┃　　　　　　　┏┛
%%% * 　　　　┗┓┓┏━┳┓┏┛
%%% * 　　　　　┃┫┫　┃┫┫
%%% * 　　　　　┗┻┛　┗┻┛
%%% * ━━━━━━感觉萌萌哒━━━━━━
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
-include("common.hrl").
-include("logger.hrl").
%% API
-export([
	unregister_client/2,
	register_client/4,

	get_proxy/1,

	get_client_list/1
]).


unregister_client(ProxyPid, Uid) ->
	gen_server:cast(ProxyPid, {unregister_client, Uid, self()}).

register_client(ProxyPid, _Uid, Device, Token) ->
	gen_server:cast(ProxyPid, {register_client, #proxy_client{pid = self(), device = Device, token = Token}}).

get_proxy(Uid) when is_binary(Uid) ->
	get_proxy(binary_to_term(Uid));
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

%% 先在本地ets中找，没找到再去redis中找
select_proxy(Uid) ->
	case landlords_ets:lookup_proxy(Uid) of
		[ProxyState] when is_record(ProxyState, proxy_state) ->
			Pid = ProxyState#proxy_state.pid,
			?IF(mod_proc:is_proc_alive(Pid), {ok, Pid}, undefined);
		_ ->
			Pid = landlords_redis:get_proxy(Uid),
			?IF(mod_proc:is_proc_alive(Pid), {ok, Pid}, undefined)
	end.

%% 启动proxy
create_proxy(Uid) ->
	case landlords_proxy_sup:start_child(node(), #proxy_state{uid = Uid}) of
		{ok, Pid} ->
			{ok, Pid};
		Error ->
			?ERROR("create proxy error: ~p~n", [Error]),
			Error
	end.



get_client_list(ProxyPid) ->
	case gen_server:call(ProxyPid, get_client_list, 3000) of
		ClientList when is_list(ClientList) ->
			ClientList;
		_ ->
			[]
	end.







