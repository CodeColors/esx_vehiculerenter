local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local CurrentVehicleData      = nil

ESX                           = nil

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer

	if Config.EnablePlayerManagement then
		if ESX.PlayerData.job.name == 'locanation' then
			Config.Zones.ShopEntering.Type = 1

			if ESX.PlayerData.job.grade_name == 'boss' then
				Config.Zones.BossActions.Type = 1
			end

		else
			Config.Zones.ShopEntering.Type = -1
			Config.Zones.BossActions.Type  = -1
		end
	end
end)

function OpenBossActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'reseller',{
		title    = _U('dealer_boss'),
		align    = 'top-left',
		elements = {
			{label = _U('boss_actions'), value = 'boss_actions'},
			{label = _U('boss_sold'), value = 'sold_vehicles'}
	}}, function (data, menu)
		if data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'locanation', function(data2, menu2)
				menu2.close()
			end, {wash = false})
		elseif data.current.value == 'sold_used_vehicles' then

			ESX.TriggerServerCallback('esx_vehiculerenter:getSoldVehicles', function(customers)
				local elements = {
					head = { _U('customer_client'), _U('customer_model'), _U('customer_plate'), _U('customer_soldby'), _U('customer_date') },
					rows = {}
				}

				for i=1, #customers, 1 do
					table.insert(elements.rows, {
						data = customers[i],
						cols = {
							customers[i].client,
							customers[i].model,
							customers[i].plate,
							customers[i].soldby,
							customers[i].date
						}
					})
				end

				ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'sold_vehicles', elements, function(data2, menu2)

				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		
		elseif data.current.value == 'rented_vehicles' then

			ESX.TriggerServerCallback('esx_vehiculerenter:getRentedVehicles', function(customers)
				local elements = {
					head = { _U('customer_renter'), _U('customer_vehicle'), _U('customer_plate'), _U('customer_rentprice'), _U('customer_remaining') },
					rows = {}
				}

				for i=1, #customers, 1 do
					table.insert(elements.rows, {
						data = customers[i],
						cols = {
							customers[i].renter,
							customers[i].vehicle,
							customers[i].plate,
							customers[i].rent_price,
							customers[i].remaining
						}
					})
				end

				ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'sold_vehicles', elements, function(data2, menu2)

				end, function(data2, menu2)
					menu2.close()
				end)
			end)

		end

	end, function (data, menu)
		menu.close()

		CurrentAction     = 'boss_actions_menu'
		CurrentActionMsg  = _U('shop_menu')
		CurrentActionData = {}
	end)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function (job)
	ESX.PlayerData.job = job

	if Config.EnablePlayerManagement then
		if ESX.PlayerData.job.name == 'locanation' then
			Config.Zones.ShopEntering.Type = 1

			if ESX.PlayerData.job.grade_name == 'boss' then
				Config.Zones.BossActions.Type = 1
			end
		else
			Config.Zones.ShopEntering.Type = -1
			Config.Zones.BossActions.Type  = -1
		end
	end
end)

function OpenMobileLocanationActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_mechanic_actions', {
		title    = _U('locanation'),
		align    = 'top-left',
		elements = {
			{label = _U('billing'),       value = 'billing'},
			{label = _U('clean'),         value = 'clean_vehicle'}
	}}, function(data, menu)
		if isBusy then return end

		if data.current.value == 'billing' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
				title = _U('invoice_amount')
			}, function(data, menu)
				local amount = tonumber(data.value)

				if amount == nil or amount < 0 then
					ESX.ShowNotification(_U('amount_invalid'))
				else
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('no_players_nearby'))
					else
						menu.close()
						TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_mechanic', _U('mechanic'), amount)
					end
				end
			end, function(data, menu)
				menu.close()
			end)
		elseif data.current.value == 'clean_vehicle' then
			local playerPed = PlayerPedId()
			local vehicle   = ESX.Game.GetVehicleInDirection()
			local coords    = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(_U('inside_vehicle'))
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
				Citizen.CreateThread(function()
					Citizen.Wait(10000)

					SetVehicleDirtLevel(vehicle, 0)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowNotification(_U('vehicle_cleaned'))
					isBusy = false
				end)
			else
				ESX.ShowNotification(_U('no_vehicle_nearby'))
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

AddEventHandler('esx_vehiculerenter:hasEnteredMarker', function (zone)
	if zone == 'ShopEntering' then

		if Config.EnablePlayerManagement then
			if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'locanation' then
				CurrentAction     = 'reseller_menu'
				CurrentActionMsg  = _U('shop_menu')
				CurrentActionData = {}
			end
		else
			CurrentAction     = 'shop_menu'
			CurrentActionMsg  = _U('shop_menu')
			CurrentActionData = {}
		end

	elseif zone == 'SellUsedVehicle' then

		local playerPed = PlayerPedId()

		if IsPedSittingInAnyVehicle(playerPed) then

			local vehicle     = GetVehiclePedIsIn(playerPed, false)
			local vehicleData, model, resellPrice, plate

			if GetPedInVehicleSeat(vehicle, -1) == playerPed then
				for i=1, #Vehicles, 1 do
					if GetHashKey(Vehicles[i].model) == GetEntityModel(vehicle) then
						vehicleData = Vehicles[i]
						break
					end
				end

				resellPrice = ESX.Math.Round(vehicleData.price / 100 * Config.ResellPercentage)
				model = GetEntityModel(vehicle)
				plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))

				CurrentAction     = 'resell_vehicle'
				CurrentActionMsg  = _U('sell_menu', vehicleData.name, ESX.Math.GroupDigits(resellPrice))

				CurrentActionData = {
					vehicle = vehicle,
					label = vehicleData.name,
					price = resellPrice,
					model = model,
					plate = plate
				}
			end

		end

	elseif zone == 'BossActions' and Config.EnablePlayerManagement and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'locanation' and ESX.PlayerData.job.grade_name == 'boss' then

		CurrentAction     = 'boss_actions_menu'
		CurrentActionMsg  = _U('shop_menu')
		CurrentActionData = {}

	end
end)


-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if CurrentAction == nil then
			Citizen.Wait(500)
		else
			if IsControlJustReleased(0, ['F6']) and not isDead and ESX.PlayerData.job and ESX.PlayerData.job.name == 'locanation' then
				OpenMobileLocanationActionsMenu()
			end
		end
	end
end)