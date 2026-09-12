while(true) do
 event, key, held = os.pullEvent("key_up")
 
 if (key == keys.w) then
  turtle.forward()
 elseif (key == keys.s) then
  turtle.back()
 elseif (key == keys.a) then
  turtle.turnLeft()
 elseif (key == keys.d) then
  turtle.turnRight()
 elseif (key == keys.e) then
  turtle.dig()
 end
end
