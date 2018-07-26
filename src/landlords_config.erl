%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 六月 2018 11:56
%%%-------------------------------------------------------------------
-module(landlords_config).
-auth("cw").

-export([set_cfg/2,
	get_cfg/1,
	create_config/0]).

-include("server.hrl").
-include("common.hrl").
-include("logger.hrl").

get_cfg(Key) ->
	lib_normal:get_val(Key, ?CONFIG_PARAMETER_ETS).

set_cfg(Key, Value) ->
	lib_normal:set_val(Key, Value, ?CONFIG_PARAMETER_ETS).

%% 加载配置文件
create_config() ->
	{ok, [Data]} = file:consult(?CONFIG_FILE_DIR),
	load_config(Data).

load_config([]) ->
	?INFO("load config ok ...~n");
load_config([ Parameter | Data]) ->
	{_Type, SingleData} = Parameter,
	lists:foreach(
		fun({Key, Value}) ->
			lib_normal:set_val(Key, Value, ?CONFIG_PARAMETER_ETS)
		end, SingleData),
	load_config(Data).



