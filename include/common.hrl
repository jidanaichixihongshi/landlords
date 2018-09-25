%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 六月 2018 12:09
%%%-------------------------------------------------------------------

%% 函数宏
-define(IF(A, B, C), (case (A) of true -> (B); _ -> (C) end)).

%% 固定参数
-define(UNDEFINED, undefined).
-define(LOCALNODE, node()).

-define(UID_HASH_RANGE, 10000000).      %% 和uid相关的hash值取值范围

%% 消息类型
-define(MT_101, 101).		%% 心跳消息
-define(MT_102, 102).		%% 登录相关
-define(MT_103, 103).		%% 增量消息
-define(MT_104, 104).		%% roster相关
-define(MT_107, 107).		%% 聊天消息


-define(MT_118, 118).		%% 群增量


%% 钩子注册
-define(HOOKS_LIST, [
	{update_session, ?LOCALNODE, mod_c2s_handle, update_session, 50},

	{seekuser, ?LOCALNODE, mod_c2s_handle, seekuser, 50},
	{requestfriend, ?LOCALNODE, mod_c2s_handle, request_friend, 50},
	{rsponserequestfriend, ?LOCALNODE, mod_c2s_handle, add_roster, 50},
	{removefriend, ?LOCALNODE, mod_c2s_handle, del_roster, 50},
	{creategroup, ?LOCALNODE, mod_c2s_handle, create_group, 50},
	{responsecreategroup, ?LOCALNODE, landlords_group, response_create_group, 50},
	{groupsession, ?LOCALNODE, mod_c2s_handle, group_session, 50}
]).












