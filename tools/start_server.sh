#!/usr/bin/env bash

if [ ! -e ./tools/server_pid ]; then
  bundle exec rackup -P ./tools/server_pid -o 0.0.0.0 &> /dev/null &
else
  echo "Server is running already."
fi
