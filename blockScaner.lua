local expect = require("cc.expect")
local modules = peripheral.wrap("back")

local relitivePos = assert(vector.new(gps.locate()), "Failed to get starting relitve POS, This needs a modem")
local filterBlocks = {
 "minecraft:obsidian",
 "minecraft:stone"
}

print("Int pos: ", relitivePos)
local function getPosDiff()
 local currentPos = vector.new(gps.locate())
 local diffPos = vector.new(
  math.floor(relitivePos.x)-math.floor(currentPos.x),
  math.floor(relitivePos.y)-math.floor(currentPos.y),
  math.floor(relitivePos.z)-math.floor(currentPos.z)
 )
 return diffPos
end

local function getBlocks(scanner)
 expect(1, scanner, "table")
 assert(scanner.scan, "Expected scanner")
 
 local blocks = scanner.scan()
 return blocks
end
 
local debugFlag = false
local function keyInList(list, key)
 if (debugFlag == true) then
  print(textutils.serialise(list), key)
  debugF = false
 end

 for _, v in pairs(list) do
  
  if (v == key) then
   return true
  end
 end
 
 return false 
end


--Relitive to relitivePos anchor
local relitiveBlocks = {} setmetatable(relitiveBlocks, {["__index"]=table})
while(true) do
 local _, ke = os.pullEvent("key_up")
 
 if (ke == keys.r) then
  local deltaVec = getPosDiff()
  local localBlocks = getBlocks(modules)
  
  for _, block in pairs(localBlocks) do     
   if (keyInList(filterBlocks, block.name)) then
    relitiveBlocks:insert(deltaVec-vector.new(block.x, block.y, block.z))
    --break
   end
  end
  
  print(#relitiveBlocks)  
 elseif (ke == keys.g) and (#relitiveBlocks > 0) then
  print(("%s Total coords"):format(#relitiveBlocks))
  
  print("Removing duplecate coords...")
  local knownCoords = {} setmetatable(knownCoords, {["__index"]=table})
  local totalRemovedCount = 0
  for index, value in pairs(relitiveBlocks) do
   local coordString = ("%s~%s~%s"):format(math.floor(value.x), math.floor(value.y), math.floor(value.z))


   if (knownCoords[coordString] == true) then
    relitiveBlocks:remove(index+totalRemovedCount)
    totalRemovedCount = totalRemovedCount +1
   else
    knownCoords[coordString] = true
   end
  end

  print(("Done, Cleared %s duplecate coords."):format(totalRemovedCount))
  
  print("Export ready.\nExport as?:")
  local fileName = assert(read(), "Expected a filename! (Without extention)")
  assert(fileName ~= "", "Expected a filename! (Without extention)")

  print("Exporting...")
  print("Converting to JSON...") local jsonConvertStart = os.epoch("utc")
  local blockJson = textutils.serialiseJSON(relitiveBlocks)
  print(("Done! (%ss)"):format((os.epoch("utc")-jsonConvertStart)/1000))
  

  print(("Writing to file... (%s)"):format(fileName)) local fileWriteStart = os.epoch("utc")
  local file = fs.open(tostring(fileName)..".mesf", "w")
  file.write(blockJson)
  file.close()
  print(("Done! (%ss)"):format((os.epoch("utc")-fileWriteStart)/1000))
  
  error("Complete.")
 end
end

