%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 六月 2018 11:14
%%%-------------------------------------------------------------------

%% ============================================
%% 先启动
%% ============================================
-module(landlords).
-auth("cw").

-export([
	start/0,
	stop/0]).

start() ->
	Apps = [crypto,
		asn1,
		public_key,
		ssl,
		compiler,
		syntax_tools,
		goldrush,
		lager,
		ranch,
		protobuffs,
		cowlib,
		cowboy,
		landlords],
	start_app(Apps, permanent).

stop() ->
	io:format("------------------stop~n").

start_app([], _Type) ->
	ok;
start_app([App | Apps], Type) ->
	case application:start(App, Type) of
		ok ->
			io:format("start app '~p' ok...~n", [App]),
			start_app(Apps, Type);
		{error, {already_started, _}} ->
			start_app(Apps, Type);
		{error, {not_started, NoApp}} ->
			Reason = io_lib:format("failed to start application '~p'", [NoApp]),
			io:format("no start app: ~p~n", [Reason]),
			exit_or_halt(Reason);
		{error, Reason} ->
			io:format("Reason:~p~n", [Reason]),
			exit_or_halt(Reason)
	end.

exit_or_halt(Reason) ->
	halt(string:substr(lists:flatten(Reason), 1, 199)).


