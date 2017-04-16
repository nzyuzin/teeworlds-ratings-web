#!/usr/bin/env bash

yum install -y ruby ruby-devel sqlite sqlite-devel git curl
sudo yum groupinstall -y 'Development Tools'
gem install sinatra sinatra-paginate haml sqlite3
