%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 六月 2018 10:31
%%%-------------------------------------------------------------------

-module(landlords_http_handler).
-auth("cw").

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

-include("logger.hrl").

init(_Transport, Req, []) ->
	?DEBUG("cowboy server init ...~n",[]),
	{ok, Req, undefined}.

handle(Req, State) ->
	?PRINTF("************ ~p *************~n",[logtest]),
	{ok, Req2} = cowboy_req:reply(200, [], <<"Hello World reloader !">>, Req),
	{ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
	ok.


