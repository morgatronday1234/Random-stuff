--This project is under the CC-BY-NC-4.0 license
--https://github.com/morgatronday1234
--Read the license!

chat = peripheral.wrap("right")
pl = peripheral.wrap("left")

header = {
 ["Content-Type"] = "application/json"
}

url = ""--Discord webhook goes here

function chat()
 while(true) do
 event, username, message = os.pullEvent("chat") 
  
 player = pl.getPlayerPos(username)
 --Yes this is mesy, No im not sorry. I tryd it the easy way, I regret that.  
 --print(textutils.serialise(player))
 
 formated_pos = "|�X:"..player.x.."�Y:"..player.y.."�Z:"..player.z.."�Dim:"..player.dimension.."�Health:"..player.health.."/"..player.maxHealth
 -- buggey ahha code, Need to fix
 -- future me, You don't ever fix this
 body_chat = {
  ["content"] = message,
  ["username"] = username..formated_pos,
   --Mmmmmmmm, Yes username=username Thats sensable, "Why not change the var name" You ask? Well This works, Thats it.
  ["allowed_mentions"] = { -- disallow pings, Doesn't stop embeds.
   ["parse"] = {}
  },
  ["avatar_url"] = "https://minotar.net/helm/"..username.."/100.png"
 }
 http.post(url,textutils.serialiseJSON(body_chat), header)--If it fails, It fails.
 end
end
function join()
 while(true) do
 event, username, dim = os.pullEvent("playerJoin")

 body_playerJoin = {
    ["content"] = username.." Has joined the server in: "..dim,
    ["username"] = "System",
    ["avatar_url"] = "https://www.ikea.com/gb/en/images/products/blahaj-soft-toy-shark__0710175_pe727378_s5.jpg"
 }

 http.post(url, textutils.serialiseJSON(body_playerJoin), header)
 end
end
function leave()
 while(true) do
 event, username, dim = os.pullEvent("playerLeave")
    
 body_playerLeave = {
    ["content"] = username.." Has Left the server in: "..dim,
    ["username"] = "System",
    ["avatar_url"] = "https://www.ikea.com/gb/en/images/products/blahaj-soft-toy-shark__0710175_pe727378_s5.jpg"
 }
       
 http.post(url, textutils.serialiseJSON(body_playerLeave), header)
 end
end

parallel.waitForAll(chat, join, leave)

--This project is under the CC-BY-NC-4.0 license
--https://github.com/morgatronday1234
--Read the license!