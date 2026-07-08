--This project is under the CC-BY-4.0 license
--https://github.com/morgatronday1234
--Read the license!

chat = peripheral.wrap("right")
dNight = peripheral.wrap("minecraft:dispenser_1")
dDay = peripheral.wrap("minecraft:dispenser_0")
drone = peripheral.wrap("drone_interface_0")
pl = peripheral.wrap("playerDetector_0")

--Players banned from commands
blacklist = {
}

--Vscode breaks this...
sgchar = utf8.char(21)

--drone TPA block vars
minPressure = 5.0


--Help function, Do not touch.--
function help()
 htext = sgchar.."oCommands:\n "
 for command, info in pairs(helpIndex) do
  htext = htext.."\""..command.."\": "..info.."\n"
 end

 chat.sendMessageToPlayer(htext, user, "WIP", "<>")
 print(user, message, isHidden)
end
--Help end--


--Time shifter block--
function day()
 redstone.setOutput("front", true)
 os.sleep(0.1)
 redstone.setOutput("front", false)

 print(user, message, isHidden)
 chat.sendMessageToPlayer(sgchar.."oSet to day (If not run $</>amount)", user, "WIP", "<>")
end

function night()
 redstone.setOutput("back", true)
 os.sleep(0.1)
 redstone.setOutput("back", false)

 print(user, message, isHidden)
 chat.sendMessageToPlayer(sgchar.."oSet to night (If not run $</>amount)", user, "WIP", "<>")
end

function amount()
 dNightList = dNight.list()
 dDayList = dDay.list()
 
 nightCount = 0
 dayCount = 0
 for _, dnli in pairs(dNightList) do
  nightCount = nightCount +dnli.count
 end
 for _, ddli in pairs(dDayList) do
  dayCount = dayCount +ddli.count
 end

 atext = sgchar.."oCurrent amounts:\n night: "..nightCount.."\n day: "..dayCount
 chat.sendMessageToPlayer(atext, user, "WIP", "<>")
 print(user, message, isHidden)
end
--Time shifter block end--





--Drone TPA block--
 function returnHome()
 drone.addArea(234, 173, 2123)--Charger pos
 drone.setAction("teleport")
 drone.clearArea()
 repeat
   os.sleep(0.3)
 until (drone.isActionDone() == true)
end

function tpToPlayer(player)
 players = pl.getOnlinePlayers()

 pass = false
 for _, curPlayer in pairs(players) do
  if (curPlayer == player) then
   pass = true 
   break
  end
 end
 
 if (drone.getDronePressure() < minPressure) then
  return false, "low pressure"
 end

 if (pass == true) then
  playerData = pl.getPlayerPos(player)
  if not (playerData.dimension == "minecraft:overworld") then return end
  
  drone.addArea(playerData.x, playerData.y, playerData.z)
  drone.setAction("teleport")
  repeat
   os.sleep(0.3)
  until (drone.isActionDone() == true)
  drone.clearArea()
  return true
 elseif (pass == false) then
  return false, "invald player"
 end
end

function importPlayer(player)
 playerData = pl.getPlayerPos(player)
 --drone.addWhitelistText("@player")

 pos1, pos2 = {playerData.x-1, playerData.y-1, playerData.z-1}, {playerData.x+1, playerData.y+1, playerData.z+1}
 drone.addArea(pos1[1], pos1[2], pos1[3], pos2[1], pos2[2], pos2[3], "Filled")
 drone.setAction("entity_import")
 os.sleep(2)
 drone.abortAction()--Doesn't abide by isActionDone, So we abort it to prevent it from regrabing you.
 drone.clearArea()

 return true
end

function exportPlayer()
 dx, dy, dz = drone.getDronePosition()

 drone.addArea(dx, dy, dz)
 drone.setAction("entity_export")
 drone.clearArea()
end

function droneMain()
 print("tp1", tpToPlayer(user))
 importPlayer(user)
 print("tp2", tpToPlayer(string.gsub(message, "</>tpa ", "")))
 exportPlayer()
 os.sleep(1.1)

 returnHome()
end
--Drone TPA block end--



--This is just the help index, This is for the help command. If you want to add a new command do that in the commands table
helpIndex = {
 ["</>day"] = "Sets the time to day",
 ["</>night"] = "Set the time to night",
 ["</>amount"] = "Show the remaining tablets left",
 ["</>tpa"] = "Its a TPA command, Its very buggy, best not to use; Expects a playername",
 ["</>help"] = "Tells you the current commands and what they do. (New commands will be shown here)"
}

--New commands get added here, The help index is above
commands = {
 ["</>day"] = day,
 ["</>night"] = night,
 ["</>amount"] = amount,
 ["</>help"] = help,
 ["</>tpa"] = droneMain
}

--Thing is the thing that checks for commands
while(true) do
 event, user, message, _, isHidden = os.pullEvent("chat")

 pass = true
 for _, bname in pairs(blacklist) do
  if (bname == user) then
   pass = false
  end
 end
 
 for command, func in pairs(commands) do
  if (string.find(message, command) == 1) and (isHidden == true) and (pass == true) then
   func()
  elseif (pass == false) then
   chat.sendMessageToPlayer(sgchar.."c"..sgchar.."oWarning you are blacklisted from using these commands")
   print("(blacklisted)", user, message, isHidden)
  end
 end
end
--This project is under the CC-BY-4.0 license
--https://github.com/morgatronday1234
--Read the license!
