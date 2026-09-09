--Made by morgatron
--https://github.com/morgatronday1234/Random-stuff

expect = require("cc.expect").expect


--Log file, Set to nil for no logging to file
local logFile = "/storageLog.log" 
--Wake trigger, Makes the sorter check the chest on trigger; Comment out line to disable.
local dumpButton, buttonSide = peripheral.wrap("redstone_relay_720"), "right" 

local storageChests = {
 --Keys are priority, Lower number means higher priority.
 [1] = "sc-goodies:diamond_chest_274",
 [2] = "sc-goodies:diamond_chest_279",
 [3] = "sc-goodies:diamond_chest_275",
 [4] = "sc-goodies:diamond_chest_278",
 [5] = "sc-goodies:diamond_chest_276",
 [6] = "sc-goodies:diamond_chest_277"
}

local dumpChests = {
 --Chest(s) that sort into the storage clusters
 "sc-goodies:iron_chest_437"
}


--Lasy helper function so I can use table: on these 
--without defining it via __index
function newChestType()
 local newChest = {}
 local indexOfBs = table
 setmetatable(newChest, {["__index"]=indexOfBs})
 
 return newChest
end

function betterSer(p)
 expect(1, p, "table")

 for k, v in pairs(p) do
  print(k, v)
 end
end

function log(data)
 local text = ("[%s] [info]: %s"):format(os.date("%I:%M%p", os.time("utc")), data)
 print(text)
 
 if (logFile) then
  file = fs.open(logFile, "w")
  file.write(text.."\n")
  file.close()
 end
end

function getSlotsUsed(chestPeriph)
 expect(1, chestPeriph, "table")
 
 local totalSlotsUsed = 0 
 for _, slot in pairs(chestPeriph.list()) do
  totalSlotsUsed = totalSlotsUsed+1
 end

 return totalSlotsUsed
end

local boundChests = newChestType()
for _, peripheralId in ipairs(storageChests) do
 boundChests:insert(peripheral.wrap(peripheralId))
end

local boundDumps = newChestType()
for _, peripheralId in pairs(dumpChests) do
 boundDumps:insert(peripheral.wrap(peripheralId))
end



--This a horrable way to do this, Its fucking slow as shit, And almost no checks are done, But it works for now; And I've got alot to fix. I hope I'll come back to this at somepoint.
--@argument [1] dump (Or input) chest of type peripheral
--@argument [2] numarical table of peripherals for sorting (or output), Key will be used for priority.
--@optional [3] boolean of if it should keep trying the current dump chest until its empty, Defaults to True.
function storeDump(curDump, peripChests, keepTrying)
 expect(1, curDump, "table")
 expect(2, peripChests, "table")
 expect(3, keepTrying, "boolean", "nil")
 if not (keepTrying) then local keepTrying = true end 
 
 local totalItemsMoved = 0 
 --betterSer(curDump)
 
 log(("Checking dump: %s"):format(peripheral.getName(curDump)))
 --What?
 for _, chest in ipairs(peripChests) do
  log(("Targeting chest: %s"):format(peripheral.getName(chest)))
  
  --If the dump chest is empty then break the loop for this dump chest.
  if (getSlotsUsed(curDump) == 0) then
    log("Killed loop, Dump is empty")
   break
  end

  --Go through all of the slots in the dump chest and try to push it to the storage chest.
  for slot, slotData in pairs(curDump.list()) do
   local curMoved = curDump.pushItems(peripheral.getName(chest), slot)

   log(("targeting slot #%s"):format(slot))
   totalItemsMoved = totalItemsMoved + curMoved
  end

 end
 log(("Moved %s items from: %s"):format(totalItemsMoved, peripheral.getName(curDump)))

 if (getSlotsUsed(curDump) > 0) then
  log(("Current dump: %s, Is not empty. Rerunning..."):format(peripheral.getName(curDump)))
  storeDump(curDump, peripChests, keepTrying)
 end
end

while(true) do
 local isItemsInDumps = false
 for _, dump in pairs(boundDumps) do
  if (getSlotsUsed(dump) > 0) then
   isItemsInDumps = true
   break
  end
 end
 
 if (isItemsInDumps == true) then
  for _, dump in pairs(boundDumps) do
   storeDump(dump, boundChests, false)
  end
 else
  log("No items in dump chests, Sleeping...")

  parallel.waitForAny(function() 
   os.sleep(60*5) --Sleep between looks, This is horrably optimized.  
   return 
  end, function() 
   os.pullEvent("redstone") 
   if (dumpButton) and (dumpButton.getInput(buttonSide) == true) then 
    log("Wake triggered!")
    return
   end 
  end)

 end
end
