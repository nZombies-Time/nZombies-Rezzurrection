
local function RegisterDefaultSpecialWeps()
	nzSpecialWeapons:AddKnife( "nz_quickknife_crowbar", false, 0.65 )
	nzSpecialWeapons:AddKnife( "nz_knife_butterfly", false, 0.65 )
	nzSpecialWeapons:AddKnife( "nz_knife_bo1", false, 0.5 )
	nzSpecialWeapons:AddKnife( "nz_knife_waw", false, 0.5 )
	nzSpecialWeapons:AddKnife( "nz_knife_mw", false, 0.5 )
	nzSpecialWeapons:AddKnife( "nz_knife_ghosts", false, 0.5 )
	nzSpecialWeapons:AddKnife( "nz_knife_malice", false, 0.65 )
	nzSpecialWeapons:AddKnife( "nz_knife_lukewarmconflict", false, 0.65 )
	nzSpecialWeapons:AddKnife( "nz_knife_boring", false, 0.65 )
	nzSpecialWeapons:AddKnife( "nz_knife_badgame", false, 0.65 )
	nzSpecialWeapons:AddKnife( "nz_knife_carver", false, 0.65 )
	nzSpecialWeapons:AddKnife( "nz_knife_crescent", false, 0.65)
	nzSpecialWeapons:AddKnife( "nz_knife_wrench", false, 0.65 )
	nzSpecialWeapons:AddKnife( "nz_bowie_knife", true, 0.65, 2.5 )
	nzSpecialWeapons:AddKnife( "nz_knife_bowie_old", true, 0.65, 2.5 )
	nzSpecialWeapons:AddKnife( "nz_knife_fury", true, 0.65, (45/30) )
	nzSpecialWeapons:AddKnife( "nz_knife_shovel", true, 0.65, (45/30) )
	nzSpecialWeapons:AddKnife( "nz_knife_katana", true, 0.65, (45/30) )
	nzSpecialWeapons:AddKnife( "nz_knife_hatchet", true, 0.65, (45/30) )
	nzSpecialWeapons:AddKnife( "nz_knife_pulverizer", true, 0.65, (45/30) )
	nzSpecialWeapons:AddKnife( "nz_knife_nunchuks", true, 0.65, (45/30) )
	nzSpecialWeapons:AddKnife( "nz_knife_prizefighter", true, 0.65, (45/30) )
	nzSpecialWeapons:AddKnife( "nz_knife_throwhands", true, 0.5, (45/30) )
	nzSpecialWeapons:AddKnife( "nz_knife_power", true, 0.5, (30/30) )
	nzSpecialWeapons:AddKnife( "nz_knife_galvatron", true, 0.5, 3 )
	nzSpecialWeapons:AddKnife( "nz_knife_saw", true, 0.65, (45/30) )
	nzSpecialWeapons:AddKnife( "nz_knife_axe", true, 0.65, (45/30) )
	nzSpecialWeapons:AddKnife( "nz_knife_bat", true, 0.65, (45/30) )
	nzSpecialWeapons:AddKnife( "nz_knife_heisenberg", true, 0.9, (60/30) )
	nzSpecialWeapons:AddKnife( "nz_knife_apothicon", true, 0.65, (45/30) )
	nzSpecialWeapons:AddKnife( "nz_knife_wrench_buyable", true, 0.65, (45/30) )
	nzSpecialWeapons:AddKnife( "nz_knife_sickle", true, 0.65, (45/30) )
	nzSpecialWeapons:AddKnife( "nz_knife_bowie_bo3", true, 0.5, 3 )
	nzSpecialWeapons:AddKnife( "nz_knife_bowie_bo4", false, 0.5)
	nzSpecialWeapons:AddKnife( "nz_knife_communism", false, 0.65)
	nzSpecialWeapons:AddKnife( "nz_knife_plunger", true, 0.5, 0)
	nzSpecialWeapons:AddKnife( "nz_knife_spork", true, 0.5, 0 )
	nzSpecialWeapons:AddKnife( "nz_knife_nightbreaker", true, 0.65, (45/30) )
	nzSpecialWeapons:AddKnife( "nz_yamato", true, 0.65, 2.5 )
	nzSpecialWeapons:AddKnife( "nz_buzz", true, 0.65, 2.5 )
	nzSpecialWeapons:AddKnife( "nz_oren", true, 0.65, 2.5 )
	nzSpecialWeapons:AddKnife( "nz_zweihander", true, 0.65, 2.5 )
	nzSpecialWeapons:AddKnife( "nz_ironjim", true, 0.65, (45/30) )
	nzSpecialWeapons:AddKnife( "nz_testwep", true, 0.65, 2.5 )
	nzSpecialWeapons:AddKnife( "nz_one_inch_punch", true, 0.75, 1.5 )
	
	nzSpecialWeapons:AddGrenade( "nz_grenade", 4, false, 0.85, false, 0.4 ) -- ALWAYS pass false instead of nil or it'll assume default value
	nzSpecialWeapons:AddGrenade( "nz_grenade_gas", 4, false, 0.85, false, 0.4 ) -- ALWAYS pass false instead of nil or it'll assume default value
	nzSpecialWeapons:AddGrenade( "nz_t97", 4, false, 1.1, false, 0.4 ) -- ALWAYS pass false instead of nil or it'll assume default value
	nzSpecialWeapons:AddGrenade( "nz_cluster", 4, false, 0.85, false, 0.4 ) -- ALWAYS pass false instead of nil or it'll assume default value
	nzSpecialWeapons:AddGrenade( "nz_grenaderpg", 4, false, 0.85, false, 0.4 ) -- ALWAYS pass false instead of nil or it'll assume default value
	nzSpecialWeapons:AddGrenade( "nz_holy", 4, false, 0.85, false, 0.4 ) -- ALWAYS pass false instead of nil or it'll assume default value

	nzSpecialWeapons:AddSpecialGrenade( "nz_monkey_bomb", 3, false, 3, false, 0.4 )
	nzSpecialWeapons:AddSpecialGrenade( "nz_seal6-claymore", 3, false, 1, false, 0.4 )
	nzSpecialWeapons:AddSpecialGrenade( "nz_tnt", 3, false, 1, false, 0.4 )
	nzSpecialWeapons:AddSpecialGrenade( "nz_rpg", 3, false, 0.75, false, 0.4 )
	nzSpecialWeapons:AddSpecialGrenade( "nz_molotov", 3, false, 1.4, false, 0.4 )
	

	nzSpecialWeapons:AddDisplay( "nz_revive_morphine", false, function(wep)
		return !IsValid(wep.Owner:GetPlayerReviving())
	end)
	
	nzSpecialWeapons:AddDisplay( "nz_perk_bottle", false, function(wep)
		return SERVER and CurTime() > wep.nzDeployTime + 3.1
	end)
	
	nzSpecialWeapons:AddDisplay( "nz_packapunch_arms", false, function(wep)
		return SERVER and CurTime() > wep.nzDeployTime + 2.5
	end)
end

hook.Add("InitPostEntity", "nzRegisterSpecialWeps", RegisterDefaultSpecialWeps)
--hook.Add("OnReloaded", "nzRegisterSpecialWeps", RegisterDefaultSpecialWeps)