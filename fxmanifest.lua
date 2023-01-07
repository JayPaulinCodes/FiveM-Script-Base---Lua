fx_version "cerulean"
games { "gta5" }

name "NAME"
description "DESCRIPTION"
version "1.0.1"
author "JayPaulinCodes (https://github.com/JayPaulinCodes)"

github_link "JayPaulinCodes/FiveM-Script-Base---Lua"

locale "en"

shared_scripts {
    "common/locales.lua",
    "locales/*.lua",
    "objects/*.lua",
    "common/config.lua",
    "common/commands.lua",
    "common/chatTemplates.lua",
}

server_scripts {
    "server/VersionCheck.lua",
}

client_scripts {
<<<<<<< HEAD
    "client/functions.lua",
    "client/events.lua",
    "client/main.lua",
}
=======

}
>>>>>>> f87410b6d7f7110f1b74fd86eae76238b5ada878
