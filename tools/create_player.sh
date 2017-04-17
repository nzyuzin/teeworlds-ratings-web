#!/usr/bin/env bash

sqlite3 rctf.db <<< "insert into players values ('$1', '$2', 1500);"
