%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 六月 2018 13:56
%%%-------------------------------------------------------------------


-define(CONFIG_FILE_DIR, "config/sys.config").

-define(CONFIG_PARAMETER_ETS, config_parameter_ets).
-define(PUBLIC_STORAGE_ETS, public_storage_ets).

-define(ETS_READ_CONCURRENCY, {read_concurrency, true}).			%% 并发读
-define(ETS_WRITE_CONCURRENCY, {write_concurrency, true}).		%% 并发写

%% ETS表配置
-define(ETS_LIST,[
	{config_parameter_ets, [set, public, named_table, ?ETS_READ_CONCURRENCY, ?ETS_WRITE_CONCURRENCY]},
	{public_storage_ets, [set, public, named_table, ?ETS_READ_CONCURRENCY, ?ETS_WRITE_CONCURRENCY]}
]).





