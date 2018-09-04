%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 六月 2018 17:11
%%%-------------------------------------------------------------------

-define(PROTO_CONFIG, "../../config/protobuf.proto").

-define(TCP_OPTIONS, [
        binary,
        {packet, 0},
        {keepalive, true},
        {active, false}]).

-define(HEART_BREAK_TIME, 15000).	%% 心跳

%% 客户端连接状态
-record(state, {
	ip,
	port,
	socket,
	status 			%% 连接状态
}).




