#!/usr/bin/env bash

kill -15 $(cat ./tools/server_pid) && echo 'Stopped!'
