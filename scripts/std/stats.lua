--[[

  The stats module introduces the following:
  - the #stats <cn> command, to show the current statictics of a player
  - pretty formatted statistics at the end of the match
  - pretty formatted statistics the middle of the match
  
  TODO: see if it's worth encapsulating the stats data in the ci.extra field, instead of a dedicated table 

]]--


local commands = require("std.commands");
local playermsg = require("std.playermsg");
local iterators = require("std.iterators");
local L = require("utils.lambda")

commands.add("stats",
  function(info)
    local cn = engine.filtertext(info.args, true, true):match("(%d+)")
    cn = tonumber(cn)
    if not cn then playermsg("Invalid format.", info.ci) return end
    local who = engine.getclientinfo(cn)
    if not who then playermsg("Cannot find cn " .. cn, info.ci) return end
    
    local pl = playerStats:getPlayer(cn)
    local acc = pl.totalDamage / (math.max(pl.totalShots, 1))
    local frags = who.state.frags
    local tk = who.state.teamkills
    local deaths = who.state.deaths
    local str = "Stats for " .. who.name .." (cn " .. tostring(cn) .. "):\n"
    
    str = str .. "Accuracy: " .. string.format("%.1f", acc) .."%, Frags: " .. tostring(frags) .. ", Deaths: " .. tostring(deaths) .. ", Teamkills: " .. tostring(tk)
    playermsg(str, info.ci)
    engine.writelog(("stats %d(%s) from %s"):format(cn, who.name, info.ci.name))
  end, "#stats <cn>: shows current stats for player <cn>")

-- A Player Class, to store the stats for a single player
local Player = {}
Player.__index = Player

function Player.create(cn)
  local player = {}
  setmetatable(player,Player)
  player.cn = cn      -- initialize our object
  player.totalDamage = 0
  player.totalShots = 0
  player.passes = 0   --rugby passes
  player.guns = {}  -- stats for each weapon
  for i = 0, 6 do
    player.guns[i] = {}
    player.guns[i].shotCount = 0
    player.guns[i].damage = 0
  end 
  return player
end

function Player:addDamage(gun, damage)
  self.guns[gun].damage = self.guns[gun].damage + damage
  self.totalDamage = self.totalDamage + damage
end

function Player:addShot(gun)
  self.guns[gun].shotCount = self.guns[gun].shotCount + 1
  self.totalShots = self.totalShots + 1
end

function Player:subtractShot(gun) --only for rugby purposes
  self.guns[gun].shotCount = self.guns[gun].shotCount - 1
  self.totalShots = self.totalShots - 1
end

function Player:printGuns() --just for debug
  for k,v in pairs(self.guns) do
    print(k, v.shotCount, v.damage)
  end
  print("TotalDamage: " .. tostring(self.totalDamage))
  print("TotalShots: " .. tostring(self.totalShots))
  print("Passes: " .. tostring(self.passes))
end

function Player:addPass()
  self.passes = self.passes + 1
end

local PlayerStats = {}
PlayerStats.__index = PlayerStats

function PlayerStats.init()
  local ps = {}
  setmetatable(ps, PlayerStats)
  ps.players = {}
  return ps
end

function PlayerStats:addDamage(cn, gun, damage)
  if not self.players[cn] then
    self.players[cn] = Player.create(cn)
  end
  self.players[cn]:addDamage(gun, damage)  
end

function PlayerStats:addShot(cn, gun)
  if not self.players[cn] then
    self.players[cn] = Player.create(cn)
  end
  self.players[cn]:addShot(gun)  
end

function PlayerStats:subtractShot(cn, gun)
  if not self.players[cn] then
    self.players[cn] = Player.create(cn)
  end
  self.players[cn]:subtractShot(gun)  
end

function PlayerStats:addPass(cn)
  if not self.players[cn] then
    self.players[cn] = Player.create(cn)
  end
  self.players[cn]:addPass()
end

--Returns Player <cn> or a dummy empty Player object.
function PlayerStats:getPlayer(cn)
  if not self.players[cn] then
    self.players[cn] = Player.create(cn)
  end
  return self.players[cn]
end

function PlayerStats:printvals()
  for k, v in pairs(self.players) do
    v:printGuns()
  end
end

playerStats = PlayerStats.init()   -- the global playerStats table

--function to return the maximum integer value on a table, and its key  
local function max(t)
  local key, value = 0, 0
  for k, v in pairs(t) do
    --print("evaluating:")
    --print(k, v)
    if v > value then
      key, value = k, v
    end
  end
  return key, value
end

local function printStats()
  
  local statsString = ""
        
        -- collect the frags of each player 
        local fragsRank = {}
        for ci in iterators.players() do
          fragsRank[ci] = ci.state.frags
        end
                
        local client, val = max(fragsRank)
        if client ~= 0 and val ~= 0 then
          local str = "\f1Pastabolous fragger:\f2 " .. client.name .. "(\f0" .. tonumber(val) .. "\f2), "
          statsString = statsString .. str
          -- print(client.name, val)
        end
        
        -- collect the deaths of each player
        local deathsRank = {}
        for ci in iterators.players() do
          deathsRank[ci] = ci.state.deaths
        end
        
        client, val = max(deathsRank)
        if client ~= 0 and val ~= 0 then
          local str = "\f1Most deaths:\f2 " .. client.name .. "(\f0" .. tonumber(val) .. "\f2), "
          statsString = statsString .. str
          -- print(client.name, val)
        end
        
        -- collect the flags scored for each player
        local flagsRank = {}
        for ci in iterators.players() do
          flagsRank[ci] = ci.state.flags
        end
        
        client, val = max(flagsRank)
        if client ~= 0 and val ~= 0 then
          local str = "\f1Flags scored:\f2 " .. client.name .. "(\f0" .. tonumber(val) .. "\f2)\n"
          statsString = statsString .. str
        end
        
        -- collect the teamkills of each player
        local tkRank = {}
        for ci in iterators.players() do
          tkRank[ci] = ci.state.teamkills
        end
        
        client, val = max(tkRank)
        if client ~= 0 and val ~= 0 then
          local str = "\f1Teamkiller:\f2 " .. client.name .. "(\f0" .. tonumber(val) .. "\f2), "
          statsString = statsString .. str
        end
        
        -- calculate accuracy of each player, but only after more than n shots
        local accRank = {}
        for ci in iterators.players() do
          local pl = playerStats:getPlayer(ci.clientnum)
          if(pl.totalShots > 6) then
            accRank[ci] = pl.totalDamage / (math.max(pl.totalShots, 1))
          else
            accRank[ci] = 0
          end
        end
        
        client, val = max(accRank)
        if client ~= 0 and val ~= 0 then
          local str = "\f1Accuracy nerd:\f2 " .. client.name .. "(\f0" .. string.format("%.1f", val) .. "%\f2), "
          statsString = statsString .. str
        end
        
        --calculate the passes for each player
        local passRank = {}
        for ci in iterators.players() do
          local pl = playerStats:getPlayer(ci.clientnum)
          passRank[ci] = pl.passes
        end
        
        client, val = max(passRank)
        if client ~= 0 and val ~= 0 then
          local str = "\f1Rugby champ:\f2 " .. client.name .. "(\f0" .. tonumber(val) .. " passes\f2), "
          statsString = statsString .. str
        end
        
        --calculate the chainsaw kills for each player
        local chainsawRank = {}
        for ci in iterators.players() do
          local pl = playerStats:getPlayer(ci.clientnum)
          if(pl ~= nil) then
            chainsawRank[ci] = (pl.guns[0].damage) / 50
          end 
        end
        
        client, val = max(chainsawRank)
        if client ~= 0 and val ~= 0 then
          local str = "\f1Chainsaw maniac:\f2 " .. client.name .. "(\f0" .. tonumber(val) .. "\f2)"
          statsString = statsString .. str
        end
        
        server.sendservmsg(statsString)
end 


-- Hooks

spaghetti.addhook("damaged", 
    function(info)
      playerStats:addDamage(info.actor.clientnum, info.gun, info.damage)
    end)
    
spaghetti.addhook("shot",
    function(info)
      playerStats:addShot(info.ci.clientnum, info.event.gun)
    end,
    false)
    
spaghetti.addhook("changemap", 
    function(info)
        -- God bless the garbage collector:
        playerStats = PlayerStats.init() --reinitialize the players stats
        
        -- Halfway through a match, show the current stats 
        spaghetti.latergame(1000 * 60 * 5, function()
          server.sendservmsg("Mid match statistics: ")
          printStats()
        end)
    end)

spaghetti.addhook("intermission", 
    function()        
       server.sendservmsg("End match statistics: ")
       printStats()   
        
       -- God bless the garbage collector:
        playerStats = PlayerStats.init() --reinitialize the players stats
                  
    end)

-- Let's make the intermission a little bit longer, so users can enjoy the stats 
spaghetti.addhook("intermission", L"server.interm = server.interm + 2500")