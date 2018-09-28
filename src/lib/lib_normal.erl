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
%%% Created : 25. 六月 2018 10:12
%%%-------------------------------------------------------------------

-module(lib_normal).
-auth("cw").

-compile(export_all).
-include("common.hrl").

%% 去掉字符串空格
-spec remove_string_black(L :: string()) -> string().
remove_string_black(L) ->
	lists:reverse(remove_string_loop(L, [])).

remove_string_loop([], L) -> L;
remove_string_loop([I | L], LS) ->
	case I of
		32 -> remove_string_loop(L, LS);
		_ -> remove_string_loop(L, [I | LS])
	end.


%% -----------------------------------------------------------------------------
%% 列表操作
%% -----------------------------------------------------------------------------
%% 获取元组列表中对应k的v
get_v_by_k(K, L) ->
	get_v_by_k(K, L, undefined).
get_v_by_k(K, L, Default) ->
	case lists:keyfind(K, 1, L) of
		{_, V} -> V;
		_ -> Default
	end.

%% 列表去重（不排序）
list_duplicate(L) ->
	list_duplicate(L, []).
list_duplicate([], L1) ->
	L1;
list_duplicate([H | L], L1) ->
	case lists:member(H, L1) of
		true -> list_duplicate(L, L1);
		false -> list_duplicate(L, [H | L1])
	end.

%%替换列表指定位置的元素
%%eg: replace([a,b,c,d], 2, g) -> [a,g,c,d]
replace(List, Key, NewElem) ->
	NewList = lists:reverse(List),
	Len = length(List),
	case Key =< 0 orelse Key > Len of
		true ->
			List;
		false ->
			replace_elem(Len, [], NewList, Key, NewElem)
	end.
replace_elem(0, List, _OldList, _Key, _NewElem) ->
	List;
replace_elem(Num, List, [Elem | OldList], Key, NewElem) ->
	NewList =
		case Num =:= Key of
			true -> [NewElem | List];
			false -> [Elem | List]
		end,
	replace_elem(Num - 1, NewList, OldList, Key, NewElem).

%% -----------------------------------------------------------------------------
%% 存储操作
%% -----------------------------------------------------------------------------
%% ets表数据操作
get_val(Key, Table) ->
	case ets:lookup(Table, Key) of
		[{Key, Value}] -> Value;
		_ -> ?UNDEFINED
	end.
set_val(Key, Val, Table) ->
	ets:insert(Table, {Key, Val}).
del_val(Key, Table) ->
	ets:delete(Table, Key).

%% 内存数据操作
get_mem(Module, Key) ->
	case erlang:get({Module, Key}) of
		Val when is_list(Val) ->
			Val;
		_ ->
			[]
	end.
set_mem(Module, Key, Val) ->
	OldMem = get_mem(Module, Key),
	erlang:put({Module, Key}, [Val | OldMem]).
replace_mem(Module, Key, Val) ->
	erlang:put({Module, Key}, [Val]).
del_mem(Module, Key) ->
	erlang:erase({Module, Key}).

%% -----------------------------------------------------------------------------
%% map操作
%% -----------------------------------------------------------------------------



%% -----------------------------------------------------------------------------
%% internal function
%% -----------------------------------------------------------------------------













