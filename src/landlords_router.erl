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


router(#proto{router = Router} = Msg) ->
	#router{to = To, to_device = TDevice} = Router,
	{_Node, ProxyPid} = mod_proxy:get_proxy(To),
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












