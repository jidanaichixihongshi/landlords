%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 六月 2018 16:55
%%%-------------------------------------------------------------------

-module(lib_codec).
-auth("cw").

-compile(export_all).

%% md5编码
md5(S) ->
	Md5_bin =  erlang:md5(S),
	Md5_list = binary_to_list(Md5_bin),
	lists:flatten(list_to_hex(Md5_list)).

list_to_hex(L) ->
	lists:map(fun(X) -> int_to_hex(X) end, L).
int_to_hex(N) when N < 256 ->
	[hex(N div 16), hex(N rem 16)].
hex(N) when N < 10 ->
	$0+N;
hex(N) when N >= 10, N < 16 ->
	$a + (N-10).

%% 字符串转换成utf8格式
to_utf8(Utf8EncodedString) ->
	Length = length(Utf8EncodedString),
	substr_utf8(Utf8EncodedString, Length).
substr_utf8(Utf8EncodedString, Length) ->
	substr_utf8(Utf8EncodedString, 1, Length).
substr_utf8(Utf8EncodedString, Start, Length) ->
	ByteLength = 2*Length,
	Ucs = xmerl_ucs:from_utf8(Utf8EncodedString),
	Utf16Bytes = xmerl_ucs:to_utf16be(Ucs),
	SubStringUtf16 = lists:sublist(Utf16Bytes, Start, ByteLength),
	Ucs1 = xmerl_ucs:from_utf16be(SubStringUtf16),
	xmerl_ucs:to_utf8(Ucs1).



%% -----------------------------------------------------------------------------
%% internal function
%% -----------------------------------------------------------------------------













