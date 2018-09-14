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
		mt = 103,
		mid = Mid,
		sig = ?SIGN2,
		timestamp = lib_time:get_mstimestamp(),
		data = Reply
	}.

produce_session(Mid, Reply) ->
	#responsesession{
		mt = 105,
		mid = Mid,
		sig = ?SIGN2,
		timestamp = lib_time:get_mstimestamp(),
		data = Reply
	}.


%% -----------------------------------------------------------------------------
%% internal function
%% -----------------------------------------------------------------------------
















