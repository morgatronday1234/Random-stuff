--This project is under the CC-BY-4.0 license
--https://github.com/morgatronday1234
--Read the license!

local expect = require("cc.expect")
local glass = peripheral.wrap("back")

local folder = "output/"
local screenSize = {["x"]=3, ["y"]=3}
local screenOffset = vector.new(0, 0, 0)
--[[
File converter command

ffmpeg -i video.mp4 "output\%d.bmp"
--]]

glass.clear()
local args = {...}
local cx, cy, cz = gps.locate()
local cx, cy, cz = cx+screenOffset.x, cy+screenOffset.y, cz+screenOffset.z
local textureFrame = glass.createTexture({["x"]=cx, ["y"]=cy, ["z"]=cz})
textureFrame.setSizeX(screenSize.x) textureFrame.setSizeY(screenSize.y)

print("Made by morgatron")

local function renderFps(text)
 expect.expect(1, text, "string")

 if not (fpsObject) then
  fpsObject = glass.createText({["x"]=1, ["y"]=1})
  fpsObject.setColor(0x00ff99)
 end
 
 fpsObject.setContent(text)
end

local function renderProg(text)
 expect.expect(1, text, "string")

 if not (progObject) then
  progObject = glass.createText({["x"]=1, ["y"]=10})
  progObject.setColor(0x443399)
 end
 
 progObject.setContent(text)
end

local function loadImage(filepath)
 expect.expect(1, filepath, "string")

 local file = fs.open(filepath, "r")
 textureFrame.load(file.readAll())
 file.close()
end

function main()
 local maxFrame = 0
 for _, v in pairs(fs.list(folder)) do
  local curValue = tonumber((string.gsub(v, "[%a.]+", "")))
  
  if (curValue > maxFrame) then
   maxFrame = curValue
  end
 end
 print("maxFrame:", maxFrame)

 print("Loading...")
 os.sleep(1)
 
 if (args[1]) and (type(tonumber(args[1])) == "number") and (tonumber(args[1]) <= maxFrame) then
  startIndex = tonumber(args[1])
 elseif (args[1]) and (tonumber(args[1]) > maxFrame) then
  error("Frame is greater then max frame in folder")
 else
  startIndex = 1
 end 

 for curFrame=startIndex, maxFrame do 
  if not (fs.exists(folder..tostring(curFrame)..".bmp")) then
   print(("Failed to find frame: '%s.bmp'; Skiping frame..."):format(folder..tostring(curFrame)))
  else

   fpsStart = os.epoch("utc")
   loadImage(folder..tostring(curFrame)..".bmp")
   fpsFinish = os.epoch("utc")
   
   renderFps("FPS: "..tostring(math.ceil(1000/(fpsFinish-fpsStart))))
   renderProg(tostring(curFrame).."/"..tostring(maxFrame))

   os.sleep(0.01)
  end
 end
end

main()

--[[
table.sort(commonColors, function(n1, n2) return (n1["count"] > n2["count"]) end)
print(textutils.serialize(commonColors))
]]

--This project is under the CC-BY-4.0 license
--https://github.com/morgatronday1234
--Read the license!