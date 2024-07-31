--This project is under the CC-BY-4.0 license
chat = peripheral.wrap("top")
pl = peripheral.wrap("left")

players = pl.getOnlinePlayers()

for i = 1, #pl.getOnlinePlayers()
do
 data = {
  {text = "Click Me "..players[i],
   color = "#00ff99",
   underlined = true,
   clickEvent = {
    action = "run_command",
    value = "/kickme"
   }
  }
 }
 chat.sendFormattedMessageToPlayer(textutils.serialiseJSON(data), players[i], "ChatGPT", "<>")
end
