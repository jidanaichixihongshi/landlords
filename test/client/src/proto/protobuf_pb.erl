-file("src/protobuf_pb.erl", 1).

-module(protobuf_pb).

-export([encode_heartbeat/1, decode_heartbeat/1,
	delimited_decode_heartbeat/1, encode_logonrequest/1,
	decode_logonrequest/1, delimited_decode_logonrequest/1,
	encode_userdata/1, decode_userdata/1,
	delimited_decode_userdata/1]).

-export([has_extension/2, extension_size/1,
	get_extension/2, set_extension/3]).

-export([decode_extensions/1]).

-export([encode/1, decode/2, delimited_decode/2]).

-export([int_to_enum/2, enum_to_int/2]).

-record(heartbeat, {mt, mid}).

-record(logonrequest, {mt, mid, data}).

-record(userdata,
{username, phone, token, device_type, device_id,
	version, app_id, timestamp}).

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

encode_logonrequest(Records) when is_list(Records) ->
	delimited_encode(Records);
encode_logonrequest(Record)
	when is_record(Record, logonrequest) ->
	encode(logonrequest, Record).

encode_userdata(Records) when is_list(Records) ->
	delimited_encode(Records);
encode_userdata(Record)
	when is_record(Record, userdata) ->
	encode(userdata, Record).

encode(userdata, Records) when is_list(Records) ->
	delimited_encode(Records);
encode(userdata, Record) ->
	[iolist(userdata, Record) | encode_extensions(Record)];
encode(logonrequest, Records) when is_list(Records) ->
	delimited_encode(Records);
encode(logonrequest, Record) ->
	[iolist(logonrequest, Record)
		| encode_extensions(Record)];
encode(heartbeat, Records) when is_list(Records) ->
	delimited_encode(Records);
encode(heartbeat, Record) ->
	[iolist(heartbeat, Record) | encode_extensions(Record)].

encode_extensions(_) -> [].

delimited_encode(Records) ->
	lists:map(fun(Record) ->
		IoRec = encode(Record),
		Size = iolist_size(IoRec),
		[protobuffs:encode_varint(Size), IoRec]
						end,
		Records).

iolist(userdata, Record) ->
	[pack(1, required,
		with_default(Record#userdata.username, none), string,
		[]),
		pack(2, required,
			with_default(Record#userdata.phone, none), int64, []),
		pack(3, required,
			with_default(Record#userdata.token, none), string, []),
		pack(4, required,
			with_default(Record#userdata.device_type, none), int32,
			[]),
		pack(5, required,
			with_default(Record#userdata.device_id, none), int32,
			[]),
		pack(6, required,
			with_default(Record#userdata.version, none), string,
			[]),
		pack(7, required,
			with_default(Record#userdata.app_id, none), string, []),
		pack(8, required,
			with_default(Record#userdata.timestamp, none), int64,
			[])];
iolist(logonrequest, Record) ->
	[pack(1, required,
		with_default(Record#logonrequest.mt, none), int32, []),
		pack(2, required,
			with_default(Record#logonrequest.mid, none), int32, []),
		pack(3, repeated,
			with_default(Record#logonrequest.data, none), userdata,
			[])];
iolist(heartbeat, Record) ->
	[pack(1, required,
		with_default(Record#heartbeat.mt, none), int32, []),
		pack(2, required,
			with_default(Record#heartbeat.mid, none), int32, [])].

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

decode_logonrequest(Bytes) when is_binary(Bytes) ->
	decode(logonrequest, Bytes).

decode_userdata(Bytes) when is_binary(Bytes) ->
	decode(userdata, Bytes).

delimited_decode_userdata(Bytes) ->
	delimited_decode(userdata, Bytes).

delimited_decode_logonrequest(Bytes) ->
	delimited_decode(logonrequest, Bytes).

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
	Types = [{8, timestamp, int64, []},
		{7, app_id, string, []}, {6, version, string, []},
		{5, device_id, int32, []}, {4, device_type, int32, []},
		{3, token, string, []}, {2, phone, int64, []},
		{1, username, string, []}],
	Defaults = [],
	Decoded = decode(Bytes, Types, Defaults),
	to_record(userdata, Decoded);
decode(logonrequest, Bytes) when is_binary(Bytes) ->
	Types = [{3, data, userdata, [is_record, repeated]},
		{2, mid, int32, []}, {1, mt, int32, []}],
	Defaults = [{3, data, []}],
	Decoded = decode(Bytes, Types, Defaults),
	to_record(logonrequest, Decoded);
decode(heartbeat, Bytes) when is_binary(Bytes) ->
	Types = [{2, mid, int32, []}, {1, mt, int32, []}],
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
	Record1 = lists:foldr(fun({_FNum, Name, Val},
		Record) ->
		set_record_field(record_info(fields,
			userdata),
			Record, Name, Val)
												end,
		#userdata{}, DecodedTuples),
	Record1;
to_record(logonrequest, DecodedTuples) ->
	Record1 = lists:foldr(fun({_FNum, Name, Val},
		Record) ->
		set_record_field(record_info(fields,
			logonrequest),
			Record, Name, Val)
												end,
		#logonrequest{}, DecodedTuples),
	Record1;
to_record(heartbeat, DecodedTuples) ->
	Record1 = lists:foldr(fun({_FNum, Name, Val},
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

