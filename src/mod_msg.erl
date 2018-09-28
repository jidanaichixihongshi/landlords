%%%-------------------------------------------------------------------
%%% * ━━━━━━神兽出没━━━━━━
%%% * 　　　┏┓　　　┏┓
%%% * 　　┏┛┻━━━┛┻┓
%%% * 　　┃　　　　　　　┃
%%% * 　　┃　　　━　　　┃
%%% * 　　┃　┳┛　┗┳　┃
%%% * 　　┃　　　　　　　┃
%%% * 　　┃　　　┻　　　┃
%%% * 　　┃　　　　　　　┃
%%% * 　　┗━┓　　　┏━┛
%%% * 　　　　┃　　　┃ 神兽保佑
%%% * 　　　　┃　　　┃ 代码无bug　　
%%% * 　　　　┃　　　┗━━━┓
%%% * 　　　　┃　　　　　　　┣┓
%%% * 　　　　┃　　　　　　　┏┛
%%% * 　　　　┗┓┓┏━┳┓┏┛
%%% * 　　　　　┃┫┫　┃┫┫
%%% * 　　　　　┗┻┛　┗┻┛
%%% * ━━━━━━感觉萌萌哒━━━━━━
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
	produce_heartbeat/1,
	produce_responselogon/4,

	produce_responsemsg/4,
	produce_responsemsg/5,

	check_msg_timestamp/1]).

-define(TimestampOverTime, 3000).                                  %% 消息延时

%% "hash(Uid)_mstimestamp()"
produce_mid(Uid) ->
	HashV = lib_random:get_hash(Uid, ?UID_HASH_RANGE),
	MsTimesstamp = lib_time:get_mstimestamp(),
	lib_change:to_list(HashV) ++ "_" ++ lib_change:to_list(MsTimesstamp).

produce_roster(From, FromDevice, FromServer) ->
	#router{
		from = <<"">>,
		from_server = <<"">>,
		from_device = <<"">>,
		to = From,
		to_device = FromDevice,
		to_server = FromServer
	}.

%% -----------------------------------------------------------------------------------------
%% 组装消息
%% -----------------------------------------------------------------------------------------

%% 应答消息
produce_heartbeat(#proto{mid = Mid, router = Router}) ->
	#router{
		from = From,
		from_device = FDevice,
		from_server = FServer
	} = Router,
	NewRouter = produce_roster(From, FDevice, FServer),
	#proto{
		mt = ?MT_101,
		mid = Mid,
		sig = ?SIGN2,
		router = NewRouter,
		data = <<"">>,
		timestamp = lib_time:get_mstimestamp()
	}.

produce_responselogon(Mt, Mid, Router, Reply) ->
	#router{
		from = From,
		from_device = FDevice,
		from_server = FServer
	} = Router,
	NewRouter = produce_roster(From, FDevice, FServer),
	#proto{
		mt = Mt,
		mid = Mid,
		sig = ?SIGN2,
		router = NewRouter,
		data = lib_change:to_binary(Reply),
		timestamp = lib_time:get_mstimestamp()
	}.
produce_responsemsg(Mt, Mid, Sig, Reply) ->
	#proto{
		mt = Mt,
		mid = Mid,
		sig = Sig,
		router = #router{},
		data = lib_change:to_binary(Reply),
		timestamp = lib_time:get_mstimestamp()
	}.
produce_responsemsg(Mt, Mid, Sig, Router, Reply) ->
	NewRouter = change_router(Router),
	#proto{
		mt = Mt,
		mid = Mid,
		sig = Sig,
		router = NewRouter,
		data = lib_change:to_binary(Reply),
		timestamp = lib_time:get_mstimestamp()
	}.



check_msg_timestamp(Timestamp) ->
	MsTimestamp = lib_time:get_mstimestamp(),
	Timestamp + ?TimestampOverTime > MsTimestamp.

%% -----------------------------------------------------------------------------
%% internal function
%% -----------------------------------------------------------------------------
change_router(Router) ->
	#router{
		from = From,
		from_device = FDevice,
		from_server = FServer,
		to = To,
		to_device = TDevice,
		to_server = TServer
	} = Router,
	#router{
		from = To,
		from_device = TDevice,
		from_server = TServer,
		to = From,
		to_device = FDevice,
		to_server = FServer
	}.
















