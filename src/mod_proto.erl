%%%-------------------------------------------------------------------
%%% * ━━━━━━神兽出没━━━━━━
%%% * 　　　┏┓　　　┏┓
%%% * 　　┏┛┻━━━┛┻┓
%%% * 　　┃　　　　　　　┃
%%% * 　　┃　　　━　　　┃
%%% * 　　┃　┳┛　┗┳　┃
%%% * 　　┃　　　　　　　┃
%%% * 　　┃　　　┻　　　┃
%%% * 　　┃　　　　　　　┃
%%% * 　　┗━┓　　　┏━┛
%%% * 　　　　┃　　　┃ 神兽保佑
%%% * 　　　　┃　　　┃ 代码无bug　　
%%% * 　　　　┃　　　┗━━━┓
%%% * 　　　　┃　　　　　　　┣┓
%%% * 　　　　┃　　　　　　　┏┛
%%% * 　　　　┗┓┓┏━┳┓┏┛
%%% * 　　　　　┃┫┫　┃┫┫
%%% * 　　　　　┗┻┛　┗┻┛
%%% * ━━━━━━感觉萌萌哒━━━━━━
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
-include("logger.hrl").

-export([
	packet/1,
	unpacket/1,
	encode/1,
	decode/2]).


%% ------------------------------------------------------------------------------------------
%% 消息包编解码
%% ------------------------------------------------------------------------------------------
%% 打包客户端消息
packet(Msg) when is_tuple(Msg) ->
	packet_msg(Msg);
packet(Msg) ->
	{error, Msg}.

packet_msg(Msg) ->
	EMsg = list_to_binary(encode(Msg)),
	{ok, <<0:16, EMsg/binary>>}.

%% 编码
encode(Msg) when is_tuple(Msg) ->
	protobuf_pb:encode(Msg);
encode(_Msg) ->
	throw(error).


%% 解包客户端消息
unpacket(Data) when is_binary(Data) ->
	<<0:16, BinMsg/binary>> = Data,
	protobuf_pb:decode(proto, BinMsg);
unpacket(_Data) ->
	throw({error, ?ERROR_101}).

%% 解码
decode(T, BinMsg) when is_binary(BinMsg) ->
	protobuf_pb:decode(T, BinMsg);
decode(_T, _Msg) ->
	throw({error, ?ERROR_101}).
















