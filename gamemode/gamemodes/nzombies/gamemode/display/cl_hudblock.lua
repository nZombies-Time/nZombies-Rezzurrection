local blockedhuds = {
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudBattery"] = true,
	["CHudHealth"] = true,
}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if blockedhuds[name] then return false end
	if name == "CHudWeaponSelection" then return !nzRound:InProgress() and !nzRound:InState(ROUND_GO) end -- Has it's own value
end )
