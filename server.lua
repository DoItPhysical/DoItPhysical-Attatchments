ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("esx_attatchments:putWeaponComponent", function(source,cb,weapon,component)
    local xPlayer = ESX.GetPlayerFromId(source)
    local real = ESX.GetWeaponComponent(weapon, component) 
    if real then
        if xPlayer.getInventoryItem(component).count >= 1 then 
            xPlayer.addWeaponComponent(weapon, component)
            xPlayer.removeInventoryItem(component, 1)
            cb(true)
        else
            xPlayer.showNotification("You are missing a(n) "..component)
            cb(false)
        end
    else
        xPlayer.showNotification("That attatchment is not compatible with this weapon")
        cb(false)
    end
end)

ESX.RegisterServerCallback("esx_attatchments:removeWeaponComponent", function(source,cb,weapon,component)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.hasWeaponComponent(weapon, component) then
        xPlayer.removeWeaponComponent(weapon, component)
        xPlayer.addInventoryItem(component, 1)
        cb(true)
    else
        -- print("How the fuck did you even manage to do this")
        cb(false)
    end
end)

ESX.RegisterServerCallback("esx_attatchments:putAllWeaponComponents", function (source,cb,weapon)
    local xPlayer = ESX.GetPlayerFromId(source)

    local usedComponents = {}
    for k,v in pairs(Config.Attatchments) do
        if ESX.GetWeaponComponent(weapon, k) then
            usedComponents[k] = v
        end
    end
    
    for k,v in pairs(usedComponents) do
        if xPlayer.getInventoryItem(v).count < 1 then
            usedComponents[k] = nil
        else
            xPlayer.addWeaponComponent(weapon, k)
            xPlayer.removeInventoryItem(v, 1)
        end
    end

    cb(usedComponents)
end)

ESX.RegisterServerCallback("esx_attatchments:removeAllWeaponComponents", function (source,cb,weapon)
    local xPlayer = ESX.GetPlayerFromId(source)

    local components = {}
    for k,v in pairs(Config.Attatchments) do
        if xPlayer.hasWeaponComponent(weapon, k) then
            xPlayer.removeWeaponComponent(weapon, k)
            xPlayer.addInventoryItem(v, 1)
            components[k] = v
        end
    end

    cb(components)
end)