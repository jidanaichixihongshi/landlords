-ifndef(PROTO_PB_H).
-define(PROTO_PB_H, true).
-record(proto, {
    mt = erlang:error({required, mt}),
    mid = erlang:error({required, mid}),
    sig = erlang:error({required, sig}),
    router = erlang:error({required, router}),
    data,
    timestamp = erlang:error({required, timestamp})
}).
-endif.

-ifndef(ROUTER_PB_H).
-define(ROUTER_PB_H, true).
-record(router, {
    from = erlang:error({required, from}),
    from_device,
    from_server,
    to,
    to_device,
    to_server
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

-ifndef(LOGONPARAMETER_PB_H).
-define(LOGONPARAMETER_PB_H, true).
-record(logonparameter, {
    uid,
    nickname,
    phone,
    token = erlang:error({required, token}),
    device = erlang:error({required, device}),
    device_id,
    version,
    app_id,
    extend
}).
-endif.

-ifndef(PERSONSESSION_PB_H).
-define(PERSONSESSION_PB_H, true).
-record(personsession, {
    uid = erlang:error({required, uid}),
    nickname = erlang:error({required, nickname}),
    portrait = erlang:error({required, portrait}),
    personlabel = erlang:error({required, personlabel}),
    setting,
    rosters,
    groups,
    serverparameter = erlang:error({required, serverparameter}),
    extend
}).
-endif.

-ifndef(PERSONRESEARCH_PB_H).
-define(PERSONRESEARCH_PB_H, true).
-record(personresearch, {
    uid = erlang:error({required, uid}),
    nickname = erlang:error({required, nickname}),
    portrait = erlang:error({required, portrait}),
    personlabel = erlang:error({required, personlabel}),
    extend
}).
-endif.

-ifndef(GROUPSESSION_PB_H).
-define(GROUPSESSION_PB_H, true).
-record(groupsession, {
    gid = erlang:error({required, gid}),
    gnickname = erlang:error({required, gnickname}),
    gportrait = erlang:error({required, gportrait}),
    setting = erlang:error({required, setting}),
    admin = erlang:error({required, admin}),
    numbers = erlang:error({required, numbers}),
    announcement = erlang:error({required, announcement}),
    extend
}).
-endif.

-ifndef(GROUPRESEARCH_PB_H).
-define(GROUPRESEARCH_PB_H, true).
-record(groupresearch, {
    gid = erlang:error({required, gid}),
    gnickname = erlang:error({required, gnickname}),
    gportrait = erlang:error({required, gportrait}),
    announcement = erlang:error({required, announcement}),
    extend
}).
-endif.

-ifndef(ROOMSESSION_PB_H).
-define(ROOMSESSION_PB_H, true).
-record(roomsession, {
    rid = erlang:error({required, rid}),
    type = erlang:error({required, type}),
    setting = erlang:error({required, setting}),
    creator = erlang:error({required, creator}),
    numbers = erlang:error({required, numbers}),
    extend
}).
-endif.

-ifndef(ROOMRESEARCH_PB_H).
-define(ROOMRESEARCH_PB_H, true).
-record(roomresearch, {
    rid = erlang:error({required, rid}),
    type = erlang:error({required, type}),
    creator = erlang:error({required, creator}),
    numbers = erlang:error({required, numbers}),
    extend
}).
-endif.

