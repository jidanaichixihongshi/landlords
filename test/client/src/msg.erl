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
-module(msg).
-auth("cw").

-include("common.hrl").
-include("protobuf_pb.hrl").

-compile(export_all).

%% -----------------------------------------------------------------------
%% 登录功能测试
%% -----------------------------------------------------------------------
get_login(#state{uid = Uid, nickname = Nickname, phone = Phone, password = Token, device = Device, version = Vs} = _State) ->
	Parameter = #logonparameter{
		uid = Uid,
		nickname = Nickname,
		phone = Phone,
		token = Token,
		device = Device,
		device_id = <<"3565861">>,
		version = Vs,
		app_id = <<"32_1_3">>
	},
	Router = get_router(Uid, <<"">>),
	#proto{
		mt = 102,
		mid = produce_mid(Uid),
		sig = 1,
		router = Router,
		data = term_to_binary(Parameter),
		timestamp = get_mstimestamp()
	}.

produce_msg(Uid, To, Mt, Reply) ->
	Router = get_router(Uid, To),
	#proto{
		mt = Mt,
		mid = produce_mid(Uid),
		sig = 1,
		router = Router,
		data = Reply,
		timestamp = get_mstimestamp()
	}.


%% -----------------------------------------------------------------------
%% 其他功能测试
%% -----------------------------------------------------------------------
get_heartbeat(Uid) ->
	Router = get_router(Uid, <<"">>),
	#proto{
		mt = 101,
		mid = produce_mid(Uid),
		sig = 1,
		router = Router,
		data = <<"">>,
		timestamp = get_mstimestamp()
	}.


%% -----------------------------------------------------------------------
%% internal API
%% -----------------------------------------------------------------------
%% 获取时间戳（13位）
-spec get_mstimestamp() -> integer().
get_mstimestamp() ->
	{MegaSecs, Secs, MicroSecs} = os:timestamp(),
	MegaSecs * 1000000 * 1000 + Secs * 1000 + MicroSecs div 1000.

produce_mid(Uid) ->
	MsTimesstamp = get_mstimestamp(),
	integer_to_list(Uid) ++ "_" ++ integer_to_list(MsTimesstamp).

get_router(Uid, To) ->
	#router{
		from = term_to_binary(Uid),
		from_device = <<"1">>,
		from_server = <<"">>,
		to = To,
		to_device = <<"">>,
		to_server = <<"">>
	}.








