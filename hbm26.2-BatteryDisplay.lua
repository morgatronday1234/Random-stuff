local monitors = {peripheral.find("monitor")}
local batts = {peripheral.find("ntm_energy_storage")}


--For every monitor defined apply the window prototype
local windowPrototype = {}
local nMonitors = {} setmetatable(nMonitors, {["__index"]=table})
for _, termObj in pairs(monitors) do 
 nMonitors:insert(
  setmetatable(termObj, {
   ["__index"] = windowPrototype
  })
 )
end
monitors = nMonitors --Peak metatable usage.

function windowPrototype:createInfoWin(x, y)
 local win = window.create(
  self,
  x,
  y,
  35,
  10,
  false --Make sure to toggle the setVisable flag to true!
 )
 win.w = 35
 win.h = 10
 win.fe, win.maxFe = 0, 0
 win.maxOut, win.maxIn = 0, 0
 win.IORate = 0
 win.cellType = "Error, Cell Type not defined"
 
 --print(win)
 
 function win:updateCurrentFe(fe)
  self.fe = fe
  local baseString = ("Charge: %sFe (%s%%)"):format(
   fe, math.floor((fe/win.maxFe)*100)
  )
  
  self.setCursorPos(2, 2)
  self.clearLine()
  self.blit(baseString,
   ("d"):rep(#baseString),
   ("f"):rep(#baseString)
  )
  
  return self
 end
 
 function win:updateMaxFe(maxFe)
  self.maxFe = maxFe
  local baseString = ("Max Charge: %sFe"):format(
   maxFe
  )
  
  self.setCursorPos(2, 3)
  self.clearLine()
  self.blit(baseString,
   ("5"):rep(#baseString),
   ("f"):rep(#baseString)
  )
  
  return self
 end
 
 function win:updateMaxOutput(maxOut)
  self.maxOut = maxOut
  local baseString = ("Max Output/t: %sFe"):format(
   maxOut
  )
  
  self.setCursorPos(2, 4)
  self.clearLine()
  self.blit(baseString,
   ("1"):rep(#baseString),
   ("f"):rep(#baseString)
  )
  
  return self
 end

 function win:updateMaxInput(maxIn)
  self.maxIn = maxIn
  local baseString = ("Max Input/t: %sFe"):format(
   maxIn
  )
  
  self.setCursorPos(2, 5)
  self.clearLine()
  self.blit(baseString,
   ("b"):rep(#baseString),
   ("f"):rep(#baseString)
  )
  
  return self
 end

 function win:updateIORate(IORate)
  self.IORate = IORate
  local baseString = ("Current I/O: %sFe/t"):format(
   IORate
  )
  
  self.setCursorPos(2, 6)
  self.clearLine()
  self.blit(baseString,
   ("6"):rep(#baseString),
   ("f"):rep(#baseString)
  )
  
  return self
 end

 function win:updateCellType(cellType)
  self.cellType = cellType
  local baseString = ("Cell: %s"):format(
   cellType
  )
  
  self.setCursorPos(2, 7)
  self.clearLine()
  self.blit(baseString,
   ("7"):rep(#baseString),
   ("f"):rep(#baseString)
  )
  
  return self
 end

 
 return win
end


function updateBattery(battPerip, frame)
 local battInfo = {battPerip.getInfo()}
 
 frame:updateMaxFe(battInfo[2])
 frame:updateCurrentFe(battInfo[1])
 frame:updateMaxInput(battInfo[8])
 frame:updateMaxOutput(battInfo[9])
 frame:updateIORate(battInfo[3])
 frame:updateCellType(battInfo[7]:gsub("item%.", ""):gsub("battery_pack_", ""))
 
 frame.redraw()
 frame.setVisible(true)
end

--[[
EVIL! EVIL! EVIL! EVIL! EVIL!
JUST RUN WHILE YOU CAN!
THIS SHIT IS MESSY!
]]


--1, 2;  41, 2;  84, 2;
monitors[1].setTextScale(0.5)
monitors[1].clear()
local mon1Frame1 = monitors[1]:createInfoWin(1, 2)
local mon1Frame2 = monitors[1]:createInfoWin(41, 2)
local mon1Frame3 = monitors[1]:createInfoWin(84, 2)

monitors[2].setTextScale(0.5)
monitors[2].clear()
local mon2Frame1 = monitors[2]:createInfoWin(84, 2)
local mon2Frame2 = monitors[2]:createInfoWin(41, 2)
local mon2Frame3 = monitors[2]:createInfoWin(1, 2)


while(true) do
 updateBattery(batts[3], mon1Frame1)
 updateBattery(batts[2], mon1Frame2)
 updateBattery(batts[1], mon1Frame3)

 --We need to invert the order of the batterys for the other side.
 updateBattery(batts[1], mon2Frame3)
 updateBattery(batts[2], mon2Frame2)
 updateBattery(batts[3], mon2Frame1)
 os.sleep(0.2)
end
