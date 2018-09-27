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

-module(mod_roster).

-include("common.hrl").
-include("logger.hrl").
-include("protobuf_pb.hrl").
%% API
-export([
	add_roster/1,
	del_roster/1
]).


%% hooks api
add_roster(UidList) ->
	F =
		fun(Uid) ->
			Mid = mod_msg:produce_mid(Uid),
			Router = #router{
				from = <<"">>,
				from_device = <<"">>,
				from_server = <<"">>,
				to = term_to_binary(Uid),
				to_device = <<"">>,
				to_server = <<"">>},
			Data = [{rt, 3}, {uid, UidList}],
			Reply = mod_msg:produce_responsemsg(?MT_104, Mid, ?SIGN0, Router, Data),
			landlords_router:router(Reply)
		end,
	lists:foreach(F, UidList).

del_roster(UidList) ->
	F =
		fun(Uid) ->
			Mid = mod_msg:produce_mid(Uid),
			Router = #router{
				from = <<"">>,
				from_device = <<"">>,
				from_server = <<"">>,
				to = term_to_binary(Uid),
				to_device = <<"">>,
				to_server = <<"">>},
			Data = [{rt, 6}, {uid, UidList}],
			Reply = mod_msg:produce_responsemsg(?MT_104, Mid, ?SIGN0, Router, Data),
			landlords_router:router(Reply)
		end,
	lists:foreach(F, UidList).


%% ----------------------------------------------------------------------------------
%% internal api
%% ----------------------------------------------------------------------------------








