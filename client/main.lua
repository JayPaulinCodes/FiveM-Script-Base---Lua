--[[
    Required for the base script setup
]]
Citizen.CreateThread(function() 
    Citizen.Wait(50)

    registerCommandSuggestions()

    registerChatTemplates()
end)