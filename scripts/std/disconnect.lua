--[[

  This module provides the following functionality:
  - add the #disconnect command, to disconnect clients giving the "Server FULL" message
  
]]--


local commands = require("std.commands");
local playermsg = require("std.playermsg");
local client = require("std.n_client");

commands.add("disconnect", function(info)
if info.ci.privilege < server.PRIV_MASTER then return playermsg("Insufficient privilege.", info.ci) end
  local cn = tonumber(engine.filtertext(info.args, true, true):match("(%d+)"))
  if not cn then playermsg("Insert client number to disconnect.") return end
  
  local who = engine.getclientinfo(cn)
  if not who then playermsg("Cannot find cn " .. cn, info.ci) return end
  
  engine.disconnect_client(cn, 7)
  
  engine.writelog(("disconnect %s(%d) from %s"):format(who.name, cn, info.ci.name))
end, "#disconnect <cn>: disconnect player <cn> sending the message 'server FULL'.")
