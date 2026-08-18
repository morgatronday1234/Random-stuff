--This project- You know what? Fuck the license. Do what you want with the code! Just please give some credit ::3
--https://github.com/morgatronday1234

--From here: https://devforum.roblox.com/t/rainbow-rgb-algorithm/1146696/4
local function getPositiveAngleDiff(a, b) return a < b and a+360-b or a-b; end
local function getRainbowRGB(num)
    local angle = num*360
    local components = {}
    for i = 1, 3 do
        local startAngle = ((i+1)*120)%360
        local diffFromStart = getPositiveAngleDiff(angle, startAngle)
        if diffFromStart < 60 then
            components[i] = diffFromStart/60*255
        elseif diffFromStart <= 180 then
            components[i] = 255
        elseif diffFromStart < 240 then
            components[i] = (240-diffFromStart)/60*255
        else
            components[i] = 0
        end
    end
    return components[1], components[2], components[3]
end
--End of copyed code.

local function clamp(value, min, max)
 if (value > max) then
  return max
 elseif (value < min) then
  return min
 end
 return value
end

function isOverLimit(value)
 if (value > 15) then
  return 0
 else
  return value
 end
end

function scale(value)
 return math.floor(((value-0)/(255-0))*(15-0)+0)
end

function rgb(r, g, b) 
 redstone.setAnalogOutput("left", clamp(r, 0, 15))
 redstone.setAnalogOutput("top", clamp(g, 0, 15))
 redstone.setAnalogOutput("right", clamp(b, 0, 15))
 return redstone.getAnalogInput("left"), redstone.getAnalogInput("top"), redstone.getAnalogInput("right")
end
rgb(0, 0, 0)

local hue = 0 
function main() while(true) do 
 r, g, b = getRainbowRGB(hue)
 sr, sg, sb = scale(r), scale(g), scale(b)
 --[[
 term.clear()
 term.setCursorPos(1, 1)
 print(("r:%s, g:%s, b:%s\nsr:%s, sg:%s, sb:%s\nhue:%s\n"):format(r, g, b, sr, sg, sb, hue))
 --]]
 rgb(sr, sg, sb) 
 hue=hue+0.003
 if (hue > 1) then hue=0 end
 os.sleep(0.01)
end end

function kill() while(true) do
 os.pullEventRaw("terminate")
 rgb(0, 0, 0)
 error("Terminated ::3")
end end

parallel.waitForAny(kill, main)
