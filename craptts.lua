--https://github.com/morgatronday1234
--Made by morgatron

local APIKey = ""
local aukit = require("aukit")
while(true) do
 local response_from_tts = textutils.unserialiseJSON(
  http.post("https://api.v8.unrealspeech.com/speech", textutils.serialiseJSON({
   ["Text"] = tostring(read()), 
   ["VoiceId"] = "Noah"
  }), {
   ["Content-Type"] = "application/json", 
   ["Authorization"] = "Bearer "..APIKey}).readAll()
 )
 local tts_data_mp3 = http.get({url = response_from_tts.OutputUri, binary = true}).readAll()

 local dfpwm_uri = http.post("https://remote.craftos-pc.cc/music/upload", tts_data_mp3).readAll()
 shell.execute("austream", "https://remote.craftos-pc.cc/music/content/"..dfpwm_uri..".wav")
end
--fs.delete(response_from_tts.TaskId..".dfpwm")
