local expect = require("cc.expect")

--List of overflow subscribers
--If maxStackSize is empty then it will fall over to 64
--slots is a List of slots to pull overflowed items from 
local overflowSubscribers = {
 ["berrys1"] = {
  ["target"] = "sc-goodies:diamond_chest_282",
  ["slots"] = {97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108},
  ["maxStackSize"] = 64
 },
}

local overflowTarget = "ender_storage_712" --Where to dump overflowed items.


function log(level, text)
 expect(1, level, "string")
 if (text == nil) then
  text = level --When called with just ("test") it will overload into INFO level
  level = "INFO"
 end
 
 print(("[%s][%s]: %s"):format(os.date("%R%M"), level:upper(), text))
end

function main()  while(true) do if (redstone.getInput("front") == true) then
 for subiName, subi in pairs(overflowSubscribers) do
  local totalItemsTransfered = 0
  
  for _, slot in pairs(subi.slots) do
   pass, amountOrErr = pcall(peripheral.call, subi.target, "pushItems", overflowTarget, slot, subi.maxStackSize or 64)
   
   --error("TMP ERR")
   if (pass == false) then
    log("error", ("Failed to call [%s]: [%s]"):format(subiName, amountOrErr))
    break
   end
   totalItemsTransfered = totalItemsTransfered +amountOrErr
  end
  
  if (totalItemsTransfered > 0) then
   log(("Items moved from [%s]: %s"):format(subiName, totalItemsTransfered))
  end
 end
 
 os.sleep(0.1)
else os.sleep(0.5) end end  end

function killLoop()
 os.pullEventRaw("terminate")
 error("Terminated ::3")
end

parallel.waitForAll(killLoop, main)
