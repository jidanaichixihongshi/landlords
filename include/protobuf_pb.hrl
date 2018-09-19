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

-ifndef(RESPONSELOGON_PB_H).
-define(RESPONSELOGON_PB_H, true).
-record(responselogon, {
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

-ifndef(FROM_PB_H).
-define(FROM_PB_H, true).
-record(from, {
    user = erlang:error({required, user}),
    device = erlang:error({required, device}),
    server = erlang:error({required, server})
}).
-endif.

-ifndef(TO_PB_H).
-define(TO_PB_H, true).
-record(to, {
    user = erlang:error({required, user}),
    device = erlang:error({required, device}),
    server = erlang:error({required, server})
}).
-endif.

-ifndef(CHAT_PB_H).
-define(CHAT_PB_H, true).
-record(chat, {
    from = erlang:error({required, from}),
    device = erlang:error({required, device}),
    c = erlang:error({required, c})
}).
-endif.

-ifndef(SEEKUSER_PB_H).
-define(SEEKUSER_PB_H, true).
-record(seekuser, {
    mt = erlang:error({required, mt}),
    mid = erlang:error({required, mid}),
    sig = erlang:error({required, sig}),
    timestamp = erlang:error({required, timestamp}),
    from = erlang:error({required, from}),
    to = erlang:error({required, to}),
    data = erlang:error({required, data})
}).
-endif.

-ifndef(RESPONSESEEKUSER_PB_H).
-define(RESPONSESEEKUSER_PB_H, true).
-record(responseseekuser, {
    mt = erlang:error({required, mt}),
    mid = erlang:error({required, mid}),
    sig = erlang:error({required, sig}),
    timestamp = erlang:error({required, timestamp}),
    from = erlang:error({required, from}),
    to = erlang:error({required, to}),
    data = erlang:error({required, data})
}).
-endif.

-ifndef(REQUESTFRIEND_PB_H).
-define(REQUESTFRIEND_PB_H, true).
-record(requestfriend, {
    mt = erlang:error({required, mt}),
    mid = erlang:error({required, mid}),
    sig = erlang:error({required, sig}),
    timestamp = erlang:error({required, timestamp}),
    from = erlang:error({required, from}),
    to = erlang:error({required, to}),
    data = erlang:error({required, data})
}).
-endif.

-ifndef(RSPONSEREQUESTFRIEND_PB_H).
-define(RSPONSEREQUESTFRIEND_PB_H, true).
-record(rsponserequestfriend, {
    mt = erlang:error({required, mt}),
    mid = erlang:error({required, mid}),
    sig = erlang:error({required, sig}),
    timestamp = erlang:error({required, timestamp}),
    from = erlang:error({required, from}),
    to = erlang:error({required, to}),
    data = erlang:error({required, data})
}).
-endif.

-ifndef(REMOVEFRIEND_PB_H).
-define(REMOVEFRIEND_PB_H, true).
-record(removefriend, {
    mt = erlang:error({required, mt}),
    mid = erlang:error({required, mid}),
    sig = erlang:error({required, sig}),
    timestamp = erlang:error({required, timestamp}),
    from = erlang:error({required, from}),
    to = erlang:error({required, to}),
    data = erlang:error({required, data})
}).
-endif.

-ifndef(RESPONSEREMOVEFRIEND_PB_H).
-define(RESPONSEREMOVEFRIEND_PB_H, true).
-record(responseremovefriend, {
    mt = erlang:error({required, mt}),
    mid = erlang:error({required, mid}),
    sig = erlang:error({required, sig}),
    timestamp = erlang:error({required, timestamp}),
    from = erlang:error({required, from}),
    to = erlang:error({required, to}),
    data = erlang:error({required, data})
}).
-endif.

-ifndef(GRIVATECHAT_PB_H).
-define(GRIVATECHAT_PB_H, true).
-record(grivatechat, {
    mt = erlang:error({required, mt}),
    mid = erlang:error({required, mid}),
    sig = erlang:error({required, sig}),
    timestamp = erlang:error({required, timestamp}),
    from = erlang:error({required, from}),
    to = erlang:error({required, to}),
    data = erlang:error({required, data})
}).
-endif.

-ifndef(RESPONSEGRIVATECHAT_PB_H).
-define(RESPONSEGRIVATECHAT_PB_H, true).
-record(responsegrivatechat, {
    mt = erlang:error({required, mt}),
    mid = erlang:error({required, mid}),
    sig = erlang:error({required, sig}),
    timestamp = erlang:error({required, timestamp}),
    from = erlang:error({required, from}),
    to = erlang:error({required, to}),
    data = erlang:error({required, data})
}).
-endif.

-ifndef(GROUPCHAT_PB_H).
-define(GROUPCHAT_PB_H, true).
-record(groupchat, {
    mt = erlang:error({required, mt}),
    mid = erlang:error({required, mid}),
    sig = erlang:error({required, sig}),
    timestamp = erlang:error({required, timestamp}),
    from = erlang:error({required, from}),
    to = erlang:error({required, to}),
    data = erlang:error({required, data})
}).
-endif.

-ifndef(RESPONSEGROUPCHAT_PB_H).
-define(RESPONSEGROUPCHAT_PB_H, true).
-record(responsegroupchat, {
    mt = erlang:error({required, mt}),
    mid = erlang:error({required, mid}),
    sig = erlang:error({required, sig}),
    timestamp = erlang:error({required, timestamp}),
    from = erlang:error({required, from}),
    to = erlang:error({required, to}),
    data = erlang:error({required, data})
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

