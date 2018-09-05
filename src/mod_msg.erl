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

-include("error.hrl").

-export([
	packet/1,
	unpacket/1,
	produce_error_msg/2]).

%% -----------------------------------------------------------------------------------------
%% 组装消息
%% -----------------------------------------------------------------------------------------
produce_error_msg(Mid, Error_num) ->
	ok
.


%% ------------------------------------------------------------------------------------------
%% 消息包编解码
%% ------------------------------------------------------------------------------------------
%% 打包客户端消息
packet(Msg) when is_tuple(Msg) ->
	packet_msg(Msg);
packet(Msg) ->
	throw(error, Msg).

packet_msg({Type, _, _, _} = Msg) ->
	EMsg = mod_proto:encode(Msg),
	{ok, <<Type:16, EMsg/binary>>}.

%% 解包客户端消息
unpacket(Data) when is_binary(Data) ->
	<<_Type:16, BinMsg/binary>> = Data,
	unpacket_msg(BinMsg);
unpacket(_Data) ->
	throw({error, ?ERROR_101}).


%% -----------------------------------------------------------------------------
%% internal function
%% -----------------------------------------------------------------------------

unpacket_msg(BinMsg) ->
	protobuf_pb:decode(BinMsg).














