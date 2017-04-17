#!/usr/bin/env bash

bundle exec rackup &> /dev/null &
echo $! > ./tools/server_pid
