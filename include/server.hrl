%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 六月 2018 13:56
%%%-------------------------------------------------------------------

-define(CONFIG_FILE_DIR, "config/sys.config").                %% 配置文件


-define(TCP_OPTIONS, [binary,
	{packet, 0},
	{reuseaddr, true},
	{nodelay, true},
	{delay_send, false},
	{send_timeout, 5000},
	{keepalive, true},
	{exit_on_close, true}]).

-define(HEART_BREAK_TIME, 15000).                              %% 心跳间隔
-define(TIMEOUT, 50000).


-define(CONFIG_PARAMETER_ETS, config_parameter_ets).          %% 配置参数ETS
-define(PUBLIC_STORAGE_ETS, public_storage_ets).              %% 公共临时存储ETS

-define(ETS_READ_CONCURRENCY, {read_concurrency, true}).      %% 并发读
-define(ETS_WRITE_CONCURRENCY, {write_concurrency, true}).    %% 并发写

%% ETS表配置
-define(ETS_LIST, [
	{config_parameter_ets, [set, public, named_table, ?ETS_READ_CONCURRENCY, ?ETS_WRITE_CONCURRENCY]},
	{public_storage_ets, [set, public, named_table, ?ETS_READ_CONCURRENCY, ?ETS_WRITE_CONCURRENCY]}
]).


%% 用户状态
-define(STATUS_ONLINE, 0).    		%% 在线
-define(STATUS_OFFLINE, 1).    		%% 离线
-define(STATUS_LOGGING, 1).    		%% 正在登陆
-define(STATUS_REGISTERING, 1).   %% 正在注册

%% 用户数据
-record(user_data, {
	uid,											%% 用户id（唯一性）
	nickname	:: <<>>,				%% 昵称
	level,										%% 用户等级
	version		:: <<>>,				%% 客户端版本
	device_id	:: <<>>,				%% 设备id
	location	:: <<>>,				%% 登录地点
	login_time,								%% 登录时间
	phone 										%% 电话
}).

%% 用户连接信息
-record(state, {
	uid,							%% 用户id（唯一性）
	status,						%% 用户状态(online | offline | logging | registering)
	pid,							%% 用户进程
	node, 						%% 链接节点
	socket,           %% 连接套接字
	ref,
	ip,								%% 连接ip
	port,							%% 连接端口
	transport,
	otp,
	user_data = #user_data{}	%% 用户详细信息
}).






