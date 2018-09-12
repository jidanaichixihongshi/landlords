%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 六月 2018 12:09
%%%-------------------------------------------------------------------

%% 函数宏
-define(IF(A, B, C), (case (A) of true -> (B); _ -> (C) end)).

%% 固定参数
-define(UNDEFINED, undefined).
-define(LOCALNODE, node()).


-define(UID_HASH_RANGE, 10000000).      %% 和uid相关的hash值取值范围


%% 钩子注册
-define(HOOKS_LIST, [
	{logonrequest, ?LOCALNODE, landlords_auth, handle_user_auth, 50}
]).












