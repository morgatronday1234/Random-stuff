--This project is under the CC-BY-NC-4.0 license
--https://github.com/morgatronday1234
--Read the license!

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

--This project is under the CC-BY-NC-4.0 license
--https://github.com/morgatronday1234
--Read the license!
