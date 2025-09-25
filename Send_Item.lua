--This project is under the CC-BY-NC-4.0 license
--https://github.com/morgatronday1234
--Read the license!

chat = peripheral.wrap("top")
block = peripheral.wrap("right")
mon = peripheral.wrap("monitor_0")

mon.setTextScale(0.5)
term.redirect(mon)
term.clear()
term.setCursorPos(1, 1)


data = block.getBlockData().Items[1]

--print(textutils.serialise(data))
--time for jank fixes

_, item_mod_length = string.find(data.id, ":")  
item = string.gsub(string.sub(data.id, item_mod_length+1), "_", " ")
if not (data.tag)
then
 data.tag = {none = nil}
end
message = {
 {
  text = "["
 },
 {
  text = item,
  color = "#5555FF",
  hoverEvent = {
   action = "show_item",
   contents = {
    id = data.id,
    count = 1,
    tag = textutils.serialiseJSON(data.tag)
   }
  }
 },
 {
  text = "]"
 }
}

chat.sendFormattedMessage(textutils.serialiseJSON(message), "§aItem-display", "<>")

--This project is under the CC-BY-NC-4.0 license
--https://github.com/morgatronday1234
--Read the license!
