--Made by Morgatron & GlingusMcDingus(@genericdumbcat)
--https://github.com/morgatronday1234/Random-stuff/

local expect = require("cc.expect").expect
local modules = peripheral.wrap("back")
local mobs, laser = modules, modules

function entDist(ent)
 expect(1, ent, "table")
 local vec = vector.new(ent.x, ent.y, ent.z)
 local dist = math.sqrt((vec.x^2)+(vec.y^2)+(vec.z^2))
 
 return dist
end

--Fake test ent
--[[
entDist({
 ["x"]= 1.5,
 ["y"]= 6.3,
 ["z"]= 2.1
})
--]]
--error("BREAK#2")

function getKeysInRange(ents, keys)
 expect(1, ents, "table")
 if (keys == nil) then key = true end --Bypass the key if key was not passed
 
 local matchingEnts = {}
 setmetatable(matchingEnts, {["__index"]=table})
 
 for _, ent in pairs(ents) do
  if (keys[ent.key] == true) or (key == true) then
   setmetatable(ent, {["__index"]={["dist"]=entDist}})
   matchingEnts:insert(ent)
  end
 end
 
 return matchingEnts
end

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

function getClosestEnt(ents)
 expect(1, ents, "table")
 
 --print(#ents)
 local closestEnt = {}
 local closestEntDist = 32
 
 for _, ent in pairs(ents) do
  local curEntDist = ent:dist()--Please just fucking work  
  
  if (curEntDist < closestEntDist) then
   closestEntDist = curEntDist
   closestEnt = ent
  end
  --error("BREAK")
 end
 
 --print(textutils.serialise(closestEnt))
 return closestEnt
end

local function targ(laser, ent)
 expect(1, laser, "table")
 expect(2, ent, "table")
 if not (ent.x) or not (ent.y) or not (ent.z) then
  error(("Agument #1: Invaild entity: %s"):format(textutils.serialise(ent)))
 end
 
 ent.x = ent.x +ent.motionX
 ent.y = ent.y +ent.motionY
 ent.z = ent.z +ent.motionZ
 --local shitToShoot = getKeyInRange(modules.sense(), "minecraft:item_frame")
 local targYaw = math.deg(math.atan2(-ent.x, ent.z))
 local targPitch = math.deg(math.atan2(ent.y, math.sqrt((ent.x^2)+(ent.z^2))))
 
 --print(("yaw: %s\nPitch: %s\n"):format(targYaw, -targPitch))
 laser.fire(targYaw, -targPitch, 5, false)
end


function killTarget(laser, sensor, listOfTargets)
 if not (listOfTargets) then 
  listOfTargets = {
   --["minecraft:item_frame"]=true,
   --["minecraft:pig"]=true,
   ["minecraft:wither"]=true,--Pray this never happens.
   ["minecraft:creeper"]=true,
   ["minecraft:zombie"]=true,
   ["minecraft:skeleton"]=true,
   ["minecraft:phantom"]=true,
   ["minecraft:slime"]=true,
   ["minecraft:cave_spider"]=true,
   ["minecrafr:breeze"]=true,
   ["minecraft:boogged"]=true,
   ["minecraft:wind_charge"]=true,
   ["minecraft:pillager"]=true,
   ["minecraft:spider"]=true,
   ["minecraft:enderman"]=true
  }
 end
 local shitToCheck = sensor.sense()
 local checkedShit = getKeysInRange(shitToCheck, listOfTargets) 
 local target = getClosestEnt(checkedShit)

 if (target.x) then
  --Don't look here, For your own sanity.
  target.y = target.y+ 0.1
  
  --print(textutils.serialise(checkedShit))
  targ(laser, target)
 else
  os.sleep(0.1)
 end
end
