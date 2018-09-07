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
	login/0,
	heartbeat/0]).

%% -----------------------------------------------------------------------
%% 登录功能测试
%% -----------------------------------------------------------------------
login() ->
	UserData = #userdata{
		nickname = "晴天",
		uid = "2537996",
		phone = 15175066700,
		token = "testloginserver#2537996#15175066700",
		device = 1,
		device_id = 3561943325861,
		version = "0.0.1"
		app_id = "32_1_3"
	},
	Login = #logonrequest{
		mt = 110,
		mid = 1634682,
		timestamp = get_mstimestamp(),
		data = UserData
	},
	send_msg(Login).

%% -----------------------------------------------------------------------
%% 其他功能测试
%% -----------------------------------------------------------------------
heartbeat() ->
	Heart = #heartbeat{
		mt = 101,
		mid = 15329642,
		sig = 1,
		data = ""},
	send_msg(Heart).


%% -----------------------------------------------------------------------
%% internal API
%% -----------------------------------------------------------------------
send_msg(Msg) ->
	case whereis(landlords_client) of
		Pid when is_pid(Pid) ->
			Pid ! Msg;
		undefined ->
			io:format("undefined register name landlords_client~n", [])
	end.

%% 获取时间戳（13位）
-spec get_mstimestamp() -> integer().
get_mstimestamp() ->
	{MegaSecs, Secs, MicroSecs} = os:timestamp(),
	MegaSecs * 1000000 * 1000 + Secs * 1000 + MicroSecs div 1000.










