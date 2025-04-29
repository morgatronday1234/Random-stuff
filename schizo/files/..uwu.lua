file = fs.open("/startup/.uwu/schizo.lua", "r")
schizo, err = load(file.readAll()) file.close()

if (err ~= nil) then 
 schizo = function() os.sleep(0.1) end
end 

parallel.waitForAny(
schizo,
function() 
 term.clear()
 term.setCursorPos(1, 1)
 shell.run("shell")
end
)
