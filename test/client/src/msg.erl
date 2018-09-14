%%%-------------------------------------------------------------------
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

-export([
	requestlogin/0,
	logonsuccess/0,
	sessionsuccess/0,
	heartbeat/0]).

%% -----------------------------------------------------------------------
%% 登录功能测试
%% -----------------------------------------------------------------------
requestlogin() ->
	Uid = 1537096,
	UserData = #userdata{
		nickname = "晴天",
		uid = Uid,
		phone = 15175066700,
		token = "testloginserver#2537996#15175066700",
		device = 1,
		device_id = 3561943325861,
		version = "0.0.1",
		app_id = "32_1_3"
	},
	RequestLogin = #requestlogon{
		mt = 102,
		mid = produce_mid(Uid),
		sig = 1,
		timestamp = get_mstimestamp(),
		data = UserData
	},
	send_msg(RequestLogin).

logonsuccess() ->
	Uid = 1537096,
	LoginSuccess = #logonsuccess{
                mt = 104,
                mid = produce_mid(Uid),
                sig = 1,
                timestamp = get_mstimestamp(),
                data = 0
        },
        send_msg(LoginSuccess).

sessionsuccess() ->
        Uid = 1537096,
        SessionSuccess = #sessionsuccess{
                mt = 106,
                mid = produce_mid(Uid),
                sig = 1,
                timestamp = get_mstimestamp(),
                data = 0
        },
        send_msg(SessionSuccess).



%% -----------------------------------------------------------------------
%% 其他功能测试
%% -----------------------------------------------------------------------
heartbeat() ->
        Uid = 1537096,
	Heart = #heartbeat{
		mt = 101,
                mid = produce_mid(Uid),
		sig = 1,
                timestamp = get_mstimestamp(),
		data = ""},
	send_msg(Heart).


%% -----------------------------------------------------------------------
%% internal API
%% -----------------------------------------------------------------------
send_msg(Msg) ->
	self() ! { send_msg, Msg}.

%% 获取时间戳（13位）
-spec get_mstimestamp() -> integer().
get_mstimestamp() ->
	{MegaSecs, Secs, MicroSecs} = os:timestamp(),
	MegaSecs * 1000000 * 1000 + Secs * 1000 + MicroSecs div 1000.

produce_mid(Uid) ->
	MsTimesstamp = get_mstimestamp(),
	integer_to_list(Uid) ++ "_" ++ integer_to_list(MsTimesstamp).








