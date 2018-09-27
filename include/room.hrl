%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 九月 2018 18:39
%%%-------------------------------------------------------------------


-record(room_state,{
	rid,
	setting,					%% 设置
	creator,
	members,
	grade,						%% 战绩 #{}
	create_time
}).



