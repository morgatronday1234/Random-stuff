--This project is under the CC-BY-NC-4.0 license
--https://github.com/morgatronday1234
--Read the license!

dog = peripheral.wrap("left")
chat = peripheral.wrap("chat_box_0")

items = {
 ["Anti-Gravity Explosive"] = "Can crash the server",
 ["Hypersonic Explosive"] = "Can crash the server",
}


function keepAlive() while(true) do
 dog.reset()
 os.sleep(0.01)
end end

function bannedItems() while(true) do
 event, user, message, _, state = os.pullEvent("chat")
 
 messageData = {
  {["text"] = "Banned Items:\n", ["color"] = "#00ff99"},
  {["text"] = "  (This may change at anytime)", ["color"] = "#00ff99"},
 }

 i=2
 for item, reason in pairs(items) do
  table.insert(messageData, i, {["text"]="    "..item.." | Reason: "..reason.."\n", ["color"] = "#443399"})
  i=i+1
 end 
 
 if (state) and (string.find(message, "Banned%-Items") == 1) then
  chat.sendFormattedMessageToPlayer(textutils.serialiseJSON(messageData), user, "·", "··")  
 end
 os.sleep(0.01)
end end


parallel.waitForAny(bannedItems, keepAlive)
print("something broke")

--This project is under the CC-BY-NC-4.0 license
--https://github.com/morgatronday1234
--Read the license!
