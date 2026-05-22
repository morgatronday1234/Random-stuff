--This project is under the CC-BY-4.0 license
--https://github.com/morgatronday1234
--Read the license!

local glass = peripheral.wrap("back")
local speaker = peripheral.wrap("right")
local bitmap = require("lua-bitmap")

local folder = "badApple/"
local startWidth, startHeight = 240/2, 180/2 --240, 180--Refer to '[REF 1]' for why the fuck this exists
local offsetX, offsetY, offsetZ = 62, 63, 84

--[[
 WARNING!
 THIS WILL LAG YOU TO DEATH!
 THIS WAS A FAILED TEST, USE AT OWN RISK!
--]]

--[[
Bad! Don't do this you lasy fuck!
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



function renderImage(imageName, objects)
 print("Trying to render: '"..imageName.."'")
 local bitmapImage = bitmapFromFile(imageName)
 local incr = 1
 local pixelsChanged = 0

 for y=0, bitmapImage.height-1 do
  for x=0, bitmapImage.width-1 do
   r, g, b = bitmapImage:get_pixel(x, y)
   
   if (r) and (g) and (b) then
    clr = colors.packRGB(r/255, g/255, b/255)

    if not (clr == objects[incr]["blk"]) then
     objects[incr]["obj"].setColor(clr)
     pixelsChanged=pixelsChanged+1
    end

    --aniliz(clr) --Debuging function, Wanted to get common colors.
    objects[incr]["blk"] = clr--And here
    incr = incr + 1
   end
  end
 end
 glass.update()
 print("Done rendering!: '"..imageName.."'")
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
   renderImage(folder..tostring(curFrame)..".bmp", objects)
   os.sleep(0.05)
  end
 end
end

objects = loadPixels(startWidth, startHeight, 1)

--main()

--This project is under the CC-BY-4.0 license
--https://github.com/morgatronday1234
--Read the license!