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


-export([update_session_established/1]).


%% -------------------------------------------------------------------------
%% 一些特殊消息的处理
%% -------------------------------------------------------------------------
update_session_established(#client_state{uid = Uid, pid = Pid, socket = Socket, sockmod = SockMod} = StateData) ->
	Mid = mod_msg:produce_mid(Uid),
	Msg = "{{address,
						{<<" ++ "我的好友" ++ ">>,
							{{{nickname,<<" ++ "小太阳" ++ ">>},{uid,1286147},{status,onlie}}},
							{{{nickname,<<" ++ "大鹏" ++ ">>},{uid,1865322},{status,offline}}}}
					},
					{groups,
						{{gid,29643},{name,<<" ++ "一起来聊天" ++ ">>},{numbers,
							{{{nickname,<<" ++ "小太阳" ++ ">>},{uid,1286147},{status,onlie}}},
							{{{nickname,<<" ++ "大鹏" ++ ">>},{uid,1865322},{status,offline}}}}}}}",
	Reply = mod_msg:produce_session(Mid, Msg),
	Pid ! {fsm_next_state, wait_for_resume},
	landlords_c2s:tcp_send(SockMod, Socket, Reply).










