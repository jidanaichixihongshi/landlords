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
	produce_roster/3,
	produce_data/4,
	produce_heartbeat/1,
	produce_proto/3,
	produce_proto/4,

	check_msg_timestamp/1]).

-define(TimestampOverTime, 3000).                                  %% 消息延时

%% "hash(Uid)_mstimestamp()"
produce_mid(Uid) ->
	HashV = lib_random:get_hash(Uid, ?UID_HASH_RANGE),
	MsTimesstamp = lib_time:get_mstimestamp(),
	lib_change:to_list(HashV) ++ "_" ++ lib_change:to_list(MsTimesstamp).

produce_roster(From, FDevice, FServer) ->
	#router{
		from = <<"">>,
		fserver = <<"">>,
		fdevice = <<"">>,
		to = From,
		tdevice = FDevice,
		tserver = FServer
	}.

produce_data(Dt, Mid, Child, Extend) ->
	#data{
		dt = term_to_binary(Dt),
		mid = term_to_binary(Mid),
		children = term_to_binary(Child),
		extend = term_to_binary(Extend)}.

%% -----------------------------------------------------------------------------------------
%% 组装消息
%% -----------------------------------------------------------------------------------------

%% 应答消息
produce_heartbeat(#proto{router = Router}) ->
	#router{
		from = From,
		fdevice = FDevice,
		fserver = FServer
	} = Router,
	NewRouter = produce_roster(From, FDevice, FServer),
	#proto{
		mt = ?MT_101,
		sig = ?SIGN2,
		router = NewRouter,
		data = <<"">>,
		ts = lib_time:get_mstimestamp()
	}.

produce_proto(Mt, Sig, Reply) ->
	#proto{
		mt = Mt,
		sig = Sig,
		router = #router{},
		data = lib_change:to_binary(Reply),
		ts = lib_time:get_mstimestamp()
	}.
produce_proto(Mt, Sig, Router, Reply) ->
	NewRouter = change_router(Router),
	#proto{
		mt = Mt,
		sig = Sig,
		router = NewRouter,
		data = term_to_binary(Reply),
		ts = lib_time:get_mstimestamp()
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
		fdevice = FDevice,
		fserver = FServer,
		to = To,
		tdevice = TDevice,
		tserver = TServer
	} = Router,
	#router{
		from = To,
		fdevice = TDevice,
		fserver = TServer,
		to = From,
		tdevice = FDevice,
		tserver = FServer
	}.
















