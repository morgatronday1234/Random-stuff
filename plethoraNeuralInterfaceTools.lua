require("killMobs")
local expect = require("cc.expect")
local module = peripheral.wrap("back")


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

local function getSelf(sensor)
 expect(1, sensor, "table")
 
 local ents = sensor.sense()
 local filteredEnts = getKeysInRange(ents, {["minecraft:player"]=true})
 local selfEnt = getClosestEnt(filteredEnts)

 if (selfEnt) then
  return true, selfEnt
 else
  return false, "Failed to get self"
 end
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

  --getMetaTime = os.epoch("utc")
 --Will dynamicly switch between a mob sensor and and introspction module; Be warned the sensor is slower.
 local metaPlayerData = nil
 local pass, playerData = nil, nil
 if (module.getMetaOwner) then
  metaPlayerData = module.getMetaOwner()
  pass, playerData = true, metaPlayerData
  if not (warnFlagI) then print("Loaded using introspc") warnFlagI = true end
 elseif not (metaPlayerData) then
  pass, playerData = getSelf(module)
  if not (warnFlagS) then print("Loaded using sensor") warnFlagS = true end
 end

 
 if not (pass) or not (playerData) then
  print("Failed to read player data, Skipping cycle")
  goto skipCycle --I shouldn't have to fucking use byte code keywords just to get modules to not crash, Im not fucking going to wrap everthing in pcall.
 end
 --getMetaFinish = (os.epoch("utc")-getMetaTime).."ms"
 

 if (pass) and (playerData) and (key == keys.c) then
  module.fire(playerData.yaw, playerData.pitch, power, breakBlocks)
 elseif (pass) and (playerData) and (key == keys.semicolon) then
  --Flip the state, Its a mess i know...
  breakBlocks = not breakBlocks
  
  print("Current break state: "..tostring(breakBlocks))
 elseif (pass) and (playerData) and (key == keys.v) then
  module.launch(playerData.yaw, playerData.pitch, 4)
 elseif (pass) and (playerData) and (key == keys.x) then
  killTarget(module, module)
 elseif (pass) and (playerData) and (key == keys.g) then
  aimTarget(module, module, {["minecraft:player"]=true, ["minecraft:arrow"]=true})
 end
 --getWholeFinish = (os.epoch("utc")-getWholeTime).."ms"
 --print(("NT: %s, MT: %s, WT: %s"):format(getNameFinish, getMetaFinish, getWholeFinish))
 ::skipCycle::
end end

main()
parallel.waitForAny(function() pcall(main) end) --fuck this shit, It will crash since the way the replethora devs implemented the module, It will hard error if ANYTHING goes wrong, Im not going to wrap ever fuck method in pcall just to fix you're lazy coding.
--God forbid the player dies mid exec, **HARD ERROR!**
