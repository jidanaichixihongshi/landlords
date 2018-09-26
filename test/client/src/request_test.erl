%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 九月 2018 16:12
%%%-------------------------------------------------------------------
-module(request_test).

-include("common.hrl").
-include("protobuf_pb.hrl").

-compile(export_all).

%% ===================================================================
%% API functions
%% ===================================================================
chat(TUid, Msg) ->
	[{state, State}] = ets:lookup(landlords_client, state),
	#state{uid = Uid, socket = Socket} = State,
	Chat = #chat{
		from = term_to_binary(Uid),
		device = <<"1">>,
		c = term_to_binary(Msg)},
	Data = term_to_binary(Chat),
	SendMsg = msg:produce_msg(Uid, term_to_binary(TUid), 107, Data),
	mod_landlords_client:tcp_send(Socket, SendMsg).

seekuser(Argument) when is_integer(Argument) ->
	[{state, State}] = ets:lookup(landlords_client, state),
	#state{uid = Uid, socket = Socket} = State,
	Data = term_to_binary({seekuser, {uid, Argument}}),
	SendMsg = msg:produce_msg(Uid, <<"">>, 121, Data),
	mod_landlords_client:tcp_send(Socket, SendMsg);
seekuser(Argument) when is_list(Argument) ->
	[{state, State}] = ets:lookup(landlords_client, state),
	#state{uid = Uid, socket = Socket} = State,
	Data = term_to_binary({seekuser, {nickname, Argument}}),
	SendMsg = msg:produce_msg(Uid, <<"">>, 121, Data),
	mod_landlords_client:tcp_send(Socket, SendMsg);
seekuser(_Argument) ->
	error.

addfriend(TUid) ->
	[{state, State}] = ets:lookup(landlords_client, state),
	#state{uid = Uid, socket = Socket} = State,
	Data = term_to_binary([{rt, 1}, {c, "嘿，我看你还不错，不如我们做朋友吧！"}]),
	SendMsg = msg:produce_msg(Uid, term_to_binary(TUid), 104, Data),
	mod_landlords_client:tcp_send(Socket, SendMsg).

addroster(Response, TUid) ->
	[{state, State}] = ets:lookup(landlords_client, state),
	#state{uid = Uid, socket = Socket} = State,
	Data =
		case Response of
			0 ->
				term_to_binary([{rt, 2}, {uid, [Uid, TUid]}, {c, "他同意了你的好友请求，现在你们已经是朋友了！"}]);
			_ ->
				term_to_binary([{rt, 3}, {uid, [TUid]}, {c, "他拒绝了你的好友请求!"}])
		end,
	SendMsg = msg:produce_msg(Uid, <<"">>, 104, Data),
	mod_landlords_client:tcp_send(Socket, SendMsg).

delroster(TUid) ->
	[{state, State}] = ets:lookup(landlords_client, state),
	#state{uid = Uid, socket = Socket} = State,
	Data = term_to_binary([{rt, 4}, {uid, [Uid, TUid]}, {c, "你和 <> 解除了好友关系！"}]),
	SendMsg = msg:produce_msg(Uid, <<"">>, 104, Data),
	mod_landlords_client:tcp_send(Socket, SendMsg).
















