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
-include_lib("protobuf_pb.hrl").

-export([
	handle_msg/2]).

%% hooks api
-export([update_session/1,
	seekuser/1]).


handle_msg(#proto{mt = Mt, sig = ?SIGN1, router = Router, timestamp = Timestamp} = Msg, StateData) ->
	(not mod_msg:check_msg_timestamp(Timestamp)) andalso throw(?ERROR_102),
	if
		Router#router.to == <<"">> ->  %% 发给自己的
			handle_msg(Mt, Msg, StateData);
		true ->	%% 启动消息路由
			landlords_router:router(Msg),
			fsm_next_state(session_established, StateData)
	end.


handle_msg(?MT_103, Msg, StateData) ->
	case binary_to_term(Msg#proto.data) of
		{sesson, all} ->
			landlords_hooks:run(update_session, node(), StateData);
		{session,?ERROR_0} ->
			?DEBUG("session success : ~p~n",[Msg]);
		_ ->
			?WARNING("undefinde request : ~p~n", [Msg])
	end,
	fsm_next_state(session_established, StateData);
handle_msg(?MT_104, Msg, #client_state{sockmod = SockMod, socket = Socket} = StateData) ->
	case binary_to_term(Msg#proto.data) of
		{seekuser, UserData} ->
			Reply = landlords_hooks:run(seekuser, node(), UserData),
			SendMsg = mod_msg:produce_responsemsg(?MT_104, Msg#proto.mid, ?SIGN2, Msg#proto.router, Reply),
			landlords_c2s:tcp_send(SockMod, Socket, SendMsg);
		_ ->
			?WARNING("undefinde request : ~p~n", [Msg])
	end,
	fsm_next_state(session_established, StateData);





handle_msg(Mt, _, StateData) ->
	?WARNING("undefined mt type : ~p~n", [Mt]),
	fsm_next_state(session_established, StateData).

%% -------------------------------------------------------------------------
%% 一些特殊消息的处理
%% -------------------------------------------------------------------------
%% hooks_api
update_session(#client_state{uid = Uid, node = Node, socket = Socket, sockmod = SockMod} = _StateData) ->
	%#user_data{nickname = NickName, } = UserData,
	Mid = mod_msg:produce_mid(Uid),
	Router = #router{
		from = lib_change:to_binary(Uid),
		from_device = <<"1">>,
		from_server = <<"">>,
		to = <<"">>,
		to_device = <<"">>,
		to_server = <<"">>},
	Rosters = [#{name => "我的好友",
		members => [#{uid => 1396554, nickname => <<"玲花">>, remark => <<"">>, lv => 10, statu => online, personlabel => "最怕刮风下雨！"},
			#{uid => 5563988, nickname => <<"皮皮球">>, remark => <<"">>, lv => 3, statu => offline, personlabel => "这个人很懒，什么都没有留下！"},
			#{uid => 7622344, nickname => <<"千层酥">>, remark => <<"">>, lv => 21, statu => online, personlabel => "谁和我来一局！"},
			#{uid => 1965332, nickname => <<"微笑online">>, remark => <<"">>, lv => 13, statu => online, personlabel => "huohuohuo~~~"}]}],
	Groups = {44235, 66594, 79330},
	ServerParameter = #{node => term_to_binary(Node),
		inittime => lib_time:get_mstimestamp()},
	Extend = [{lv, 15}, {grade, 2}],
	Msg = #personsession{
		uid = Uid,
		nickname = <<"kitty">>,
		portrait = <<"https://yunbaidu.com?search=/landlords/touxiang/uid_10223.jpg">>,
		personlabel = <<"天气不错，出门打豆豆！">>,
		setting = term_to_binary([{voice, open}, {skin, 1032}]),
		rosters = term_to_binary(Rosters),
		groups = term_to_binary(Groups),
		serverparameter = lib_change:to_binary(ServerParameter),
		extend = term_to_binary(Extend)
	},
	Reply = mod_msg:produce_responselogon(?MT_103, Mid, Router, Msg),
	landlords_c2s:tcp_send(SockMod, Socket, Reply).


%% 查找用户
%% hooks_api
seekuser(UserData) ->
	case UserData of
		{uid, Uid} ->
			#{uid => Uid, nickname => "小倩", age => 21, city => "北京", lv => 16, label => "天是蓝的，云是白的，脸是黑的 =_=!"};
		{nickname, NickName} ->
			[#{uid => 4698250, nickname => NickName, age => 45, city => "广州", lv => 16, label => "这个人很懒，什么都没有留下"},
				#{uid => 7758991, nickname => NickName, age => 19, city => "南京", lv => 11, label => "没有什么可以阻挡，我对美食的向往"},
				#{uid => 4365303, nickname => NickName, age => 32, city => "成都", lv => 26, label => "我是大神"}]
	end.



%% fsm_next_state: Generate the next_state FSM tuple with different
%% timeout, depending on the future state
fsm_next_state(session_established, StateData) ->
	{next_state, session_established, StateData, ?AUTH_TIMEOUT};
fsm_next_state(wait_for_auth, #client_state{retry_times = TetryTimes} = StateData) when TetryTimes >= 1 ->
	{stop, normal, StateData};
fsm_next_state(wait_for_auth, #client_state{retry_times = TetryTimes} = StateData) ->
	{next_state, wait_for_auth, StateData#client_state{retry_times = TetryTimes + 1}, ?AUTH_TIMEOUT};
fsm_next_state(StateName, StateData) ->
	{next_state, StateName, StateData, ?HIBERNATE_TIMEOUT}.



