--[[

  Configuration for Pastaland

]]--

if not os.getenv("GUSTAVOVPS") then return end
engine.writelog("Applying the Pastaland configuration.")

local servertag = require"utils.servertag"
servertag.tag = "gustavo"

local uuid = require"std.uuid"

local fp, L = require"utils.fp", require"utils.lambda"
local map, I = fp.map, fp.I
local abuse, playermsg = require"std.abuse", require"std.playermsg"

cs.maxclients = 32
cs.serverport = 28785
spaghetti.later(10000, L'engine.requestmaster("\\n")', true)
spaghetti.addhook("masterin", L'if _.input:match("^failreg") then engine.lastupdatemaster = 0 end', true)

--make sure you delete the next two lines, or I'll have admin on your server.
cs.serverauth = "gustavo"
local auth = require"std.auth"
cs.adduser("GustavoLapasta", "gustavo", "+0f4edc6a81315c60974f532ddda9bbcf410a47559ffdd233", "a")
cs.adduser("Shag", "gustavo", "-4751bf9630525b622053c10d69690860544dc877265250bc", "m")
cs.adduser("Eric", "gustavo", "+e676b6d2ddc76fcfff37119d4baa948a69a5996a832ce889", "m")
cs.adduser("Pikachu", "gustavo", "+472f6febce5a00b0fa19954f98f01606c3c7f67f9ef71244", "m")
cs.adduser("Obstriegel", "gustavo", "-7b4bcc7bf148a3f9891c7a1fd1d70e8fd03d8c3d980791bc", "m")
cs.adduser("Star", "gustavo", "+de96f3e0ba5bcb692c86cbb06a695fc3db60debc59ec8355", "m")
cs.adduser("Fear", "gustavo", "+bf1fa38e7439791d9ff52635575e6a002fdfd532d07d5565", "m")
cs.adduser("a-monster", "gustavo", "-a5a2ba763973d5af0cd90bb46a663712376e855681672864", "m")
cs.adduser("Narwhaal", "gustavo", "-f14e1ba9db58e791f5a65ed8443cc28e507572903f0ef5d1", "m")
cs.adduser("Cs4", "gustavo", "+b7fbb3b4227c69eeda4c6aa328fffd75a0717316a4dedb7f", "m")
cs.adduser("Benz", "gustavo", "+39d60464f037ec70f11163b3e9e2d5f8b03f8bb1c2423b8c", "m")
cs.adduser("pisto", "gustavo", "-f16c266e93ef6e4882dd865e56cc3f7d3d84d9b4887e01b7", "m")
cs.adduser("Swatllama", "gustavo", "-b7a19f6996775d3524d6e4c17f85274c925dd0f8cbe9baae", "m")
cs.adduser("Bourbon", "gustavo", "-ceb7be8552da06683cb117c585e4bc255b4ca05385646321", "m")
cs.adduser("Dai", "gustavo", "+f7e29d9c5e91fb53d2c19927c3ccae6869055cc5543f31d1", "m")
cs.adduser("Zver", "gustavo", "-b89f2161ffe5d9787e465db4cf21801c192334400dd93292", "m")
cs.adduser("Duke", "gustavo", "+694670498667548b315c450aaa0fb7a24c1306c5f16bd010", "m")

table.insert(auth.preauths, "gustavo")

spaghetti.addhook(server.N_SETMASTER, L"_.skip = _.skip or (_.mn ~= _.ci.clientnum and _.ci.privilege < server.PRIV_AUTH)")

cs.serverdesc = "\f7:: Pastaland ::"

cs.lockmaprotation = 2
cs.ctftkpenalty = 0
cs.maprotationreset()
--copied from data/menus.cfg
local ffamaps, capturemaps, ctfmaps = table.concat({
  "aard3c academy akaritori alithia alloy aqueducts arbana bvdm_01 castle_trap collusion complex corruption curvedm curvy_castle darkdeath deathtek depot",
  "dirtndust DM_BS1 dock douze duel7 duel8 dune elegy fanatic_quake force fragplaza frostbyte frozen fury guacamole gubo hades",
"hashi hog2 industry injustice island justice kalking1 katrez_d kffa killfactory kmap5 konkuri-to ksauer1 legazzo lostinspace masdm mbt10",
  "mbt2 mbt9 memento metl2 metl3 metl4 moonlite neondevastation neonpanic nmp8 nucleus oasis oddworld ogrosupply orbe orion osiris",
  "ot outpost paradigm park pgdm phosgene pitch_black powerplant refuge renegade rm5 roughinery ruby ruine sauerstruck sdm1 shadowed",
  "shindou shinmei1 shiva simplicity skrdm1 stemple suburb tartech teahupoo tejen thetowers thor torment tumwalk turbine wake5 wdcd"
}, " "), table.concat({
  "abbey akroseum alithia arabic asgard asteroids c_egypt c_valley campo capture_night caribbean collusion core_refuge core_transfer corruption cwcastle damnation",
  "dirtndust donya duomo dust2 eternal_valley evilness face-capture fb_capture fc3 fc4 fc5 forge frostbyte hades hallo haste hidden",
  "infamy killcore3 kopenhagen lostinspace mbt12 mercury monastery nevil_c nitro nmp4 nmp8 nmp9 nucleus ogrosupply paradigm ph-capture reissen",
  "relic river_c serenity snapper_rocks spcr subterra suburb tempest tortuga turbulence twinforts urban_c valhalla venice xenon"
}, " "), table.concat({
  "abbey akroseum arbana asgard authentic autumn bad_moon berlin_wall bt_falls campo capture_night catch22 core_refuge core_transfer damnation desecration dust2",
  "eternal_valley europium evilness face-capture flagstone forge forgotten garden hallo haste hidden infamy kopenhagen l_ctf mach2 mbt1 mbt12",
  "mbt4 mercury mill nitro nucleus recovery redemption reissen sacrifice shipwreck siberia snapper_rocks spcr subterra suburb tejen tempest",
  "tortuga turbulence twinforts urban_c valhalla wdcd xenon fc4 fc5 gubo donya duomo"
}, " ")

ffamaps, capturemaps, ctfmaps = map.uv(function(maps)
  local t = map.f(I, maps:gmatch("[^ ]+"))
  for i = 2, #t do
    local j = math.random(i)
    local s = t[j]
    t[j] = t[i]
    t[i] = s
  end
  return table.concat(t, " ")
end, ffamaps, capturemaps, ctfmaps)

cs.maprotation("ffa effic tac teamplay efficteam tacteam", ffamaps, "regencapture capture hold effichold instahold", capturemaps, "ctf efficctf instactf protect efficprotect instaprotect", ctfmaps)
server.mastermask = server.MM_PUBSERV + server.MM_AUTOAPPROVE

--gamemods
--require"gamemods.quadarmour".on(1/2, 6, 0, 20000, 30000, server.A_GREEN, 100)
spaghetti.addhook("changemap", L'require"gamemods.rugby".on(server.m_ctf)')

local commands = require"std.commands"
local nextflagswitch = false
commands.add("flagswitch", function(info)
  local arg = info.args == "" and 1 or tonumber(info.args)
  if not arg then playermsg("Invalid flagswitch value", info.ci) end
  local old = nextflagswitch
  nextflagswitch = arg == 1
  if old == nextflagswitch then return end
  if nextflagswitch and (not server.m_ctf or server.m_hold) then playermsg("Mind that you still need to force the next mode to be ctf/protect.", info.ci) end
  server.sendservmsg(server.colorname(info.ci, nil) .. (nextflagswitch and " activated" or " deactivated") .. " \f1flag switch mode\f7 for the next map (see #help flagswitch).")
end, "Usage: #flagswitch [0|1]: activate flag switch (blue flag spawns in place of red and viceversa) for the next map if mode is ctf or protect (default 1, only masters)")

local flagswitch, currentflagswitch = require"gamemods.flagswitch", false
spaghetti.addhook("entsloaded", function()
  currentflagswitch = false
  nextflagswitch = nextflagswitch and server.m_ctf and not server.m_hold
  if not nextflagswitch then flagswitch.on(false) return end
  nextflagswitch = false
  flagswitch.on(true)
  currentflagswitch = true
end)

local ents = require"std.ents", require"std.maploaded"

require"std.pm"       -- private messaging module
require"std.getip"    -- get ip module
require"std.jokes"    -- jokes module
require"std.stats"    -- statistics module
require"std.autospec" -- autospec module

spaghetti.addhook("entsloaded", function()
  if server.smapname ~= "thetowers" then return end
  for i, _, ment in ents.enum(server.JUMPPAD) do if ment.attr4 == 40 then
    ents.editent(i, server.JUMPPAD, ment.o, ment.attr1, ment.attr2, ment.attr3)
    break
  end end
end)

--moderation

cs.teamkillkick("*", 5, 30)     -- keep autokick quite low

--limit reconnects when banned, or to avoid spawn wait time
abuse.reconnectspam(1/60, 5)

--limit some message types
spaghetti.addhook(server.N_KICK, function(info)
  if info.skip or info.ci.privilege > server.PRIV_MASTER then return end
  info.skip = true
  playermsg("No. Use gauth.", info.ci)
end)
spaghetti.addhook(server.N_SOUND, function(info)
  if info.skip or abuse.clientsound(info.sound) then return end
  info.skip = true
  playermsg("I know I used to do that but... whatever.", info.ci)
end)
abuse.ratelimit({ server.N_TEXT, server.N_SAYTEAM }, 0.5, 10, L"nil, 'I don\\'t like spam.'")
abuse.ratelimit(server.N_SWITCHNAME, 1/30, 4, L"nil, 'You\\'re a pain.'")
abuse.ratelimit(server.N_MAPVOTE, 1/10, 3, L"nil, 'That map sucks anyway.'")
abuse.ratelimit(server.N_SPECTATOR, 1/30, 5, L"_.ci.clientnum ~= _.spectator, 'Can\\'t even describe you.'") --self spec
abuse.ratelimit(server.N_MASTERMODE, 1/30, 5, L"_.ci.privilege == server.PRIV_NONE, 'Can\\'t even describe you.'")
abuse.ratelimit({ server.N_AUTHTRY, server.N_AUTHKICK }, 1/60, 4, L"nil, 'Are you really trying to bruteforce a 192 bits number? Kudos to you!'")
abuse.ratelimit(server.N_SERVCMD, 0.5, 10, L"nil, 'Yes I\\'m filtering this too.'")
abuse.ratelimit(server.N_JUMPPAD, 1, 10, L"nil, 'I know I used to do that but... whatever.'")
abuse.ratelimit(server.N_TELEPORT, 1, 10, L"nil, 'I know I used to do that but... whatever.'")

--prevent masters from annoying players
local tb = require"utils.tokenbucket"
local function bullying(who, victim)
  local t = who.extra.bullying or {}
  local rate = t[victim.extra.uuid] or tb(1/30, 6)
  t[victim.extra.uuid] = rate
  who.extra.bullying = t
  return not rate()
end
spaghetti.addhook(server.N_SETTEAM, function(info)
  if info.skip or info.who == info.sender or not info.wi or info.ci.privilege == server.PRIV_NONE then return end
  local team = engine.filtertext(info.text):sub(1, engine.MAXTEAMLEN)
  if #team == 0 or team == info.wi.team then return end
  if bullying(info.ci, info.wi) then
    info.skip = true
    playermsg("...", info.ci)
  end
end)
spaghetti.addhook(server.N_SPECTATOR, function(info)
  if info.skip or info.spectator == info.sender or not info.spinfo or info.ci.privilege == server.PRIV_NONE or info.val == (info.spinfo.state.state == engine.CS_SPECTATOR and 1 or 0) then return end
  if bullying(info.ci, info.spinfo) then
    info.skip = true
    playermsg("...", info.ci)
  end
end)

--ratelimit just gobbles the packet. Use the selector to add a tag to the exceeding message, and append another hook to send the message
local function warnspam(packet)
  if not packet.ratelimited or type(packet.ratelimited) ~= "string" then return end
  playermsg(packet.ratelimited, packet.ci)
end
map.nv(function(type) spaghetti.addhook(type, warnspam) end,
  server.N_TEXT, server.N_SAYTEAM, server.N_SWITCHNAME, server.N_MAPVOTE, server.N_SPECTATOR, server.N_MASTERMODE, server.N_AUTHTRY, server.N_AUTHKICK, server.N_CLIENTPING
)

local sound = require"std.sound"
spaghetti.addhook(server.N_TEXT, function(info)
  if info.skip then return end
  local low = info.text:lower()
  if not low:match"cheat" and not low:match"hack" and not low:match"auth" and not low:match"kick" then return end
  local tellcheatcmd = info.ci.extra.tellcheatcmd or tb(1/30000, 1)
  info.ci.extra.tellcheatcmd = tellcheatcmd
  if not tellcheatcmd() then return end
  playermsg("\f2Problems with a cheater? You are doomed.", info.ci)
  sound(info.ci, server.S_HIT, true) sound(info.ci, server.S_HIT, true)
end)

require"std.enetping"

local parsepacket = require"std.parsepacket"
spaghetti.addhook("martian", function(info)
  if info.skip or info.type ~= server.N_TEXT or info.ci.connected or parsepacket(info) then return end
  local text = engine.filtertext(info.text, true, true)
  engine.writelog(("limbotext: (%d) %s"):format(info.ci.clientnum, text))
  info.skip = true
end, true)

--simple banner

commands.add("info", function(info)
  playermsg("Pastaland is a server based on pisto's spaghettimod, brought to you with love by GustavoLapasta", info.ci)
end)

local function gamemoddesc()
  local msg
  if ents.active() and currentflagswitch then msg = "\n\f1Flag switch mode activated\f7! " .. (server.m_protect and "Your flag spawns in the enemy base!" or "Bring the enemy flag back to the enemy base!") end
  if server.m_ctf then msg = (msg or "") .. "\n\f3Rugby mode activated\f7! Shoot a teammate to pass the flag you are carrying" end
  return msg
end

local passes = {}
local function resetstreak(info) if not info.i then passes = {} else passes[info.i] = nil end end
spaghetti.addhook("changemap", resetstreak)
spaghetti.addhook("returnflag", resetstreak)
spaghetti.addhook("resetflag", resetstreak)

spaghetti.addhook("rugbypass", function(info)
  server.sendservmsg(server.colorname(info.actor, nil) .. " passed to " .. server.colorname(info.target, nil) .. "!")
  if server.m_hold or server.m_protect or info.actor.state.aitype ~= server.AI_NONE then return end   --sendresume with bots is problematic
  local i = next(info.flags)
  local streak = passes[i] or {}
  streak[info.actor.extra.uuid] = true
  passes[i] = streak
  
  if playerStats then --if global variable "players" is set, we are using std.stats
      playerStats:addPass(info.actor.clientnum)
       --need to correct the stats values
      playerStats:addDamage(info.actor.clientnum, server.GUN_RIFLE, -100)
      playerStats:subtractShot(info.actor.clientnum, server.GUN_RIFLE)
  end
end)

spaghetti.addhook("scoreflag", function(info)
  local streak = passes[info.relay] or {}
  streak[info.ci.extra.uuid] = nil
  passes[info.relay] = nil
  streak = map.gp(uuid.find, streak)
  if #streak == 0 then return end
  for _, ci in ipairs(streak) do ci.state.flags = ci.state.flags + 1 server.sendresume(ci) end
  server.sendservmsg("Passes in flagrun (+1 flag point): " .. table.concat(map.li(L"server.colorname(_2, nil)", streak), ", "))
end)

banner = "\n\n\f7Welcome to \f2Pastaland! \f7A rebrand of spaghettimod kindly brought to you by \f0Gustavo\f7La\f3Pasta\nctf/protect/hold have \f3RUGBY MODE\f7: shoot a teammate to pass the flag you are carrying!"
spaghetti.addhook("maploaded", function(info)
  if info.ci.extra.bannershown then
    local moddesc = gamemoddesc()
    return moddesc and playermsg(moddesc, info.ci)
  end
  info.ci.extra.bannershown = true
  local ciuuid = info.ci.extra.uuid
  spaghetti.later(1000, function()
    local ci = uuid.find(ciuuid)
    if not ci then return end
    local moddesc = gamemoddesc()
    playermsg(banner .. (moddesc and moddesc or ""), ci)
  end)
end)

spaghetti.later(30000, function()
  return server.m_ctf and server.sendservmsg("Remember, it's RUGBY MODE: you \f6shoot a teammate\f7 with \f3rifle\f7 to \f6pass the flag\f7!")
end, true)
