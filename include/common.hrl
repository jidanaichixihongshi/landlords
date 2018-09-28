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
-define(MT_102, 102).		%% 登录相关
-define(MT_103, 103).		%% 增量消息
-define(MT_104, 104).		%% roster相关
-define(MT_107, 107).		%% 聊天消息

-define(MT_117, 117).		%% 群操作相关
-define(MT_118, 118).		%% 群增量

-define(MT_121, 121).		%% 查询消息


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
	{addgroup, ?LOCALNODE, mod_group, add_group, 50},
	{leavegroup, ?LOCALNODE, mod_group, leave_group, 50},
	{groupsession, ?LOCALNODE, mod_group, group_session, 50},
	%% 房间操作
	{createroom, ?LOCALNODE, landlords_room, create_room, 50},
	{addroom, ?LOCALNODE, landlords_room, add_room, 50},
	{leaveroom, ?LOCALNODE, landlords_room, leave_room, 50},
	{roomsession, ?LOCALNODE, landlords_room, room_session, 50}
]).












