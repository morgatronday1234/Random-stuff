--This project is under the CC-BY-4.0 license
--https://github.com/morgatronday1234
--Read the license!

aukit = require "aukit"
while(true) do
response_from_tts = textutils.unserialiseJSON(http.post("https://api.v8.unrealspeech.com/speech", textutils.serialiseJSON({["Text"] = tostring(read()), ["VoiceId"] = "Noah"}), {["Content-Type"] = "application/json", ["Authorization"] = "Bearer "}).readAll())

tts_data_mp3 = nil
tts_data_mp3 = http.get({url = response_from_tts.OutputUri, binary = true}).readAll()


dfpwm_uri = http.post("https://remote.craftos-pc.cc/music/upload", tts_data_mp3).readAll()

shell.execute("austream", "https://remote.craftos-pc.cc/music/content/"..dfpwm_uri..".wav")
end
--fs.delete(response_from_tts.TaskId..".dfpwm")

--This project is under the CC-BY-4.0 license
--https://github.com/morgatronday1234
--Read the license!
