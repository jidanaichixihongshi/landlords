-ifndef(USERDATA_PB_H).
-define(USERDATA_PB_H, true).
-record(userdata, {
    username = erlang:error({required, username}),
    phone = erlang:error({required, phone}),
    token = erlang:error({required, token}),
    device_type = erlang:error({required, device_type}),
    device_id = erlang:error({required, device_id}),
    version = erlang:error({required, version}),
    app_id = erlang:error({required, app_id}),
    timestamp = erlang:error({required, timestamp})
}).
-endif.

-ifndef(LOGONREQUEST_PB_H).
-define(LOGONREQUEST_PB_H, true).
-record(logonrequest, {
    mt = erlang:error({required, mt}),
    mid = erlang:error({required, mid}),
    data = []
}).
-endif.

-ifndef(HEARTBEAT_PB_H).
-define(HEARTBEAT_PB_H, true).
-record(heartbeat, {
    mt = erlang:error({required, mt}),
    mid = erlang:error({required, mid})
}).
-endif.

