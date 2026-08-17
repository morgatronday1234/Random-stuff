local log = function(text) local file = fs.open("log.txt", "a") if (file) then file.write(("\n[%s]: %s"):format(os.date("%b|%d %I:%M:%S(%p)", os.epoch("local")/1000), text)) file.close() else print(("Failed to write to log: %s"):format(text)) end end

local fcode, compErr = loadfile("depthCheck.lua")
if (compErr) then error(compErr) end
while(true) do
 --fcode()
 pass, err = pcall(fcode)
 if (pass == false) then
  local output = "[runningCode]: "..tostring(err)
  log(output)
  print(output)
 end
 
 os.sleep(1)
end
