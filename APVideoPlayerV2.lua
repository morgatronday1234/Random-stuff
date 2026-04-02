--This project is under the CC-BY-4.0 license
--https://github.com/morgatronday1234
--Read the license!

local glass = peripheral.wrap("back")
local speaker = peripheral.wrap("right")
local bitmap = require("lua-bitmap")

local folder = "badApple/"
local startWidth, startHeight = 240, 180 --Refer to '[REF 1]' for why the fuck this exists
--[[
File converter commands

ffmpeg -i video.mp4 -pix_fmt gray "tempOutputFolder\%d.bmp"
for %f in (tempOutputFolder\*.bmp) do ffmpeg -i "%f" -f rawvideo -pix_fmt gray "outputFolder\%~nf.raw"
--]]


--[[
--Bad! Don't do this you lasy fuck!
print = function(input)
 file = fs.open("DEBUG.txt", "a")
 file.write(tostring(input).."\n")
 file.close()
end
--]]


glass.clear()
glass.autoUpdate(false)

print("Made by morgatron")
gx, gy = glass.getSize()
print(string.format("SCR: %dx%d", gx, gy))

--Create the objects... Don't forget to do the real render.
local function loadPixels(sizeX, sizeY, mult)
 print("Loading pixels...")
 print(string.format("L-IMG: %dx%d", sizeX, sizeY))
 
 local objects = {}
 local ind = 1
 if not (mult) then
  mult = 1
 end

 for y=0, sizeY-1 do
    for x=0, sizeX-1 do
        local color = 0x000000 --Int color

        local object = glass.createRectangle({
         ["x"]=x*mult, ["y"]=y*mult,
         ["maxX"]=x*mult+2, ["maxY"]=y*mult+2,
         ["color"]=color
        })
        objects[ind] = {["obj"] = object, ["clr"]=color}
        ind = ind+1
        glass.update()
    end
    os.sleep(0.01)
 end

 print("Done! Loaded "..tostring(#objects).." pixels!")
 speaker.playNote("pling")
 return objects
end

local function dataFromFile(imageName)
 local file = fs.open(imageName, "rb")
 local data = file.readAll()
 file.close()
 
 local flat = {}
 for i = 1, #data do
  if (string.byte(data, i) > 128) then
   flat[i] = 0xFFFFFF
  else 
   flat[i] = 0x000000
  end
 end
 
 flat.width, flat.height = startWidth, startHeight
 return flat
end

--{ {["color"]=65535, ["count"]=1} }
--Debug function
local commonColors = {}
local function aniliz(input)
 startTime = os.epoch()

 local exists = false
 
 for incr, set in pairs(commonColors) do
  if (input == set["color"]) then
   commonColors[incr]["count"] = set["count"]+1
   exists = true
  end
 end
 
 if (exists == false) then
  table.insert(commonColors, {["color"]=input, ["count"]=1})
 end
 endTime = os.epoch()
 
 return (endTime-startTime)/1000
end

function renderImage(imageName, objects)
 print("Trying to render: '"..imageName.."'")
 local data = dataFromFile(imageName) --0ms
 local pixelsChanged = 0

 for incr=1, data.width*data.height do
  local clr = data[incr]
  
  if not (clr == objects[incr]["clr"]) then
   objects[incr]["obj"].setColor(clr)
   pixelsChanged=pixelsChanged+1
  end
  
  objects[incr]["clr"] = clr
 end

 glass.update()
 print("Done rendering!: '"..imageName.."'\n"..tostring(pixelsChanged).." Pixels chnaged")
end

local function renderFps(text)
 if not (fpsObject) then
  fpsObject = glass.createText({["x"]=1, ["y"]=1})
  fpsObject.setColor(0x00ff99)
 end
 
 fpsObject.setContent(text)
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

 --My old method of just pulling the width and height wont work, So fuck it. [REF 1]
 local objects = loadPixels(startWidth, startHeight, 1)

 for curFrame=1, maxFrame do 
  if not (fs.exists(folder..tostring(curFrame)..".raw")) then
   print("Failed to find frame: '"..folder..tostring(curFrame)..".raw'; Skiping frame...")
  else
   --This fucker is slow a shit (I think?????) but i can't trace it down.
   fpsStart = os.epoch("utc")
   renderImage(folder..tostring(curFrame)..".raw", objects)
   fpsFinish = os.epoch("utc")
   
   renderFps("FPS: "..tostring(math.ceil(1000/(fpsFinish-fpsStart))))
   --print("["..tostring(folder).."]renderWhole: "..tostring((finish-start)).."s")

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