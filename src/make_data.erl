%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 六月 2018 18:14
%%%-------------------------------------------------------------------

-module(make_data).
-auth("cw").

-include("file.hrl").

-export([
	start/0]).

%% 生成相应的erl和hrl文件
start() ->
	protobuffs_compile:generate_source(?PROTO_CONFIG).




