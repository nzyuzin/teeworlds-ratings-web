#!/usr/bin/env bash

bundle exec ruby rctf.rb &> /dev/null &
echo $! > ./tools/server_pid
