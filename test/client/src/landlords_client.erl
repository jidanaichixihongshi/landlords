-module(landlords_client).
-auth("cw").

-export([
	start/0,
	stop/0]).

start() ->
	Apps = [
		compiler,
		syntax_tools,
		asn1,
		crypto,
		public_key,
		ssl,
		protobuffs,
		landlords_client],
	start_app(Apps, permanent).

stop() ->
	io_lib:format("------------------stop~n",[]).

start_app([], _Type) ->
	ok;
start_app([App | Apps], Type) ->
	case application:start(App, Type) of
		ok ->
			start_app(Apps, Type);
		{error, {already_started, _}} ->
			start_app(Apps, Type);
		{error, {not_started, NoApp}} ->
			Reason = io_lib:format("failed to start application '~p'", [NoApp]),
			exit_or_halt(Reason);
		{error, Reason} ->
			exit_or_halt(Reason)
	end.

exit_or_halt(Reason) ->
	halt(string:substr(lists:flatten(Reason), 1, 199)).






