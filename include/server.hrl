%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 六月 2018 13:56
%%%-------------------------------------------------------------------

-define(CONFIG_FILE_DIR, "config/sys.config").								%% 配置文件


-define(TCP_OPTIONS, [binary,
	{packet, 0},
	{reuseaddr, true},
	{nodelay, true},
	{delay_send, false},
	{send_timeout, 5000},
	{keepalive, true},
	{exit_on_close, true}]).
-define(HEART_BREAK_TIME, 30000).  												 		%% 心跳间隔

-define(CONFIG_PARAMETER_ETS, config_parameter_ets).					%% 配置参数ETS
-define(PUBLIC_STORAGE_ETS, public_storage_ets).							%% 公共临时存储ETS

-define(ETS_READ_CONCURRENCY, {read_concurrency, true}).			%% 并发读
-define(ETS_WRITE_CONCURRENCY, {write_concurrency, true}).		%% 并发写

%% ETS表配置
-define(ETS_LIST,[
	{config_parameter_ets, [set, public, named_table, ?ETS_READ_CONCURRENCY, ?ETS_WRITE_CONCURRENCY]},
	{public_storage_ets, [set, public, named_table, ?ETS_READ_CONCURRENCY, ?ETS_WRITE_CONCURRENCY]}
]).

%% 用户连接信息
-record(state, {
	ref,
	node,							%% 链接节点
	socket,						%% 链接套接字
	transport,
	otp,
	ip,
	port}).

-define(TIMEOUT, 50000).



