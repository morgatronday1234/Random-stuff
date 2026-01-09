chat = peripheral.wrap("top")

data = {
 {text = "Click Me",
  color = "#00ff99",
  underlined = true,
  clickEvent = {
   action = "run_command",
   value = "/kickme"
  }}
}

chat.sendFormattedMessage(textutils.serialiseJSON(data), "owo", "<>")
