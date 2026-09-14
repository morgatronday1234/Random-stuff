local ferns = {peripheral.find("minecraft:furnace")}

local fuelChest = peripheral.wrap("")
local inputChest = peripheral.wrap("")
local outputChest = peripheral.wrap("")
local dumpTrigger, dumpTriggerSide = peripheral.wrap("") --[[redstone]], "front"


local function fuelLoop() while(true) do 
 for slot, item in pairs(fuelChest.list()) do
  local fuelSplitPer = math.max((#ferns/item.count), 1)
  --print(("%s: %s"):format(item.name, fuelSplitPer))
  
  for _, furn in pairs(ferns) do
   local fernSlot = 2
   --print(peripheral.getName(fuelChest), slot, fuelSplitPer, fernSlot)
   local amount = furn.pullItems(peripheral.getName(fuelChest), slot, fuelSplitPer, fernSlot)
  end
 end
end end

local function inputLoop() while(true) do 
 for slot, item in pairs(inputChest.list()) do
  local inputSplitPer = math.max((#ferns/item.count), 1)
  
  for _, furn in pairs(ferns) do
   local fernSlot = 1
   local amount = furn.pullItems(peripheral.getName(inputChest), slot, inputSplitPer, fernSlot)
  end
 end
end end

local function outputLoop() while(true) do
  for _, furn in pairs(ferns) do
   local fernSlot = 3
   local amount = furn.pushItems(peripheral.getName(outputChest), fernSlot)
  end
end end

local function sleepLoop() while(true) do
 os.sleep(0.05)
end end

local function dumpCheck() while(true) do
 os.pullEvent("redstone")

 if (dumpTrigger.getInput(dumpTriggerSide) == true) then
  local totalFurn = 0
  for _, furn in pairs(ferns) do
   for i=1, 3 do
    local amount = furn.pushItems(peripheral.getName(outputChest), i)
    print(("[%s] [%s], Amount moved: [%s]"):format(peripheral.getName(furn), i, amount))
   end
   totalFurn = totalFurn +1
  end

  print(totalFurn, " Furns searched")
 end
end end

parallel.waitForAll(fuelLoop, inputLoop, outputLoop, sleepLoop, dumpCheck)
