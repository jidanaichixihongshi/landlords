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
%%% Created : 29. 九月 2018 18:33
%%%-------------------------------------------------------------------
-module(mod_c2s_handle).
-auth("cw").

-include("server.hrl").
-include("logger.hrl").
-include_lib("protobuf_pb.hrl").

-export([
	handle_msg_c2s/3,
	handle_msg_s2s/3]).

%% hooks api
-export([
	update_session/1,
	seek_user/1]).

%% c2s消息
handle_msg_c2s(#proto{mt = Mt, sig = ?SIGN1, router = Router, data = Data, ts = Timestamp} = Msg, StateName,
	#client_state{socket = Socket, sockmod = SockMod} = StateData) ->
	?DEBUG("handle msg: ~p~n", [Msg]),
	(not mod_msg:check_msg_timestamp(Timestamp)) andalso throw(?ERROR_113),
	TData = binary_to_term(Data),
	#data{dt = Dt, children = Child} = TData,
	NewStateData =
		if
			Dt == 0 orelse Dt == 3 ->  %% chat消息
				landlords_c2s:tcp_send(SockMod, Socket, Msg#proto{sig = ?SIGN2}),
				StateData;
			Dt == 1 ->
				handle_request(Mt, binary_to_term(Child), StateData);
			Dt == 2 ->
				handle_push(Mt, Msg, StateName, StateData);
			true ->
				?WARNING("undefined dt type for msg : ~p~n", [TData]),
				StateData
		end,
	fsm_next_state(StateName, NewStateData).

%% s2s消息
handle_msg_s2s(#proto{mt = Mt, sig = ?SIGN0, router = Router, data = Data, ts = Timestamp} = Msg, StateName,
	#client_state{socket = Socket, sockmod = SockMod} = StateData) ->
	?DEBUG("handle msg: ~p~n", [Msg]),
	(not mod_msg:check_msg_timestamp(Timestamp)) andalso throw(?ERROR_113),
	TData = binary_to_term(Data),
	NewStateData =
		if
			TData#data.dt == 0 orelse TData#data.dt == 3 ->  %% chat消息
				landlords_c2s:tcp_send(SockMod, Socket, Msg#proto{sig = ?SIGN2}),
				StateData;
			TData#data.dt == 1 ->
				handle_request(Msg, StateData),
				StateData;
			TData#data.dt == 2 ->
				handle_msg(Mt, Msg, StateName, StateData),
				StateData;
			true ->
				?WARNING("undefined dt type for msg : ~p~n", [TData]),
				StateData
		end,
	fsm_next_state(StateName, NewStateData).


handle_request(Mt, #request{rt = Rt,rm = Rm} = Child, StateData) ->
	if
		Mt == ?MT_107 ->	%% 个人相关请求
			if
				Rt == 10 -> %% 查询用户
					landlords_hooks:run(seekuser,node(),{StateData#client_state.uid, , SockMod, Socket});
				true ->
			end;
		true ->

	end.


handle_msg(?MT_103, Msg, _StateName, StateData) ->
	case binary_to_term(Msg#proto.data) of
		{session, all} ->
			landlords_hooks:run(update_session, node(), StateData);
		{session, ?ERROR_0} ->
			?DEBUG("session success : ~p~n", [Msg]);
		_ ->
			?WARNING("undefinde request : ~p~n", [Msg])
	end;
handle_msg(?MT_104, #proto{router = Router} = Msg, _StateName, #client_state{socket = Socket, sockmod = SockMod} = _StateData) ->
	case binary_to_term(Msg#proto.data) of
		Request when is_list(Request) ->
			{rt, RT} = lists:keyfind(rt, 1, Request),
			{uid, Uid} = lists:keyfind(uid, 1, Request),
			if
				RT == 2 ->
					%% 触发钩子
					landlords_hooks:run(addroster, node(), Uid);
				RT == 4 ->
					Reply = Msg#proto{sig = ?SIGN2, router = Router#router{to = term_to_binary(Uid)}},
					landlords_c2s:tcp_send(SockMod, Socket, Reply);
				RT == 5 ->
					landlords_hooks:run(delroster, node(), Uid);
				true ->
					?WARNING("undefinde request : ~p~n", [Msg])
			end;
		_ ->
			?WARNING("undefinde request : ~p~n", [Msg])
	end;
handle_msg(?MT_117, Msg, _StateName, _StateData) ->
	case binary_to_term(Msg#proto.data) of
		Request when is_list(Request) ->
			{rt, RT} = lists:keyfind(rt, 1, Request),
			if
				RT == 1 ->
					landlords_hooks:run(creategroup, node(), {Msg#proto.router, Request});
				RT == 3 ->
					landlords_hooks:run(setgroup, node(), {Msg#proto.router, Request});
				RT == 5 ->
					landlords_hooks:run(joingroup, node(), {Msg#proto.router, Request});
				RT == 7 ->
					landlords_hooks:run(exitgroup, node(), Request);
				true ->
					?WARNING("undefined group request: ~p~n", [Msg])
			end;
		_ ->
			?WARNING("undefined group request: ~p~n", [Msg])
	end;
handle_msg(?MT_121, Msg, _StateName, #client_state{uid = Uid, sockmod = SockMod, socket = Socket} = _StateData) ->
	#proto{router = Router, data = Data} = Msg,
	case binary_to_term(Data) of
		{seekuser, Information} ->
			landlords_hooks:run(seekuser, node(), {Uid, Router, Information, SockMod, Socket});
		_ ->
			?WARNING("undefinde request : ~p~n", [Msg])
	end;
handle_msg(?MT_121, Msg, _StateName, #client_state{uid = Uid, sockmod = SockMod, socket = Socket} = _StateData) ->
	#proto{router = Router, data = Data} = Msg,
	case binary_to_term(Data) of
		{seekuser, Information} ->
			landlords_hooks:run(seekuser, node(), {Uid, Router, Information, SockMod, Socket});
		_ ->
			?WARNING("undefinde request : ~p~n", [Msg])
	end;
handle_msg(Mt, _, _, _StateData) ->
	?WARNING("undefined mt type : ~p~n", [Mt]).


%% -------------------------------------------------------------------------
%% 一些特殊消息的处理
%% -------------------------------------------------------------------------
%% hooks_api
update_session(#client_state{uid = Uid, node = Node, socket = Socket, sockmod = SockMod} = _StateData) ->
	%#user_data{nickname = NickName, } = UserData,
	Router = #router{
		from = lib_change:to_binary(Uid),
		fdevice = <<"1">>,
		fserver = <<"">>,
		to = <<"">>,
		tdevice = <<"">>,
		tserver = <<"">>},
	Rosters = [#{name => "我的好友",
		members => [#{uid => 1396554, nickname => <<"玲花">>, remark => <<"">>, lv => 10, statu => online, personlabel => "最怕刮风下雨！"},
			#{uid => 5563988, nickname => <<"皮皮球">>, remark => <<"">>, lv => 3, statu => offline, personlabel => "这个人很懒，什么都没有留下！"},
			#{uid => 7622344, nickname => <<"千层酥">>, remark => <<"">>, lv => 21, statu => online, personlabel => "谁和我来一局！"},
			#{uid => 1965332, nickname => <<"微笑online">>, remark => <<"">>, lv => 13, statu => online, personlabel => "huohuohuo~~~"}]}],
	Groups = [44235, 66594, 79330],
	ServerParameter = #{node => term_to_binary(Node),
		inittime => lib_time:get_mstimestamp()},
	Extend = [{lv, 15}, {grade, 2}],
	Pm = #{
		uid => Uid,
		nickname => <<"kitty">>,
		portrait => <<"https://yunbaidu.com?search=/landlords/touxiang/uid_10223.jpg">>,
		personlabel => <<"天气不错，出门打豆豆！">>,
		setting => [{voice, open}, {skin, 1032}],
		rosters => Rosters,
		groups => Groups,
		serverparameter => ServerParameter,
		extend => Extend
	},
	reply_push(Uid, SockMod, Socket, Router, ?MT_103, 2, Pm).


%% 查找用户
%% hooks_api
seek_user({Uid, Router, Information, SockMod, Socket}) ->
	Pm =
		case Information of
			{uid, Uid} ->
				#{uid => Uid, nickname => "小倩", age => 21, city => "北京", lv => 16, label => "天是蓝的，云是白的，脸是黑的 =_=!"};
			{nickname, NickName} ->
				[#{uid => 4698250, nickname => NickName, age => 45, city => "广州", lv => 16, label => "这个人很懒，什么都没有留下"},
					#{uid => 7758991, nickname => NickName, age => 19, city => "南京", lv => 11, label => "没有什么可以阻挡，我对美食的向往"},
					#{uid => 4365303, nickname => NickName, age => 32, city => "成都", lv => 26, label => "我是大神"}]
		end,
	reply_push(Uid, SockMod, Socket, Router, ?MT_107, 10, Pm).


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



reply_push(Uid, SockMod, Socket, Router, Mt, Pt, Pm) ->
	Mid = mod_msg:produce_mid(Uid),
	Child = #push{
		pt = term_to_binary(Pt),
		pm = term_to_binary(Pm),
		extend = <<"">>
	},
	NewData = mod_msg:produce_data(2, Mid, Child, null),
	Reply =
		#proto{
			mt = Mt,
			sig = ?SIGN2,
			router = Router,
			data = term_to_binary(NewData),
			ts = lib_time:get_mstimestamp()
		},
	landlords_c2s:tcp_send(SockMod, Socket, Reply).



