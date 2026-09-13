local expect = require("cc.expect")
local scanner = peripheral.wrap("left")
local args = {...}
local enableSpeaker = false

assert(args[1], "Argument #1: Expect enchantment ID")
assert(args[2] and (type(tonumber(args[2]) == "number")), "Argument #2: Expect enchantment level")
os.setComputerLabel("Villager roller | "..tostring(args[1]):gsub(".+:", ""))

local function entDist(ent)
 expect(1, ent, "table")
 local vec = vector.new(ent.x, ent.y, ent.z)
 local dist = math.sqrt((vec.x^2)+(vec.y^2)+(vec.z^2))
 
 return dist
end

local function getClosestEnt(ents)
 expect(1, ents, "table")
 
 local closestEnt = {}
 local closestEntDist = 32
 
 for _, ent in pairs(ents) do
  local curEntDist = entDist(ent)
  
  if (curEntDist < closestEntDist) then
   closestEntDist = curEntDist
   closestEnt = ent
  end
 end

 closestEnt["dist"] = closestEntDist
 return closestEnt
end

function getEntsByIds(ents, keys)
 expect(1, ents, "table")
 if (keys == nil) then key = true end --Bypass the key if key was not passed
 
 local matchingEnts = {}
 setmetatable(matchingEnts, {["__index"]=table})
 
 for _, ent in pairs(ents) do
  if (keys[ent.key] == true) or (key == true) then
   matchingEnts:insert(ent)
  end
 end
 
 return matchingEnts
end

local function cycleTrade()
 local ingameTime = os.time("ingame")
 if (ingameTime > 17) or (ingameTime < 6) then
  print(("Out of job hours (%s), Sleeping..."):format(ingameTime))
  os.sleep(60)
 else
  turtle.digDown()
  turtle.placeDown()
  os.sleep(3)
 end
end
--trades[2].sellItem.getMetadata().enchantments[1].name

local function beep()
 turtle.select(16)
 turtle.equipRight()
 peripheral.call("right", "playSound", "minecraft:block.beacon.activate", 3.0)
 turtle.equipRight()
 turtle.select(1)
end

local filteredEnts = getEntsByIds(scanner.sense(), {["minecraft:villager"]=true})
local closestEntBasic = getClosestEnt(filteredEnts)
assert(not (closestEntBasic) or not (closestEntBasic.dist > 4), "No villagers in range")

local totalRolls = 0
local totalEnchants = 0
local startTime = os.epoch("utc")
local canRun = true
while(canRun) do 
 local closestEnt = scanner.getMetaByID(closestEntBasic.id)
 
 if (closestEnt.trades) then
  for _, trade in pairs(closestEnt.trades) do
   local tradeItemData = trade.sellItem.getMetadata()
   if (tradeItemData.enchantments) and (math.abs(tradeItemData.enchantments[1].level) >= math.abs(tonumber(args[2]))) and (tradeItemData.enchantments[1].name == args[1]) then
    print(("Trade found!\nEnchantment: %s, Level: %s\nTotal Time: %s, Total Rolls: %s, Total Enchantment Rolls: %s"):format(tradeItemData.enchantments[1].displayName, tradeItemData.enchantments[1].level, ((os.epoch("utc")-startTime)/1000).."s", totalRolls, totalEnchants))
    if (enableSpeaker) then beep() end
    
    totalEnchants = totalEnchants +1
    canRun = false
   elseif (tradeItemData.enchantments) then
    print(("Found enchant, But not right trade: %s %s"):format(tradeItemData.enchantments[1].name, tradeItemData.enchantments[1].level))
    totalEnchants = totalEnchants +1
   end
  end
 end
 totalRolls = totalRolls +1
 
 if (canRun) then
  cycleTrade()
 end
end
