--Made by Morgatron
--https://github.com/morgatronday1234/Random-stuff/blob/main/Replethora-Laser-Turret.lua


local kinetic = peripheral.wrap("right")
local modem = peripheral.wrap("left")

local selfTurtle = "berry#1"
modem.open(42424)

--Inbound
--[[
{
 ["data"] = {
  ["bushesReady"] = 0,
  ["totalBushes"] = 0
 },
 ["deviceId"] = "provider#1"
}
--]]

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

--If we ever fully fill the turtle up, Then I call that a win; This isn't a 
local function refuel()
 turtle.turnLeft()
   
 for i=1, 16 do 
  turtle.select(i)
  turtle.suck()
  turtle.refuel(64)
 end

 turtle.select(1)
 turtle.turnRight()
end


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


local function networkLoop() while(true) do
 local event, _, port, _, rawData, dist = os.pullEvent("modem_message")
 local currentTurtleFuel = turtle.getFuelLevel()

 --Validate network info
 if (port == 42424) and (dist <= 20) and (type(rawData) == "table") and (rawData.deviceId == "provider#1") then
  --Check if home, If not then do a cycle to aline.
  local pass, data = turtle.inspectDown()
  if (pass) and (data.name ~= "minecraft:cobblestone") and (currentTurtleFuel > 100) then
   print("Not at home, Trying to aline.")
   doCycle()
  elseif (currentTurtleFuel < 100) then
   error("Cannot aline to home, Not enough fuel.")
  end
  
  --Validate data
  if (rawData.data) and (type(rawData.data.bushesReady) == "number") and (type(rawData.data.totalBushes) == "number") then
   local berryPers = ((rawData.data.bushesReady/rawData.data.totalBushes)*100)
   
   print(("Berry Bushes Ready: \n%s%% (%s/%s)"):format(math.floor(berryPers), rawData.data.bushesReady, rawData.data.totalBushes))
   if (berryPers > 90) and (currentTurtleFuel > 100) then
    doCycle()
   elseif (currentTurtleFuel < 100) then
    refuel()
   end
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
