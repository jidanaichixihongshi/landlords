%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 六月 2018 17:11
%%%-------------------------------------------------------------------
-include("protobuf_pb.hrl").
-define(PROTO_CONFIG, "../../config/protobuf.proto").

-define(UID, 1000000).

-define(TCP_OPTIONS, [
	binary,
	{packet, 4},
	{keepalive, true},
	{active, once}]).

-define(HEART_BREAK_TIME, 60000).  %% 心跳

%% 客户端连接状态
-record(state, {
	uid,
	ip,
	port,
	socket,
	status      %% 连接状态
}).




