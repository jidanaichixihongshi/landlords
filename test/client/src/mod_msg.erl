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
packet(Msg) ->
	{error,Msg}.

packet_msg({Type, _, _, _,_} = Msg) ->
	EMsg = mod_proto:encode(Msg),
	{ok, <<Type:16, EMsg/binary>>};
packet_msg(Msg) ->
	{error, Msg}.


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


%% 生成心跳消息
packet_heart() ->
	Heart = #heartbeat{mt = 101, mid = 15329642, sig = 1,  data = ""},
	io:format("Heart: ~p~n", [Heart]),
	EHeart = list_to_binary(protobuf_pb:encode_heartbeat(Heart)),
	io:format("EHeart: ~p~n", [EHeart]),
	<<101:16, EHeart/binary>>.

%% -----------------------------------------------------------------------------
%% internal function
%% -----------------------------------------------------------------------------

get_decode_type(110) -> logonrequest;
get_decode_type(101) -> heartbeat.












