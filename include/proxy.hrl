%%%-------------------------------------------------------------------
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


-record(proxy_state, {
	uid,                      %% 用户id
	node,											%% proxy 节点
	pid,											%% proxy 进程
	client = []               %% 代理进程的client集合 #client_state
}).


-record(proxy_client, {
	pid,											%% client 进程，下线后为undefined
	device :: <<>>,										%% 连接方式，1 手机安卓		2 手机苹果		3 windows电脑		4 网页
	token :: <<>>
}).





