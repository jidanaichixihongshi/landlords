%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 六月 2018 11:36
%%%-------------------------------------------------------------------

-compile([{parse_transform, lager_transform}]).

-define(INFO(Format, Args), lager:info(Format, Args)).


-define(PRINTF(Format, Args), io:format(Format, Args)).
-define(PRINTF(Args), io:format(Args)).






