%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 六月 2018 15:59
%%%-------------------------------------------------------------------


%% 消息路由
-record(landlords_router, {
	type,								%% 路由类型，personal/group
	form,								%% 消息来源
	to,									%% 消息目的地
	to_gid,
	to_node,
	to_pid,
	msg		              %% 消息
}).





