--This project is under the CC-BY-4.0 license
--https://github.com/morgatronday1234
chat = peripheral.wrap("left")

nicknames = {
}

local function getNickname(name)
 if not (name) then return false end

 if (nicknames[name]) then
  return nickanmes[name]
 else 
  return name
 end
end

function ChatModifier() while(true) do
 event, user, message, _, invisible = os.pullEvent("chat")

 if (invisible) and (string.find(message, "c ") == 1) then
  print("color", string.find(message, "c "))
  message = string.gsub(message, "c ", "")

  messageOut = string.gsub(message, "&([0-9a-fkimnor])", utf8.char(167).."%1") 
  chat.sendMessage(messageOut, getNickname(user), "<>")
 elseif (invisible) and (string.find(message, "f ") == 1) then
  print("Format", string.find(message, "f "))
  message = string.gsub(message, "f ", "")
  messageOut = message
  
  pass, err = pcall(chat.sendFormattedMessage, messageOut, getNickname(user), "<>")
  if not (pass) then
   errorMessageJson = textutils.serialiseJSON({
    {
     ["text"] = "Error: ", 
     ["color"] = "#FF5555", 
     ["italic"] = true
    },
    {
     ["text"] = tostring(err), 
     ["color"] = "#555555",
     ["italic"] = true,
     ["HoverEvent"] = {
      ["action"] = "show_text",
      ["contents"] = {
       {["text"] = "Click to copy text"}
      }
     },
     ["clickEvent"] = {
      ["action"] = "copy_to_clipboard",
      ["value"] = tostring(err)  
     }
    }
   })
   chat.sendFormattedMessageToPlayer(errorMessageJson, user, "Chat Modifier", "<>")
  end
 end
end end

parallel.waitForAny(ChatModifier)

