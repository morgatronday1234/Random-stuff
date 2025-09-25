--This project is under the CC-BY-NC-4.0 license
--https://github.com/morgatronday1234
--Read the license!

monitor = peripheral.wrap("monitor_0")
dog = peripheral.wrap("left")
require("sign-text")

function getMonitors()
 local peripherals = peripheral.getNames()
 local monitors = {}

 for _, prhName in pairs(peripherals) do
  if (string.find(prhName, "monitor")) then 
   monitors[prhName] = peripheral.wrap(prhName)
  end
 end

 return monitors
end
monitors = getMonitors()

--brick'O text, Now with screen resetting
function reset()
 for _, monCur in pairs(monitors) do
  monCur.clear()
  monCur.setCursorPos(1, 1)
  monCur.setTextColor(colors.white)
  monCur.setBackgroundColor(colors.black)
  monCur.setTextScale(1.5)
 end
end
reset()
data = getData()

--color [color var], color_bg [color var], text [string], line [table](x [value], y [value])
function render(color, color_bg, text, line)
 for _, monCur in pairs(monitors) do
  monCur.setCursorPos(0, 0)
 
  monCur.setCursorPos(line.x, line.y)
  monCur.blit(text, string.rep(colors.toBlit(color), #text), string.rep(colors.toBlit(color_bg), #text))
 end
end

--This project is under the CC-BY-NC-4.0 license
--https://github.com/morgatronday1234
--Read the license!
for _, context in pairs(data) do
 render(context.color, context.color_bg, context.text, context.line)
end

--made by morgatron
