--Made by morgatron
--https://github.com/morgatronday1234/Random-stuff/

local homeBlock = "minecraft:lime_concrete"


local layers = 0
local function doLayer()
 local layerPass, layerData = false, {}
 --If we are at the home block then get into postion
 local homePass, homeData = turtle.inspectDown()
 if (homeData.name == homeBlock) then
  turtle.dig()
  turtle.forward()
 else
  layerPass = turtle.detectUp()
 end
 
 --First spot from layer start
 turtle.dig()
 turtle.digUp()
 turtle.turnRight()
 turtle.dig()
 
 
 --Second spot from layer start
 turtle.forward()
 turtle.turnLeft()
 turtle.dig()
 
 --Return to first spot and go up in prepertion for next layer
 turtle.turnLeft()
 turtle.forward()
 turtle.turnRight()
 turtle.up()
 layers = layers +1
 
 return layerPass
end

local function goHome()
 for i=1, layers do
  turtle.down()
 end
 turtle.back()
end

local layersWithoutWood = 0
repeat
 if not (layerPass) then
  layersWithoutWood = layersWithoutWood +1
 else
  layersWithoutWood = 0
 end

 local layerPass = doLayer()
until (layersWithoutWood >= 3)
goHome()
