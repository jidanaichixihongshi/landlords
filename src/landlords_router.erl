%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 六月 2018 13:33
%%%-------------------------------------------------------------------
-module(landlords_router).
-auth("cw").

-include("proxy.hrl").
-include("logger.hrl").
-include("protobuf_pb.hrl").

-export([
	router/1
]).

%% 消息标志位，控制消息走向
-define(SIGN0, 0).					%% 节点消息
-define(SIGN1, 1).					%% c2s消息
-define(SIGN2, 2).					%% s2c消息

router(#proto{router = Router} = OldMsg) ->
	?DEBUG("router msg : ~p~n",[OldMsg]),
	Msg = OldMsg#proto{sig = ?SIGN2},
	#router{to = To, to_device = TDevice} = Router,
	{_Node, ProxyPid} = mod_proxy:get_proxy(binary_to_term(To)),
	ClientList = mod_proxy:get_client_list(ProxyPid),
	NeedOffline =
		if
			TDevice == <<"">> ->
				lists:foldl(
					fun(Client, Acc) ->
						case Client#proxy_client.device == ?DEVICE_4 of
							true ->
								send(Client#proxy_client.pid, Msg),
								Acc;
							_ ->
								send(Client#proxy_client.pid, Msg),
								false
						end
					end, true, ClientList);
			true ->
				InTDevice = binary_to_integer(TDevice),
				lists:foreach(
					fun(Client) ->
						Client#proxy_client.device == InTDevice andalso send(Client#proxy_client.pid, Msg)
					end, ClientList)
		end,
	NeedOffline andalso landlords_hooks:run(store_offline, node(), Msg).

send(Pid, Msg) ->
	try
		Pid ! Msg
	catch
		Error ->
			?ERROR("Send Msg Error : ~p, Reason : ~p, Stack : ~p", [Msg, Error, erlang:get_stacktrace()])
	end.












