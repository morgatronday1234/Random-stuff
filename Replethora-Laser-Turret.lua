--Made by Morgatron & GlingusMcDingus(@genericdumbcat)
--https://github.com/morgatronday1234/Random-stuff/blob/main/Replethora-Laser-Turret.lua

require(killMobs) --https://github.com/morgatronday1234/Random-stuff/blob/main/killMobs.lua
local expect = require("cc.expect").expect
local mobs = peripheral.wrap("right")
local laser = peripheral.wrap("left")


while(true) do
 killTarget({
   --["minecraft:item_frame"]=true,
   --["minecraft:pig"]=true,
   ["minecraft:wither"]=true,--Pray this never happens.
   ["minecraft:creeper"]=true,
   ["minecraft:zombie"]=true,
   ["minecraft:skeleton"]=true,
   ["minecraft:phantom"]=true,
   ["minecraft:slime"]=true,
   ["minecraft:cave_spider"]=true,
   ["minecrafr:breeze"]=true,
   ["minecraft:boogged"]=true,
   ["minecraft:wind_charge"]=true,
   ["minecraft:pillager"]=true,
   ["minecraft:spider"]=true,
   ["minecraft:enderman"]=true
  })
end
