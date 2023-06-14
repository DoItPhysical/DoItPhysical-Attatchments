ESX = nil

local cooldown = math.floor(0)
local allCooldown = math.floor(0);

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
end)

RegisterNetEvent('esx_attatchments:putWeaponComponent')
AddEventHandler('esx_attatchments:putWeaponComponent', function(component)
	local loadout = ESX.GetPlayerData().loadout
	local weapon = GetSelectedPedWeapon(PlayerPedId())
	
	for k,v in pairs(loadout) do
		if GetHashKey(v.name) == weapon then
			ESX.TriggerServerCallback('esx_attatchments:putWeaponComponent', function(result) end, v.name, component)
			break
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		if IsControlPressed(math.floor(0), math.floor(21)) and IsControlPressed(math.floor(0), math.floor(172)) then
			if GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey('WEAPON_UNARMED') then
				AttatchmentsMenu()
			end
			
			Wait(1000)
		end
		
		Wait(0)
	end
end)

function AttatchmentsMenu()
	local weaponName = nil
	local weapon = GetSelectedPedWeapon(PlayerPedId())
	local loadout = ESX.GetPlayerData().loadout
	local usedComponents = {}
	
	for k,v in pairs(loadout) do
		if GetHashKey(v.name) == weapon then
			for x,y in pairs(v.components) do
				usedComponents[y] = true
			end
			
			weaponName = v.name
			
			break
		end
	end
	
	local components = {}
	
	if weaponName ~= nil then
		for k,v in pairs(Config.Attatchments) do
			local component = ESX.GetWeaponComponent(weaponName, v)
			
			if component ~= nil then
				if usedComponents[component.name] then
					table.insert(components, {label = component.label, value = k, used = true})
				else
					table.insert(components, {label = component.label, value = k, used = false})
				end
			end
		end
	end
	
	if #components < math.floor(1) then
		ESX.ShowNotification('No components found for this weapon')
		return
	end
	
	table.sort(components, function(a,b) return a.label < b.label end)
	
	SetNuiFocus(true, true)
	SendNUIMessage({action = 'show', components = components, weapon = weaponName})
end

RegisterNUICallback('quit', function(data)
	SetNuiFocus(false, false)
end)

RegisterNUICallback('addAllComponents', function(data)
	if allCooldown > GetGameTimer() then
		return;
	end
	
	allCooldown = GetGameTimer() + math.floor(10000)
	
	ESX.TriggerServerCallback('esx_attatchments:putAllWeaponComponents', function(result)
		for k,v in pairs(result) do
			if v then
				SendNUIMessage({action = 'add', item = k, weapon = data.weapon});
			end
		end
		
		allCooldown = GetGameTimer() + math.floor(500);
	end, data.weapon)
end)

RegisterNUICallback('removeAllComponents', function(data)
	if allCooldown > GetGameTimer() then
		return;
	end
	
	allCooldown = GetGameTimer() + math.floor(10000);
	
	ESX.TriggerServerCallback('esx_attatchments:removeAllWeaponComponents', function(result)
		for k,v in pairs(result) do
			if v then
				SendNUIMessage({action = 'remove', item = k, weapon = data.weapon});
			end
		end
		
		allCooldown = GetGameTimer() + math.floor(500);
	end, data.weapon)
end)

RegisterNUICallback('remove', function(data)
	if cooldown > GetGameTimer() then
		return
	end
	
	cooldown = GetGameTimer() + math.floor(10000)
	
	ESX.TriggerServerCallback('esx_attatchments:removeWeaponComponent', function(result)
		if result then
			SendNUIMessage({action = 'remove', item = data.item, weapon = data.weapon})
		end
		
		cooldown = GetGameTimer() + math.floor(500)
	end, data.weapon, data.item)
end)

RegisterNUICallback('add', function(data)
	if cooldown > GetGameTimer() then
		return
	end
	
	cooldown = GetGameTimer() + math.floor(10000)
	
	ESX.TriggerServerCallback('esx_attatchments:putWeaponComponent', function(result)
		if result then
			SendNUIMessage({action = 'add', item = data.item, weapon = data.weapon})
		end
		
		cooldown = GetGameTimer() + math.floor(500)
	end, data.weapon, data.item)
end)