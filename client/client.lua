local RSGCore = exports['rsg-core']:GetCoreObject()
local goldsmelt = false

------------------------------------------------------------------------------------------------------

-- Setting the smelter
RegisterNetEvent('qc-craft:client:setupgoldsmelt')
AddEventHandler('qc-craft:client:setupgoldsmelt', function()
    local ped = PlayerPedId()

    if goldsmelt == true then
        CrouchAnim()
        Wait(6000)
        ClearPedTasks(ped)
        SetEntityAsMissionEntity(smelt)
        DeleteObject(smelt)
        TriggerEvent("bln_notify:send", {
            title = "~#ffcc00~The smelter was postponed~e~",
            description = "Smelter was successfully deferred.",
            placement = "top-right"
        })
        goldsmelt = false
    elseif goldsmelt == false then
        -- Setting up a solution with animation
        CrouchAnim()
        Wait(6000)
        ClearPedTasks(ped)
        
        -- Creating the Facility of the smelter in a specific position
        local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.75, -1.55))
        local prop = CreateObject(GetHashKey("mp005_s_posse_ammotable03x"), x, y, z, true, false, true)
        SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
        PlaceObjectOnGroundProperly(prop)
        smelt = prop
        
        -- Starting the script
        TaskStartScenarioInPlace(ped, "PROP_HUMAN_REPAIR_WAGON_WHEEL_ON_LARGE", 0, true)
        
        -- Showing Progress Bar
        exports['progressbar']:Progress({
            name = 'gold-smelting-progress',
            label = 'The making of the object...',
            duration = 30000,  -- 20 seconds
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }
        })

        -- Waits 20 seconds before the scenario stops
        Wait(30000)
        ClearPedTasks(ped)  -- Stops the script after 20 seconds

        -- Notification on successful placement of the smelter
        TriggerEvent("bln_notify:send", {
            title = "~#ffcc00~The desktop is set up~e~",
            description = "The work surface is successfully mountedted.",
            placement = "top-right"
        })
        goldsmelt = true
    end
end, false)

------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    for _, v in pairs(Config.SmeltProps) do
        exports.ox_target:addModel(v, {
            {
                name = "smeltmenu",
                icon = "fa-solid fa-fire",
                label = "Make",
                onSelect = function()
                    TriggerEvent('qc-craft:client:smeltmenu')
                end
            }
        })
    end
end)


------------------------------------------------------------------------------------------------------

-- to the melting menu
RegisterNetEvent('qc-craft:client:smeltmenu', function()
    smeltMenu = {}
    smeltMenu = {
        {
            header = Lang:t('menu.smelting_menu'),
            isMenuHeader = true,
        },
    }
    for k, v in pairs(Config.SmeltOptions) do
        local item = {}
        local text = ""
        for k, v in pairs(v.smeltitems) do
            text = text .. "- " .. RSGCore.Shared.Items[v.item].label .. ": " .. v.amount .. "x <br>"
        end
        smeltMenu[#smeltMenu + 1] = {
            header = k,
            txt = text,
            params = {
                event = 'qc-craft:client:checkinggolditems',
                args = {
					name = v.name,
                    item = k,
                    smelttime = v.smelttime,
					receive = v.receive
                }
            }
        }
    end
    smeltMenu[#smeltMenu + 1] = {
        header = Lang:t('menu.close_menu'),
        txt = '',
        params = {
            event = 'rsg-menu:closeMenu',
        }
    }
    exports['rsg-menu']:openMenu(smeltMenu)
end)

------------------------------------------------------------------------------------------------------

-- Checks if a player has the necessary things
RegisterNetEvent('qc-craft:client:checkinggolditems', function(data)
	RSGCore.Functions.TriggerCallback('qc-craft:server:checkinggolditems', function(hasRequired)
    if (hasRequired) then
		if Config.Debug == true then
			print("Uspešno")
		end
		TriggerEvent('qc-craft:client:dosmelt', data.name, data.item, tonumber(data.smelttime), data.receive)
	else
		if Config.Debug == true then
			print("Neuspešno")
		end
		return
	end
	end, Config.SmeltOptions[data.item].smeltitems)
end)

local Animation = 'amb_rest_lean@world_human_lean@table@sharpen_knife@male_a@idle_a'  -- The animation we will use
local anim = 'idle_c'  -- The animation we want to launch

-- Animation function function
local LoadAnimDict = function(dict)
    local isLoaded = HasAnimDictLoaded(dict)

    while not isLoaded do
        RequestAnimDict(dict)
        Wait(0)
        isLoaded = HasAnimDictLoaded(dict)
    end
end

-- Event Handler to bold gold
RegisterNetEvent('qc-craft:client:dosmelt', function(name, item, smelttime, receive)
    local smeltitems = Config.SmeltOptions[item].smeltitems

    -- We load the animation before we run it
    local player = PlayerPedId()
    LoadAnimDict(Animation)

    -- We run the animation
    TaskPlayAnim(player, Animation, anim, 3.0, 3.0, -1, 1, 0, false, false, false)

    exports['progressbar']:Progress({
        name = 'smelt-gold',
        label = Lang:t('progressbar.smelting_a')..name,
        duration = smelttime,  -- Duration progress bar
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        },
    }, function(cancelled)
        -- We stop the animation after the progress bar is over
        ClearPedTasksImmediately(player)

        if not cancelled then
            -- If death ends successfully
            TriggerServerEvent('qc-craft:server:finishsmelting', smeltitems, receive)
        else
            -- If death is interrupted
            TriggerEvent("bln_notify:send", {
                title = "~#dc3545~Canceled~e~",
                description = "Reading is interrupted!",
                placement = "top-right"
            })
        end
    end)

    -- We stop animation after progress bar is over
    Citizen.SetTimeout(smelttime, function()
        ClearPedTasksImmediately(player)
    end)
end)


------------------------------------------------------------------------------------------------------

-- Sitting animation
function CrouchAnim()
    local dict = "script_rc@cldn@ig@rsc2_ig1_questionshopkeeper"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    TaskPlayAnim(ped, dict, "inspectfloor_player", 0.5, 8.0, -1, 1, 0, false, false, false)
end

------------------------------------------------------------------------------------------------------

-- Testing text
function DrawText3Ds(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(9)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end

------------------------------------------------------------------------------------------------------
