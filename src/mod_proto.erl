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

-define(ZIP_SIZE, 1024).

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
	Size = size(EMsg),
	T =
		case Size < ?ZIP_SIZE of
			true -> 0;
			_ -> 1
		end,
	{ok, <<T:16, Size:16, EMsg/binary>>}.


%% 编码
encode(Msg) when is_tuple(Msg) ->
	protobuf_pb:encode(Msg);
encode(_Msg) ->
	throw(error).


%% 解包客户端消息
%% <<消息是否经过压缩（包头）/16字节,消息包大小（未压缩前）/16字节,消息包（二进制）>>
unpacket(Data) when is_binary(Data) ->
	<<H:16, Size:16, BinMsg/binary>> = Data,
	UZBinMsg =
		if
			H == 0 ->
				BinMsg;
			H == 1 ->
				zip:unzip(BinMsg);
			true ->
				{error, ?ERROR_102}
		end,
	case UZBinMsg of
		{error, _} ->
			UZBinMsg;
		_ ->
			case check_length(Size, UZBinMsg) of
				true ->
					decode(proto, UZBinMsg);
				_ ->
					{error, ?ERROR_103}
			end
	end;
unpacket(_Data) ->
	{error, ?ERROR_101}.

%% 解码
decode(T, BinMsg) when is_binary(BinMsg) ->
	protobuf_pb:decode(T, BinMsg);
decode(_T, _Msg) ->
	throw({error, ?ERROR_101}).


%% internal api
check_length(Size, BinMsg) ->
	Size == size(BinMsg).













