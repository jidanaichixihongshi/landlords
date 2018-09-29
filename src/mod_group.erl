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
%%% Created : 27. 九月 2018 17:07
%%%-------------------------------------------------------------------

-module(mod_group).
-auth("cw").

-include("group.hrl").
-include("common.hrl").
-include("error.hrl").
-include("logger.hrl").
-include("protobuf_pb.hrl").
%% API
-export([
	create_group/1,
	set_group/1,
	join_group/1,
	exit_group/1,
	group_session/1,
	get_group/1,
	get_group_members/1
]).


%% hooks api
-spec create_group({#router{}, list()}) -> ok.
create_group({Router, Information}) ->
	Requester = lib_normal:get_v_by_k(requester, Information),
	Members = lib_normal:get_v_by_k(members, Information),
	Count = length(Members),
	if
		Count >= ?CREATE_GROUP_COUNT ->
			Gid = lib_random:random(?MIN_GID, ?MAX_GID),
			case landlords_group_sup:start_child(node(), #group_state{gid = Gid}) of
				{ok, _Pid} ->
					F =
						fun(Uid) ->
							Mid = mod_msg:produce_mid(Uid),
							Router1 = #router{
								from = <<"">>,
								from_device = <<"">>,
								from_server = <<"">>,
								to = term_to_binary(Uid),
								to_device = <<"">>,
								to_server = <<"">>},
							Data = [{rt, 2}, {success, ?ERROR_0}, {gid, Gid}, {creator, Requester}, {c, "欢迎加入群聊大家庭!"}],
							Reply = mod_msg:produce_responsemsg(?MT_117, Mid, ?SIGN0, Router1, Data),
							landlords_router:router(Reply)
						end,
					lists:foreach(F, Members),
					landlords_hooks:run(groupsession, node(), {Gid, Members});
				Error ->
					?ERROR("start group ~p error : ~p~n", [Gid, Error]),
					Mid = mod_msg:produce_mid(Requester),
					Data = [{rt, 2}, {failed, ?ERROR_100}],
					Reply = mod_msg:produce_responsemsg(?MT_117, Mid, ?SIGN0, Router, Data),
					landlords_router:router(Reply)
			end;
		true ->
			Mid = mod_msg:produce_mid(Requester),
			Data = [{rt, 2}, {failed, ?ERROR_201}],
			Reply = mod_msg:produce_responsemsg(?MT_117, Mid, ?SIGN0, Router, Data),
			landlords_router:router(Reply)
	end.
set_group({_Router, Information}) ->
	Set = lists:keyfind(set, 1, Information),
	Gid = lib_normal:get_v_by_k(gid, Information),
	group_request(Gid, Set).
join_group({_Router, Information}) ->
	Uid = lib_normal:get_v_by_k(uid, Information),
	Gid = lib_normal:get_v_by_k(gid, Information),
	group_request(Gid, {join_group, Uid}).
exit_group(Information) ->
	Uid = lib_normal:get_v_by_k(uid, Information),
	Gid = lib_normal:get_v_by_k(gid, Information),
	group_request(Gid, {exit_group, Uid}).
group_session(Information) ->
	Gid = lib_normal:get_v_by_k(gid, Information),
	Request =
		case lib_normal:get_v_by_k(uid, Information) of
			UidList when is_list(UidList) ->
				{group_session, UidList};
			undefined ->
				{group_session, all}
		end,
	group_request(Gid, Request).

%% hooks api end

-spec get_group(binary() | integer()) -> term().
get_group(Gid) when is_binary(Gid) ->
	get_group(binary_to_term(Gid));
get_group(Gid) ->
	case select_group(Gid) of
		{ok, Pid} ->
			{node(Pid), Pid};
		_ -> %% 没找着
			case start_group(Gid) of
				{ok, Pid} ->
					erlang:monitor(process, Pid),
					{node(Pid), Pid};
				Error ->
					?ERROR("start proxy error: ~p~n", [Error]),
					undefined
			end
	end.

get_group_members(Gid) ->
	[1000000, 1000001, 1000002].

%% ---------------------------------------------------------------------------------------------
%% internal api
%% ---------------------------------------------------------------------------------------------

group_request(Gid, Request) ->
	{_, Pid} = get_group(Gid),
	gen_server:cast(Pid, Request).


%% 先在本地ets中找，没找到再去redis中找
select_group(Gid) ->
	case landlords_ets:lookup_group(Gid) of
		[GroupState] when is_record(GroupState, group_state) ->
			Pid = GroupState#group_state.pid,
			?IF(mod_proc:is_proc_alive(Pid), {ok, Pid}, undefined);
		_ ->
			Pid = landlords_redis:get_group(Gid),
			?IF(mod_proc:is_proc_alive(Pid), {ok, Pid}, undefined)
	end.

%% 启动group
start_group(Gid) ->
	case landlords_proxy_sup:start_child(node(), #group_state{gid = Gid}) of
		{ok, Pid} ->
			{ok, Pid};
		Error ->
			?ERROR("start group ~p error: ~p~n", [Gid, Error]),
			Error
	end.











