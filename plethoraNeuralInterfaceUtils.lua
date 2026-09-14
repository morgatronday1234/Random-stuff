require("killMobs")
local expect = require("cc.expect")
local module = peripheral.wrap("back")


function getKeysInRangeBlacklist(ents, keys)
 expect(1, ents, "table")
 if (keys == nil) then key = true end --Bypass the key if key was not passed
 
 local matchingEnts = {}
 setmetatable(matchingEnts, {["__index"]=table})
 
 for _, ent in pairs(ents) do
  if not (keys[ent.key] == true) or (key == true) then
   setmetatable(ent, {["__index"]={["dist"]=entDist}})
   matchingEnts:insert(ent)
  end
 end
 
 return matchingEnts
end


local function useTarg(kin, ent)
 expect(1, kin, "table")
 expect(2, ent, "table")
 if not (ent.x) or not (ent.y) or not (ent.z) then
  error(("Agument #1: Invaild entity: %s"):format(textutils.serialise(ent)))
 end
 
 ent.x = ent.x +ent.motionX
 ent.y = ent.y +ent.motionY
 ent.z = ent.z +ent.motionZ
 --local shitToShoot = getKeyInRange(modules.sense(), "minecraft:item_frame")
 local targYaw = math.deg(math.atan2(-ent.x, ent.z))
 local targPitch = math.deg(math.atan2(ent.y, math.sqrt((ent.x*ent.x)+(ent.z*ent.z))))
 
 --print(("yaw: %s\nPitch: %s\n"):format(targYaw, -targPitch))
 kin.look(targYaw, -targPitch)
end

function aimTarget(kin, sensor,  listOfTargets)
 local shitToCheck = sensor.sense()
 local checkedShit = getKeysInRangeBlacklist(shitToCheck, listOfTargets) 
 local target = getClosestEnt(checkedShit)

 if (target.x) then
  --Don't look here, For your own sanity.
  target.y = target.y+ 0.1
  
  --print(textutils.serialise(checkedShit))
  useTarg(kin, target)
  kin.swing()
  os.sleep(0.1)
  kin.stopSwinging()
 else
  os.sleep(0.1)
 end
end

local breakBlocks = false
local power = 5

function main() while(true) do
 local event, key, held = os.pullEvent("key")
 --getWholeTime = os.epoch("utc")
 --getNameTime = os.epoch("utc")
 local pass, username = pcall(module.getName)
 --getNameFinish = (os.epoch("utc")-getNameTime).."ms"

 --getMetaTime = os.epoch("utc")
 local playerData = nil
 if (pass) then
  playerData = module.getMetaOwner()
 else
  goto skipCycle --I shouldn't have to fucking use byte code keywords just to get modules to not crash, Im not fucking going to wrap everthing in pcall.
 end
 --getMetaFinish = (os.epoch("utc")-getMetaTime).."ms"
 

 if (pass) and (username) and (key == keys.c) then
  module.fire(playerData.yaw, playerData.pitch, power, breakBlocks)
 elseif (pass) and (username) and (key == keys.semicolon) then
  --Flip the state, Its a mess i know...
  breakBlocks = not breakBlocks
  
  print("Current break state: "..tostring(breakBlocks))
 elseif (pass) and (username) and (key == keys.v) then
  module.launch(playerData.yaw, playerData.pitch, 4)
 elseif (pass) and (username) and (key == keys.x) then
  killTarget(module, module)
 elseif (pass) and (username) and (key == keys.g) then
  aimTarget(module, module, {["minecraft:player"]=true, ["minecraft:arrow"]=true})
 end
 --getWholeFinish = (os.epoch("utc")-getWholeTime).."ms"
 --print(("NT: %s, MT: %s, WT: %s"):format(getNameFinish, getMetaFinish, getWholeFinish))
 ::skipCycle::
end end

parallel.waitForAny(function() pcall(main) end) --fuck this shit, It will crash since the way the replethora devs implemented the module, It will hard error if ANYTHING goes wrong, Im not going to wrap ever fuck method in pcall just to fix you're lazy coding.
--God forbid the player dies mid exec, **HARD ERROR!**
