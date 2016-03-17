#What is this?

This repo contains the Lua modules for the **Pastaland** Sauerbraten server:

* The *stats* module, to gather and show user statistics
* The *jokes* module, to send random jokes to the client
* The *autospec* module, to put non-moving clients to spec
* The *authloader* module, to load auth keys from an external file and allow adding keys in real time
* The *db* module, to connect to the Pastalandjs service to save and load players statistics
* The *1000-gustavo-config* file, the actual server configuration.

###Building
* Nothing to build here. Get **spaghettimod** from here: https://github.com/pisto/spaghettimod 
* Build spaghettimod according to Pisto's instructions.

###Installing the modules
* Just copy the Pastaland modules respecting the paths shown in this repo: *stats.lua*, *autospec.lua*, *authloader.lua*, *db.lua* and *jokes.lua* go in script/std, *1000-gustavo-config.lua* goes into script/load.d, *gustavo.auth* contains the authkeys for players and goes in the var directory.

###Running
* Once copied the modules, there's no need to rebuild. Just move to spaghettimod's root dir and launch *#GST=1 ./sauer_server*

##PastalandJs
* PastalandJs is service based on NodeJs that communicates via UDP with the Pastaland server. Currently it is just used to save and load player statistics and connection info, persisted in a Sqlite database.

###Installing PastalandJs
* Install NodeJs. PastalandJs has been tested with NodeJs 5.9 but any version > 0.10 should be fine.
* Copy the *pastalandjs* folder and its content wherever you want in your server.
* Open a terminal in the *pastalandjs* folder and issue *npm install*. This will automatically resolve NodeJs dependencies.

###Running PastalandJs
* The easiest way is opening a terminal in *pastalandjs* folder and issue *node index.js*, but the recommended way is by means of a process manager like Pm2: https://github.com/Unitech/pm2
* Since the connection between Pastaland and PastalandJs is via UDP, there is actually no connection. This means that one can run with or without the other, with no problems whatsoever.
