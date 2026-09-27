--Made by morgatron
--https://github.com/morgatronday1234/Random-stuff/

expect = require("cc.expect").expect

local storageIntr = peripheral.wrap("sc-goodies:diamond_chest_280")
--print(textutils.serialise(storageIntr))
function getSlotsUsed(chestPeriph)
 expect(1, chestPeriph, "table")
 
 local totalSlotsUsed = 0 
 for _, slot in pairs(chestPeriph.list()) do
  totalSlotsUsed = totalSlotsUsed+1
 end

 return totalSlotsUsed
end

function skulkerStore() while(true) do
 if (storageIntr) and (getSlotsUsed(storageIntr) > 0) then
  for slot, _ in pairs(storageIntr.list()) do
   storageIntr.pushItems("sc-goodies:iron_chest_437", slot)
  end
 else
  os.sleep(1)
 end
end end
