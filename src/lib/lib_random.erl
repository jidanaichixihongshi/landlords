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
%%% Created : 29. 六月 2018 14:25
%%%-------------------------------------------------------------------

-module(lib_random).
-auth("cw").

-compile(export_all).

%% 随机返回两个数之间的一个数
-spec random(Min :: integer(), Max :: integer()) -> integer().
random(Min, Max) ->
	Min2 = Min - 1,
	rand:uniform(Max - Min2) + Min2.

%% 从一个list中随机选择一个元素
-spec select([term()]) -> term().
select(List) ->
	RandId = rand:uniform(length(List)),
	lists:nth(RandId, List).

%% 哈希值计算
get_hash(Term, Range) ->
	erlang:phash(Term, Range).


%% 从一个list中随机选择n个元素
-spec select_n(non_neg_integer(), [term()]) -> [term()].
select_n(N, Lst) ->
	select_n(N, Lst, []).
select_n(0, _Lst, Result) ->
	Result;
select_n(_, [], Result) ->
	Result;
select_n(N, Lst, Result) ->
	R = select(Lst),
	NewLst = lists:delete(R, Lst),
	select_n(N - 1, NewLst, [R | Result]).

%% -----------------------------------------------------------------------------
%% internal function
%% -----------------------------------------------------------------------------
















