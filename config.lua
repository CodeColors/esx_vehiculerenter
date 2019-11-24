Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerColor                = { r = 120, g = 120, b = 240 }
Config.EnablePlayerManagement     = true -- enables the actual car dealer job. You'll need esx_addonaccount, esx_billing and esx_society
Config.EnableOwnedVehicles        = true
Config.EnableSocietyOwnedVehicles = true -- use with EnablePlayerManagement disabled, or else it wont have any effects
Config.ResellPercentage           = 50

Config.Locale                     = 'fr'

Config.LicenseEnable = false -- require people to own drivers license when buying vehicles? Only applies if EnablePlayerManagement is disabled. Requires esx_license

-- looks like this: 'LLL NNN'
-- The maximum plate length is 8 chars (including spaces & symbols), don't go past it!
Config.PlateLetters  = 3
Config.PlateNumbers  = 3
Config.PlateUseSpace = true

Config.Zones = {

	ShopEntering = {
		Pos   = { x = -218.62, y = -1162.35, z = 21.89 },
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Type  = 1
	},

	ShopSpawn = {
		Pos     = { x = -208.2, y = -1183.19, z = 21.89 },
		Size    = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = -20.0,
		Type    = -1
	},

	ShopOutside = {
		Pos     = { x = -231.42, y = -1169.53, z = 20.84 },
		Size    = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = 344.0,
		Type    = -1
	},

	BossActions = {
		Pos   = { x = -218.08, y = -1162, z = 21.89 },
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Type  = -1
	},

	SellUsedVehicle = {
		Pos   = { x = -176.15, y = -1181.11, z = 21.89 },
		Size  = { x = 3.0, y = 3.0, z = 1.0 },
		Type  = 1
	}

}
