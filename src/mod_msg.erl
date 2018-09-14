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
-include("protobuf_pb.hrl").

-export([
	produce_mid/1,
	packet/1,
	unpacket/1,
	produce_error_msg/2,
	produce_heartbeat/2,
	produce_responselogon/2,
	produce_session/2]).

%% 消息标志位，控制消息走向
-define(SIGN0, 0).          %% 节点消息
-define(SIGN1, 1).          %% c2s消息
-define(SIGN2, 2).          %% s2c消息

%% "hash(Uid)_mstimestamp()"
produce_mid(Uid) ->
	HashV = lib_random:get_hash(Uid, ?UID_HASH_RANGE),
	MsTimesstamp = lib_time:get_mstimestamp(),
	lib_change:to_list(HashV) ++ "_" ++ lib_change:to_list(MsTimesstamp).


%% -----------------------------------------------------------------------------------------
%% 组装消息
%% -----------------------------------------------------------------------------------------
produce_error_msg(_Mid, _Error_Num) ->
	ok.

%% 应答消息
produce_heartbeat(Mid, MsTimestamp) ->
	#heartbeat{
		mt = 101,
		mid = Mid,
		sig = ?SIGN2,
		timestamp = MsTimestamp,
		data = ""
	}.

produce_responselogon(Mid, Reply) ->
	#responselogon{
		mt = 201,
		mid = Mid,
		sig = ?SIGN2,
		timestamp = lib_time:get_mstimestamp(),
		data = Reply
	}.

produce_session(Mid, Reply) ->
	#responssession{
		mt = 202,
		mid = Mid,
		sig = ?SIGN2,
		timestamp = lib_time:get_mstimestamp(),
		data = Reply
	}.

%% ------------------------------------------------------------------------------------------
%% 消息包编解码
%% ------------------------------------------------------------------------------------------
%% 打包客户端消息
packet(Msg) when is_tuple(Msg) ->
	packet_msg(Msg);
packet(Msg) ->
	{error, Msg}.

packet_msg(Msg) ->
	Type = erlang:element(1, Msg),
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
















