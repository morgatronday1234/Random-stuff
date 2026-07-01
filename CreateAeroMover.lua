--This project is under the CC-BY-4.0 license
--https://github.com/morgatronday1234
--Read the license!

local left, right = peripheral.wrap("Create_SequencedGearshift_1"), peripheral.wrap("Create_SequencedGearshift_0")
local modem = peripheral.wrap("top")
local shifter = peripheral.wrap("front")
local shaftPerDeg = 360/19.6
local shaftBlockMod = 19.6*2.4

--unfuck stuff
shifter.setOutput("right", false)
shifter.setOutput("left", false)

local function getRot()
 local pitch, yaw, roll = sublevel.getLogicalPose().orientation:toEuler()
 local rot = {
  ["pitch"] = ((math.deg(pitch)%360)+360)%360,
  ["yaw"] = ((math.deg(yaw)%360)+360)%360,
  ["roll"] = ((math.deg(roll)%360)+360)%360
 }
 
 return rot
end

local function getPos()
 return sublevel.getLogicalPose().position
end

local car = {} --Watch as I define a table with nothing just so I can use in its self ::3
car = {
 ["turnRight"] = function(input)
  shifter.setOutput("left", true)
  right.rotate(math.floor(input*shaftPerDeg))
  left.rotate(math.floor(input*shaftPerDeg))
  
  while(right.isRunning() or left.isRunning()) do os.sleep(0.1) end
  shifter.setOutput("left", false)
 end,
 
 ["turnLeft"] = function(input)
  shifter.setOutput("right", true)
  
  right.rotate(math.floor(input*shaftPerDeg))
  left.rotate(math.floor(input*shaftPerDeg))
  while(right.isRunning() or left.isRunning()) do os.sleep(0.1) end
  shifter.setOutput("right", false)
 end,
 
 ["rotateTo"] = function(angle)
  local curYaw = getRot().yaw
  local diff = ((angle-curYaw+540)%360)-180
  
  --print("curYaw:", curYaw, "\nrotTarget:", angle, "\nrotDiff:", diff, "\n")
  if (math.abs(diff) < 1) then 
   return 
  end
        
  if diff > 0 then
  -- print(diff)
   car.turnLeft(diff)
  elseif diff < 0 then
  -- print(diff)
   car.turnRight(-diff)
  end
 end,
 
 ["forward"] = function(amount)
 -- print("F started")
  shifter.setOutput("right", true)
  shifter.setOutput("left", true)
  
  left.rotate(amount*shaftBlockMod)
  right.rotate(amount*shaftBlockMod)
  
  while(left.isRunning() or right.isRunning()) do os.sleep(0.1) end
  shifter.setOutput("right", false)
  shifter.setOutput("left", false)
 -- print("F end")
 end,
 
 ["gotoVec"] = function(targ)
  local self = getPos()
  --print("self: ", self)
  
  local targAngle = math.deg(math.atan2(
   targ.x-self.x,
   targ.z-self.z
  ))
  
  local distToTarg = math.sqrt(
   ((targ.x-self.x)^2)+
   ((targ.z-self.z)^2)
  )
  --print(("tx: %f, tz: %f\nsx: %f, sz: %f"):format(targ.x, targ.z, self.x, self.z))
  
  print("selfAngle", getRot().yaw, "\ntargAngle: ", targAngle, "\nDist: ", distToTarg, "\n")
  car.rotateTo(targAngle)
  
  car.forward(distToTarg)
 end
}

--right.rotate(60)
--car.turnRight(100)
--car.turnLeft(100)
--car.forward(10)
--car.rotateTo(getRot().yaw+180)

targets = {
 vector.new(-9832, 64, 781),
 vector.new(-9840, 66, 799)
}


while(true) do
 for _, targ in pairs(targets) do
  car.gotoVec(targ)
  createLine(getPos(), targ)
 end
end
