--Made by Morgatron
--https://github.com/morgatronday1234/Random-stuff/blob/main/Replethora-Laser-Turret.lua


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


function getBushes(blocks)
 local bushes = {}
 for _, block in pairs(blocks) do
  if (block.name:find("berry")) then
   table.insert(bushes, block)
  end
 end
 
 return bushes
end


while(true) do
 local bushes = getBushes(scanner.scan())
 
 local totalReadyBushes = 0 
 for _, bush in pairs(bushes) do
  if (bush.state.age == 3) then
   totalReadyBushes = totalReadyBushes +1
  end
 end 
 term.setCursorPos(1, 1)
 term.clear()
 print(("Berry Bushes Ready: \n%s%% (%s/%s)"):format(math.floor((totalReadyBushes/#bushes)*100), totalReadyBushes, #bushes))
 
 modem.transmit(42424, 0, {["data"] = {["bushesReady"] = totalReadyBushes, ["totalBushes"] = #bushes}, ["deviceId"] = deviceId})
 os.sleep(3)
end

