--[[
  
  This module provides the following functionality:
  - add the #addkey command, to load auth key directly from the game prompt
  - add the #load command, lo load the auth keys saved to disk, in case of manual editing of the auth file
  - persist the keys in a file named var/<cs.serverauth>.auth in json format. 
  
]]--

local jsonpersist = require("utils.jsonpersist")
local commands = require("std.commands");
local playermsg = require("std.playermsg")

local Module = {}

-- Load the auth keys persisted in the json file
Module.loadAuths = function()
  cs.clearusers()
  local authtable = jsonpersist.load(cs.serverauth .. ".auth")
  for index, usertable in ipairs(authtable) do
    cs.adduser(usertable.user, usertable.domain, usertable.pubkey, usertable.privilege)
  end
  engine.writelog("Reloaded auth keys")
end

-- Adds a key to the localauth table and persists it to disk 
Module.addkey = function(user, domain, pubkey, privilege)
  cs.adduser(user, domain, pubkey, privilege)
  local authtable = jsonpersist.load(cs.serverauth .. ".auth")
  table.insert(authtable, {user=user, domain=domain, pubkey=pubkey, privilege=privilege})
  jsonpersist.save(authtable, cs.serverauth .. ".auth")
  engine.writelog("Added auth key for user " .. user)
end 

commands.add("keysreload", function(info)
  if info.ci.privilege < server.PRIV_AUTH then return playermsg("Insufficient privilege.", info.ci) end
  Module.loadAuths()
end)
  
commands.add("keyadd", function(info)
  if info.ci.privilege < server.PRIV_AUTH then return playermsg("Insufficient privilege.", info.ci) end
  local argstable = {}
  for arg in string.gmatch(info.args, "%S+") do
    table.insert(argstable, arg);
  end
  if #argstable ~= 4 then return playermsg("Wrong parameters number.", info.ci) end
  --TODO: sanitize parameters
  Module.addkey(argstable[1],argstable[2],argstable[3], argstable[4])
end, "#keyadd [user] [domain] [pubkey] [privilege]: add a key to the auths table")

return Module