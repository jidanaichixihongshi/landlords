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
%%% Created : 23. 六月 2018 12:09
%%%-------------------------------------------------------------------

%% 函数宏
-define(IF(A, B, C), (case (A) of true -> (B); _ -> (C) end)).

%% 固定参数
-define(UNDEFINED, undefined).
-define(LOCALNODE, node()).

-define(UID_HASH_RANGE, 10000000).      %% 和uid相关的hash值取值范围


%% 消息标志位，控制消息走向
-define(SIGN0, 0).					%% 节点消息
-define(SIGN1, 1).					%% c2s消息
-define(SIGN2, 2).					%% s2c消息

%% 消息类型
-define(MT_101, 101).		%% 心跳消息
-define(MT_102, 102).		%% 注册相关
-define(MT_103, 103).		%% 登录消息
-define(MT_104, 106).		%% 服务推送
-define(MT_107, 107).		%% 个人相关消息

-define(MT_117, 117).		%% 群相关
-define(MT_118, 127).		%% 房间相关

-define(MT_121, 129).		%% 房间内游戏相关


%% 钩子注册
-define(HOOKS_LIST, [
	%% 其他操作
	{update_session, ?LOCALNODE, mod_c2s_handle, update_session, 50},
	{seekuser, ?LOCALNODE, mod_c2s_handle, seek_user, 50},
	%% roster操作
	{addroster, ?LOCALNODE, mod_roster, add_roster, 50},
	{delroster, ?LOCALNODE, mod_roster, del_roster, 50},
	%% 群操作
	{creategroup, ?LOCALNODE, mod_group, create_group, 50},
	{setgroup, ?LOCALNODE, mod_group, set_group, 50},
	{joingroup, ?LOCALNODE, mod_group, join_group, 50},
	{exitgroup, ?LOCALNODE, mod_group, exit_group, 50},
	{groupsession, ?LOCALNODE, mod_group, group_session, 50},
	%% 房间操作
	{createroom, ?LOCALNODE, mod_room, create_room, 50},


	{addroom, ?LOCALNODE, mod_room, join_room, 50},
	{leaveroom, ?LOCALNODE, mod_room, leave_room, 50},
	{roomsession, ?LOCALNODE, mod_room, room_session, 50}
]).












