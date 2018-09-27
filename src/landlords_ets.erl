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
-module(landlords_ets).
-auth("cw").

-include("proxy.hrl").

-export([
	set_proxy/1,
	lookup_proxy/1,
	lookup_element_proxy/2,
	update_proxy/2,
	del_proxy/1]).

%% -------------------------------------------------------------------------------------
%% proxy 相关
%% -------------------------------------------------------------------------------------
set_proxy(State) ->
	[OldState] =
		case lookup_proxy(State#proxy_state.uid) of
			StateL when StateL /= [] ->
				StateL;
			_ ->
				[#proxy_state{}]
		end,
	ClientList = lists:foldl(
		fun(Client, Acc) when is_record(Client, proxy_client) ->
			case mod_proc:is_proc_alive(Client#proxy_client.pid) of
				true ->
					[Client | Acc];
				_ ->
					Acc
			end;
			(_, Acc) ->
				Acc
		end, [], OldState#proxy_state.client),
	NewState = State#proxy_state{client = ClientList},
	ets:insert(?PROXY_STATE, NewState),
	{ok, NewState}.

-spec lookup_proxy(integer()) -> #proxy_state{}.
lookup_proxy(Uid) ->
	ets:lookup(?PROXY_STATE, Uid).

lookup_element_proxy(Uid, Pos) ->
	ets:lookup_element(?PROXY_STATE, Uid, Pos).

-spec update_proxy(integer(), tuple()) -> boolean().
update_proxy(Uid, Parameter) ->
	ets:update_element(?PROXY_STATE, Uid, Parameter).

del_proxy(Uid) ->
	ets:delete(?PROXY_STATE, Uid).

%% -----------------------------------------------------------------------------
%% internal function
%% -----------------------------------------------------------------------------
















