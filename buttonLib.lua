--This project is under the CC-BY-4.0 license
--https://github.com/morgatronday1234
--Read the license!

function prep()
 term.setBackgroundColor(colors.black)
 term.setTextColor(colors.white)
 term.clear()
end


--buttons = {
-- {3, 3, 6, 6, colors.green, function() print("on") os.sleep(0.5) prep() end},
-- {9, 3, 12, 6, colors.red, function() print("off") os.sleep(0.5) prep() end}
--}
createButtons = function(buttons)
  
while(true)
do
 for _, button_box in pairs(buttons)
 do
  
  paintutils.drawFilledBox(button_box[1], button_box[2], button_box[3], button_box[4], button_box[5])
 end
 event, _, x, y = os.pullEvent("mouse_click")
 
 for _, button in pairs(buttons)
 do
  if button[6]
  then
   if (x <= button[3]) and (x >= button[1]) and (y <= button[4]) and (y >=  button[2])
   then

    button[6]()
   end
  end
 end
end

end

--createButtons(buttons)
