require("killMobs")
local module = peripheral.wrap("back")



local breakBlocks = false
local power = 5
function main() while(true) do
 local event, key, held = os.pullEvent("key")
 --getWholeTime = os.epoch("utc")
 --getNameTime = os.epoch("utc")
 local pass, username = pcall(module.getName)
 --getNameFinish = (os.epoch("utc")-getNameTime).."ms"

 --getMetaTime = os.epoch("utc")
 local playerData = module.getMetaOwner()
 --getMetaFinish = (os.epoch("utc")-getMetaTime).."ms"
 

 if (pass) and (username) and (key == keys.c) then
  module.fire(playerData.yaw, playerData.pitch, power, breakBlocks)
 elseif (pass) and (username) and (key == keys.semicolon) then
  --Flip the state, Its a mess i know...
  breakBlocks = not breakBlocks
  
  print("Current break state: "..tostring(breakBlocks))
 elseif (pass) and (username) and (key == keys.v) then
  module.launch(playerData.yaw, playerData.pitch, 4)
 elseif (pass) and (username) and (key == keys.x) then
  killTarget()
 end
 --getWholeFinish = (os.epoch("utc")-getWholeTime).."ms"
 --print(("NT: %s, MT: %s, WT: %s"):format(getNameFinish, getMetaFinish, getWholeFinish))
end end

parallel.waitForAny(main)
