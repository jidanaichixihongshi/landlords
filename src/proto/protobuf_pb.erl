-file("src/protobuf_pb.erl", 1).

-module(protobuf_pb).

-export([encode_heartbeat/1, decode_heartbeat/1,
	 delimited_decode_heartbeat/1,
	 encode_responsegroupchat/1, decode_responsegroupchat/1,
	 delimited_decode_responsegroupchat/1,
	 encode_groupchat/1, decode_groupchat/1,
	 delimited_decode_groupchat/1,
	 encode_responsegrivatechat/1,
	 decode_responsegrivatechat/1,
	 delimited_decode_responsegrivatechat/1,
	 encode_grivatechat/1, decode_grivatechat/1,
	 delimited_decode_grivatechat/1,
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
	 encode_to/1, decode_to/1, delimited_decode_to/1,
	 encode_from/1, decode_from/1, delimited_decode_from/1,
	 encode_sessionsuccess/1, decode_sessionsuccess/1,
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
	{mt, mid, sig, timestamp, from, to, data}).

-record(groupchat,
	{mt, mid, sig, timestamp, from, to, data}).

-record(responsegrivatechat,
	{mt, mid, sig, timestamp, from, to, data}).

-record(grivatechat,
	{mt, mid, sig, timestamp, from, to, data}).

-record(responseremovefriend,
	{mt, mid, sig, timestamp, from, to, data}).

-record(removefriend,
	{mt, mid, sig, timestamp, from, to, data}).

-record(rsponserequestfriend,
	{mt, mid, sig, timestamp, from, to, data}).

-record(requestfriend,
	{mt, mid, sig, timestamp, from, to, data}).

-record(responseseekuser,
	{mt, mid, sig, timestamp, from, to, data}).

-record(seekuser,
	{mt, mid, sig, timestamp, from, to, data}).

-record(chat, {from, device, c}).

-record(to, {user, device, server}).

-record(from, {user, device, server}).

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

encode_responsegrivatechat(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_responsegrivatechat(Record)
    when is_record(Record, responsegrivatechat) ->
    encode(responsegrivatechat, Record).

encode_grivatechat(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_grivatechat(Record)
    when is_record(Record, grivatechat) ->
    encode(grivatechat, Record).

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

encode_to(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_to(Record) when is_record(Record, to) ->
    encode(to, Record).

encode_from(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_from(Record) when is_record(Record, from) ->
    encode(from, Record).

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
encode(from, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(from, Record) ->
    [iolist(from, Record) | encode_extensions(Record)];
encode(to, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(to, Record) ->
    [iolist(to, Record) | encode_extensions(Record)];
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
encode(grivatechat, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(grivatechat, Record) ->
    [iolist(grivatechat, Record)
     | encode_extensions(Record)];
encode(responsegrivatechat, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(responsegrivatechat, Record) ->
    [iolist(responsegrivatechat, Record)
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
iolist(from, Record) ->
    [pack(1, required, with_default(Record#from.user, none),
	  int32, []),
     pack(2, required,
	  with_default(Record#from.device, none), int32, []),
     pack(3, required,
	  with_default(Record#from.server, none), int32, [])];
iolist(to, Record) ->
    [pack(1, required, with_default(Record#to.user, none),
	  int32, []),
     pack(2, required, with_default(Record#to.device, none),
	  int32, []),
     pack(3, required, with_default(Record#to.server, none),
	  int32, [])];
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
	  with_default(Record#seekuser.from, none), from, []),
     pack(6, required,
	  with_default(Record#seekuser.to, none), to, []),
     pack(7, required,
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
	  with_default(Record#responseseekuser.from, none), from,
	  []),
     pack(6, required,
	  with_default(Record#responseseekuser.to, none), to, []),
     pack(7, required,
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
	  with_default(Record#requestfriend.from, none), from,
	  []),
     pack(6, required,
	  with_default(Record#requestfriend.to, none), to, []),
     pack(7, required,
	  with_default(Record#requestfriend.data, none), string,
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
	  with_default(Record#rsponserequestfriend.from, none),
	  from, []),
     pack(6, required,
	  with_default(Record#rsponserequestfriend.to, none), to,
	  []),
     pack(7, required,
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
	  with_default(Record#removefriend.from, none), from, []),
     pack(6, required,
	  with_default(Record#removefriend.to, none), to, []),
     pack(7, required,
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
	  with_default(Record#responseremovefriend.from, none),
	  from, []),
     pack(6, required,
	  with_default(Record#responseremovefriend.to, none), to,
	  []),
     pack(7, required,
	  with_default(Record#responseremovefriend.data, none),
	  string, [])];
iolist(grivatechat, Record) ->
    [pack(1, required,
	  with_default(Record#grivatechat.mt, none), int32, []),
     pack(2, required,
	  with_default(Record#grivatechat.mid, none), string, []),
     pack(3, required,
	  with_default(Record#grivatechat.sig, none), int32, []),
     pack(4, required,
	  with_default(Record#grivatechat.timestamp, none), int64,
	  []),
     pack(5, required,
	  with_default(Record#grivatechat.from, none), from, []),
     pack(6, required,
	  with_default(Record#grivatechat.to, none), to, []),
     pack(7, required,
	  with_default(Record#grivatechat.data, none), chat, [])];
iolist(responsegrivatechat, Record) ->
    [pack(1, required,
	  with_default(Record#responsegrivatechat.mt, none),
	  int32, []),
     pack(2, required,
	  with_default(Record#responsegrivatechat.mid, none),
	  string, []),
     pack(3, required,
	  with_default(Record#responsegrivatechat.sig, none),
	  int32, []),
     pack(4, required,
	  with_default(Record#responsegrivatechat.timestamp,
		       none),
	  int64, []),
     pack(5, required,
	  with_default(Record#responsegrivatechat.from, none),
	  from, []),
     pack(6, required,
	  with_default(Record#responsegrivatechat.to, none), to,
	  []),
     pack(7, required,
	  with_default(Record#responsegrivatechat.data, none),
	  int32, [])];
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
	  with_default(Record#groupchat.from, none), from, []),
     pack(6, required,
	  with_default(Record#groupchat.to, none), to, []),
     pack(7, required,
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
	  with_default(Record#responsegroupchat.from, none), from,
	  []),
     pack(6, required,
	  with_default(Record#responsegroupchat.to, none), to,
	  []),
     pack(7, required,
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

decode_responsegrivatechat(Bytes)
    when is_binary(Bytes) ->
    decode(responsegrivatechat, Bytes).

decode_grivatechat(Bytes) when is_binary(Bytes) ->
    decode(grivatechat, Bytes).

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

decode_to(Bytes) when is_binary(Bytes) ->
    decode(to, Bytes).

decode_from(Bytes) when is_binary(Bytes) ->
    decode(from, Bytes).

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

delimited_decode_from(Bytes) ->
    delimited_decode(from, Bytes).

delimited_decode_to(Bytes) ->
    delimited_decode(to, Bytes).

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

delimited_decode_grivatechat(Bytes) ->
    delimited_decode(grivatechat, Bytes).

delimited_decode_responsegrivatechat(Bytes) ->
    delimited_decode(responsegrivatechat, Bytes).

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
decode(from, Bytes) when is_binary(Bytes) ->
    Types = [{3, server, int32, []}, {2, device, int32, []},
	     {1, user, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(from, Decoded);
decode(to, Bytes) when is_binary(Bytes) ->
    Types = [{3, server, int32, []}, {2, device, int32, []},
	     {1, user, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(to, Decoded);
decode(chat, Bytes) when is_binary(Bytes) ->
    Types = [{3, c, string, []}, {2, device, int32, []},
	     {1, from, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(chat, Decoded);
decode(seekuser, Bytes) when is_binary(Bytes) ->
    Types = [{7, data, string, []},
	     {6, to, to, [is_record]}, {5, from, from, [is_record]},
	     {4, timestamp, int64, []}, {3, sig, int32, []},
	     {2, mid, string, []}, {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(seekuser, Decoded);
decode(responseseekuser, Bytes) when is_binary(Bytes) ->
    Types = [{7, data, bytes, []}, {6, to, to, [is_record]},
	     {5, from, from, [is_record]}, {4, timestamp, int64, []},
	     {3, sig, int32, []}, {2, mid, string, []},
	     {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(responseseekuser, Decoded);
decode(requestfriend, Bytes) when is_binary(Bytes) ->
    Types = [{7, data, string, []},
	     {6, to, to, [is_record]}, {5, from, from, [is_record]},
	     {4, timestamp, int64, []}, {3, sig, int32, []},
	     {2, mid, string, []}, {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(requestfriend, Decoded);
decode(rsponserequestfriend, Bytes)
    when is_binary(Bytes) ->
    Types = [{7, data, string, []},
	     {6, to, to, [is_record]}, {5, from, from, [is_record]},
	     {4, timestamp, int64, []}, {3, sig, int32, []},
	     {2, mid, string, []}, {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(rsponserequestfriend, Decoded);
decode(removefriend, Bytes) when is_binary(Bytes) ->
    Types = [{7, data, bytes, []}, {6, to, to, [is_record]},
	     {5, from, from, [is_record]}, {4, timestamp, int64, []},
	     {3, sig, int32, []}, {2, mid, string, []},
	     {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(removefriend, Decoded);
decode(responseremovefriend, Bytes)
    when is_binary(Bytes) ->
    Types = [{7, data, string, []},
	     {6, to, to, [is_record]}, {5, from, from, [is_record]},
	     {4, timestamp, int64, []}, {3, sig, int32, []},
	     {2, mid, string, []}, {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(responseremovefriend, Decoded);
decode(grivatechat, Bytes) when is_binary(Bytes) ->
    Types = [{7, data, chat, [is_record]},
	     {6, to, to, [is_record]}, {5, from, from, [is_record]},
	     {4, timestamp, int64, []}, {3, sig, int32, []},
	     {2, mid, string, []}, {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(grivatechat, Decoded);
decode(responsegrivatechat, Bytes)
    when is_binary(Bytes) ->
    Types = [{7, data, int32, []}, {6, to, to, [is_record]},
	     {5, from, from, [is_record]}, {4, timestamp, int64, []},
	     {3, sig, int32, []}, {2, mid, string, []},
	     {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(responsegrivatechat, Decoded);
decode(groupchat, Bytes) when is_binary(Bytes) ->
    Types = [{7, data, chat, [is_record]},
	     {6, to, to, [is_record]}, {5, from, from, [is_record]},
	     {4, timestamp, int64, []}, {3, sig, int32, []},
	     {2, mid, string, []}, {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(groupchat, Decoded);
decode(responsegroupchat, Bytes)
    when is_binary(Bytes) ->
    Types = [{7, data, int32, []}, {6, to, to, [is_record]},
	     {5, from, from, [is_record]}, {4, timestamp, int64, []},
	     {3, sig, int32, []}, {2, mid, string, []},
	     {1, mt, int32, []}],
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
to_record(from, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields, from),
						   Record, Name, Val)
			  end,
			  #from{}, DecodedTuples),
    Record1;
to_record(to, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields, to),
						   Record, Name, Val)
			  end,
			  #to{}, DecodedTuples),
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
to_record(grivatechat, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       grivatechat),
						   Record, Name, Val)
			  end,
			  #grivatechat{}, DecodedTuples),
    Record1;
to_record(responsegrivatechat, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       responsegrivatechat),
						   Record, Name, Val)
			  end,
			  #responsegrivatechat{}, DecodedTuples),
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

