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

commands.add("stats", function(info)
  local cn = tonumber(engine.filtertext(info.args, true, true):match("(%d+)"))
  if not cn then cn = info.ci.clientnum end
  
  local who = engine.getclientinfo(cn)
  if not who then playermsg("Cannot find cn " .. cn, info.ci) return end
  
  local pl = playerStats:getPlayer(cn)
  local acc = pl.totalDamage / (math.max(pl.totalShots, 1))
  local frags = who.state.frags
  local tk = who.state.teamkills
  local deaths = who.state.deaths
  local kpd = frags/(math.max(deaths, 1))
  
  local str = "Stats for %s (cn %d):\n"
  str = str .. "Accuracy: %.1f%%, Frags: %d, Deaths: %d, Teamkills: %d, KpD: %.1f"
  
  playermsg(str:format(who.name, cn, acc, frags, deaths, tk, kpd), info.ci)
  engine.writelog(("stats %d(%s) from %s"):format(cn, who.name, info.ci.name))
end, "#stats <cn>: shows current stats for player <cn>. Omit <cn> to see your own stats.")


-- A Player Class, to store the stats for a single player
local Player = {}
Player.__index = Player

function Player.create(cn)
  local player = setmetatable({
    cn = cn,      -- initialize our object
    totalDamage = 0,
    totalShots = 0,
    passes = 0,   --rugby passes
    guns = {}  -- stats for each weapon
  }, Player)

  for i = 0, 6 do   --initialize each weapon
    player.guns[i] = {}
    player.guns[i].shotCount = 0
    player.guns[i].damage = 0
  end 
  return player
end

-- Reinitialize all Player fields
function Player:reset()
  
  self.totalDamage = 0
  self.totalDamage = 0
  self.totalShots = 0
  self.passes = 0
  self.guns = {}
  
  for i = 0, 6 do   --reinitialize each weapon
    self.guns[i] = {}
    self.guns[i].shotCount = 0
    self.guns[i].damage = 0
  end 
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
  local players_local = {}
  return setmetatable({
      players = setmetatable({}, {
        -- automatically create player if not made yet
        __index = function(t,k)
          if not players_local[k] then
            players_local[k] = Player.create(cn)
          end
          return players_local[k]
        end
      })
    }, PlayerStats)
end

function PlayerStats:addDamage(cn, gun, damage)
  self.players[cn]:addDamage(gun, damage)  
end

function PlayerStats:addShot(cn, gun)
  self.players[cn]:addShot(gun)  
end

function PlayerStats:subtractShot(cn, gun)
  self.players[cn]:subtractShot(gun)  
end

function PlayerStats:addPass(cn)
  self.players[cn]:addPass()
end

--Returns Player <cn> or a dummy empty Player object.
function PlayerStats:getPlayer(cn)
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
    if v > value then
      key, value = k, v
    end
  end
  return key, value
end

local function printStats()
  local statsString = ""
  
  local getRankOf = function(stat, msg, cb)
    local rank = {}
    for ci in iterators.players() do
      rank[ci] = cb and cb(ci) or ci.state[stat]
    end
    
    local client, val = max(rank)
    if client ~= 0 and val ~= 0 then
      statsString = statsString .. msg:format(client.name, tonumber(val))
    end
  end
  
  -- collect the frags of each player 
  getRankOf("frags", "\f1Pastabolous fragger:\f2 %s(\f0%d\f2), ")
  
  -- collect the deaths of each player
  getRankOf("deaths", "\f1Most deaths:\f2 %s(\f0%d\f2), ")
  
  -- collect the flags scored for each player
  getRankOf("flags", "\f1Flags scored:\f2 %s(\f0%d\f2)\n")
  
  -- collect the teamkills of each player
  getRankOf("teamkills", "\f1Teamkiller:\f2 %s(\f0%d\f2), ")
  
  -- calculate accuracy of each player, but only after more than n shots
  getRankOf("acc", "\f1Accuracy nerd:\f2 %s(\f0%.1f%%\f2), ", function(ci)
    local pl = playerStats:getPlayer(ci.clientnum)
    return pl.totalShots > 6 and (pl.totalDamage / (math.max(pl.totalShots, 1))) or 0
  end)

  --calculate the kpd
  getRankOf("kpd", "\f1KpD:\f2 %s(\f0%.1f\f2), ", function(ci)
    local pl = playerStats:getPlayer(ci.clientnum)
    return ci.state.frags / (math.max(ci.state.deaths, 1))
  end)
  
  --calculate the passes for each player
  getRankOf("passes", "\f1Rugby champ:\f2 %s(\f0%d passes\f2), ", function(ci)
    return playerStats:getPlayer(ci.clientnum).passes
  end)
  
  --calculate the chainsaw kills for each player
  getRankOf("chainsaw", "\f1Chainsaw maniac:\f2 %s(\f0%d\f2)", function(ci)
    local pl = playerStats:getPlayer(ci.clientnum)
    if pl ~= nil then return (pl.guns[0].damage) / 50 end 
  end)
  
  server.sendservmsg(statsString)
end 

-- Hooks

spaghetti.addhook("damaged", function(info)
  playerStats:addDamage(info.actor.clientnum, info.gun, info.damage)
end)
    
spaghetti.addhook("shot", function(info)
  playerStats:addShot(info.ci.clientnum, info.event.gun)
end, false)

spaghetti.addhook("connected", function(info)
  local pl = playerStats:getPlayer(info.ci.clientnum)
  pl:reset()
  end
)

spaghetti.addhook("changemap", function(info)
  -- God bless the garbage collector:
  playerStats = PlayerStats.init() --reinitialize the players stats
  
  -- Halfway through a match, show the current stats 
  spaghetti.latergame(1000 * 60 * 5, function()
    server.sendservmsg("Mid match statistics: ")
    printStats()
  end)
end)

spaghetti.addhook("changemap", function(info)
  -- First quarter through a match, show the current stats 
  spaghetti.latergame(1000 * 60 * 2.5, function()
    server.sendservmsg("First quarter match statistics: ")
    printStats()
  end)
end)

spaghetti.addhook("changemap", function(info)
  -- First quarter through a match, show the current stats 
  spaghetti.latergame(1000 * 60 * 7.5, function()
    server.sendservmsg("Third quarter match statistics: ")
    printStats()
  end)
end)

spaghetti.addhook("intermission", function()        
  server.sendservmsg("End match statistics: ")
  printStats()   
    
  -- God bless the garbage collector:
  playerStats = PlayerStats.init() --reinitialize the players stats
end)

-- Let's make the intermission a little bit longer, so users can enjoy the stats 
spaghetti.addhook("intermission", L"server.interm = server.interm + 3000")