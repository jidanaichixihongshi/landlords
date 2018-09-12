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
-include("error.hrl").

-export([
	produce_mid/1,
	packet/1,
	unpacket/1,
	produce_error_msg/2]).


%% "hash(Uid)_mstimestamp()"
produce_mid(Uid) when is_integer(Uid) ->
	HashV = lib_random:get_hash(Uid, ?UID_HASH_RANGE),
	MsTimesstamp = lib_time:get_mstimestamp(),
	lib_change:to_list(HashV) ++ "_" ++ lib_change:to_list(MsTimesstamp);
produce_mid(_) ->
	false.


%% -----------------------------------------------------------------------------------------
%% 组装消息
%% -----------------------------------------------------------------------------------------
produce_error_msg(_Mid, _Error_Num) ->
	ok.


%% ------------------------------------------------------------------------------------------
%% 消息包编解码
%% ------------------------------------------------------------------------------------------
%% 打包客户端消息
packet(Msg) when is_tuple(Msg) ->
	packet_msg(Msg);
packet(Msg) ->
	{error, Msg}.

packet_msg({Type, _, _, _, _, _} = Msg) ->
	EMsg = mod_proto:encode(Msg),
	{ok, <<Type:16, EMsg/binary>>};
packet_msg(Msg) ->
	{error, Msg}.

%% 解包客户端消息
unpacket(Data) when is_binary(Data) ->
	<<H:16, BinMsg/binary>> = Data,
	mod_proto:decode(H, BinMsg);
unpacket(_Data) ->
	throw({error, ?ERROR_101}).


%% -----------------------------------------------------------------------------
%% internal function
%% -----------------------------------------------------------------------------
















