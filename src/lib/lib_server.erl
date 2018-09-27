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
%%% Created : 23. 六月 2018 14:25
%%%-------------------------------------------------------------------

-module(lib_server).
-auth("cw").

-compile(export_all).

%% 通过socket获取ip
get_ip(Socket) ->
	{ok, {IP, _Port}} = inet:peername(Socket),
	{Ip0, Ip1, Ip2, Ip3} = IP,
	list_to_binary(integer_to_list(Ip0) ++ "." ++ integer_to_list(Ip1) ++ "." ++ integer_to_list(Ip2) ++ "." ++ integer_to_list(Ip3)).

%% ip格式化
ip_str(IP) ->
	case IP of
		{A, B, C, D} ->
			lists:concat([A, ".", B, ".", C, ".", D]);
		{A, B, C, D, E, F, G, H} ->
			lists:concat([A, ":", B, ":", C, ":", D, ":", E, ":", F, ":", G, ":", H]);
		Str when is_list(Str) ->
			Str;
		_ ->
			[]
	end.

%% 获取节点ip
node_parts(Node) when is_list(Node) ->
	case lists:splitwith(fun(E) -> E =/= $@ end, Node) of
		{Prefix, []} -> {_, Suffix} = node_parts(node()),
			{Prefix, Suffix};
		{Prefix, Suffix} -> {Prefix, tl(Suffix)}
	end;
node_parts(Node) when is_atom(Node) ->
	StrNode = atom_to_list(Node),
	node_parts(StrNode);
node_parts(_Node) ->
	{undefined, undefined}.


%% -----------------------------------------------------------------------------
%% internal function
%% -----------------------------------------------------------------------------













