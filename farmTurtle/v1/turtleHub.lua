--Made by Morgatron
--https://github.com/morgatronday1234/Random-stuff/blob/main/Replethora-Laser-Turret.lua


local modem = peripheral.wrap("modem_6697")
local scanner = peripheral.wrap("manipulator_103")
local expect = require("cc.expect")

local activeTurtles = {}
modem.open(42425) --Callback for turtles, Say getFuel.

--Outbound
--[[
{
 ["instruct"] = "getFuel",
 ["deviceId"] = "berry#1"
}
--]]

--Inbound
--[[
{
 ["deviceId"] = "berry#1",
 ["data"] = 100
}
--]]


function connectTurtle(turtleId)
 expect(1, turtleId, "string")
 local newTurtleObject = {
  ["id"] = turtleId
 }
 
 
 function newTurtleObject:ping()
  modem.transmit(42424, 42425, {["deviceId"]=self.id, ["instruct"]="ping"})
  
  local output = "broken"
  parallel.waitForAny(function()
   --Timeout function
   os.sleep(1)
   --print("fail")
   
   output = false
   return
  end,function() while(true) do
   local event, _, port, _, data, dist = os.pullEvent("modem_message")
   
   if (port == 42425) and (dist <= 20) and (data) and (data.deviceId) and (data.deviceId == self.id) then
    --print("pass")
    
    output = data.data
    return
   end 
  end end)
  
  --print("ping output: ", output)
  return output
 end
 
 
 function newTurtleObject:getFuel()
  modem.transmit(42424, 42425, {["deviceId"]=self.id, ["instruct"]="getFuel"})

  local output = "broken"
  parallel.waitForAny(function()
   --Timeout function
   os.sleep(5)
   output = false
   return
  end, function() while(true) do
   --Networking function
   local event, _, port, _, data, dist = os.pullEvent("modem_message")
  
   if (port == 42425) and (dist <= 20) and (data) and (data.deviceId) and (data.deviceId == self.id) then
    output = data.data
    return 
   end
  end end)
  
  return output
 end
 
 function newTurtleObject:doCycle()
  modem.transmit(42424, 0, {["deviceId"]="berry#1", ["instruct"]="doCycle"})
 end
 
 --Check that you can even call the turtle.
 local pingTest = newTurtleObject:ping()
 if (pingTest ~= "pong") then
  return false, "Failed to connect turtle!"
 end
 
 table.insert(activeTurtles, newTurtleObject)
 return newTurtleObject,"Connected!"
end

function getBushes(blocks)
 local bushes = {}
 for _, block in pairs(blocks) do
  if (block.name:find("berry")) then
   table.insert(bushes, block)
  end
 end
 
 return bushes
end


local turtleObject, status = connectTurtle("berry#1")
assert(turtleObject, "Failed to connect to turtle: "..tostring(status))
print(("Connected! (%s)\nFuel: %s"):format(status, turtleObject:getFuel()))


while(true) do
 local bushes = getBushes(scanner.scan())
 
 local totalReadyBushes = 0 
 for _, bush in pairs(bushes) do
  if (bush.state.age == 3) then
   totalReadyBushes = totalReadyBushes +1
  end
 end 
 print(totalReadyBushes, "/", #bushes)
 
 local turtleFuel = turtleObject:getFuel()
 if (totalReadyBushes > 65) and (turtleFuel > 100) then
  turtleObject:doCycle()  
  
  turtleObject.doingRun = true
 elseif (turtleFuel < 100) then
  print("turtle "..tostring(turtleObject.turtleId).." low on fuel. Cannot run.")
 end
 
 if (doingRun == true) then
  os.sleep(60*2)
 else
  os.sleep(4)
 end
end

