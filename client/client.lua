local RSGCore = exports['rsg-core']:GetCoreObject()
local craft = false
lib.locale()
------------------------------------------------------------------------------------------------------

-- Placing the Crafting Table
RegisterNetEvent('qc-craft:client:setupcrafting')
AddEventHandler('qc-craft:client:setupcrafting', function()
    local ped = PlayerPedId()
    if craft == true then
        CrouchAnim()
        Wait(6000)
        ClearPedTasks(ped)
        SetEntityAsMissionEntity(crafter)
        DeleteObject(crafter)
        TriggerEvent("bln_notify:send", {
            title = "~#ffcc00~"..locale('qc_notify_setup_title').."~e~",
            description = locale('qc_notify_setup_desc'),
            placement = "top-right"
        })
        craft = false
    elseif craft == false then
        -- Setting up a solution with animation
        CrouchAnim()
        Wait(6000)
        ClearPedTasks(ped)
        
        -- Creating the Crafting table at player's position WILL BE UPDATING SOON TO A BETTER SOLUTION
        local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.75, -1.55))
        local prop = CreateObject(GetHashKey("mp005_s_posse_ammotable03x"), x, y, z, true, false, true)
        SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
        PlaceObjectOnGroundProperly(prop)
        crafter = prop
        TaskStartScenarioInPlace(ped, "PROP_HUMAN_REPAIR_WAGON_WHEEL_ON_LARGE", 0, true)
        -- Progress bar for the Crafting table placement
        exports['progressbar']:Progress({
            name = 'gold-smelting-progress',
            label = locale('qc_progress_placing'),
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
            title = "~#ffcc00~"..locale('qc_notify_setup_complete').."~e~",
            description = locale('qc_notify_setup_desc_comp'),
            placement = "top-right"
        })
        craft = true
    end
end, false)

------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    for _, v in pairs(Config.CraftingProps) do
        exports.ox_target:addModel(v, {
            {
                name = "smeltmenu",
                icon = "fa-solid fa-fire",
                label = locale('qc_target_label'),
                onSelect = function()
                    TriggerEvent('qc-craft:client:craftmenu')
                end
            }
        })
    end
end)


------------------------------------------------------------------------------------------------------

RegisterNetEvent('qc-craft:client:craftmenu', function()
    local craftmenu = {}
    craftmenu = {
        {
            header = locale('qc_craft_title'),
            isMenuHeader = true,
        },
    }
        for optionKey, optionValue in pairs(Config.CraftingOptions) do
            local text = ""
            for _, required in pairs(optionValue.required or {}) do
                text = text .. "- " .. (RSGCore.Shared.Items[required.item] and RSGCore.Shared.Items[required.item].label or required.item) .. ": " .. required.amount .. "x<br>"
            end
            craftmenu[#craftmenu + 1] = {
                header = optionKey,
                txt = text,
                params = {
                    event = 'qc-craft:client:checkingItems',
                    args = {
                        name = optionValue.name,
                        item = optionKey,
                        smeltTime = optionValue.crafttimer * 10000,
                        receive = optionValue.receive
                    }
                }
            }
        end
    craftmenu[#craftmenu + 1] = {
        header = locale('qc_craft_close_menu'),
        txt = '',
        params = {
            event = 'rsg-menu:closeMenu',
        }
    }
    exports['rsg-menu']:openMenu(craftmenu)
end)
------------------------------------------------------------------------------------------------------

-- Checks if a player has the necessary things
RegisterNetEvent('qc-craft:client:checkingItems', function(data)
	RSGCore.Functions.TriggerCallback('qc-craft:server:itemcheck', function(hasRequired)
    if (hasRequired) then
		if Config.Debug == true then
			print("Successfully")
		end
		TriggerEvent('qc-craft:client:docraft', data.name, data.item, tonumber(data.crafttimer), data.receive)
	else
		if Config.Debug == true then
			print("Unsuccessfully")
		end
		return
	end
	end, Config.CraftingOptions[data.item].required)
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
RegisterNetEvent('qc-craft:client:docraft', function(name, item, crafttimer, receive)
    local required = Config.CraftingOptions[item].required
    -- We load the animation before we run it
    local player = PlayerPedId()
    LoadAnimDict(Animation)

    -- We run the animation
    TaskPlayAnim(player, Animation, anim, 3.0, 3.0, -1, 1, 0, false, false, false)

    exports['progressbar']:Progress({
        name = 'smelt-gold',
        label = locale('qc_progress_label')..receive,
        duration = crafttimer,  -- Duration progress bar
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
            TriggerServerEvent('qc-craft:server:finishsCraft', required, receive)
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
    Citizen.SetTimeout(crafttimer, function()
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
