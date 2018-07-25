%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 六月 2018 11:36
%%%-------------------------------------------------------------------

-define(PRINTF(Format, Args), io:format(Format, Args)).

-define(DEBUG(Format, Args), log4erl:debug(Format, Args)).
-define(INFO(Format, Args), log4erl:info(Format, Args)).
-define(WARN(Format, Args), log4erl:warn(Format, Args)).
-define(ERROR(Format, Args), log4erl:error(Format, Args)).
-define(FATAL(Format, Args), log4erl:fatal(Format, Args)).

-define(DEBUG(Format), log4erl:debug(Format)).
-define(INFO(Format), log4erl:info(Format)).
-define(WARN(Format), log4erl:warn(Format)).
-define(ERROR(Format), log4erl:error(Format)).
-define(FATAL(Format), log4erl:fatal(Format)).






