--[[
    Returns the player's server id
]]
function serverId()
    return GetPlayerServerId(PlayerId())    
end


--[[
    Registers command suggestions for each command
    in the common/commands.lua file
]]
function registerCommandSuggestions()
    for i, command in ipairs(COMMANDS) do
        
        if #command.parameters == 0 then
            TriggerEvent("chat:addSuggestion", "/" .. command.name, command.description)
        else 
            TriggerEvent("chat:addSuggestion", "/" .. command.name, command.description, command.parameters)
        end

        print(GetThisScriptName() .. _("registeredCommand") .. command.name)
        Citizen.Wait(25)
        
    end
end


--[[
    Registers chat templates for each template
    in the common/chatTemplates.lua file
]]
function registerChatTemplates()
    for i, chatTemplate in ipairs(CHAT_TEMPLATES) do
        TriggerEvent("chat:addTemplate", chatTemplate.templateId, chatTemplate.htmlString)
    
        print(GetThisScriptName() .. _("registeredChatTemplate") .. chatTemplate.templateId)
        Citizen.Wait(25)
    end
end


--[[
    Shoutout to Flatracer on the forums for this one
    https://forum.cfx.re/t/use-displayonscreenkeyboard-properly/51143/2

    -- TextEntry		-->	The Text above the typing field in the black square
	-- ExampleText		-->	An Example Text, what it should say in the typing field
	-- MaxStringLenght	-->	Maximum String Lenght
]]
function getUserTextInput(TextEntry, ExampleText, MaxStringLenght)

	AddTextEntry('FMMC_KEY_TIP1', TextEntry) --Sets the Text above the typing field in the black square
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght) --Actually calls the Keyboard Input
	blockinput = true --Blocks new input while typing if **blockinput** is used

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do --While typing is not aborted and not finished, this loop waits
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult() --Gets the result of the typing
		Citizen.Wait(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
		blockinput = false --This unblocks new Input when typing is done
		return result --Returns the result
	else
		Citizen.Wait(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
		blockinput = false --This unblocks new Input when typing is done
		return nil --Returns nil if the typing got aborted
	end
    
end


--[[
    sendChatMessage(templateID, arguments) 

    @param {String} templateID - The tempalte ID of the template to use
    @param {Array} arguments - Array of the arguments for the message
]]
function sendChatMessage(templateID, arguments) 
    TriggerEvent('chat:addMessage', 
        { 
            templateId = templateID, 
            multiline = true, 
            args = arguments
        }
    )
end


--[[
    isPedRealAndAlive(playerPed)
    Checks to make sure a player exists and is not dead

    @playerPed - The player ped of the entity to test (See GetPlayerPed())

    @returns - boolean
]]
function isPedRealAndAlive(playerPed) 

    if DoesEntityExist(playerPed) and not IsEntityDead(playerPed) then 
        return true 
    else
        return false 
    end

end


--[[
    isVehicleLocked(vehicle) 
    Checks to see if a vehicle is locked

    @vehicle - The vehicle to check

    @returns - boolean

    @nilReturns 
    The function will return nil when the vehicle
    doesn't exist
]]
function isVehicleLocked(vehicle) 

    if not DoesEntityExist(vehicle) then return nil end         -- Make sure the vehicle is real

    local lockState = GetVehicleDoorLockStatus(vehicle)

    if lockState == 0 or lockState == 1 then
        return false
    else
        return true
    end

end


--[[
    doesVehicleHaveDoor(vehicle, doorIndex)
    Checks if a vehicle has a specific door

    Vehicle Door Indexes:
    0 = Front Driver
    1 = Rear Driver
    2 = Front Passenger
    3 = Rear Passenger
    4 = Hood
    5 = Trunk

    @vehicle - The vehicle to check
    @doorIndex - The index of the door to check

    @returns - boolean

    @nilReturns 
    The function will return nil when either the vehicle
    doesn't exist or the doorIndex is out of value
]]
function doesVehicleHaveDoor(vehicle, doorIndex) 

    if not isDoorIndexValid(doorIndex) then return nil end      -- Make sure the doorIndex is valid
    if not DoesEntityExist(vehicle) then return nil end         -- Make sure the vehicle is real

    local value = GetIsDoorValid(vehicle, doorIndex)

    return value

end


--[[
    doesVehicleHaveWindow(vehicle, windowIndex)
    Checks if a vehicle has a specific window

    Vehicle Window Indexes:
    0 = Front Driver
    1 = Front Passenger
    2 = Rear Driver
    3 = Rear Passenger

    @vehicle - The vehicle to check
    @windowIndex - The index of the window to check

    @returns - boolean

    @nilReturns 
    The function will return nil when either the vehicle
    doesn't exist or the windowIndex is out of value
]]
function doesVehicleHaveWindow(vehicle, windowIndex) 

    if not isWindowIndexValid(windowIndex) then return nil end      -- Make sure the windowIndex is valid
    if not DoesEntityExist(vehicle) then return nil end         -- Make sure the vehicle is real

    doorIndex = windowIndexToDoorIndex(windowIndex)

    local value = GetIsDoorValid(vehicle, doorIndex)

    return value

end


--[[
    isVehicleDoorOpen(vehicle, doorIndex)
    Checks if a vehicle's door is open or not

    Vehicle Door Indexes:
    0 = Front Driver
    1 = Rear Driver
    2 = Front Passenger
    3 = Rear Passenger
    4 = Hood
    5 = Trunk

    @vehicle - The vehicle to check
    @doorIndex - The index of the door to check

    @returns - boolean

    @nilReturns 
    The function will return nil when either 
        the vehicle doesn't exist
        the doorIndex is out of value
        the vehicle doesn't have the requested door
]]
function isVehicleDoorOpen(vehicle, doorIndex)

    if not isDoorIndexValid(doorIndex) then return nil end                      -- Make sure the doorIndex is valid
    if not DoesEntityExist(vehicle) then return nil end                         -- Make sure the vehicle is real
    if not doesVehicleHaveDoor(vehicle, doorIndex) then return nil end           -- Make sure the vehicle has the door

    if GetVehicleDoorAngleRatio(vehicle, doorIndex) > 0 then
        return true
    else
        return false
    end

end


--[[
    isDoorIndexValid(doorIndex) 
    Checks if a value is allowed as a doorIndex

    Vehicle Door Indexes:
    0 = Front Driver
    1 = Rear Driver
    2 = Front Passenger
    3 = Rear Passenger
    4 = Hood
    5 = Trunk

    @doorIndex - The index of the door to check

    @returns - boolean
]]
function isDoorIndexValid(doorIndex) 
    if doorIndex >= 0 and doorIndex <= 5 then
        return true
    else
        return false
    end
end


--[[
    TODO: Document Function
]]
function getPedCurrentWeaponObject()
    local playerPed = GetPlayerPed(-1)
    xx, currentWeaponHash = GetCurrentPedWeapon(playerPed)

    if WEAPONS[tostring(currentWeaponHash)] ~= nil then
        return WEAPONS[tostring(currentWeaponHash)]
    else
        return nill
    end
end


--[[
    TODO: Document Function
]]
function getWeaponObjectFromHash(weaponHash)
    return WEAPONS[weaponHash]
end