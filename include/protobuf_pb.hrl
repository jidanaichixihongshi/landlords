-ifndef(PROTO_PB_H).
-define(PROTO_PB_H, true).
-record(proto, {
    mt = erlang:error({required, mt}),
    sig = erlang:error({required, sig}),
    router = erlang:error({required, router}),
    data,
    ts = erlang:error({required, ts})
}).
-endif.

-ifndef(DATA_PB_H).
-define(DATA_PB_H, true).
-record(data, {
    dt = erlang:error({required, dt}),
    mid = erlang:error({required, mid}),
    children = erlang:error({required, children}),
    extend
}).
-endif.

-ifndef(ROUTER_PB_H).
-define(ROUTER_PB_H, true).
-record(router, {
    from = erlang:error({required, from}),
    fdevice,
    fserver,
    to,
    tdevice,
    tserver
}).
-endif.

-ifndef(CHAT_PB_H).
-define(CHAT_PB_H, true).
-record(chat, {
    from = erlang:error({required, from}),
    device = erlang:error({required, device}),
    ct = erlang:error({required, ct}),
    c = erlang:error({required, c})
}).
-endif.

-ifndef(REQUEST_PB_H).
-define(REQUEST_PB_H, true).
-record(request, {
    from = erlang:error({required, from}),
    device = erlang:error({required, device}),
    rt = erlang:error({required, rt}),
    rm = erlang:error({required, rm}),
    extend
}).
-endif.

-ifndef(PUSH_PB_H).
-define(PUSH_PB_H, true).
-record(push, {
    pt = erlang:error({required, pt}),
    pm = erlang:error({required, pm}),
    extend
}).
-endif.

