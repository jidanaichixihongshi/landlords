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
%%% Created : 25. 六月 2018 11:32
%%%-------------------------------------------------------------------

-module(lib_change).
-auth("cw").

-compile(export_all).

%% Any to list
-spec to_list(Msg :: any()) -> list().
to_list(Msg) when is_list(Msg) ->
	Msg;
to_list(Msg) when is_atom(Msg) ->
	atom_to_list(Msg);
to_list(Msg) when is_binary(Msg) ->
	binary_to_list(Msg);
to_list(Msg) when is_integer(Msg) ->
	integer_to_list(Msg);
to_list(Msg) when is_float(Msg) ->
	f2s(Msg);
to_list(Msg) when is_tuple(Msg) ->
	tuple_to_list(Msg);
to_list(_) ->
	throw(other_value).

%% Any to atom
-spec to_atom(Msg :: any()) -> atom().
to_atom(Msg) when is_atom(Msg) ->
	Msg;
to_atom(Msg) when is_binary(Msg) ->
	list_to_atom2(binary_to_list(Msg));
to_atom(Msg) when is_list(Msg) ->
	list_to_atom2(Msg);
to_atom(_) ->
	throw(other_value).

%% Any to binary
-spec to_binary(Msg :: any()) -> binary().
to_binary(Msg) when is_binary(Msg) ->
	Msg;
to_binary(Msg) when is_tuple(Msg) ->
	term_to_binary(Msg);
to_binary(Msg) when is_atom(Msg) ->
	list_to_binary(atom_to_list(Msg));
to_binary(Msg) when is_map(Msg) ->
	LMsg = maps:to_list(Msg),
	term_to_binary(LMsg);
%%atom_to_binary(Msg, utf8);
to_binary(Msg) when is_list(Msg) ->
	term_to_binary(Msg);
to_binary(Msg) when is_integer(Msg) ->
	list_to_binary(integer_to_list(Msg));
to_binary(Msg) when is_float(Msg) ->
	list_to_binary(f2s(Msg));
to_binary(_Msg) ->
	throw(other_value).

%% Any to integer
-spec to_integer(Msg :: any()) -> integer().
to_integer(Msg) when is_integer(Msg) ->
	Msg;
to_integer(Msg) when is_binary(Msg) ->
	Msg2 = binary_to_list(Msg),
	list_to_integer(Msg2);
to_integer(Msg) when is_list(Msg) ->
	list_to_integer(Msg);
to_integer(Msg) when is_float(Msg) ->
	round(Msg);
to_integer(_Msg) ->
	throw(other_value).

%% Any to tuple
-spec to_tuple(D :: any()) -> tuple().
to_tuple(D) when is_integer(D) ->
	list_to_tuple(integer_to_list(D));
to_tuple(D) when is_list(D) ->
	list_to_tuple(D);
to_tuple(D) when is_atom(D) ->
	list_to_tuple(atom_to_list(D));
to_tuple(_D) ->
	throw(other_value).



%% Any to boolean
-spec to_bool(D :: any()) -> boolean().
to_bool(D) when is_integer(D) ->
	D =/= 0;
to_bool(D) when is_list(D) ->
	length(D) =/= 0;
to_bool(D) when is_binary(D) ->
	to_bool(binary_to_list(D));
to_bool(D) when is_boolean(D) ->
	D;
to_bool(_D) ->
	throw(other_value).

%% Any to float
-spec to_float(Msg :: any()) -> float().
to_float(Msg)->
	Msg2 = to_list(Msg),
	list_to_float(Msg2).





%% -----------------------------------------------------------------------------
%% internal function
%% -----------------------------------------------------------------------------
%% Float to list
f2s(N) when is_integer(N) ->
	integer_to_list(N) ++ ".00";
f2s(F) when is_float(F) ->
	[A] = io_lib:format("~.2f", [F]),
	A.

list_to_atom2(List) when is_list(List) ->
	case catch(list_to_existing_atom(List)) of
		{'EXIT', _} -> erlang:list_to_atom(List);
		Atom when is_atom(Atom) -> Atom
	end.

%% String to term
list_to_term(String) ->
	{ok, T, _} = erl_scan:string(String++"."),
	case erl_parse:parse_term(T) of
		{ok, Term} ->
			Term;
		{error, Error} ->
			Error
	end.













