
-module(landlords_http_handler).
-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

-include("../include/logger.hrl").

init(_Transport, Req, []) ->
	io:format("cowboy server init ...~n",[]),
	{ok, Req, undefined}.

handle(Req, State) ->
	?DEBUG("************ ~p *************~n",[logtest]),
	{ok, Req2} = cowboy_req:reply(200, [], <<"Hello World reloader !">>, Req),
	{ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
	ok.


