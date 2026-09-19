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

monitor.setPaletteColor(colors.purple, 0x443399)
monitor.setPaletteColor(colors.lime, 0x00ff99)
monitor.setTextScale(1)
monitor.setTextColor(colors.lime)
monitor.setBackgroundColor(colors.purple)
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
 
 --berry render stuff
 term.setCursorPos(1, 1) monitor.setCursorPos(1, 2)
 local pers, rem = math.floor((totalReadyBushes/#bushes)*100), (#bushes-totalReadyBushes)
 term.clear() monitor.clear()

 print(("Berry Bushes Ready: \n%s%% (%s/%s)"):format(pers, totalReadyBushes, #bushes))
 monitor.write(("%s"):format(string.rep(string.char(0x7f), pers/5.7)..string.rep(string.char(0x11), rem/5.7)))
 monitor.setCursorPos(1, 3) 
 monitor.write(("%i%% (%i/%i)"):format(pers, totalReadyBushes, #bushes))

 -- tomato stuff
 term.setCursorPos(1, 3) monitor.setCursorPos(1, 4)
 local pers, rem = math.floor((totalReadyTomatos/#tomatos)*100), (#tomatos-totalReadyTomatos)

 print(("Tomatos Vines Ready: \n%s%% (%s/%s)"):format(pers, totalReadyTomatos, #tomatos))
 monitor.write(("%s"):format(string.rep(string.char(0x7f), pers/5.7)..string.rep(string.char(0x11), rem/5.7)))
 monitor.setCursorPos(1, 5) 
 monitor.write(("%i%% (%i/%i)"):format(pers, totalReadyTomatos, #tomatos))

 modem.transmit(42424, 0, {["data"] = {["bushesReady"] = totalReadyBushes, ["totalBushes"] = #bushes, ["tomatosReady"] = totalReadyTomatos, ["totalTomatos"] = #tomatos}, ["deviceId"] = deviceId})
 os.sleep(3)
end

