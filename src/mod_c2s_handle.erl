%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 九月 2018 18:33
%%%-------------------------------------------------------------------
-module(mod_c2s_handle).
-auth("cw").

-include("server.hrl").
-include("logger.hrl").
-include("protobuf_pb.hrl").

-export([handle_c2s_msg/2]).

%% -------------------------------------------------------------------------
%% 一些特殊消息的处理
%% -------------------------------------------------------------------------
%% 心跳消息
handle_c2s_msg(Msg, State) when is_record(Msg, heartbeat) ->
	MsTimestamp = lib_time:get_mstimestamp(),
	case Msg#heartbeat.mt + ?DATA_OVERTIME > MsTimestamp of
		true ->
			{ok, State#client_state{last_recv_time = MsTimestamp}};
		_ ->
			?WARNING("recv overtime msg,~p~n ", [Msg#heartbeat.mid]),
			{ok, State}
	end;
%% -------------------------------------------------------------------------
%% 其余消息直接启动钩子
%% -------------------------------------------------------------------------
handle_c2s_msg(Msg, State) when is_record(Msg, logonrequest) ->
	case handle_msg(logonrequest, Msg, Msg#logonrequest.timestamp, State) of
		{true, State} ->
			%% 登录验证成功，把链接注册到proxy
			Data = Msg#logonrequest.data,
			#userdata{
				uid = Uid,
				version = Version,
				device = Device,
				device_id = DeviceId,
				token = Token,
				phone = Phone} = Data,
			{_Node, ProxyPid} = mod_proxy:get_proxy(Uid),
			mod_proxy:register_client(Uid, Device, Token),
			UserData = #user_data{
				uid = Uid,
				nickname = <<"晴天">>,
				level = 0,
				version = Version,
				device = Device,
				device_id = DeviceId,
				token = Token,
				location = <<"北京">>,
				login_time = lib_time:get_mstimestamp(),
				phone = Phone
			},
			NewState = State#client_state{
				uid = Uid,
				proxy = ProxyPid,
				status = online,
				pid = self(),
				node = node(),
				user_data = UserData},
			{ok, NewState};
		_ ->
			throw(error)
	end.


%% -----------------------------------------------------------------------------
%% internal function
%% -----------------------------------------------------------------------------
handle_msg(Type, Msg, MsgTime, State) ->
	MsTimestamp = lib_time:get_mstimestamp(),
	case MsgTime + ?DATA_OVERTIME > MsTimestamp of
		true ->
			Rest = landlords_hooks:run(Type, Msg),
			{Rest, State#client_state{last_recv_time = MsTimestamp}};
		_ ->
			?WARNING("recv overtime msg,~p~n ", [Msg#heartbeat.mid]),
			{error, State}
	end.














