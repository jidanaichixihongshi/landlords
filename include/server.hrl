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
%%% Created : 23. 六月 2018 13:56
%%%-------------------------------------------------------------------

-include("proxy.hrl").
-include("group.hrl").
-include("room.hrl").
-include("common.hrl").
-include("error.hrl").


-define(CONFIG_FILE_DIR, "config/sys.config").                %% 配置文件


%% 时间参数
-define(RECEIVER_HIBERNATE_TIMEOUT, 90000).                            %% 休眠
-define(AUTH_TIMEOUT, 12000).                                  %% 登录超时
-define(HIBERNATE_TIMEOUT, 90000).                            %% 休眠
-define(TIMEOUT, 50000).
-define(DATA_OVERTIME, 3000).                                  %% 消息延时



%% ets表名称
-define(PUBLIC_STORAGE_ETS, public_storage_ets).              %% 公共临时存储ETS
-define(PROXY_STATE_ETS, proxy_state_ets).                    %% 代理进程存储ETS

%% ETS表配置
-define(ETS_READ_CONCURRENCY, {read_concurrency, true}).      %% 并发读
-define(ETS_WRITE_CONCURRENCY, {write_concurrency, true}).    %% 并发写
-define(ETS_LIST, [
	{public_storage_ets, [set, public, named_table, ?ETS_READ_CONCURRENCY, ?ETS_WRITE_CONCURRENCY]},

	%% proxy存储表
	{proxy_state_ets, [set, public, named_table, ?ETS_READ_CONCURRENCY, ?ETS_WRITE_CONCURRENCY, {keypos, #proxy_state.uid}]},
	{group_state_ets, [set, public, named_table, ?ETS_READ_CONCURRENCY, ?ETS_WRITE_CONCURRENCY, {keypos, #group_state.gid}]},
	{room_state_ets, [set, public, named_table, ?ETS_READ_CONCURRENCY, ?ETS_WRITE_CONCURRENCY, {keypos, #room_state.rid}]}
]).


%% 用户状态
-define(STATUS_ONLINE, 0).          %% 在线
-define(STATUS_OFFLINE, 1).          %% 离线
-define(STATUS_LOGGING, 2).          %% 正在登陆
-define(STATUS_REGISTERING, 3).    %% 正在注册

%% 其他参数
-define(ATTACK_HEAD_COUNT, 10).				%% 遭受攻击极限次数

%% 用户数据
-record(user_data, {
	uid,                      %% 用户id（唯一性）
	nickname :: <<>>,          %% 昵称
	avatar,                    %% 头像
	level,                    %% 用户等级
	version :: <<>>,          %% 客户端版本
	device,                    %% 客户端类型
	device_id :: <<>>,        %% 设备id
	app_id,
	token :: <<>>,
	location :: <<>>,        %% 登录地点
	login_time,               %% 登录时间
	phone :: <<>>              %% 电话
}).

%% 用户连接信息
-record(client_state, {
	uid,                %% 用户id（唯一性）
	proxy,              %% 代理进程
	status,              %% 用户状态(online | offline | logging | registering)
	pid,                %% 用户进程
	node,                %% 链接节点
	socket,            %% 连接套接字
	ip,                  %% 连接ip
	port,                %% 连接端口
	sockmod,
	retry_times,
	user_data = #user_data{}  %% 用户详细信息
}).










