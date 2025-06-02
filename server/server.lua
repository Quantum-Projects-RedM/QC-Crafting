local RSGCore = exports['rsg-core']:GetCoreObject()
lib.locale()
-- Create Crafting Table
RSGCore.Functions.CreateUseableItem(Config.Item, function(source, item)
    local src = source
    TriggerClientEvent('qc-craft:client:setupcrafting', src, item.name)
end)

-- Does the player have the necessary things
RSGCore.Functions.CreateCallback('qc-craft:server:itemcheck', function(source, cb, required)
    local src = source
    local hasItems = false
    local icheck = 0
    local Player = RSGCore.Functions.GetPlayer(src)
    for k, v in pairs(required) do
        if Player.Functions.GetItemByName(v.item) and Player.Functions.GetItemByName(v.item).amount >= v.amount then
            icheck = icheck + 1
            if icheck == #required then
                cb(true)
            end
        else
            TriggerClientEvent("bln_notify:send", src, {
                title = "~#dc3545~Error~e~",
                description = locale('qc_not_enough_resources'),
                placement = "top-right"
            })
            cb(false)
            return
        end
    end
end)

RegisterServerEvent('qc-craft:server:finishedtable')
AddEventHandler('qc-craft:server:finishedtable', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(Config.Item) then
        Player.Functions.RemoveItem(Config.Item, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[Config.Item], "remove")
    end
end)


-- Completing the Crafting
RegisterServerEvent('qc-craft:server:finishsCraft')
AddEventHandler('qc-craft:server:finishsCraft', function(required, receive)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    -- uklanjanje smeltitem-a
    for k, v in pairs(required) do
        if Config.Debug == true then
            print(v.item)
            print(v.amount)
        end
        Player.Functions.RemoveItem(v.item, v.amount)
        TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[v.item], "remove")
    end
    -- Adding new Item
    Player.Functions.AddItem(receive, 1)
    TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[receive], "add")
    TriggerClientEvent("bln_notify:send", src, {
        title = "~#28a745~Success~e~",
        description = locale('qc_progress_finished'),
        placement = "top-right"
    })
end)

------------------------------------------------------------------------------------------------------


local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/Quantum-Projects-RedM/QC-VersionCheckers/master/QC-Crafting.txt', function(err, newestVersion, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')
        local resourceName = GetCurrentResourceName()
        local discordLink = GetResourceMetadata(resourceName, 'quantum_discord')

        if not newestVersion then
            print("\n^1[Quantum Projects]^7 Unable to perform version check.\n")
            return
        end

        local isLatestVersion = newestVersion:gsub("%s+", "") == currentVersion:gsub("%s+", "")
        if isLatestVersion then
            print(("^3[Quantum Projects]^7: You are running the latest version of ^2%s^7 (^2%s^7)."):format(resourceName, currentVersion))
        else
            print("\n^6========================================^7")
            print("^3[Quantum Projects]^7 Version Checker")
            print("")
            print(("^3Version Check^7:\n ^2Current^7: %s\n ^2Latest^7: %s\n"):format(currentVersion, newestVersion))
            print(("^1You are running an outdated version of %s.\n^6Visit Discord for News: ^4%s^7\n"):format(resourceName, discordLink))
            print("^6========================================^7\n")
        end
    end)
end

CheckVersion()
