#!/usr/bin/env bash

ruby rctf.rb &> /dev/null &
echo $! > ./tools/server_pid
