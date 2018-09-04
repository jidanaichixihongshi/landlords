%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 八月 2018 11:34
%%%-------------------------------------------------------------------

-module(mod_redis).

-include("logger.hrl").
%% API
-export([
	exists_redis/2,
	expire_redis/3,
	pexpire_redis/3,
	pexpireat_redis/3,
	keys_redis/2,
	del_redis/2,


	set_redis/3,
	get_redis/2,
	mset_redis/2,
	mget_redis/2,
	psetex_redis/4,
	incr_redis/2,
	incrby_redis/3,
	incrbyfloat_redis/3,
	decrby_redis/3,

	lpush_redis/3,
	lindex_redis/3,
	lrange_redis/4,
	llen_redis/2,

	zadd_redis/3,

	q_asyn/2]).


-define(TIMEOUT, 5000).


%% ------------------------------------------------------------------------
%% external api
%% ------------------------------------------------------------------------
%% -------------------------------------------------------------------------
%% redis键操作
%% -------------------------------------------------------------------------
%% 判断建是否存在
exists_redis(PoolName, Key) ->
	case q(PoolName, ["EXISTS", Key]) of
		{ok, <<"1">>} ->
			defined;
		_ ->
			undefined
	end.

%% 给键设置过期时间
expire_redis(PoolName, Key, Second) ->
	q(PoolName, ["EXPIRE", Key, Second]).

pexpire_redis(PoolName, Key, Msec) ->
	q(PoolName, ["PEXPIRE", Key, Msec]).

pexpireat_redis(PoolName, Key, Timestamp) ->
	q(PoolName, ["PEXPIREAT", Key, Timestamp]).


%% 查找符合模式的key
keys_redis(PoolName, Pattern) ->
	q(PoolName, ["KEYS", Pattern]).

del_redis(PoolName, Key) ->
	q(PoolName, ["DEL", Key]).

%% -------------------------------------------------------------------------
%% redis常规操作
%% -------------------------------------------------------------------------
set_redis(PoolName, Key, Data) ->
	q(PoolName, ["SET", Key, Data]).
get_redis(PoolName, Key) ->
	q(PoolName, ["GET", Key]).

%% Values :: [{K1,V1},{K2,V2}.{K3,V3},... ...]
mset_redis(PoolName, Values) when is_list(Values) ->
	NewValues =
		lists:foldl(
			fun({K, V}, Acc) -> [K, V | Acc];
				(A, Acc) -> [A | Acc]
			end, [], Values),
	q(PoolName, ["MSET" | NewValues]);
mset_redis(PoolName, Values) ->
	mget_redis(PoolName, lib_change:to_list(Values)).

mget_redis(PoolName, Keys) when is_list(Keys) ->
	q(PoolName, ["MGET" | Keys]);
mget_redis(PoolName, Keys) ->
	mget_redis(PoolName, lib_change:to_list(Keys)).

%% 存储数据并定时
psetex_redis(PoolName, Key, Data, Msec) ->
	q(PoolName, ["PSETEX", Key, Msec, Data]).

%% 加一
incr_redis(PoolName, Key) ->
	q(PoolName, ["INCR", Key]).

%% 加增量值
incrby_redis(PoolName, Key, Val) ->
	q(PoolName, ["INCRBY", Key, Val]).

incrbyfloat_redis(PoolName, Key, Val) ->
	q(PoolName, ["INCRBYFLOAT", Key, Val]).

%% 减增量
decrby_redis(PoolName, Key, Val) ->
	q(PoolName, ["DECRBY", Key, Val]).


%% -------------------------------------------------------------------------
%% redis列表操作
%% -------------------------------------------------------------------------
lpush_redis(PoolName, Key, Data) ->
	q(PoolName, ["LPUSH", Key, Data]).

%% 通过索引查找信息
lindex_redis(PoolName, Key, Index) ->
	q(PoolName, ["LINDEX", Key, Index]).

%% 一次读取 Destination - Origin 条
lrange_redis(PoolName, Key, Origin, Destination) ->
	q(PoolName, ["LRANGE", Key, Origin, Destination]).

llen_redis(PoolName, Key) ->
	{ok, BinLen} = q(PoolName, ["LLEN", Key]),
	binary_to_integer(BinLen).

%% -------------------------------------------------------------------------
%% redis有序集合操作
%% -------------------------------------------------------------------------

zadd_redis(PoolName, Key, Values) when is_list(Values) ->
	q(PoolName, ["ZADD", Key | Values]);
zadd_redis(PoolName, Key, Values) ->
	zadd_redis(PoolName, Key, lib_change:to_list(Values)).




%% ------------------------------------------------------------------------
%% internal api
%% ------------------------------------------------------------------------
q(PoolName, Command) ->
	q(PoolName, Command, ?TIMEOUT, 1).

q(PoolName, Command, Timeout, Times) ->
	try
		q0(PoolName, Command, Timeout)
	catch Type:Reason ->
		case Reason of
			{timeout, _} ->
				timer:sleep(1000),
				Times_ = Times + 1,
				if
					Times_ =< 3 ->
						q(PoolName, Command, Timeout, Times_);
					true ->
						throw({Type, Reason})
				end;
			_ ->
				?ERROR("Type:~p Reason:~p Trace:~p ~n", [Type, Reason, erlang:get_stacktrace()]),
				throw({Type, Reason})
		end
	end.

q0(PoolName, Command, Timeout) ->
	poolboy:transaction(PoolName,
		fun(Worker) ->
			eredis:q(Worker, Command, Timeout)
		end).

qp(PoolName, Pipeline) ->
	qp(PoolName, Pipeline, ?TIMEOUT).
qp(PoolName, Pipeline, Timeout) ->
	poolboy:transaction(PoolName,
		fun(Worker) ->
			eredis:qp(Worker, Pipeline, Timeout)
		end).


q_asyn(PoolName, Command) ->
	q_asyn(PoolName, Command, ?TIMEOUT, 1).
q_asyn(PoolName, Command, Timeout) ->
	q_asyn(PoolName, Command, Timeout, 1).
q_asyn(PoolName, Command, Timeout, Times) ->
	try
		q0_asyn(PoolName, Command, Timeout)
	catch Type:Reason ->
		case Reason of
			{timeout, _} ->
				timer:sleep(1000),
				Times_ = Times + 1,
				if
					Times_ =< 3 -> q_asyn(PoolName, Command, Timeout, Times_);
					true -> throw({Type, Reason})
				end;
			_ -> throw({Type, Reason})
		end
	end.

q0_asyn(PoolName, Command) ->
	q_asyn(PoolName, Command, ?TIMEOUT).
q0_asyn(PoolName, Command, _Timeout) ->
	poolboy:transaction(PoolName,
		fun(Worker) ->
			eredis:q_noreply(Worker, Command)
		end).

transaction(PoolName, Fun) when is_function(Fun) ->
	F = fun(C) ->
		try
			{ok, <<"OK">>} = eredis:q(C, ["MULTI"]),
			Fun(C),
			eredis:q(C, ["EXEC"])
		catch Klass:Reason ->
			{ok, <<"OK">>} = eredis:q(C, ["DISCARD"]),
			{Klass, Reason}
		end
			end,
	poolboy:transaction(PoolName, F).












