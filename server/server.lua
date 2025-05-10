local RSGCore = exports['rsg-core']:GetCoreObject()

-- korišćenje ore za topionicu
RSGCore.Functions.CreateUseableItem("indianbook", function(source, item)
    local src = source
    TriggerClientEvent('qc-craft:client:setupgoldsmelt', src, item.name)
end)

-- provera da li igrač ima potrebne stvari
RSGCore.Functions.CreateCallback('qc-craft:server:checkinggolditems', function(source, cb, smeltitems)
    local src = source
    local hasItems = false
    local icheck = 0
    local Player = RSGCore.Functions.GetPlayer(src)
    for k, v in pairs(smeltitems) do
        if Player.Functions.GetItemByName(v.item) and Player.Functions.GetItemByName(v.item).amount >= v.amount then
            icheck = icheck + 1
            if icheck == #smeltitems then
                cb(true)
            end
        else
            TriggerClientEvent("bln_notify:send", src, {
                title = "~#dc3545~Greška~e~",
                description = Lang:t('error.you_donthave_the_required_items'),
                placement = "top-right"
            })
            cb(false)
            return
        end
    end
end)

-- završavanje smeltovanja
RegisterServerEvent('qc-craft:server:finishsmelting')
AddEventHandler('qc-craft:server:finishsmelting', function(smeltitems, receive)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    -- uklanjanje smeltitem-a
    for k, v in pairs(smeltitems) do
        if Config.Debug == true then
            print(v.item)
            print(v.amount)
        end
        Player.Functions.RemoveItem(v.item, v.amount)
        TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[v.item], "remove")
    end
    -- dodavanje novih item-a
    Player.Functions.AddItem(receive, 1)
    TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[receive], "add")
    TriggerClientEvent("bln_notify:send", src, {
        title = "~#28a745~Uspešno~e~",
        description = Lang:t('success.smelting_finished'),
        placement = "top-right"
    })
end)
