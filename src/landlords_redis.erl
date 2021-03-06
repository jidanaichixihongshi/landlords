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
%%% Created : 29. 六月 2018 13:33
%%%-------------------------------------------------------------------
-module(landlords_redis).
-auth("cw").

-include("redis_push.hrl").

-export([
	set_proxy/3,
	get_proxy/1,
	del_proxy/1,
	set_group/3,
	get_group/1,
	del_group/1]).

%% --------------------------------------------------------------------------------
%% proxy
set_proxy(Uid, Node, Pid) ->
	HKey = get_proxy_key(Uid),
	mod_redis:hmset_redis(?POOL_REDIS, HKey, [{node, Node}, {pid, Pid}]).

get_proxy(Uid) ->
	HKey = get_proxy_key(Uid),
	{ok, [Pid]} = mod_redis:hmget_redis(?POOL_REDIS, HKey, [pid]),
	if
		Pid /= undefined -> binary_to_term(Pid);
		true -> undefined
	end.

del_proxy(Uid) ->
	Key = get_proxy_key(Uid),
	mod_redis:hdel_redis(?POOL_REDIS, Key).

%% --------------------------------------------------------------------------------
%% group
set_group(Gid, Node, Pid) ->
	HKey = get_group_key(Gid),
	mod_redis:hmset_redis(?POOL_REDIS, HKey, [{node, Node}, {pid, Pid}]).

get_group(Gid) ->
	HKey = get_group_key(Gid),
	{ok, [Pid]} = mod_redis:hmget_redis(?POOL_REDIS, HKey, [pid]),
	if
		Pid /= undefined -> binary_to_term(Pid);
		true -> undefined
	end.

del_group(Gid) ->
	Key = get_group_key(Gid),
	mod_redis:hdel_redis(?POOL_REDIS, Key).


%% -----------------------------------------------------------------------------
%% internal function
%% -----------------------------------------------------------------------------
get_proxy_key(Uid) ->
	?USER_PROXY_REDIS ++ lib_change:to_list(Uid).

get_group_key(Gid) ->
	?GROUP_REDIS ++ lib_change:to_list(Gid).














