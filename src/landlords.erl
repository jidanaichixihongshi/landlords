%% ============================================
%% 先启动
%% ============================================
-module(landlords).
-export([start/0]).

start() ->
	Apps = [crypto,
		asn1,
		public_key,
		ssl,
		ranch,
		protobuffs,
		cowlib,
		cowboy,
		landlords],
	start_app(Apps).

start_app([]) ->
	ok;
start_app([App|Apps]) ->
	case application:start(App) of
		ok ->
			io:format("start app '~p' ok...~n",[App]),
			start_app(Apps);
		{error,{already_started, _}} ->
			start_app(Apps);
		{error, {not_started, NoApp}} ->
			Reason = io_lib:format("failed to start application '~p'", [NoApp]),
			io:format("no start app: ~p~n",[Reason]),
			exit_or_halt(Reason);
		{error,Reason} ->
			io:format("Reason:~p~n",[Reason]),
			exit_or_halt(Reason)
	end.

exit_or_halt(Reason) ->
	halt(string:substr(lists:flatten(Reason), 1, 199)).


