local glass = peripheral.wrap("back")
local speaker = peripheral.wrap("right")
local bitmap = require("lua-bitmap")

local folder = "tempTestVid/"
local startWidth, startHeight = 240, 180 --Refer to '[REF 1]' for why the fuck this exists
--[[
 ffmpeg -i Box.mp4 -pix_fmt gray "tempTestVid\%d.bmp"
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
   local color = 0x000000 --Base color
   
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

local function bitmapFromFile(imageName)
 --print("IMG name: ", imageName)
 local file = fs.open(imageName, "r")
 local bitmapImage = bitmap.from_string(file.readAll())
 file.close()
 return bitmapImage
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
 local bitmapImage = bitmapFromFile(imageName) --0ms
 local incr = 1
 local pixelsChanged = 0
 --local anilizTime = 0
 totalTime = 0
 
 for y=0, bitmapImage.height-1 do
  for x=0, bitmapImage.width-1 do
   r, g, b = bitmapImage:get_pixel(x, y) --0.25s

   if (r) and (g) and (b) then
    clr = colors.packRGB(r/255, g/255, b/255) --0.25s

    if not (clr == objects[incr]["clr"]) then --0.05s
     objects[incr]["obj"].setColor(clr)--Please note this function will freaze the thread if you let it.
     pixelsChanged = pixelsChanged +1
    end
    --anilizTime=anilizTime + aniliz(clr) --Debuging function, Wanted to get common colors.
    objects[incr]["clr"] = clr --0ms
    incr = incr + 1
   end
  end
 end

  

  --print("renderWhole: "..tostring(totalTime).."s")
 --print("TFA: "..tostring(anilizTime))
 glass.update()
 print("Done rendering!: '"..imageName.."', "..tostring(pixelsChanged).." Pixels chnaged")
 return
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
  if not (fs.exists(folder..tostring(curFrame)..".bmp")) then
   print("Failed to find frame: '"..folder..tostring(curFrame)..".bmp'; Skiping frame...")
  else
   start = os.clock()
   --K I L L  M E
   --This fucker is slow a shit (I think?????) but i can't trace it down.
   renderImage(folder..tostring(curFrame)..".bmp", objects)
   finish = os.clock()
   print("["..tostring(folder).."]renderWhole: "..tostring((finish-start)).."s")

   os.sleep(0.01)
  end
 end
end

main()

--[[
table.sort(commonColors, function(n1, n2) return (n1["count"] > n2["count"]) end)
print(textutils.serialize(commonColors))
]]