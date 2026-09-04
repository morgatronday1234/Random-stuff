--Made by Morgatron & GlingusMcDingus(@genericdumbcat)


local expect = require("cc.expect").expect
local mobs = peripheral.wrap("right")
local laser = peripheral.wrap("left")

--Uhh I'm jsut gonna put this here
function magnitude(x, y, z)
    return math.sqrt((x * x) + (y * y) + (z * z))
end


--[[
Knowen things: 
 Ent is valid, It contains a table with the ent data.
 The output is NaN regardless of input
 Vec is the valid data.
 
 So it has to be the sqrt() call.
--]]
function entDist(ent)
 expect(1, ent, "table")
 local vec = vector.new(ent.x, ent.y, ent.z)
 local dist = ((vec.x * vec.x)+(vec.y * vec.y)+(vec.z * vec.z))
 
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

function getClosestEnt(ents)
 expect(1, ents, "table")
 
 --print(#ents)
 local closestEnt = {}
 local closestEntDist = 0
 
 for _, ent in pairs(ents) do
  local curEntDist = ent:dist()--Please just fucking work  
  
  if (curEntDist > closestEntDist) then
   closestEntDist = curEntDist
   closestEnt = ent
  end
  --error("BREAK")
 end
 
 --print(textutils.serialise(closestEnt))
 return closestEnt
end

local function targ(ent)
 expect(1, ent, "table")
 if not (ent.x) or not (ent.y) or not (ent.z) then
  error(("Agument #1: Invaild entity: %s"):format(textutils.serialise(ent)))
 end
 
 --local shitToShoot = getKeyInRange(modules.sense(), "minecraft:item_frame")
 local targYaw = math.deg(math.atan2(-ent.x, ent.z))
 local targPitch = math.deg(math.atan2(ent.y, math.sqrt((ent.x*ent.x)+(ent.z*ent.z))))
 
 --print(("yaw: %s\nPitch: %s\n"):format(targYaw, -targPitch))
 laser.fire(targYaw, -targPitch, 2, false)
end


while(true) do
 local shitToCheck = mobs.sense()
 local checkedShit = getKeysInRange(shitToCheck, 
  {
   --["minecraft:item_frame"]=true,
   --["minecraft:pig"]=true,
   ["minecraft:wither"]=true,--Pray this never happens.
   ["minecraft:creeper"]=true,
   ["minecraft:zombie"]=true,
   ["minecraft:skeleton"]=true,
   ["minecraft:phantom"]=true,
  }
 ) 
 local target = getClosestEnt(checkedShit)

 if (target.x) then
  --Don't look here, For your own sanity.
  target.y = target.y+ 0.1
   
  --print(textutils.serialise(checkedShit))
  targ(target)
 else
  os.sleep(0.1)
 end
end
