fs.delete("/startup/")

fs.makeDir("/startup/.-")
fs.makeDir("/startup/.uwu")

shell.execute("wget", "https://raw.github.com/morgatronday1234/Random-stuff/raw/refs/heads/main/schizo/files/soundevents.json")
shell.execute("wget", "https://raw.github.com/morgatronday1234/Random-stuff/raw/refs/heads/main/schizo/files/..uwu.lua")
shell.execute("wget", "https://raw.github.com/morgatronday1234/Random-stuff/raw/refs/heads/main/schizo/files/readme.txt")
shell.execute("wget", "https://raw.github.com/morgatronday1234/Random-stuff/blob/main/schizo/files/schizo.lua")

fs.move("readme.txt", "/startup/.uwu/readme.txt")
fs.move("soundevents.json", "/startup/.uwu/soundevents.json")
fs.move("schizo.lua", "/startup/.uwu/schizo.lua")
fs.move("..uwu.lua", "/startup/..uwu.lua")
