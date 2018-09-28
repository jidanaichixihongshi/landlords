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
%%% Created : 27. 九月 2018 下午 13:59
%%%-------------------------------------------------------------------
-module(mod_group_handle).
-author("cw").

-include("group.hrl").
-include("common.hrl").
-include("logger.hrl").
-include("protobuf_pb.hrl").

%% API
-export([
	handle_msg/2,
	set_group/2,
	add_group/2,
	leave_group/2,
	group_session/2,
	send_g_msg/3
]).

-define(G_SENDER_LIFECYCLE, 90000).



handle_msg(Msg, #group_state{gid = Gid} = _State) ->
	Members = mod_group:get_group_members(Gid),
	send_g_msg(Gid, Members, Msg).


set_group(Param, #group_state{setting = Set} = State) ->
	Fun =
		fun({K, V}, M) ->
			maps:put(K, V, M)
		end,
	NewSet = lists:foldl(Fun, Set, Param),
	State#group_state{setting = NewSet}.

add_group(Uid, #group_state{gid = Gid} = _State) ->
	Members = mod_group:get_group_members(Gid),
	Mid = mod_msg:produce_mid(Gid),
	C = "用戶" ++ integer_to_list(Uid) ++ "加入了群聊",
	Data = [{uid, Uid}, {c, C}],
	Msg = mod_msg:produce_responsemsg(?MT_117, Mid, ?SIGN0, maps:to_list(Data)),
	send_g_msg(Gid, Members, Msg).

leave_group(Uid, #group_state{gid = Gid} = _State) ->
	Members = mod_group:get_group_members(Gid),
	Mid = mod_msg:produce_mid(Gid),
	C = "用戶" ++ integer_to_list(Uid) ++ "退出了群聊",
	Data = [{uid, Uid}, {c, C}],
	Msg = mod_msg:produce_responsemsg(?MT_117, Mid, ?SIGN0, maps:to_list(Data)),
	send_g_msg(Gid, Members, Msg).

group_session(UidList, State) ->
	#group_state{
		gid = Gid,
		groupname = GName,
		avatar = Avatar,
		lv = Lv,
		setting = Set,
		creator = Creator,
		admin = Admin} = State,
	Members = [
		#{uid => 5563988, nickname => <<"皮皮球">>, gnickname => <<"大刚">>, lv => 3, statu => offline, personlabel => "这个人很懒，什么都没有留下！"},
		#{uid => 9866333, nickname => <<"JiJi">>, gnickname => <<"刘畅">>, lv => 3, statu => offline, personlabel => "这个人很懒，什么都没有留下！"},
		#{uid => 1507326, nickname => <<"Fly">>, gnickname => <<"王晓伟">>, lv => 3, statu => online, personlabel => "这个人很懒，什么都没有留下！"},
		#{uid => 3945630, nickname => <<"终结者">>, gnickname => <<"张佳">>, lv => 3, statu => online, personlabel => "这个人很懒，什么都没有留下！"},
		#{uid => 2238551, nickname => <<"小昭">>, gnickname => <<"豆豆">>, lv => 3, statu => offline, personlabel => "这个人很懒，什么都没有留下！"},
		#{uid => 6003021, nickname => <<"坏掉的鱼">>, gnickname => <<"糊涂">>, lv => 3, statu => offline, personlabel => "这个人很懒，什么都没有留下！"}],
	Session = #{gid => Gid, gname => GName, avatar => Avatar, lv => Lv, set => Set, creator => Creator,
		admin => Admin, members => Members},
	Mid = mod_msg:produce_mid(Gid),
	SendSession = mod_msg:produce_responsemsg(?MT_118, Mid, ?SIGN0, maps:to_list(Session)),
	send_g_msg(Gid, UidList, SendSession).


send_g_msg(Gid, UidList, SendM) ->
	GidSK = get_gidsk(Gid),
	SPid = get_spid(GidSK),
	SPid ! {Gid, SendM, UidList}.


%% ---------------------------------------------------------------------------------------
%% internal api
%% ---------------------------------------------------------------------------------------
get_spid(GidSK) ->
	case erlang:get(GidSK) of
		Pid when Pid /= undefined ->
			case is_process_alive(Pid) of
				true -> Pid;
				_ -> start_spid(GidSK)
			end;
		_ ->
			start_spid(GidSK)
	end.

start_spid(GidSK) ->
	Pid = erlang:spawn(fun() -> loop_sender(self(), GidSK) end),
	erlang:put(GidSK, Pid),
	Pid.


loop_sender(Pid, GidSK) ->
	receive
		{Gid, Msg, UidList} ->
			lists:foreach(
				fun(Uid) ->
					Router = #router{from = integer_to_binary(Gid), from_server = <<"">>, from_device = <<"">>,
						to = integer_to_binary(Uid), to_server = <<"">>, to_device = <<"">>},
					?DEBUG("group ~p router msg for ~p ... ~n", [Gid, Uid]),
					landlords_router:router(Msg#proto{router = Router})
				end, UidList),
			loop_sender(Pid, GidSK)
	after ?G_SENDER_LIFECYCLE ->
		erlang:erase(GidSK)
	end.

get_gidsk(Gid) ->
	"sender_pid_" ++ integer_to_list(Gid).






