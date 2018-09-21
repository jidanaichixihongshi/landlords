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
	decode/2]).

-define(SIGN0, 0).          %% 节点消息
-define(SIGN1, 1).          %% c2s消息
-define(SIGN2, 2).          %% s2c消息

%% 打包客户端消息
packet(Msg) when is_tuple(Msg) ->
	packet_msg(Msg);
packet(Msg) ->
	{error,Msg}.

packet_msg(Msg) ->
	EMsg = list_to_binary(protobuf_pb:encode(Msg)),
	{ok, <<0:16, EMsg/binary>>}.



%% 解包服务器消息
unpacket(Data) when is_binary(Data) ->
	<<0:16, BinMsg/binary>> = Data,
	protobuf_pb:decode(proto, BinMsg);
unpacket(_Data) ->
	error.

%% 解码
decode(T, BinMsg) when is_binary(BinMsg) ->
	protobuf_pb:decode(T, BinMsg);
decode(_T, _Msg) ->
	error.


%% -----------------------------------------------------------------------------
%% internal function
%% -----------------------------------------------------------------------------













