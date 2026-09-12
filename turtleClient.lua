--Made by Morgatron
--https://github.com/morgatronday1234/Random-stuff/blob/main/Replethora-Laser-Turret.lua


local kinetic = peripheral.wrap("right")
local modem = peripheral.wrap("left")

local selfTurtle = "berry#1"
modem.open(42424)

local debugFlag = false


local function log(text)
 print(("[Info]: %s"):format(text))
end

local blockCommands = {
 ["minecraft:lime_concrete"] = turtle.turnRight,
 ["minecraft:gray_concrete"] = turtle.turnLeft,
 ["minecraft:cobblestone"] = function() 
  local pass, data = turtle.inspectUp()
  local chest = peripheral.wrap("top")
  
  --Check that theres a chest there and it binded.
  if (pass) and (chest) then
   local totalItems = 0
   for _, item in pairs(chest.list()) do
    totalItems=totalItems +item.count
   end
   
   if (totalItems >= (chest.size()*64)) then
    error("[SafeError]: Warning, Chest full!")
   end
   
   for i=1, 16 do
    turtle.select(i)
    turtle.dropUp()
   end
   turtle.select(1)
  else
   log("Waning! Unable to bind chest or not about chest. Something has failed.")
  end
  
  return "cycleEnd"
 end,
 ["minecraft:glowstone"] = function()
  turtle.turnLeft()
  kinetic.use() turtle.suck() os.sleep(0.3)
  turtle.turnRight()
  
  turtle.turnRight()
  kinetic.use() turtle.suck() os.sleep(0.3)
  turtle.turnLeft()
 end,
 ["minecraft:warped_wart_block"] = function()
  log("WARNING RUNNAWAY DETECTED, Self destructing...")
  error("WARNING RUNNAWAY DETECTED, Self destructing...")
 end
}

local function doCycle() while(true) do
 turtle.forward() turtle.suck()
 local pass, data = turtle.inspectDown()
 
 if (pass) and (blockCommands[data.name]) then
  local outData = blockCommands[data.name]()
 
  if (outData == "cycleEnd") then
   break
  end
 end
end end

if (debugFlag == true) then
 doCycle()
end

local function networkLoop() while(true) do
 local event, _, port, callBack, rawData, dist = os.pullEvent("modem_message")

 if (port == 42424) and (dist <= 20) and (type(rawData) == "table") and (rawData.deviceId) and (rawData.deviceId == selfTurtle) then
  local instruct = rawData.instruct
  --print(instruct)
     
  if (instruct == "getFuel") then
   modem.transmit(callBack, 0, {["deviceId"] = selfTurtle, ["data"]=turtle.getFuelLevel()})
  elseif (instruct == "refuel") then
   turtle.turnLeft()
   
   for i=1, 16 do 
    turtle.select(i)
    turtle.suck()
    turtle.refuel(64)
   end
   turtle.select(1)
   turtle.turnRight()
  elseif (instruct == "doCycle") then
   doCycle()
   modem.transmit(callBack, 0, {["deviceId"]=selfTurtle, ["data"]=true})
  elseif (instruct == "ping") then
   --print("pong triggered")
   modem.transmit(callBack, 0, {["deviceId"]=selfTurtle, ["data"]="pong"})
  end
  
 else
  log(("Failed to read message: [%s], [�%s] [<T>%s]: %s"):format(port, dist, type(rawData), tostring(textutils.serialise(rawData))))
 end
end end

local function fuelTickLoop() while(true) do
 os.setComputerLabel(("%s | %s"):format(selfTurtle, turtle.getFuelLevel()))
 os.sleep(0.5)
end end

function main() while(true) do
 parallel.waitForAll(networkLoop, fuelTickLoop)
end end

main()
