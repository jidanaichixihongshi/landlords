%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 六月 2018 13:33
%%%-------------------------------------------------------------------
-module(mod_proto).
-auth("cw").

-include("error.hrl").

-export([
	packet/1,
	unpacket/1,
	encode/1,
	decode/2]).


%% ------------------------------------------------------------------------------------------
%% 消息包编解码
%% ------------------------------------------------------------------------------------------
%% 打包客户端消息
packet(Msg) when is_tuple(Msg) ->
	packet_msg(Msg);
packet(Msg) ->
	{error, Msg}.

packet_msg(Msg) ->
	Type = erlang:element(2, Msg),
	EMsg = list_to_binary(encode(Msg)),
	{ok, <<Type:16, EMsg/binary>>};
packet_msg(Msg) ->
	{error, Msg}.

%% 解包客户端消息
unpacket(Data) when is_binary(Data) ->
	<<H:16, BinMsg/binary>> = Data,
	decode(H, BinMsg);
unpacket(_Data) ->
	throw({error, ?ERROR_101}).


%% 编码
encode(Msg) when is_tuple(Msg) ->
	protobuf_pb:encode(Msg);
encode(_Msg) ->
	throw(error).

%% 解码
decode(H, BinMsg) when is_binary(BinMsg) ->
	Type = get_decode_type(H),
	protobuf_pb:decode(Type, BinMsg);
decode(_Type, _Msg) ->
	throw({error, ?ERROR_101}).


%% -----------------------------------------------------------------------------
%% internal function
%% -----------------------------------------------------------------------------
get_decode_type(106) -> sessionsuccess;
get_decode_type(105) -> responssession;
get_decode_type(104) -> logonsuccess;
get_decode_type(103) -> requestlogonack;
get_decode_type(102) -> requestlogin;
get_decode_type(101) -> heartbeat.













