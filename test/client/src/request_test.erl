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
chat(Uid, Msg) ->
	Chat = #chat{
		from = integer_to_binary(?UID),
		device = <<"1">>,
		c = term_to_binary(Msg)},
	Data = term_to_binary(Chat),
	SendMsg = msg:produce_msg(?UID, integer_to_binary(Uid), 107, Data),
	[{state, State}] = ets:lookup(landlords_ets, state),
	mod_landlords_client:tcp_send(State#state.socket, SendMsg).

seekuser(Argument) when is_integer(Argument) ->
	Data = term_to_binary({seekuser, {uid, Argument}}),
	SendMsg = msg:produce_msg(?UID, <<"">>, 121, Data),
	[{state, State}] = ets:lookup(landlords_ets, state),
	mod_landlords_client:tcp_send(State#state.socket, SendMsg);
seekuser(Argument) when is_list(Argument) ->
	Data = term_to_binary({seekuser, {nickname, Argument}}),
	SendMsg = msg:produce_msg(?UID, <<"">>, 121, Data),
	[{state, State}] = ets:lookup(landlords_ets, state),
	mod_landlords_client:tcp_send(State#state.socket, SendMsg);
seekuser(_Argument) ->
	error.

addfriend(Uid) ->
	Data = term_to_binary([{rt, 1}, {c, "嘿，我看你还不错，不如我们做朋友吧！"}]),
	SendMsg = msg:produce_msg(?UID, integer_to_binary(Uid), 104, Data),
	[{state, State}] = ets:lookup(landlords_ets, state),
	mod_landlords_client:tcp_send(State#state.socket, SendMsg).

addroster(Response, Uid) ->
	Data =
		case Response of
			0 ->
				term_to_binary([{rt, 2}, {uid, [?UID, Uid]}, {c, "他同意了你的好友请求，现在你们已经是朋友了！"}]);
			_ ->
				term_to_binary([{rt, 3}, {uid, [Uid]}, {c, "他拒绝了你的好友请求!"}])
		end,
	SendMsg = msg:produce_msg(?UID, <<"">>, 104, Data),
	[{state, State}] = ets:lookup(landlords_ets, state),
	mod_landlords_client:tcp_send(State#state.socket, SendMsg).

delroster(Uid) ->
	Data = term_to_binary([{rt, 4}, {uid, [?UID, Uid]}, {c, "你和 <> 解除了好友关系！"}]),
	SendMsg = msg:produce_msg(?UID, <<"">>, 104, Data),
	[{state, State}] = ets:lookup(landlords_ets, state),
	mod_landlords_client:tcp_send(State#state.socket, SendMsg).
















