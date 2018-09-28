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
%%% Created : 28. 九月 2018 17:52
%%%-------------------------------------------------------------------
-module(landlords_room_sup).
-auth("cw").

-behaviour(supervisor).

-include("room.hrl").
-include("logger.hrl").

-export([
	init/1,
	start_link/0,
	start_child/2]).

-define(CHILD(I, Type), {I, {I, start_link, []}, temporary, 5000, Type, [I]}).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).


start_child(Node, Args) when is_record(Args, room_state) ->
	case supervisor:start_child({?MODULE, Node}, [Args]) of
		{ok, Pid} ->
			{ok, Pid};
		{error, {already_started, Pid}} ->
			{ok, Pid};
		Error ->
			Error
	end.

init([]) ->
	?DEBUG("init room ... ...~n",[]),
	{ok, {{simple_one_for_one, 10000, 1}, [?CHILD(landlords_room, worker)]}}.














