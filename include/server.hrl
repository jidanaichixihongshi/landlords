%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 六月 2018 13:56
%%%-------------------------------------------------------------------

-include("common.hrl").
-include("error.hrl").


-define(CONFIG_FILE_DIR, "config/sys.config").                %% 配置文件

-define(TCP_OPTIONS, [binary,
	{packet, 0},
	{reuseaddr, true},
	{nodelay, true},
	{delay_send, false},
	{send_timeout, 5000},
	{keepalive, true},
	{exit_on_close, true}]).

-define(HIBERNATE_TIMEOUT, 30000).                            %% 休眠
-define(TIMEOUT, 50000).
-define(DATA_OVERTIME, 3000).																	%% 消息延时
-define(AUTH_TIMEOUT, 12000).																	%% 登录超时
-define(FSM_TIMEOUT, 60000).

%% 消息标志位，控制消息走向
-define(SIGN0, 0).					%% 节点消息
-define(SIGN1, 1).					%% c2s消息
-define(SIGN2, 2).					%% s2c消息


-define(PUBLIC_STORAGE_ETS, public_storage_ets).              %% 公共临时存储ETS
-define(PROXY_STATE_ETS, proxy_state_ets).                    %% 代理进程存储ETS

-define(ETS_READ_CONCURRENCY, {read_concurrency, true}).      %% 并发读
-define(ETS_WRITE_CONCURRENCY, {write_concurrency, true}).    %% 并发写

%% ETS表配置
-define(ETS_LIST, [
	{public_storage_ets, [set, public, named_table, ?ETS_READ_CONCURRENCY, ?ETS_WRITE_CONCURRENCY]},

	%% proxy存储表
	{proxy_state_ets, [set, public, named_table, ?ETS_READ_CONCURRENCY, ?ETS_WRITE_CONCURRENCY, {keypos, #proxy_state.uid}]}
]).


%% 用户状态
-define(STATUS_ONLINE, 0).        	%% 在线
-define(STATUS_OFFLINE, 1).        	%% 离线
-define(STATUS_LOGGING, 2).        	%% 正在登陆
-define(STATUS_REGISTERING, 3).   	%% 正在注册

%% 用户状态
-define(ONLINE, online).		%% 在线状态
-define(OFFLINE, offline).	%% 离线状态
-define(LOGGING, logging).	%% 正在登陆
-define(REGISTERING, register).	%% 正在注册

%% 用户数据
-record(user_data, {
	uid,                      %% 用户id（唯一性）
	nickname :: <<>>,        	%% 昵称
	level,                    %% 用户等级
	version :: <<>>,        	%% 客户端版本
	device :: <<>>,						%% 客户端类型
	device_id :: <<>>,        %% 设备id
	app_id,
	token :: <<>>,
	location :: <<>>,       	%% 登录地点
	login_time,               %% 登录时间
	phone                    	%% 电话
}).

%% 用户连接信息
-record(client_state, {
	uid,              	%% 用户id（唯一性）
	proxy,							%% 代理进程
	status,            	%% 用户状态(online | offline | logging | registering)
	pid,              	%% 用户进程
	node,            		%% 链接节点
	socket,           	%% 连接套接字
	ip,                	%% 连接ip
	port,              	%% 连接端口
	sockmod,
	retry_times,
	user_data = #user_data{}  %% 用户详细信息
}).










