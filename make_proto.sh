#!/bin/sh
erl -pa ./ebin deps/protobuffs/ebin -noinput +B -eval "make_data:start(), init:stop()"
mv *.beam ./ebin
mv *.hrl ./include




