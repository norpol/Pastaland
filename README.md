#What is this?

This repo contains the Lua modules for the **Pastaland** Sauerbraten server:

* The *stats* module, to gather and show user statistics
* The *jokes* module, to send random jokes to the client
* The *autospec* module, to put non-moving clients to spec
* The *1000-gustavo-config* file, the actual server configuration.

###Building
* Nothing to build here. Get **spaghettimod** from here: https://github.com/pisto/spaghettimod 
* Build spaghettimod according to Pisto's instructions.

###Installing the modules
* Just copy the Pastaland modules respecting the paths shown in this repo: *stats.lua*, *autospec.lua* and *jokes.lua* go in script/std, *1000-gustavo-config.lua* goes into script/load.d

###Running
* Once copied the modules, there's no need to rebuild. Just move to spaghettimod's root dir and launch *#GUSTAVOVPS=1 ./sauer_server*
