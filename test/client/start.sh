#!/bin/bash

localip=`/sbin/ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'` \
NODE="landlords_client"
NODENAME="$NODE@$localip"

erl -pa ebin deps/*/ebin\
		-config config/sys.config \
		-name $NODENAME \
		-setcookie landlords_client \
		-s landlords_client

