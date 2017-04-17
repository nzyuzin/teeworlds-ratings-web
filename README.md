Teeworlds-ratings-web
=====================

Webapp to display the information from https://github.com/nzyuzin/teeworlds-ratings database.

Dependencies
------------

ruby >= 2.2, sqlite3

Gems: bundler

Setting up
----------

Execute the following command before starting the server the first time
`bundle install`

Once launched, server will look for database file which should be placed in the root directory of the repo.
Instructions to set up the databse are given in https://github.com/nzyuzin/teeworlds-ratings

Using
-----

To launch the web server execute
`./tools/start_server.sh`
from the root of the repository
To stop the server execute
`./tools/stop_server.sh`
