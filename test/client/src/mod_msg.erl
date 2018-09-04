%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 六月 2018 13:33
%%%-------------------------------------------------------------------
-module(mod_msg).
-auth("cw").

-include("common.hrl").

-export([
	packet/1,
	unpacket/1,
	packet_heart/0]).

%% 打包客户端消息
packet(Msg) when is_tuple(Msg) ->
	packet_msg(Msg);
packet(_Msg) ->
	error.

packet_msg({Type, _, _, _} = Msg) ->
	EMsg = mod_proto:encode(Msg),
	{ok, lib_change:to_binary([lib_change:to_binary(Type), EMsg])}.

%% 解包客户端消息
unpacket(Msg) when is_binary(Msg) ->
	unpacket_msg(lib_change:to_list(Msg));
unpacket(_Msg) ->
	error.

unpacket_msg([BinType, Msg]) ->
	{ok, mod_proto:decode(lib_change:to_list(BinType), Msg)}.

%% 生成心跳消息
packet_heart() ->
	Heart = #heartbeat{mt = 101, mid = 15329642, data = ""},
	list_to_binary([101,12369,Heart]).

%% -----------------------------------------------------------------------------
%% internal function
%% -----------------------------------------------------------------------------















