--[[

  This module provides the following functionality:
  - add the #rename command, rename clients
  
]]--


local commands = require("std.commands");
local playermsg = require("std.playermsg");
local putf = require("std.putf");
local client = require("std.n_client");

commands.add("rename", function(info)
if info.ci.privilege < server.PRIV_MASTER then return playermsg("Insufficient privilege.", info.ci) end
local argstable = {}
  for arg in string.gmatch(info.args, "%S+") do
    table.insert(argstable, arg);
  end
  if #argstable ~= 2 then return playermsg("Wrong parameters number.", info.ci) end
  --TODO: sanitize parameters, as usual
    
  local cn = tonumber(argstable[1])
  local newname = argstable[2]
  
  if string.len(newname) <= 1 then return playermsg("Name too short", info.ci) end
  if string.len(newname) > 15 then return playermsg("Name too long", info.ci) end
     
  local who = engine.getclientinfo(cn)
  if not who then playermsg("Cannot find cn " .. cn, info.ci) return end
  local oldname = who.name
  
  if not newname then playermsg("You need to specify a name.", info.ci) return end
  
  who.messages:putint(server.N_SWITCHNAME)
  who.messages:sendstring(newname)
  
  engine.sendpacket(
    who.clientnum, 1,
    client(
      putf(
        {newname:len(), r = 1},
        server.N_SWITCHNAME,
        newname
      ), who
    ):finalize(),
  -1)
  --messages.error(msg):format(oldname):send(ci)
  info.ci.name = newname
  
  playermsg(("renamed %d(%s) into %s"):format(cn, oldname, who.name), info.ci)
  engine.writelog(("rename %d(%s) into %s from %s"):format(cn, oldname, who.name, info.ci.name))
end, "#rename <cn> <newname>: change the name for player <cn>.")
