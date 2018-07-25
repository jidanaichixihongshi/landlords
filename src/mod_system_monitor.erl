%%%-------------------------------------------------------------------
%%% @author
%%% @copyright
%%% @doc
%%%
%%% @end
%%% Created :
%%%-------------------------------------------------------------------
-module(mod_system_monitor).
-author("").
-behaviour(gen_server).

%% API
-export([start_link/0,
  process_remote_command/1]).

-export([init/1, handle_call/3, handle_cast/2,
  handle_info/2, terminate/2, code_change/3]).

-include("logger.hrl").

-record(state, {}).

%%====================================================================
%% API
%%====================================================================
%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link() ->
  Opts = [{large_heap, 2000000}],
  gen_server:start_link({local, ?MODULE}, ?MODULE, Opts, []).

%%====================================================================
%% gen_server callbacks
%%====================================================================

%%--------------------------------------------------------------------
%% Function: init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
%%--------------------------------------------------------------------
init(Opts) ->
  LH = proplists:get_value(large_heap, Opts),
  process_flag(priority, high),
  erlang:system_monitor(self(), [{large_heap, LH}]),
  {ok, #state{}}.

%%--------------------------------------------------------------------
%% Function: %% handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
%%--------------------------------------------------------------------
handle_call({get, large_heap}, _From, State) ->
  {reply, get_large_heap(), State};
handle_call({set, large_heap, NewValue}, _From,
    State) ->
  MonSettings = erlang:system_monitor(self(),
    [{large_heap, NewValue}]),
  OldLH = get_large_heap(MonSettings),
  NewLH = get_large_heap(),
  {reply, {lh_changed, OldLH, NewLH}, State};
handle_call(_Request, _From, State) ->
  Reply = ok, {reply, Reply, State}.

get_large_heap() ->
  MonSettings = erlang:system_monitor(),
  get_large_heap(MonSettings).

get_large_heap(MonSettings) ->
  {_MonitorPid, Options} = MonSettings,
  proplists:get_value(large_heap, Options).

%%--------------------------------------------------------------------
%% Function: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
%%--------------------------------------------------------------------
handle_cast(_Msg, State) -> {noreply, State}.

%%--------------------------------------------------------------------
%% Function: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages
%%--------------------------------------------------------------------
handle_info({monitor, Pid, large_heap, Info}, State) ->
  spawn(fun () ->
    process_flag(priority, high),
    process_large_heap(Pid, Info)
        end),
  {noreply, State};
handle_info(_Info, State) -> {noreply, State}.

%%--------------------------------------------------------------------
%% Function: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
%%--------------------------------------------------------------------
terminate(_Reason, _State) -> ok.

%%--------------------------------------------------------------------
%% Func: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) -> {ok, State}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------

process_large_heap(Pid, Info) ->
  Current = process_info(Pid, current_function),
  case Current of
    {current_function,{Modu,_,_}} ->
      if
        Modu == code_server ->
          ok;
        true ->
          DetailedInfo = detailed_info(Pid),
          Body = iolist_to_binary(
            io_lib:format("(~w) The process ~w is consuming too "
            "much memory:~n~p~n~s monitor kill it",
              [node(), Pid, Info, DetailedInfo])),
          erlang:exit(Pid,kill),
          io:format("~p",[Body])
      end;
    _->
      DetailedInfo = detailed_info(Pid),
      Body = iolist_to_binary(
        io_lib:format("(~w) The process ~w is consuming too "
        "much memory:~n~p~n~s monitor kill it",
          [node(), Pid, Info, DetailedInfo])),
      erlang:exit(Pid,kill),
      io:format("~p",[Body])
  end.

detailed_info(Pid) ->
  case process_info(Pid, dictionary) of
    {dictionary, Dict} ->
      case lists:keysearch('$ancestors', 1, Dict) of
        {value, {'$ancestors', [_Sup | _]}} ->
%%          case Sup of
%%            ejabberd_c2s_sup -> c2s_info(Pid);
%%            ejabberd_s2s_out_sup -> s2s_out_info(Pid);
%%            ejabberd_service_sup -> service_info(Pid);
%%            _ ->
              detailed_info1(Pid);
%%          end;
        _ -> detailed_info1(Pid)
      end;
    _ -> detailed_info1(Pid)
  end.

detailed_info1(Pid) ->
  io_lib:format("~p",
    [[process_info(Pid, current_function),
      process_info(Pid, initial_call),
      process_info(Pid, message_queue_len),
      process_info(Pid, links), process_info(Pid, dictionary),
      process_info(Pid, heap_size),
      process_info(Pid, stack_size)]]).

%%pid_info(Pid) ->
%%  [<<"Process type: c2s">>, check_send_queue(Pid),
%%    <<"\n">>,
%%    io_lib:format("Command to kill this process: kill ~s ~w",
%%      [iolist_to_binary(atom_to_list(node())), Pid])].

%%check_send_queue(Pid) ->
%%  case {process_info(Pid, current_function),
%%    process_info(Pid, message_queue_len)}
%%  of
%%    {{current_function, MFA}, {message_queue_len, MLen}} ->
%%      if MLen > 100 ->
%%        case MFA of
%%          {prim_inet, send, 2} ->
%%            <<"\nPossible reason: the process is blocked "
%%            "trying to send data over its TCP connection.">>;
%%          {M, F, A} ->
%%            [<<"\nPossible reason: the process can't "
%%            "process messages faster than they arrive.  ">>,
%%              io_lib:format("Current function is ~w:~w/~w",
%%                [M, F, A])]
%%        end;
%%        true -> <<"">>
%%      end;
%%    _ -> <<"">>
%%  end.


process_remote_command([kill, SPid]) ->
  exit(list_to_pid(SPid), kill), <<"ok">>;
process_remote_command([showlh]) ->
  Res = gen_server:call(ejabberd_system_monitor,
    {get, large_heap}),
  io_lib:format("Current large heap: ~p", [Res]);
process_remote_command([setlh, NewValue]) ->
  {lh_changed, OldLH, NewLH} =
    gen_server:call(ejabberd_system_monitor,
      {set, large_heap, NewValue}),
  io_lib:format("Result of set large heap: ~p --> ~p",
    [OldLH, NewLH]);
process_remote_command(_) -> throw(unknown_command).