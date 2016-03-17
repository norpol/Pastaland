--[[

  The db introduces a database connection with the Nodejs server.
  It requires the stats module.
  
  TODO: all 

]]--
local ip = require ("utils.ip")
local json = require ("dkjson")
local iterators = require("std.iterators");

if not playerStats then
  require("stats")
end  --make sure the stats module is loaded

--Generate the udp connection to the local Nodejs server
local host, writeport = "localhost", 41234
-- load namespace
local socket = require("socket")
local localIp, udp
local connected = false

-- retrieve the answer and print results
--io.write(assert(udp:receive())) 

local function createConnection()
  localIp = socket.dns.toip(host)
  if not localIp then
    engine.writelog("Error fetching localhost ip")
    return false
  end
  udp = socket.udp()
  udp:settimeout(0) -- make the call not blocking
  if not udp then
    engine.writelog("Error creating udp socket")
    return false
  end
  return true
end

local function sendDbMessage(message)
  -- The maximum datagram size for UDP is 64K minus IP layer overhead
  -- In UDP, the send method never blocks and the only way it can fail is if the
  -- underlying transport layer refuses to send a message to the specified address
  -- (i.e. no interface accepts the address). 
  
  if connected then
    local result = udp:sendto(message, localIp, writeport)
    if not result then engine.writelog(("Failed to send message %s"):format(message)) end
  else
    engine.writelog("Not connected.")
  end
end

connected = createConnection()
if connected then
  engine.writelog("Connection established with local Pastalandjs server.")
else
  engine.writelog("Could not connect with local Pastalandjs server.")
end

local function registerStats()
  
  for ci in iterators.players() do
    if ci.state.aitype ~= server.AI_BOT then      
      local pl = playerStats:getPlayer(ci.clientnum)
      
      --register the stats only if the player shot at least 10 times and has a name
      if pl.totalShots > 10 and ci.name ~= "unnamed" then  
        local tbl = {
          command = "register stats",
          name = ci.name,
          ip = tostring(ip.ip(ci)),
          frags = ci.state.frags,
          deaths = ci.state.deaths,
          flags = ci.state.flags,
          tk = ci.state.teamkills,
          passes = pl.passes,
          shots = pl.totalShots,
          damage = pl.totalDamage,
          stolen = pl.stolen
        }   
    
        local str = json.encode(tbl, {indent = false})
        sendDbMessage(str)
      end
    end
  end
end

-- When a player connects, send a notification to the database server
spaghetti.addhook("connected", function(info)
  local tbl = {
    command  = "connected",
    name = info.ci.name,
    ip = tostring(ip.ip(info.ci))
  }
  local str = json.encode(tbl, {indent = false})
  if(tbl.name ~= "unnamed") then 
    sendDbMessage(str)
  end
end)

-- When a match finishes, send the stats of all players to the Nodejs server
spaghetti.addhook("intermission", function(info)
  registerStats()
end)

-- every few milliseconds, poll for UDP messages from the server
spaghetti.later(50, function()
  local datagram = udp:receive()  -- maximum allowed datagram size is 8192 bytes.
  if datagram then
    local obj, pos, err = json.decode(datagram, 1, nil)
    if err then return print("Error: ", err)
    else
      if obj.command == "user description" then
        local kpd = obj.frags/(math.max(obj.deaths, 1))
        local acc = obj.damage / (math.max(obj.shots, 1))
        local str = "\f2%s\f1:  Rank \f0#%d\f1, Average acc \f0%.1f%%\f1, Average KpD: \f0%.1f\f1" 
        server.sendservmsg(str:format(obj.name, obj.rank, acc, kpd))
      else
        print("Unknown server request");
      end
    end
  end
end, true)

