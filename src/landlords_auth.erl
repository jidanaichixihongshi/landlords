%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 八月 2018 19:29
%%%-------------------------------------------------------------------
-module(landlords_auth).
-auth("cw").

-include("logger.hrl").
-include("protobuf_pb.hrl").

-export([
	start_link/0
]).

-export([
	init/1,
	handle_call/3,
	handle_cast/2,
	handle_info/2,
	terminate/2,
	code_change/3
]).

-export([
	handle_user_auth/1
]).

-record(auth_state, {}).


start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%%%----------------------------------------------------------------------
%%% Callback functions from gen_server
%%%----------------------------------------------------------------------
init([]) ->
	{ok, #auth_state{}}.

handle_call(Request, _From, State) ->
	?DEBUG("unrecognized request type: ~p~n", [Request]),
	Reply = ok,
	{reply, Reply, State}.


handle_cast(Msg, State) ->
	?DEBUG("unrecognized msg type: ~p~n", [Msg]),
	{noreply, State}.

handle_info(Info, State) ->
	?DEBUG("unrecognized msg type: ~p~n", [Info]),
	{noreply, State}.

%%----------------------------------------------------------------------
%% Func: terminate/2
%% Purpose: Shutdown the server
%% Returns: any (ignored by gen_server)
%%----------------------------------------------------------------------
terminate(_Reason, _State) ->
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

handle_user_auth(Msg) when is_record(Msg, logonrequest) ->
	Data = Msg#logonrequest.data,
	#userdata{uid = Uid, token = Token, device = Device} = Data,
	?INFO("账号 ~p 在 ~p 设备上使用token: ~p 验证登陆成功~n", [Uid, get_devicename(Device), Token]),
	true;
handle_user_auth(Msg) ->
	{error, Msg}.


%% -----------------------------------------------------------------------------
%% internal function
%% -----------------------------------------------------------------------------
%% 连接方式，1 手机安卓		2 手机苹果		3 windows电脑		4 网页
get_devicename(1) ->
	"手机安卓";
get_devicename(2) ->
	"手机苹果";
get_devicename(3) ->
	"windows电脑";
get_devicename(4) ->
	"网页";
get_devicename(5) ->
	none.













