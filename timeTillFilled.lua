local transf = peripheral.wrap("bottom")
local cir = peripheral.wrap("block_reader_0")
local mon = peripheral.wrap("monitor_0")

local feMax = 1000000000
local tps = 20

transf.setTransferRateLimit(5100)
mon.setTextScale(0.5)
mon.setPaletteColor(colors.green, 0x00ff99)
mon.setPaletteColor(colors.purple, 0x443399)
mon.setTextColor(colors.green)
mon.setBackgroundColor(colors.purple)

while(true) do
 local fe = transf.getTransferRate()
 local filled = cir.getBlockData().pow
 local rate = ((feMax-filled)/(fe*tps))
 local pers = (filled/feMax)*100
 
 os.sleep(0.4)
 mon.clear()
 
 mon.setCursorPos(1, 1)
 mon.write(("Fe/t: %s"):format(fe))
 mon.setCursorPos(1, 2)
 mon.write(("%s%% (%s/%s)"):format(math.floor(pers), feMax, filled))
 
 mon.setCursorPos(1, 4)
 mon.write("Time until filled:")
 mon.setCursorPos(1, 5)
 mon.write(("%s Hours (%s Minutes) (%s Seconds)"):format(math.floor((rate/60)/60), math.floor(rate/60), math.floor(rate)))
end
