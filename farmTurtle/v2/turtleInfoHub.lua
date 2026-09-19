--Made by Morgatron
--https://github.com/morgatronday1234/Random-stuff/blob/main/Replethora-Laser-Turret.lua


local monitor = peripheral.wrap("monitor_1013")
local modem = peripheral.wrap("modem_6697")
local scanner = peripheral.wrap("manipulator_103")
local expect = require("cc.expect")

local deviceId = "provider#1"
--Outbound
--[[
{
 ["data"] = {
  ["bushesReady"] = 0,
  ["totalBushes"] = 0
 },
 ["deviceId"] = "provider#1"
}
--]]


function getBlocks(blocks, filter)
 local bushes = {}
 for _, block in pairs(blocks) do
  if (block.name:find(filter)) then
   table.insert(bushes, block)
  end
 end
 
 return bushes
end

while(true) do
 local blockScan = scanner.scan()

 local bushes = getBlocks(blockScan, "berry")
 local totalReadyBushes = 0 
 for _, bush in pairs(bushes) do
  if (bush.state.age == 3) then
   totalReadyBushes = totalReadyBushes +1
  end
 end 
 
 local tomatos = getBlocks(blockScan, "tomato")
 local totalReadyTomatos = 0 
 for _, tomato in pairs(tomatos) do
  if (tomato.state.age == 3) then
   totalReadyTomatos = totalReadyTomatos +1
  end
 end 

 modem.transmit(42424, 0, {["data"] = {["bushesReady"] = totalReadyBushes, ["totalBushes"] = #bushes, ["tomatosReady"] = totalReadyTomatos, ["totalTomatos"] = #tomatos}, ["deviceId"] = deviceId})
 os.sleep(3)
end

