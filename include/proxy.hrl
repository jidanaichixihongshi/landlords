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
%%% Created : 19. 六月 2018 19:09
%%%-------------------------------------------------------------------


%% ets表
-define(PROXY_STATE, proxy_state_ets).

%% 键
-define(USER_PROXY_ETS, "user_proxy_ets_").

%% 登录方式
-define(DEVICE_1, 1).		%% 安卓
-define(DEVICE_2, 2).		%% ios
-define(DEVICE_3, 3).		%% windows
-define(DEVICE_4, 4).		%% 网页

-record(proxy_state, {
	uid,                      %% 用户id
	node,											%% proxy 节点
	pid,											%% proxy 进程
	room,											%% room列表
	client = []               %% 代理进程的client集合 #client_state
}).


-record(proxy_client, {
	pid,											%% client 进程，下线后为undefined
	device,										%% 连接方式，1 手机安卓		2 手机苹果		3 windows电脑		4 网页
	token :: <<>>
}).





