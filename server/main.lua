ESX              = nil
local Categories = {}
local Vehicles   = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'locanation', _U('dealer_customers'), false, false)
TriggerEvent('esx_society:registerSociety', 'locanation', _U('locanation'), 'society_locanation', 'society_locanation', 'society_locanation', {type = 'private'})
