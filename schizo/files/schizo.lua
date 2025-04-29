file = fs.open("/startup/.uwu/soundevents.json", "r") 
soundids = textutils.unserialiseJSON(file.readAll())
file.close()

speaker = peripheral.find("speaker")
if not (speaker) then while(true) do os.sleep(0.1) end end

while(true) do
 random_time = math.random(50, 700)

 os.sleep(random_time)
 speaker.playSound(soundids[math.random(1, #soundids)], 1.0, math.random(0.5, 2.0))
end
