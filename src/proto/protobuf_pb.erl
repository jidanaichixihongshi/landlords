-file("src/protobuf_pb.erl", 1).

-module(protobuf_pb).

-export([encode_roomresearch/1, decode_roomresearch/1,
	 delimited_decode_roomresearch/1, encode_roomsession/1,
	 decode_roomsession/1, delimited_decode_roomsession/1,
	 encode_groupresearch/1, decode_groupresearch/1,
	 delimited_decode_groupresearch/1, encode_groupsession/1,
	 decode_groupsession/1, delimited_decode_groupsession/1,
	 encode_personresearch/1, decode_personresearch/1,
	 delimited_decode_personresearch/1,
	 encode_personsession/1, decode_personsession/1,
	 delimited_decode_personsession/1, encode_category/1,
	 decode_category/1, delimited_decode_category/1,
	 encode_logonparameter/1, decode_logonparameter/1,
	 delimited_decode_logonparameter/1, encode_chat/1,
	 decode_chat/1, delimited_decode_chat/1, encode_router/1,
	 decode_router/1, delimited_decode_router/1,
	 encode_proto/1, decode_proto/1,
	 delimited_decode_proto/1]).

-export([has_extension/2, extension_size/1,
	 get_extension/2, set_extension/3]).

-export([decode_extensions/1]).

-export([encode/1, decode/2, delimited_decode/2]).

-export([int_to_enum/2, enum_to_int/2]).

-record(roomresearch,
	{rid, type, creator, numbers, extend}).

-record(roomsession,
	{rid, type, setting, creator, numbers, extend}).

-record(groupresearch,
	{gid, gnickname, gportrait, announcement, extend}).

-record(groupsession,
	{gid, gnickname, gportrait, setting, admin, numbers,
	 announcement, extend}).

-record(personresearch,
	{uid, nickname, portrait, personlabel, extend}).

-record(personsession,
	{uid, nickname, portrait, personlabel, setting, rosters,
	 groups, serverparameter, extend}).

-record(category, {name, members}).

-record(logonparameter,
	{uid, nickname, phone, token, device, device_id,
	 version, app_id, extend}).

-record(chat, {from, device, c}).

-record(router,
	{from, from_device, from_server, to, to_device,
	 to_server}).

-record(proto, {mt, mid, sig, router, data, timestamp}).

-dialyzer(no_match).

encode([]) -> [];
encode(Records) when is_list(Records) ->
    delimited_encode(Records);
encode(Record) -> encode(element(1, Record), Record).

encode_roomresearch(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_roomresearch(Record)
    when is_record(Record, roomresearch) ->
    encode(roomresearch, Record).

encode_roomsession(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_roomsession(Record)
    when is_record(Record, roomsession) ->
    encode(roomsession, Record).

encode_groupresearch(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_groupresearch(Record)
    when is_record(Record, groupresearch) ->
    encode(groupresearch, Record).

encode_groupsession(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_groupsession(Record)
    when is_record(Record, groupsession) ->
    encode(groupsession, Record).

encode_personresearch(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_personresearch(Record)
    when is_record(Record, personresearch) ->
    encode(personresearch, Record).

encode_personsession(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_personsession(Record)
    when is_record(Record, personsession) ->
    encode(personsession, Record).

encode_category(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_category(Record)
    when is_record(Record, category) ->
    encode(category, Record).

encode_logonparameter(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_logonparameter(Record)
    when is_record(Record, logonparameter) ->
    encode(logonparameter, Record).

encode_chat(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_chat(Record) when is_record(Record, chat) ->
    encode(chat, Record).

encode_router(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_router(Record) when is_record(Record, router) ->
    encode(router, Record).

encode_proto(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_proto(Record) when is_record(Record, proto) ->
    encode(proto, Record).

encode(proto, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(proto, Record) ->
    [iolist(proto, Record) | encode_extensions(Record)];
encode(router, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(router, Record) ->
    [iolist(router, Record) | encode_extensions(Record)];
encode(chat, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(chat, Record) ->
    [iolist(chat, Record) | encode_extensions(Record)];
encode(logonparameter, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(logonparameter, Record) ->
    [iolist(logonparameter, Record)
     | encode_extensions(Record)];
encode(category, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(category, Record) ->
    [iolist(category, Record) | encode_extensions(Record)];
encode(personsession, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(personsession, Record) ->
    [iolist(personsession, Record)
     | encode_extensions(Record)];
encode(personresearch, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(personresearch, Record) ->
    [iolist(personresearch, Record)
     | encode_extensions(Record)];
encode(groupsession, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(groupsession, Record) ->
    [iolist(groupsession, Record)
     | encode_extensions(Record)];
encode(groupresearch, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(groupresearch, Record) ->
    [iolist(groupresearch, Record)
     | encode_extensions(Record)];
encode(roomsession, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(roomsession, Record) ->
    [iolist(roomsession, Record)
     | encode_extensions(Record)];
encode(roomresearch, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(roomresearch, Record) ->
    [iolist(roomresearch, Record)
     | encode_extensions(Record)].

encode_extensions(_) -> [].

delimited_encode(Records) ->
    lists:map(fun (Record) ->
		      IoRec = encode(Record),
		      Size = iolist_size(IoRec),
		      [protobuffs:encode_varint(Size), IoRec]
	      end,
	      Records).

iolist(proto, Record) ->
    [pack(1, required, with_default(Record#proto.mt, none),
	  int32, []),
     pack(2, required, with_default(Record#proto.mid, none),
	  string, []),
     pack(3, required, with_default(Record#proto.sig, none),
	  int32, []),
     pack(4, required,
	  with_default(Record#proto.router, none), router, []),
     pack(5, optional, with_default(Record#proto.data, none),
	  bytes, []),
     pack(6, required,
	  with_default(Record#proto.timestamp, none), int64, [])];
iolist(router, Record) ->
    [pack(1, required,
	  with_default(Record#router.from, none), bytes, []),
     pack(2, optional,
	  with_default(Record#router.from_device, none), bytes,
	  []),
     pack(3, optional,
	  with_default(Record#router.from_server, none), bytes,
	  []),
     pack(4, optional, with_default(Record#router.to, none),
	  bytes, []),
     pack(5, optional,
	  with_default(Record#router.to_device, none), bytes, []),
     pack(6, optional,
	  with_default(Record#router.to_server, none), bytes,
	  [])];
iolist(chat, Record) ->
    [pack(1, required, with_default(Record#chat.from, none),
	  bytes, []),
     pack(2, required,
	  with_default(Record#chat.device, none), bytes, []),
     pack(3, required, with_default(Record#chat.c, none),
	  bytes, [])];
iolist(logonparameter, Record) ->
    [pack(1, optional,
	  with_default(Record#logonparameter.uid, none), int32,
	  []),
     pack(2, optional,
	  with_default(Record#logonparameter.nickname, none),
	  bytes, []),
     pack(3, optional,
	  with_default(Record#logonparameter.phone, none), bytes,
	  []),
     pack(4, required,
	  with_default(Record#logonparameter.token, none), bytes,
	  []),
     pack(5, required,
	  with_default(Record#logonparameter.device, none), int32,
	  []),
     pack(6, optional,
	  with_default(Record#logonparameter.device_id, none),
	  bytes, []),
     pack(7, optional,
	  with_default(Record#logonparameter.version, none),
	  bytes, []),
     pack(8, optional,
	  with_default(Record#logonparameter.app_id, none), bytes,
	  []),
     pack(9, optional,
	  with_default(Record#logonparameter.extend, none), bytes,
	  [])];
iolist(category, Record) ->
    [pack(1, required,
	  with_default(Record#category.name, none), bytes, []),
     pack(2, optional,
	  with_default(Record#category.members, none), bytes,
	  [])];
iolist(personsession, Record) ->
    [pack(1, required,
	  with_default(Record#personsession.uid, none), int32,
	  []),
     pack(2, required,
	  with_default(Record#personsession.nickname, none),
	  bytes, []),
     pack(3, required,
	  with_default(Record#personsession.portrait, none),
	  bytes, []),
     pack(4, required,
	  with_default(Record#personsession.personlabel, none),
	  bytes, []),
     pack(5, optional,
	  with_default(Record#personsession.setting, none), bytes,
	  []),
     pack(6, optional,
	  with_default(Record#personsession.rosters, none), bytes,
	  []),
     pack(7, optional,
	  with_default(Record#personsession.groups, none), bytes,
	  []),
     pack(8, required,
	  with_default(Record#personsession.serverparameter,
		       none),
	  bytes, []),
     pack(9, optional,
	  with_default(Record#personsession.extend, none), bytes,
	  [])];
iolist(personresearch, Record) ->
    [pack(1, required,
	  with_default(Record#personresearch.uid, none), int32,
	  []),
     pack(2, required,
	  with_default(Record#personresearch.nickname, none),
	  bytes, []),
     pack(3, required,
	  with_default(Record#personresearch.portrait, none),
	  bytes, []),
     pack(4, required,
	  with_default(Record#personresearch.personlabel, none),
	  bytes, []),
     pack(5, optional,
	  with_default(Record#personresearch.extend, none), bytes,
	  [])];
iolist(groupsession, Record) ->
    [pack(1, required,
	  with_default(Record#groupsession.gid, none), int32, []),
     pack(2, required,
	  with_default(Record#groupsession.gnickname, none),
	  bytes, []),
     pack(3, required,
	  with_default(Record#groupsession.gportrait, none),
	  bytes, []),
     pack(4, required,
	  with_default(Record#groupsession.setting, none), bytes,
	  []),
     pack(5, required,
	  with_default(Record#groupsession.admin, none), bytes,
	  []),
     pack(6, required,
	  with_default(Record#groupsession.numbers, none), bytes,
	  []),
     pack(7, required,
	  with_default(Record#groupsession.announcement, none),
	  bytes, []),
     pack(8, optional,
	  with_default(Record#groupsession.extend, none), bytes,
	  [])];
iolist(groupresearch, Record) ->
    [pack(1, required,
	  with_default(Record#groupresearch.gid, none), int32,
	  []),
     pack(2, required,
	  with_default(Record#groupresearch.gnickname, none),
	  bytes, []),
     pack(3, required,
	  with_default(Record#groupresearch.gportrait, none),
	  bytes, []),
     pack(4, required,
	  with_default(Record#groupresearch.announcement, none),
	  bytes, []),
     pack(5, optional,
	  with_default(Record#groupresearch.extend, none), bytes,
	  [])];
iolist(roomsession, Record) ->
    [pack(1, required,
	  with_default(Record#roomsession.rid, none), int32, []),
     pack(2, required,
	  with_default(Record#roomsession.type, none), bytes, []),
     pack(3, required,
	  with_default(Record#roomsession.setting, none), bytes,
	  []),
     pack(4, required,
	  with_default(Record#roomsession.creator, none), int32,
	  []),
     pack(5, required,
	  with_default(Record#roomsession.numbers, none), bytes,
	  []),
     pack(6, optional,
	  with_default(Record#roomsession.extend, none), bytes,
	  [])];
iolist(roomresearch, Record) ->
    [pack(1, required,
	  with_default(Record#roomresearch.rid, none), int32, []),
     pack(2, required,
	  with_default(Record#roomresearch.type, none), bytes,
	  []),
     pack(3, required,
	  with_default(Record#roomresearch.creator, none), int32,
	  []),
     pack(4, required,
	  with_default(Record#roomresearch.numbers, none), bytes,
	  []),
     pack(5, optional,
	  with_default(Record#roomresearch.extend, none), bytes,
	  [])].

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

decode_roomresearch(Bytes) when is_binary(Bytes) ->
    decode(roomresearch, Bytes).

decode_roomsession(Bytes) when is_binary(Bytes) ->
    decode(roomsession, Bytes).

decode_groupresearch(Bytes) when is_binary(Bytes) ->
    decode(groupresearch, Bytes).

decode_groupsession(Bytes) when is_binary(Bytes) ->
    decode(groupsession, Bytes).

decode_personresearch(Bytes) when is_binary(Bytes) ->
    decode(personresearch, Bytes).

decode_personsession(Bytes) when is_binary(Bytes) ->
    decode(personsession, Bytes).

decode_category(Bytes) when is_binary(Bytes) ->
    decode(category, Bytes).

decode_logonparameter(Bytes) when is_binary(Bytes) ->
    decode(logonparameter, Bytes).

decode_chat(Bytes) when is_binary(Bytes) ->
    decode(chat, Bytes).

decode_router(Bytes) when is_binary(Bytes) ->
    decode(router, Bytes).

decode_proto(Bytes) when is_binary(Bytes) ->
    decode(proto, Bytes).

delimited_decode_proto(Bytes) ->
    delimited_decode(proto, Bytes).

delimited_decode_router(Bytes) ->
    delimited_decode(router, Bytes).

delimited_decode_chat(Bytes) ->
    delimited_decode(chat, Bytes).

delimited_decode_logonparameter(Bytes) ->
    delimited_decode(logonparameter, Bytes).

delimited_decode_category(Bytes) ->
    delimited_decode(category, Bytes).

delimited_decode_personsession(Bytes) ->
    delimited_decode(personsession, Bytes).

delimited_decode_personresearch(Bytes) ->
    delimited_decode(personresearch, Bytes).

delimited_decode_groupsession(Bytes) ->
    delimited_decode(groupsession, Bytes).

delimited_decode_groupresearch(Bytes) ->
    delimited_decode(groupresearch, Bytes).

delimited_decode_roomsession(Bytes) ->
    delimited_decode(roomsession, Bytes).

delimited_decode_roomresearch(Bytes) ->
    delimited_decode(roomresearch, Bytes).

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
decode(proto, Bytes) when is_binary(Bytes) ->
    Types = [{6, timestamp, int64, []},
	     {5, data, bytes, []}, {4, router, router, [is_record]},
	     {3, sig, int32, []}, {2, mid, string, []},
	     {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(proto, Decoded);
decode(router, Bytes) when is_binary(Bytes) ->
    Types = [{6, to_server, bytes, []},
	     {5, to_device, bytes, []}, {4, to, bytes, []},
	     {3, from_server, bytes, []},
	     {2, from_device, bytes, []}, {1, from, bytes, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(router, Decoded);
decode(chat, Bytes) when is_binary(Bytes) ->
    Types = [{3, c, bytes, []}, {2, device, bytes, []},
	     {1, from, bytes, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(chat, Decoded);
decode(logonparameter, Bytes) when is_binary(Bytes) ->
    Types = [{9, extend, bytes, []}, {8, app_id, bytes, []},
	     {7, version, bytes, []}, {6, device_id, bytes, []},
	     {5, device, int32, []}, {4, token, bytes, []},
	     {3, phone, bytes, []}, {2, nickname, bytes, []},
	     {1, uid, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(logonparameter, Decoded);
decode(category, Bytes) when is_binary(Bytes) ->
    Types = [{2, members, bytes, []}, {1, name, bytes, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(category, Decoded);
decode(personsession, Bytes) when is_binary(Bytes) ->
    Types = [{9, extend, bytes, []},
	     {8, serverparameter, bytes, []}, {7, groups, bytes, []},
	     {6, rosters, bytes, []}, {5, setting, bytes, []},
	     {4, personlabel, bytes, []}, {3, portrait, bytes, []},
	     {2, nickname, bytes, []}, {1, uid, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(personsession, Decoded);
decode(personresearch, Bytes) when is_binary(Bytes) ->
    Types = [{5, extend, bytes, []},
	     {4, personlabel, bytes, []}, {3, portrait, bytes, []},
	     {2, nickname, bytes, []}, {1, uid, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(personresearch, Decoded);
decode(groupsession, Bytes) when is_binary(Bytes) ->
    Types = [{8, extend, bytes, []},
	     {7, announcement, bytes, []}, {6, numbers, bytes, []},
	     {5, admin, bytes, []}, {4, setting, bytes, []},
	     {3, gportrait, bytes, []}, {2, gnickname, bytes, []},
	     {1, gid, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(groupsession, Decoded);
decode(groupresearch, Bytes) when is_binary(Bytes) ->
    Types = [{5, extend, bytes, []},
	     {4, announcement, bytes, []}, {3, gportrait, bytes, []},
	     {2, gnickname, bytes, []}, {1, gid, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(groupresearch, Decoded);
decode(roomsession, Bytes) when is_binary(Bytes) ->
    Types = [{6, extend, bytes, []},
	     {5, numbers, bytes, []}, {4, creator, int32, []},
	     {3, setting, bytes, []}, {2, type, bytes, []},
	     {1, rid, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(roomsession, Decoded);
decode(roomresearch, Bytes) when is_binary(Bytes) ->
    Types = [{5, extend, bytes, []},
	     {4, numbers, bytes, []}, {3, creator, int32, []},
	     {2, type, bytes, []}, {1, rid, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(roomresearch, Decoded).

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

to_record(proto, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields, proto),
						   Record, Name, Val)
			  end,
			  #proto{}, DecodedTuples),
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
to_record(logonparameter, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       logonparameter),
						   Record, Name, Val)
			  end,
			  #logonparameter{}, DecodedTuples),
    Record1;
to_record(category, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       category),
						   Record, Name, Val)
			  end,
			  #category{}, DecodedTuples),
    Record1;
to_record(personsession, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       personsession),
						   Record, Name, Val)
			  end,
			  #personsession{}, DecodedTuples),
    Record1;
to_record(personresearch, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       personresearch),
						   Record, Name, Val)
			  end,
			  #personresearch{}, DecodedTuples),
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
to_record(groupresearch, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       groupresearch),
						   Record, Name, Val)
			  end,
			  #groupresearch{}, DecodedTuples),
    Record1;
to_record(roomsession, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       roomsession),
						   Record, Name, Val)
			  end,
			  #roomsession{}, DecodedTuples),
    Record1;
to_record(roomresearch, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       roomresearch),
						   Record, Name, Val)
			  end,
			  #roomresearch{}, DecodedTuples),
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

