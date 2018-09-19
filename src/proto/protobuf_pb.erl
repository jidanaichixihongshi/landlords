-file("src/protobuf_pb.erl", 1).

-module(protobuf_pb).

-export([encode_heartbeat/1, decode_heartbeat/1,
	 delimited_decode_heartbeat/1,
	 encode_responsegroupchat/1, decode_responsegroupchat/1,
	 delimited_decode_responsegroupchat/1,
	 encode_groupchat/1, decode_groupchat/1,
	 delimited_decode_groupchat/1, encode_groupsession/1,
	 decode_groupsession/1, delimited_decode_groupsession/1,
	 encode_responsecreategroup/1,
	 decode_responsecreategroup/1,
	 delimited_decode_responsecreategroup/1,
	 encode_creategroup/1, decode_creategroup/1,
	 delimited_decode_creategroup/1,
	 encode_responsepersonalchat/1,
	 decode_responsepersonalchat/1,
	 delimited_decode_responsepersonalchat/1,
	 encode_personalchat/1, decode_personalchat/1,
	 delimited_decode_personalchat/1,
	 encode_responseremovefriend/1,
	 decode_responseremovefriend/1,
	 delimited_decode_responseremovefriend/1,
	 encode_removefriend/1, decode_removefriend/1,
	 delimited_decode_removefriend/1,
	 encode_rsponserequestfriend/1,
	 decode_rsponserequestfriend/1,
	 delimited_decode_rsponserequestfriend/1,
	 encode_requestfriend/1, decode_requestfriend/1,
	 delimited_decode_requestfriend/1,
	 encode_responseseekuser/1, decode_responseseekuser/1,
	 delimited_decode_responseseekuser/1, encode_seekuser/1,
	 decode_seekuser/1, delimited_decode_seekuser/1,
	 encode_chat/1, decode_chat/1, delimited_decode_chat/1,
	 encode_router/1, decode_router/1,
	 delimited_decode_router/1, encode_sessionsuccess/1,
	 decode_sessionsuccess/1,
	 delimited_decode_sessionsuccess/1,
	 encode_responsesession/1, decode_responsesession/1,
	 delimited_decode_responsesession/1,
	 encode_logonsuccess/1, decode_logonsuccess/1,
	 delimited_decode_logonsuccess/1, encode_responselogon/1,
	 decode_responselogon/1,
	 delimited_decode_responselogon/1, encode_requestlogon/1,
	 decode_requestlogon/1, delimited_decode_requestlogon/1,
	 encode_userdata/1, decode_userdata/1,
	 delimited_decode_userdata/1]).

-export([has_extension/2, extension_size/1,
	 get_extension/2, set_extension/3]).

-export([decode_extensions/1]).

-export([encode/1, decode/2, delimited_decode/2]).

-export([int_to_enum/2, enum_to_int/2]).

-record(heartbeat, {mt, mid, sig, timestamp, data}).

-record(responsegroupchat,
	{mt, mid, sig, timestamp, router, data}).

-record(groupchat,
	{mt, mid, sig, timestamp, router, data}).

-record(groupsession,
	{mt, mid, sig, timestamp, router, data}).

-record(responsecreategroup,
	{mt, mid, sig, timestamp, router, data}).

-record(creategroup,
	{mt, mid, sig, timestamp, router, data}).

-record(responsepersonalchat,
	{mt, mid, sig, timestamp, router, data}).

-record(personalchat,
	{mt, mid, sig, timestamp, router, data}).

-record(responseremovefriend,
	{mt, mid, sig, timestamp, router, data}).

-record(removefriend,
	{mt, mid, sig, timestamp, router, data}).

-record(rsponserequestfriend,
	{mt, mid, sig, timestamp, router, data}).

-record(requestfriend,
	{mt, mid, sig, timestamp, router, bytes}).

-record(responseseekuser,
	{mt, mid, sig, timestamp, router, data}).

-record(seekuser,
	{mt, mid, sig, timestamp, router, data}).

-record(chat, {from, device, c}).

-record(router,
	{from, from_device, from_server, to, to_device,
	 to_server}).

-record(sessionsuccess,
	{mt, mid, sig, timestamp, data}).

-record(responsesession,
	{mt, mid, sig, timestamp, data}).

-record(logonsuccess, {mt, mid, sig, timestamp, data}).

-record(responselogon, {mt, mid, sig, timestamp, data}).

-record(requestlogon, {mt, mid, sig, timestamp, data}).

-record(userdata,
	{nickname, uid, phone, token, device, device_id,
	 version, app_id}).

-dialyzer(no_match).

encode([]) -> [];
encode(Records) when is_list(Records) ->
    delimited_encode(Records);
encode(Record) -> encode(element(1, Record), Record).

encode_heartbeat(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_heartbeat(Record)
    when is_record(Record, heartbeat) ->
    encode(heartbeat, Record).

encode_responsegroupchat(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_responsegroupchat(Record)
    when is_record(Record, responsegroupchat) ->
    encode(responsegroupchat, Record).

encode_groupchat(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_groupchat(Record)
    when is_record(Record, groupchat) ->
    encode(groupchat, Record).

encode_groupsession(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_groupsession(Record)
    when is_record(Record, groupsession) ->
    encode(groupsession, Record).

encode_responsecreategroup(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_responsecreategroup(Record)
    when is_record(Record, responsecreategroup) ->
    encode(responsecreategroup, Record).

encode_creategroup(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_creategroup(Record)
    when is_record(Record, creategroup) ->
    encode(creategroup, Record).

encode_responsepersonalchat(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_responsepersonalchat(Record)
    when is_record(Record, responsepersonalchat) ->
    encode(responsepersonalchat, Record).

encode_personalchat(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_personalchat(Record)
    when is_record(Record, personalchat) ->
    encode(personalchat, Record).

encode_responseremovefriend(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_responseremovefriend(Record)
    when is_record(Record, responseremovefriend) ->
    encode(responseremovefriend, Record).

encode_removefriend(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_removefriend(Record)
    when is_record(Record, removefriend) ->
    encode(removefriend, Record).

encode_rsponserequestfriend(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_rsponserequestfriend(Record)
    when is_record(Record, rsponserequestfriend) ->
    encode(rsponserequestfriend, Record).

encode_requestfriend(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_requestfriend(Record)
    when is_record(Record, requestfriend) ->
    encode(requestfriend, Record).

encode_responseseekuser(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_responseseekuser(Record)
    when is_record(Record, responseseekuser) ->
    encode(responseseekuser, Record).

encode_seekuser(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_seekuser(Record)
    when is_record(Record, seekuser) ->
    encode(seekuser, Record).

encode_chat(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_chat(Record) when is_record(Record, chat) ->
    encode(chat, Record).

encode_router(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_router(Record) when is_record(Record, router) ->
    encode(router, Record).

encode_sessionsuccess(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_sessionsuccess(Record)
    when is_record(Record, sessionsuccess) ->
    encode(sessionsuccess, Record).

encode_responsesession(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_responsesession(Record)
    when is_record(Record, responsesession) ->
    encode(responsesession, Record).

encode_logonsuccess(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_logonsuccess(Record)
    when is_record(Record, logonsuccess) ->
    encode(logonsuccess, Record).

encode_responselogon(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_responselogon(Record)
    when is_record(Record, responselogon) ->
    encode(responselogon, Record).

encode_requestlogon(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_requestlogon(Record)
    when is_record(Record, requestlogon) ->
    encode(requestlogon, Record).

encode_userdata(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_userdata(Record)
    when is_record(Record, userdata) ->
    encode(userdata, Record).

encode(userdata, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(userdata, Record) ->
    [iolist(userdata, Record) | encode_extensions(Record)];
encode(requestlogon, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(requestlogon, Record) ->
    [iolist(requestlogon, Record)
     | encode_extensions(Record)];
encode(responselogon, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(responselogon, Record) ->
    [iolist(responselogon, Record)
     | encode_extensions(Record)];
encode(logonsuccess, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(logonsuccess, Record) ->
    [iolist(logonsuccess, Record)
     | encode_extensions(Record)];
encode(responsesession, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(responsesession, Record) ->
    [iolist(responsesession, Record)
     | encode_extensions(Record)];
encode(sessionsuccess, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(sessionsuccess, Record) ->
    [iolist(sessionsuccess, Record)
     | encode_extensions(Record)];
encode(router, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(router, Record) ->
    [iolist(router, Record) | encode_extensions(Record)];
encode(chat, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(chat, Record) ->
    [iolist(chat, Record) | encode_extensions(Record)];
encode(seekuser, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(seekuser, Record) ->
    [iolist(seekuser, Record) | encode_extensions(Record)];
encode(responseseekuser, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(responseseekuser, Record) ->
    [iolist(responseseekuser, Record)
     | encode_extensions(Record)];
encode(requestfriend, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(requestfriend, Record) ->
    [iolist(requestfriend, Record)
     | encode_extensions(Record)];
encode(rsponserequestfriend, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(rsponserequestfriend, Record) ->
    [iolist(rsponserequestfriend, Record)
     | encode_extensions(Record)];
encode(removefriend, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(removefriend, Record) ->
    [iolist(removefriend, Record)
     | encode_extensions(Record)];
encode(responseremovefriend, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(responseremovefriend, Record) ->
    [iolist(responseremovefriend, Record)
     | encode_extensions(Record)];
encode(personalchat, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(personalchat, Record) ->
    [iolist(personalchat, Record)
     | encode_extensions(Record)];
encode(responsepersonalchat, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(responsepersonalchat, Record) ->
    [iolist(responsepersonalchat, Record)
     | encode_extensions(Record)];
encode(creategroup, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(creategroup, Record) ->
    [iolist(creategroup, Record)
     | encode_extensions(Record)];
encode(responsecreategroup, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(responsecreategroup, Record) ->
    [iolist(responsecreategroup, Record)
     | encode_extensions(Record)];
encode(groupsession, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(groupsession, Record) ->
    [iolist(groupsession, Record)
     | encode_extensions(Record)];
encode(groupchat, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(groupchat, Record) ->
    [iolist(groupchat, Record) | encode_extensions(Record)];
encode(responsegroupchat, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(responsegroupchat, Record) ->
    [iolist(responsegroupchat, Record)
     | encode_extensions(Record)];
encode(heartbeat, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(heartbeat, Record) ->
    [iolist(heartbeat, Record) | encode_extensions(Record)].

encode_extensions(_) -> [].

delimited_encode(Records) ->
    lists:map(fun (Record) ->
		      IoRec = encode(Record),
		      Size = iolist_size(IoRec),
		      [protobuffs:encode_varint(Size), IoRec]
	      end,
	      Records).

iolist(userdata, Record) ->
    [pack(1, optional,
	  with_default(Record#userdata.nickname, none), string,
	  []),
     pack(2, optional,
	  with_default(Record#userdata.uid, none), int32, []),
     pack(3, optional,
	  with_default(Record#userdata.phone, none), int64, []),
     pack(4, required,
	  with_default(Record#userdata.token, none), string, []),
     pack(5, required,
	  with_default(Record#userdata.device, none), int32, []),
     pack(6, optional,
	  with_default(Record#userdata.device_id, none), int32,
	  []),
     pack(7, required,
	  with_default(Record#userdata.version, none), string,
	  []),
     pack(8, required,
	  with_default(Record#userdata.app_id, none), string,
	  [])];
iolist(requestlogon, Record) ->
    [pack(1, required,
	  with_default(Record#requestlogon.mt, none), int32, []),
     pack(2, required,
	  with_default(Record#requestlogon.mid, none), string,
	  []),
     pack(3, required,
	  with_default(Record#requestlogon.sig, none), int32, []),
     pack(4, required,
	  with_default(Record#requestlogon.timestamp, none),
	  int64, []),
     pack(5, required,
	  with_default(Record#requestlogon.data, none), userdata,
	  [])];
iolist(responselogon, Record) ->
    [pack(1, required,
	  with_default(Record#responselogon.mt, none), int32, []),
     pack(2, required,
	  with_default(Record#responselogon.mid, none), string,
	  []),
     pack(3, required,
	  with_default(Record#responselogon.sig, none), int32,
	  []),
     pack(4, required,
	  with_default(Record#responselogon.timestamp, none),
	  int64, []),
     pack(5, optional,
	  with_default(Record#responselogon.data, none), int32,
	  [])];
iolist(logonsuccess, Record) ->
    [pack(1, required,
	  with_default(Record#logonsuccess.mt, none), int32, []),
     pack(2, required,
	  with_default(Record#logonsuccess.mid, none), string,
	  []),
     pack(3, required,
	  with_default(Record#logonsuccess.sig, none), int32, []),
     pack(4, required,
	  with_default(Record#logonsuccess.timestamp, none),
	  int64, []),
     pack(5, optional,
	  with_default(Record#logonsuccess.data, none), int32,
	  [])];
iolist(responsesession, Record) ->
    [pack(1, required,
	  with_default(Record#responsesession.mt, none), int32,
	  []),
     pack(2, required,
	  with_default(Record#responsesession.mid, none), string,
	  []),
     pack(3, required,
	  with_default(Record#responsesession.sig, none), int32,
	  []),
     pack(4, required,
	  with_default(Record#responsesession.timestamp, none),
	  int64, []),
     pack(5, optional,
	  with_default(Record#responsesession.data, none), string,
	  [])];
iolist(sessionsuccess, Record) ->
    [pack(1, required,
	  with_default(Record#sessionsuccess.mt, none), int32,
	  []),
     pack(2, required,
	  with_default(Record#sessionsuccess.mid, none), string,
	  []),
     pack(3, required,
	  with_default(Record#sessionsuccess.sig, none), int32,
	  []),
     pack(4, required,
	  with_default(Record#sessionsuccess.timestamp, none),
	  int64, []),
     pack(5, optional,
	  with_default(Record#sessionsuccess.data, none), int32,
	  [])];
iolist(router, Record) ->
    [pack(1, required,
	  with_default(Record#router.from, none), int32, []),
     pack(2, required,
	  with_default(Record#router.from_device, none), int32,
	  []),
     pack(3, required,
	  with_default(Record#router.from_server, none), int32,
	  []),
     pack(4, required, with_default(Record#router.to, none),
	  int32, []),
     pack(5, required,
	  with_default(Record#router.to_device, none), int32, []),
     pack(6, required,
	  with_default(Record#router.to_server, none), int32,
	  [])];
iolist(chat, Record) ->
    [pack(1, required, with_default(Record#chat.from, none),
	  int32, []),
     pack(2, required,
	  with_default(Record#chat.device, none), int32, []),
     pack(3, required, with_default(Record#chat.c, none),
	  string, [])];
iolist(seekuser, Record) ->
    [pack(1, required,
	  with_default(Record#seekuser.mt, none), int32, []),
     pack(2, required,
	  with_default(Record#seekuser.mid, none), string, []),
     pack(3, required,
	  with_default(Record#seekuser.sig, none), int32, []),
     pack(4, required,
	  with_default(Record#seekuser.timestamp, none), int64,
	  []),
     pack(5, required,
	  with_default(Record#seekuser.router, none), router, []),
     pack(6, required,
	  with_default(Record#seekuser.data, none), string, [])];
iolist(responseseekuser, Record) ->
    [pack(1, required,
	  with_default(Record#responseseekuser.mt, none), int32,
	  []),
     pack(2, required,
	  with_default(Record#responseseekuser.mid, none), string,
	  []),
     pack(3, required,
	  with_default(Record#responseseekuser.sig, none), int32,
	  []),
     pack(4, required,
	  with_default(Record#responseseekuser.timestamp, none),
	  int64, []),
     pack(5, required,
	  with_default(Record#responseseekuser.router, none),
	  router, []),
     pack(6, required,
	  with_default(Record#responseseekuser.data, none), bytes,
	  [])];
iolist(requestfriend, Record) ->
    [pack(1, required,
	  with_default(Record#requestfriend.mt, none), int32, []),
     pack(2, required,
	  with_default(Record#requestfriend.mid, none), string,
	  []),
     pack(3, required,
	  with_default(Record#requestfriend.sig, none), int32,
	  []),
     pack(4, required,
	  with_default(Record#requestfriend.timestamp, none),
	  int64, []),
     pack(5, required,
	  with_default(Record#requestfriend.router, none), router,
	  []),
     pack(6, required,
	  with_default(Record#requestfriend.bytes, none), string,
	  [])];
iolist(rsponserequestfriend, Record) ->
    [pack(1, required,
	  with_default(Record#rsponserequestfriend.mt, none),
	  int32, []),
     pack(2, required,
	  with_default(Record#rsponserequestfriend.mid, none),
	  string, []),
     pack(3, required,
	  with_default(Record#rsponserequestfriend.sig, none),
	  int32, []),
     pack(4, required,
	  with_default(Record#rsponserequestfriend.timestamp,
		       none),
	  int64, []),
     pack(5, required,
	  with_default(Record#rsponserequestfriend.router, none),
	  router, []),
     pack(6, required,
	  with_default(Record#rsponserequestfriend.data, none),
	  string, [])];
iolist(removefriend, Record) ->
    [pack(1, required,
	  with_default(Record#removefriend.mt, none), int32, []),
     pack(2, required,
	  with_default(Record#removefriend.mid, none), string,
	  []),
     pack(3, required,
	  with_default(Record#removefriend.sig, none), int32, []),
     pack(4, required,
	  with_default(Record#removefriend.timestamp, none),
	  int64, []),
     pack(5, required,
	  with_default(Record#removefriend.router, none), router,
	  []),
     pack(6, required,
	  with_default(Record#removefriend.data, none), bytes,
	  [])];
iolist(responseremovefriend, Record) ->
    [pack(1, required,
	  with_default(Record#responseremovefriend.mt, none),
	  int32, []),
     pack(2, required,
	  with_default(Record#responseremovefriend.mid, none),
	  string, []),
     pack(3, required,
	  with_default(Record#responseremovefriend.sig, none),
	  int32, []),
     pack(4, required,
	  with_default(Record#responseremovefriend.timestamp,
		       none),
	  int64, []),
     pack(5, required,
	  with_default(Record#responseremovefriend.router, none),
	  router, []),
     pack(6, required,
	  with_default(Record#responseremovefriend.data, none),
	  string, [])];
iolist(personalchat, Record) ->
    [pack(1, required,
	  with_default(Record#personalchat.mt, none), int32, []),
     pack(2, required,
	  with_default(Record#personalchat.mid, none), string,
	  []),
     pack(3, required,
	  with_default(Record#personalchat.sig, none), int32, []),
     pack(4, required,
	  with_default(Record#personalchat.timestamp, none),
	  int64, []),
     pack(5, required,
	  with_default(Record#personalchat.router, none), router,
	  []),
     pack(6, required,
	  with_default(Record#personalchat.data, none), chat,
	  [])];
iolist(responsepersonalchat, Record) ->
    [pack(1, required,
	  with_default(Record#responsepersonalchat.mt, none),
	  int32, []),
     pack(2, required,
	  with_default(Record#responsepersonalchat.mid, none),
	  string, []),
     pack(3, required,
	  with_default(Record#responsepersonalchat.sig, none),
	  int32, []),
     pack(4, required,
	  with_default(Record#responsepersonalchat.timestamp,
		       none),
	  int64, []),
     pack(5, required,
	  with_default(Record#responsepersonalchat.router, none),
	  router, []),
     pack(6, required,
	  with_default(Record#responsepersonalchat.data, none),
	  int32, [])];
iolist(creategroup, Record) ->
    [pack(1, required,
	  with_default(Record#creategroup.mt, none), int32, []),
     pack(2, required,
	  with_default(Record#creategroup.mid, none), string, []),
     pack(3, required,
	  with_default(Record#creategroup.sig, none), int32, []),
     pack(4, required,
	  with_default(Record#creategroup.timestamp, none), int64,
	  []),
     pack(5, required,
	  with_default(Record#creategroup.router, none), router,
	  []),
     pack(6, required,
	  with_default(Record#creategroup.data, none), bytes,
	  [])];
iolist(responsecreategroup, Record) ->
    [pack(1, required,
	  with_default(Record#responsecreategroup.mt, none),
	  int32, []),
     pack(2, required,
	  with_default(Record#responsecreategroup.mid, none),
	  string, []),
     pack(3, required,
	  with_default(Record#responsecreategroup.sig, none),
	  int32, []),
     pack(4, required,
	  with_default(Record#responsecreategroup.timestamp,
		       none),
	  int64, []),
     pack(5, required,
	  with_default(Record#responsecreategroup.router, none),
	  router, []),
     pack(6, required,
	  with_default(Record#responsecreategroup.data, none),
	  int32, [])];
iolist(groupsession, Record) ->
    [pack(1, required,
	  with_default(Record#groupsession.mt, none), int32, []),
     pack(2, required,
	  with_default(Record#groupsession.mid, none), string,
	  []),
     pack(3, required,
	  with_default(Record#groupsession.sig, none), int32, []),
     pack(4, required,
	  with_default(Record#groupsession.timestamp, none),
	  int64, []),
     pack(5, required,
	  with_default(Record#groupsession.router, none), router,
	  []),
     pack(6, required,
	  with_default(Record#groupsession.data, none), bytes,
	  [])];
iolist(groupchat, Record) ->
    [pack(1, required,
	  with_default(Record#groupchat.mt, none), int32, []),
     pack(2, required,
	  with_default(Record#groupchat.mid, none), string, []),
     pack(3, required,
	  with_default(Record#groupchat.sig, none), int32, []),
     pack(4, required,
	  with_default(Record#groupchat.timestamp, none), int64,
	  []),
     pack(5, required,
	  with_default(Record#groupchat.router, none), router,
	  []),
     pack(6, required,
	  with_default(Record#groupchat.data, none), chat, [])];
iolist(responsegroupchat, Record) ->
    [pack(1, required,
	  with_default(Record#responsegroupchat.mt, none), int32,
	  []),
     pack(2, required,
	  with_default(Record#responsegroupchat.mid, none),
	  string, []),
     pack(3, required,
	  with_default(Record#responsegroupchat.sig, none), int32,
	  []),
     pack(4, required,
	  with_default(Record#responsegroupchat.timestamp, none),
	  int64, []),
     pack(5, required,
	  with_default(Record#responsegroupchat.router, none),
	  router, []),
     pack(6, required,
	  with_default(Record#responsegroupchat.data, none),
	  int32, [])];
iolist(heartbeat, Record) ->
    [pack(1, required,
	  with_default(Record#heartbeat.mt, none), int32, []),
     pack(2, required,
	  with_default(Record#heartbeat.mid, none), string, []),
     pack(3, required,
	  with_default(Record#heartbeat.sig, none), int32, []),
     pack(4, required,
	  with_default(Record#heartbeat.timestamp, none), int64,
	  []),
     pack(5, optional,
	  with_default(Record#heartbeat.data, none), string, [])].

with_default(Default, Default) -> undefined;
with_default(Val, _) -> Val.

pack(_, optional, undefined, _, _) -> [];
pack(_, repeated, undefined, _, _) -> [];
pack(_, repeated_packed, undefined, _, _) -> [];
pack(_, repeated_packed, [], _, _) -> [];
pack(FNum, required, undefined, Type, _) ->
    exit({error,
	  {required_field_is_undefined, FNum, Type}});
pack(_, repeated, [], _, Acc) -> lists:reverse(Acc);
pack(FNum, repeated, [Head | Tail], Type, Acc) ->
    pack(FNum, repeated, Tail, Type,
	 [pack(FNum, optional, Head, Type, []) | Acc]);
pack(FNum, repeated_packed, Data, Type, _) ->
    protobuffs:encode_packed(FNum, Data, Type);
pack(FNum, _, Data, _, _) when is_tuple(Data) ->
    [RecName | _] = tuple_to_list(Data),
    protobuffs:encode(FNum, encode(RecName, Data), bytes);
pack(FNum, _, Data, Type, _)
    when Type =:= bool;
	 Type =:= int32;
	 Type =:= uint32;
	 Type =:= int64;
	 Type =:= uint64;
	 Type =:= sint32;
	 Type =:= sint64;
	 Type =:= fixed32;
	 Type =:= sfixed32;
	 Type =:= fixed64;
	 Type =:= sfixed64;
	 Type =:= string;
	 Type =:= bytes;
	 Type =:= float;
	 Type =:= double ->
    protobuffs:encode(FNum, Data, Type);
pack(FNum, _, Data, Type, _) when is_atom(Data) ->
    protobuffs:encode(FNum, enum_to_int(Type, Data), enum).

enum_to_int(pikachu, value) -> 1.

int_to_enum(_, Val) -> Val.

decode_heartbeat(Bytes) when is_binary(Bytes) ->
    decode(heartbeat, Bytes).

decode_responsegroupchat(Bytes) when is_binary(Bytes) ->
    decode(responsegroupchat, Bytes).

decode_groupchat(Bytes) when is_binary(Bytes) ->
    decode(groupchat, Bytes).

decode_groupsession(Bytes) when is_binary(Bytes) ->
    decode(groupsession, Bytes).

decode_responsecreategroup(Bytes)
    when is_binary(Bytes) ->
    decode(responsecreategroup, Bytes).

decode_creategroup(Bytes) when is_binary(Bytes) ->
    decode(creategroup, Bytes).

decode_responsepersonalchat(Bytes)
    when is_binary(Bytes) ->
    decode(responsepersonalchat, Bytes).

decode_personalchat(Bytes) when is_binary(Bytes) ->
    decode(personalchat, Bytes).

decode_responseremovefriend(Bytes)
    when is_binary(Bytes) ->
    decode(responseremovefriend, Bytes).

decode_removefriend(Bytes) when is_binary(Bytes) ->
    decode(removefriend, Bytes).

decode_rsponserequestfriend(Bytes)
    when is_binary(Bytes) ->
    decode(rsponserequestfriend, Bytes).

decode_requestfriend(Bytes) when is_binary(Bytes) ->
    decode(requestfriend, Bytes).

decode_responseseekuser(Bytes) when is_binary(Bytes) ->
    decode(responseseekuser, Bytes).

decode_seekuser(Bytes) when is_binary(Bytes) ->
    decode(seekuser, Bytes).

decode_chat(Bytes) when is_binary(Bytes) ->
    decode(chat, Bytes).

decode_router(Bytes) when is_binary(Bytes) ->
    decode(router, Bytes).

decode_sessionsuccess(Bytes) when is_binary(Bytes) ->
    decode(sessionsuccess, Bytes).

decode_responsesession(Bytes) when is_binary(Bytes) ->
    decode(responsesession, Bytes).

decode_logonsuccess(Bytes) when is_binary(Bytes) ->
    decode(logonsuccess, Bytes).

decode_responselogon(Bytes) when is_binary(Bytes) ->
    decode(responselogon, Bytes).

decode_requestlogon(Bytes) when is_binary(Bytes) ->
    decode(requestlogon, Bytes).

decode_userdata(Bytes) when is_binary(Bytes) ->
    decode(userdata, Bytes).

delimited_decode_userdata(Bytes) ->
    delimited_decode(userdata, Bytes).

delimited_decode_requestlogon(Bytes) ->
    delimited_decode(requestlogon, Bytes).

delimited_decode_responselogon(Bytes) ->
    delimited_decode(responselogon, Bytes).

delimited_decode_logonsuccess(Bytes) ->
    delimited_decode(logonsuccess, Bytes).

delimited_decode_responsesession(Bytes) ->
    delimited_decode(responsesession, Bytes).

delimited_decode_sessionsuccess(Bytes) ->
    delimited_decode(sessionsuccess, Bytes).

delimited_decode_router(Bytes) ->
    delimited_decode(router, Bytes).

delimited_decode_chat(Bytes) ->
    delimited_decode(chat, Bytes).

delimited_decode_seekuser(Bytes) ->
    delimited_decode(seekuser, Bytes).

delimited_decode_responseseekuser(Bytes) ->
    delimited_decode(responseseekuser, Bytes).

delimited_decode_requestfriend(Bytes) ->
    delimited_decode(requestfriend, Bytes).

delimited_decode_rsponserequestfriend(Bytes) ->
    delimited_decode(rsponserequestfriend, Bytes).

delimited_decode_removefriend(Bytes) ->
    delimited_decode(removefriend, Bytes).

delimited_decode_responseremovefriend(Bytes) ->
    delimited_decode(responseremovefriend, Bytes).

delimited_decode_personalchat(Bytes) ->
    delimited_decode(personalchat, Bytes).

delimited_decode_responsepersonalchat(Bytes) ->
    delimited_decode(responsepersonalchat, Bytes).

delimited_decode_creategroup(Bytes) ->
    delimited_decode(creategroup, Bytes).

delimited_decode_responsecreategroup(Bytes) ->
    delimited_decode(responsecreategroup, Bytes).

delimited_decode_groupsession(Bytes) ->
    delimited_decode(groupsession, Bytes).

delimited_decode_groupchat(Bytes) ->
    delimited_decode(groupchat, Bytes).

delimited_decode_responsegroupchat(Bytes) ->
    delimited_decode(responsegroupchat, Bytes).

delimited_decode_heartbeat(Bytes) ->
    delimited_decode(heartbeat, Bytes).

delimited_decode(Type, Bytes) when is_binary(Bytes) ->
    delimited_decode(Type, Bytes, []).

delimited_decode(_Type, <<>>, Acc) ->
    {lists:reverse(Acc), <<>>};
delimited_decode(Type, Bytes, Acc) ->
    try protobuffs:decode_varint(Bytes) of
      {Size, Rest} when size(Rest) < Size ->
	  {lists:reverse(Acc), Bytes};
      {Size, Rest} ->
	  <<MessageBytes:Size/binary, Rest2/binary>> = Rest,
	  Message = decode(Type, MessageBytes),
	  delimited_decode(Type, Rest2, [Message | Acc])
    catch
      _What:_Why -> {lists:reverse(Acc), Bytes}
    end.

decode(enummsg_values, 1) -> value1;
decode(userdata, Bytes) when is_binary(Bytes) ->
    Types = [{8, app_id, string, []},
	     {7, version, string, []}, {6, device_id, int32, []},
	     {5, device, int32, []}, {4, token, string, []},
	     {3, phone, int64, []}, {2, uid, int32, []},
	     {1, nickname, string, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(userdata, Decoded);
decode(requestlogon, Bytes) when is_binary(Bytes) ->
    Types = [{5, data, userdata, [is_record]},
	     {4, timestamp, int64, []}, {3, sig, int32, []},
	     {2, mid, string, []}, {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(requestlogon, Decoded);
decode(responselogon, Bytes) when is_binary(Bytes) ->
    Types = [{5, data, int32, []},
	     {4, timestamp, int64, []}, {3, sig, int32, []},
	     {2, mid, string, []}, {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(responselogon, Decoded);
decode(logonsuccess, Bytes) when is_binary(Bytes) ->
    Types = [{5, data, int32, []},
	     {4, timestamp, int64, []}, {3, sig, int32, []},
	     {2, mid, string, []}, {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(logonsuccess, Decoded);
decode(responsesession, Bytes) when is_binary(Bytes) ->
    Types = [{5, data, string, []},
	     {4, timestamp, int64, []}, {3, sig, int32, []},
	     {2, mid, string, []}, {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(responsesession, Decoded);
decode(sessionsuccess, Bytes) when is_binary(Bytes) ->
    Types = [{5, data, int32, []},
	     {4, timestamp, int64, []}, {3, sig, int32, []},
	     {2, mid, string, []}, {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(sessionsuccess, Decoded);
decode(router, Bytes) when is_binary(Bytes) ->
    Types = [{6, to_server, int32, []},
	     {5, to_device, int32, []}, {4, to, int32, []},
	     {3, from_server, int32, []},
	     {2, from_device, int32, []}, {1, from, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(router, Decoded);
decode(chat, Bytes) when is_binary(Bytes) ->
    Types = [{3, c, string, []}, {2, device, int32, []},
	     {1, from, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(chat, Decoded);
decode(seekuser, Bytes) when is_binary(Bytes) ->
    Types = [{6, data, string, []},
	     {5, router, router, [is_record]},
	     {4, timestamp, int64, []}, {3, sig, int32, []},
	     {2, mid, string, []}, {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(seekuser, Decoded);
decode(responseseekuser, Bytes) when is_binary(Bytes) ->
    Types = [{6, data, bytes, []},
	     {5, router, router, [is_record]},
	     {4, timestamp, int64, []}, {3, sig, int32, []},
	     {2, mid, string, []}, {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(responseseekuser, Decoded);
decode(requestfriend, Bytes) when is_binary(Bytes) ->
    Types = [{6, bytes, string, []},
	     {5, router, router, [is_record]},
	     {4, timestamp, int64, []}, {3, sig, int32, []},
	     {2, mid, string, []}, {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(requestfriend, Decoded);
decode(rsponserequestfriend, Bytes)
    when is_binary(Bytes) ->
    Types = [{6, data, string, []},
	     {5, router, router, [is_record]},
	     {4, timestamp, int64, []}, {3, sig, int32, []},
	     {2, mid, string, []}, {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(rsponserequestfriend, Decoded);
decode(removefriend, Bytes) when is_binary(Bytes) ->
    Types = [{6, data, bytes, []},
	     {5, router, router, [is_record]},
	     {4, timestamp, int64, []}, {3, sig, int32, []},
	     {2, mid, string, []}, {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(removefriend, Decoded);
decode(responseremovefriend, Bytes)
    when is_binary(Bytes) ->
    Types = [{6, data, string, []},
	     {5, router, router, [is_record]},
	     {4, timestamp, int64, []}, {3, sig, int32, []},
	     {2, mid, string, []}, {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(responseremovefriend, Decoded);
decode(personalchat, Bytes) when is_binary(Bytes) ->
    Types = [{6, data, chat, [is_record]},
	     {5, router, router, [is_record]},
	     {4, timestamp, int64, []}, {3, sig, int32, []},
	     {2, mid, string, []}, {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(personalchat, Decoded);
decode(responsepersonalchat, Bytes)
    when is_binary(Bytes) ->
    Types = [{6, data, int32, []},
	     {5, router, router, [is_record]},
	     {4, timestamp, int64, []}, {3, sig, int32, []},
	     {2, mid, string, []}, {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(responsepersonalchat, Decoded);
decode(creategroup, Bytes) when is_binary(Bytes) ->
    Types = [{6, data, bytes, []},
	     {5, router, router, [is_record]},
	     {4, timestamp, int64, []}, {3, sig, int32, []},
	     {2, mid, string, []}, {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(creategroup, Decoded);
decode(responsecreategroup, Bytes)
    when is_binary(Bytes) ->
    Types = [{6, data, int32, []},
	     {5, router, router, [is_record]},
	     {4, timestamp, int64, []}, {3, sig, int32, []},
	     {2, mid, string, []}, {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(responsecreategroup, Decoded);
decode(groupsession, Bytes) when is_binary(Bytes) ->
    Types = [{6, data, bytes, []},
	     {5, router, router, [is_record]},
	     {4, timestamp, int64, []}, {3, sig, int32, []},
	     {2, mid, string, []}, {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(groupsession, Decoded);
decode(groupchat, Bytes) when is_binary(Bytes) ->
    Types = [{6, data, chat, [is_record]},
	     {5, router, router, [is_record]},
	     {4, timestamp, int64, []}, {3, sig, int32, []},
	     {2, mid, string, []}, {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(groupchat, Decoded);
decode(responsegroupchat, Bytes)
    when is_binary(Bytes) ->
    Types = [{6, data, int32, []},
	     {5, router, router, [is_record]},
	     {4, timestamp, int64, []}, {3, sig, int32, []},
	     {2, mid, string, []}, {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(responsegroupchat, Decoded);
decode(heartbeat, Bytes) when is_binary(Bytes) ->
    Types = [{5, data, string, []},
	     {4, timestamp, int64, []}, {3, sig, int32, []},
	     {2, mid, string, []}, {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(heartbeat, Decoded).

decode(<<>>, Types, Acc) ->
    reverse_repeated_fields(Acc, Types);
decode(Bytes, Types, Acc) ->
    {ok, FNum} = protobuffs:next_field_num(Bytes),
    case lists:keyfind(FNum, 1, Types) of
      {FNum, Name, Type, Opts} ->
	  {Value1, Rest1} = case lists:member(is_record, Opts) of
			      true ->
				  {{FNum, V}, R} = protobuffs:decode(Bytes,
								     bytes),
				  RecVal = decode(Type, V),
				  {RecVal, R};
			      false ->
				  case lists:member(repeated_packed, Opts) of
				    true ->
					{{FNum, V}, R} =
					    protobuffs:decode_packed(Bytes,
								     Type),
					{V, R};
				    false ->
					{{FNum, V}, R} =
					    protobuffs:decode(Bytes, Type),
					{unpack_value(V, Type), R}
				  end
			    end,
	  case lists:member(repeated, Opts) of
	    true ->
		case lists:keytake(FNum, 1, Acc) of
		  {value, {FNum, Name, List}, Acc1} ->
		      decode(Rest1, Types,
			     [{FNum, Name, [int_to_enum(Type, Value1) | List]}
			      | Acc1]);
		  false ->
		      decode(Rest1, Types,
			     [{FNum, Name, [int_to_enum(Type, Value1)]} | Acc])
		end;
	    false ->
		decode(Rest1, Types,
		       [{FNum, Name, int_to_enum(Type, Value1)} | Acc])
	  end;
      false ->
	  case lists:keyfind('$extensions', 2, Acc) of
	    {_, _, Dict} ->
		{{FNum, _V}, R} = protobuffs:decode(Bytes, bytes),
		Diff = size(Bytes) - size(R),
		<<V:Diff/binary, _/binary>> = Bytes,
		NewDict = dict:store(FNum, V, Dict),
		NewAcc = lists:keyreplace('$extensions', 2, Acc,
					  {false, '$extensions', NewDict}),
		decode(R, Types, NewAcc);
	    _ ->
		{ok, Skipped} = protobuffs:skip_next_field(Bytes),
		decode(Skipped, Types, Acc)
	  end
    end.

reverse_repeated_fields(FieldList, Types) ->
    [begin
       case lists:keyfind(FNum, 1, Types) of
	 {FNum, Name, _Type, Opts} ->
	     case lists:member(repeated, Opts) of
	       true -> {FNum, Name, lists:reverse(Value)};
	       _ -> Field
	     end;
	 _ -> Field
       end
     end
     || {FNum, Name, Value} = Field <- FieldList].

unpack_value(Binary, string) when is_binary(Binary) ->
    binary_to_list(Binary);
unpack_value(Value, _) -> Value.

to_record(userdata, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       userdata),
						   Record, Name, Val)
			  end,
			  #userdata{}, DecodedTuples),
    Record1;
to_record(requestlogon, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       requestlogon),
						   Record, Name, Val)
			  end,
			  #requestlogon{}, DecodedTuples),
    Record1;
to_record(responselogon, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       responselogon),
						   Record, Name, Val)
			  end,
			  #responselogon{}, DecodedTuples),
    Record1;
to_record(logonsuccess, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       logonsuccess),
						   Record, Name, Val)
			  end,
			  #logonsuccess{}, DecodedTuples),
    Record1;
to_record(responsesession, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       responsesession),
						   Record, Name, Val)
			  end,
			  #responsesession{}, DecodedTuples),
    Record1;
to_record(sessionsuccess, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       sessionsuccess),
						   Record, Name, Val)
			  end,
			  #sessionsuccess{}, DecodedTuples),
    Record1;
to_record(router, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields, router),
						   Record, Name, Val)
			  end,
			  #router{}, DecodedTuples),
    Record1;
to_record(chat, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields, chat),
						   Record, Name, Val)
			  end,
			  #chat{}, DecodedTuples),
    Record1;
to_record(seekuser, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       seekuser),
						   Record, Name, Val)
			  end,
			  #seekuser{}, DecodedTuples),
    Record1;
to_record(responseseekuser, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       responseseekuser),
						   Record, Name, Val)
			  end,
			  #responseseekuser{}, DecodedTuples),
    Record1;
to_record(requestfriend, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       requestfriend),
						   Record, Name, Val)
			  end,
			  #requestfriend{}, DecodedTuples),
    Record1;
to_record(rsponserequestfriend, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       rsponserequestfriend),
						   Record, Name, Val)
			  end,
			  #rsponserequestfriend{}, DecodedTuples),
    Record1;
to_record(removefriend, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       removefriend),
						   Record, Name, Val)
			  end,
			  #removefriend{}, DecodedTuples),
    Record1;
to_record(responseremovefriend, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       responseremovefriend),
						   Record, Name, Val)
			  end,
			  #responseremovefriend{}, DecodedTuples),
    Record1;
to_record(personalchat, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       personalchat),
						   Record, Name, Val)
			  end,
			  #personalchat{}, DecodedTuples),
    Record1;
to_record(responsepersonalchat, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       responsepersonalchat),
						   Record, Name, Val)
			  end,
			  #responsepersonalchat{}, DecodedTuples),
    Record1;
to_record(creategroup, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       creategroup),
						   Record, Name, Val)
			  end,
			  #creategroup{}, DecodedTuples),
    Record1;
to_record(responsecreategroup, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       responsecreategroup),
						   Record, Name, Val)
			  end,
			  #responsecreategroup{}, DecodedTuples),
    Record1;
to_record(groupsession, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       groupsession),
						   Record, Name, Val)
			  end,
			  #groupsession{}, DecodedTuples),
    Record1;
to_record(groupchat, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       groupchat),
						   Record, Name, Val)
			  end,
			  #groupchat{}, DecodedTuples),
    Record1;
to_record(responsegroupchat, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       responsegroupchat),
						   Record, Name, Val)
			  end,
			  #responsegroupchat{}, DecodedTuples),
    Record1;
to_record(heartbeat, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       heartbeat),
						   Record, Name, Val)
			  end,
			  #heartbeat{}, DecodedTuples),
    Record1.

decode_extensions(Record) -> Record.

decode_extensions(_Types, [], Acc) ->
    dict:from_list(Acc);
decode_extensions(Types, [{FNum, Bytes} | Tail], Acc) ->
    NewAcc = case lists:keyfind(FNum, 1, Types) of
	       {FNum, Name, Type, Opts} ->
		   {Value1, Rest1} = case lists:member(is_record, Opts) of
				       true ->
					   {{FNum, V}, R} =
					       protobuffs:decode(Bytes, bytes),
					   RecVal = decode(Type, V),
					   {RecVal, R};
				       false ->
					   case lists:member(repeated_packed,
							     Opts)
					       of
					     true ->
						 {{FNum, V}, R} =
						     protobuffs:decode_packed(Bytes,
									      Type),
						 {V, R};
					     false ->
						 {{FNum, V}, R} =
						     protobuffs:decode(Bytes,
								       Type),
						 {unpack_value(V, Type), R}
					   end
				     end,
		   case lists:member(repeated, Opts) of
		     true ->
			 case lists:keytake(FNum, 1, Acc) of
			   {value, {FNum, Name, List}, Acc1} ->
			       decode(Rest1, Types,
				      [{FNum, Name,
					lists:reverse([int_to_enum(Type, Value1)
						       | lists:reverse(List)])}
				       | Acc1]);
			   false ->
			       decode(Rest1, Types,
				      [{FNum, Name, [int_to_enum(Type, Value1)]}
				       | Acc])
			 end;
		     false ->
			 [{FNum,
			   {optional, int_to_enum(Type, Value1), Type, Opts}}
			  | Acc]
		   end;
	       false -> [{FNum, Bytes} | Acc]
	     end,
    decode_extensions(Types, Tail, NewAcc).

set_record_field(Fields, Record, '$extensions',
		 Value) ->
    Decodable = [],
    NewValue = decode_extensions(element(1, Record),
				 Decodable, dict:to_list(Value)),
    Index = list_index('$extensions', Fields),
    erlang:setelement(Index + 1, Record, NewValue);
set_record_field(Fields, Record, Field, Value) ->
    Index = list_index(Field, Fields),
    erlang:setelement(Index + 1, Record, Value).

list_index(Target, List) -> list_index(Target, List, 1).

list_index(Target, [Target | _], Index) -> Index;
list_index(Target, [_ | Tail], Index) ->
    list_index(Target, Tail, Index + 1);
list_index(_, [], _) -> -1.

extension_size(_) -> 0.

has_extension(_Record, _FieldName) -> false.

get_extension(_Record, _FieldName) -> undefined.

set_extension(Record, _, _) -> {error, Record}.

