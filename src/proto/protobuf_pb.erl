-file("src/protobuf_pb.erl", 1).

-module(protobuf_pb).

-export([encode_request/1, decode_request/1,
	 delimited_decode_request/1, encode_chat/1,
	 decode_chat/1, delimited_decode_chat/1, encode_router/1,
	 decode_router/1, delimited_decode_router/1,
	 encode_data/1, decode_data/1, delimited_decode_data/1,
	 encode_proto/1, decode_proto/1,
	 delimited_decode_proto/1]).

-export([has_extension/2, extension_size/1,
	 get_extension/2, set_extension/3]).

-export([decode_extensions/1]).

-export([encode/1, decode/2, delimited_decode/2]).

-export([int_to_enum/2, enum_to_int/2]).

-record(request, {from, device, rt, rm, extend}).

-record(chat, {from, device, ct, c}).

-record(router,
	{from, fdevice, fserver, to, tdevice, tserver}).

-record(data, {dt, mid, children, extend}).

-record(proto, {mt, sig, router, data, ts}).

-dialyzer(no_match).

encode([]) -> [];
encode(Records) when is_list(Records) ->
    delimited_encode(Records);
encode(Record) -> encode(element(1, Record), Record).

encode_request(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_request(Record)
    when is_record(Record, request) ->
    encode(request, Record).

encode_chat(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_chat(Record) when is_record(Record, chat) ->
    encode(chat, Record).

encode_router(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_router(Record) when is_record(Record, router) ->
    encode(router, Record).

encode_data(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_data(Record) when is_record(Record, data) ->
    encode(data, Record).

encode_proto(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_proto(Record) when is_record(Record, proto) ->
    encode(proto, Record).

encode(proto, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(proto, Record) ->
    [iolist(proto, Record) | encode_extensions(Record)];
encode(data, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(data, Record) ->
    [iolist(data, Record) | encode_extensions(Record)];
encode(router, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(router, Record) ->
    [iolist(router, Record) | encode_extensions(Record)];
encode(chat, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(chat, Record) ->
    [iolist(chat, Record) | encode_extensions(Record)];
encode(request, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(request, Record) ->
    [iolist(request, Record) | encode_extensions(Record)].

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
     pack(2, required, with_default(Record#proto.sig, none),
	  int32, []),
     pack(3, required,
	  with_default(Record#proto.router, none), router, []),
     pack(4, optional, with_default(Record#proto.data, none),
	  bytes, []),
     pack(5, required, with_default(Record#proto.ts, none),
	  int64, [])];
iolist(data, Record) ->
    [pack(1, required, with_default(Record#data.dt, none),
	  int32, []),
     pack(2, required, with_default(Record#data.mid, none),
	  string, []),
     pack(3, required,
	  with_default(Record#data.children, none), bytes, []),
     pack(4, optional,
	  with_default(Record#data.extend, none), bytes, [])];
iolist(router, Record) ->
    [pack(1, required,
	  with_default(Record#router.from, none), bytes, []),
     pack(2, optional,
	  with_default(Record#router.fdevice, none), bytes, []),
     pack(3, optional,
	  with_default(Record#router.fserver, none), bytes, []),
     pack(4, optional, with_default(Record#router.to, none),
	  bytes, []),
     pack(5, optional,
	  with_default(Record#router.tdevice, none), bytes, []),
     pack(6, optional,
	  with_default(Record#router.tserver, none), bytes, [])];
iolist(chat, Record) ->
    [pack(1, required, with_default(Record#chat.from, none),
	  bytes, []),
     pack(2, required,
	  with_default(Record#chat.device, none), bytes, []),
     pack(3, required, with_default(Record#chat.ct, none),
	  bytes, []),
     pack(4, required, with_default(Record#chat.c, none),
	  bytes, [])];
iolist(request, Record) ->
    [pack(1, required,
	  with_default(Record#request.from, none), bytes, []),
     pack(2, required,
	  with_default(Record#request.device, none), bytes, []),
     pack(3, required, with_default(Record#request.rt, none),
	  bytes, []),
     pack(4, required, with_default(Record#request.rm, none),
	  bytes, []),
     pack(5, optional,
	  with_default(Record#request.extend, none), bytes, [])].

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

decode_request(Bytes) when is_binary(Bytes) ->
    decode(request, Bytes).

decode_chat(Bytes) when is_binary(Bytes) ->
    decode(chat, Bytes).

decode_router(Bytes) when is_binary(Bytes) ->
    decode(router, Bytes).

decode_data(Bytes) when is_binary(Bytes) ->
    decode(data, Bytes).

decode_proto(Bytes) when is_binary(Bytes) ->
    decode(proto, Bytes).

delimited_decode_proto(Bytes) ->
    delimited_decode(proto, Bytes).

delimited_decode_data(Bytes) ->
    delimited_decode(data, Bytes).

delimited_decode_router(Bytes) ->
    delimited_decode(router, Bytes).

delimited_decode_chat(Bytes) ->
    delimited_decode(chat, Bytes).

delimited_decode_request(Bytes) ->
    delimited_decode(request, Bytes).

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
    Types = [{5, ts, int64, []}, {4, data, bytes, []},
	     {3, router, router, [is_record]}, {2, sig, int32, []},
	     {1, mt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(proto, Decoded);
decode(data, Bytes) when is_binary(Bytes) ->
    Types = [{4, extend, bytes, []},
	     {3, children, bytes, []}, {2, mid, string, []},
	     {1, dt, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(data, Decoded);
decode(router, Bytes) when is_binary(Bytes) ->
    Types = [{6, tserver, bytes, []},
	     {5, tdevice, bytes, []}, {4, to, bytes, []},
	     {3, fserver, bytes, []}, {2, fdevice, bytes, []},
	     {1, from, bytes, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(router, Decoded);
decode(chat, Bytes) when is_binary(Bytes) ->
    Types = [{4, c, bytes, []}, {3, ct, bytes, []},
	     {2, device, bytes, []}, {1, from, bytes, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(chat, Decoded);
decode(request, Bytes) when is_binary(Bytes) ->
    Types = [{5, extend, bytes, []}, {4, rm, bytes, []},
	     {3, rt, bytes, []}, {2, device, bytes, []},
	     {1, from, bytes, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(request, Decoded).

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
to_record(data, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields, data),
						   Record, Name, Val)
			  end,
			  #data{}, DecodedTuples),
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
to_record(request, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields, request),
						   Record, Name, Val)
			  end,
			  #request{}, DecodedTuples),
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

