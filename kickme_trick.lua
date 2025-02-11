--This project is under the CC-BY-4.0 license
--https://github.com/morgatronday1234
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

