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

-export([encode/1, decode/2]).

%% 编码
encode(Msg) when is_tuple(Msg) ->
	protobuf_pb:encode(Msg);
encode(_Msg) ->
	throw(error).

%% 解码
decode(Type, Msg) when is_binary(Msg) ->
	protobuf_pb:decode(Type, Msg);
decode(Type, Msg) when is_list(Msg) ->
	BinMsg = lib_change:to_binary(Msg),
	decode(Type, BinMsg);
decode(_Type, _Msg) ->
	throw(error).


%% -----------------------------------------------------------------------------
%% internal function
%% -----------------------------------------------------------------------------















