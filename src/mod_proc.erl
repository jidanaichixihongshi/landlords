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
%%% Created : 29. 八月 2018 11:34
%%%-------------------------------------------------------------------

-module(mod_proc).

-include("logger.hrl").
%% API
-export([
	is_proc_alive/1
]).


%% 检查进程是否存活
is_proc_alive(Pid) when is_pid(Pid) ->
	try
		Node = node(Pid),
		if
			Node == node() ->
				is_process_alive(Pid);
			true ->
				case rpc:call(Node, erlang, is_process_alive, [Pid]) of
					{badrpc, _Reason} -> false;
					Res -> Res
				end
		end
	catch
		_ -> false
	end;
is_proc_alive(_Pid) ->
	false.







