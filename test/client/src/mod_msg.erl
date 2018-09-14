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
	unpacket/1]).

%% 打包客户端消息
packet(Msg) when is_tuple(Msg) ->
	packet_msg(Msg);
packet(Msg) ->
	{error,Msg}.

packet_msg(Msg) ->
	Type = element(2, Msg),
	EMsg = list_to_binary(protobuf_pb:encode(Msg)),
	io:format("Type: ~p, Emsg: ~p~n",[Type,EMsg]),
	{ok, <<Type:16, EMsg/binary>>}.


%% 解包服务器消息
unpacket(Data) when is_binary(Data) ->
	<<H:16, BinMsg/binary>> = Data,
	unpacket_msg(H, BinMsg);
unpacket(_Data) ->
	error.

unpacket_msg(H, BinMsg) ->
	Type = get_decode_type(H),
	Msg = protobuf_pb:decode(Type, BinMsg),
	{Type, Msg}.


%% -----------------------------------------------------------------------------
%% internal function
%% -----------------------------------------------------------------------------



get_decode_type(104) -> logonsuccess;
get_decode_type(103) -> responselogon;
get_decode_type(102) -> requestlogin;
get_decode_type(101) -> heartbeat.












