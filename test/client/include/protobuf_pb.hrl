-ifndef(USERDATA_PB_H).
-define(USERDATA_PB_H, true).
-record(userdata, {
    nickname,
    uid,
    phone,
    token = erlang:error({required, token}),
    device = erlang:error({required, device}),
    device_id,
    version = erlang:error({required, version}),
    app_id = erlang:error({required, app_id})
}).
-endif.

-ifndef(REQUESTLOGON_PB_H).
-define(REQUESTLOGON_PB_H, true).
-record(requestlogon, {
    mt = erlang:error({required, mt}),
    mid = erlang:error({required, mid}),
    sig = erlang:error({required, sig}),
    timestamp = erlang:error({required, timestamp}),
    data = erlang:error({required, data})
}).
-endif.

-ifndef(REQUESTLOGONACK_PB_H).
-define(REQUESTLOGONACK_PB_H, true).
-record(requestlogonack, {
    mt = erlang:error({required, mt}),
    mid = erlang:error({required, mid}),
    sig = erlang:error({required, sig}),
    timestamp = erlang:error({required, timestamp}),
    data
}).
-endif.

-ifndef(LOGONSUCCESS_PB_H).
-define(LOGONSUCCESS_PB_H, true).
-record(logonsuccess, {
    mt = erlang:error({required, mt}),
    mid = erlang:error({required, mid}),
    sig = erlang:error({required, sig}),
    timestamp = erlang:error({required, timestamp}),
    data
}).
-endif.

-ifndef(RESPONSESESSION_PB_H).
-define(RESPONSESESSION_PB_H, true).
-record(responsesession, {
    mt = erlang:error({required, mt}),
    mid = erlang:error({required, mid}),
    sig = erlang:error({required, sig}),
    timestamp = erlang:error({required, timestamp}),
    data
}).
-endif.

-ifndef(SESSIONSUCCESS_PB_H).
-define(SESSIONSUCCESS_PB_H, true).
-record(sessionsuccess, {
    mt = erlang:error({required, mt}),
    mid = erlang:error({required, mid}),
    sig = erlang:error({required, sig}),
    timestamp = erlang:error({required, timestamp}),
    data
}).
-endif.

-ifndef(HEARTBEAT_PB_H).
-define(HEARTBEAT_PB_H, true).
-record(heartbeat, {
    mt = erlang:error({required, mt}),
    mid = erlang:error({required, mid}),
    sig = erlang:error({required, sig}),
    timestamp = erlang:error({required, timestamp}),
    data
}).
-endif.

