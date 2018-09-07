%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 六月 2018 13:33
%%%-------------------------------------------------------------------
-module(mod_proto).
-auth("cw").

-include("error.hrl").

-export([
	encode/1,
	decode/2]).

%% 编码
encode(Msg) when is_tuple(Msg) ->
	protobuf_pb:encode(Msg);
encode(_Msg) ->
	throw(error).

%% 解码
decode(H, BinMsg) when is_binary(BinMsg) ->
	Type = get_decode_type(H),
	protobuf_pb:decode(Type, BinMsg);
decode(_Type, _Msg) ->
	throw({error, ?ERROR_101}).


%% -----------------------------------------------------------------------------
%% internal function
%% -----------------------------------------------------------------------------
get_decode_type(110) -> logonrequest;
get_decode_type(101) -> heartbeat.













