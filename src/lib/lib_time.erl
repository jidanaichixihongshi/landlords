%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 六月 2018 17:11
%%%-------------------------------------------------------------------

-module(lib_time).
-auth("cw").

-compile(export_all).

%% 获取时间戳（13位）
-spec get_mstimestamp() -> integer().
get_mstimestamp() ->
	{MegaSecs, Secs, MicroSecs} = os:timestamp(),
	MegaSecs * 1000000 * 1000 + Secs * 1000 + MicroSecs div 1000.

%% 获取本地当前时间
-spec get_local_time() -> tuple().
get_local_time() ->
	calendar:local_time().


%% 时间戳转换成国际时间
-spec to_international_time(integer()) -> tuple().
to_international_time(TimeStamp) ->
	SecTimeStamp = check_second(TimeStamp),
	calendar:gregorian_seconds_to_datetime(SecTimeStamp +
		calendar:datetime_to_gregorian_seconds({{1970,1,1}, {0,0,0}})).

%% 时间戳转换成本地当前时间
-spec to_local_time(integer()) -> tuple().
to_local_time(TimeStamp) ->
	{{Y,M,D},{H,Min,S}} = to_international_time(TimeStamp),
	case (H + 8) >= 24 of
		true ->
			{{Y,M,D + 1},{H - 16,Min,S}};
		_ ->
			{{Y,M,D},{H + 8,Min,S}}
	end.

%% 判断是不是同一天
-spec is_same_day(integer(), integer) -> boolean().
is_same_day(Seconds1, Seconds2) ->
	((Seconds1 + 8 * 3600) div 86400) =:= ((Seconds2 + 8 * 3600) div 86400).

%% -----------------------------------------------------------------------------
%% internal function
%% -----------------------------------------------------------------------------
check_second(Timestamp) ->
	case Timestamp div 10000000000 of
		0 -> Timestamp;
		_ -> Timestamp div 1000
	end.
















