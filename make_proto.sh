#!/bin/sh
erl -pa ./ebin deps/protobuffs/ebin -noinput +B -eval "make_data:start(), init:stop()"
mv *.erl ./src/proto
mv *.hrl ./include




