game.AddParticles("particles/drops_powerups.pcf")
game.AddParticles("particles/perks_cherry.pcf")
game.AddParticles("particles/perks_phd.pcf")
game.AddParticles("particles/perks_zombshell.pcf")
game.AddParticles("particles/perks_razor.pcf")
game.AddParticles("particles/perks_vulture.pcf")

game.AddParticles("particles/perks_aat_blastfurnace.pcf")
game.AddParticles("particles/perks_aat_thunderwall.pcf")
game.AddParticles("particles/perks_aat_deadwire.pcf")
game.AddParticles("particles/perks_aat_fireworks.pcf")
game.AddParticles("particles/perks_aat_cryofreeze.pcf")
game.AddParticles("particles/perks_aat_turned.pcf")

game.AddParticles("particles/magicbox.pcf")

PrecacheParticleSystem("nz_powerup_purple")
PrecacheParticleSystem("nz_powerup_global")
PrecacheParticleSystem("nz_powerup_local")
PrecacheParticleSystem("nz_powerup_anti")
PrecacheParticleSystem("nz_powerup_mini")

PrecacheParticleSystem("nz_perks_cherry")
PrecacheParticleSystem("nz_perks_cherry_player")
PrecacheParticleSystem("nz_perks_phd")
PrecacheParticleSystem("nz_perks_zombshell")
PrecacheParticleSystem("nz_perks_razor_vm")
PrecacheParticleSystem("nz_perks_razor_trail")
PrecacheParticleSystem("nz_perks_vulture_stink")

PrecacheParticleSystem("bo3_aat_blastfurnace")
PrecacheParticleSystem("bo3_aat_thunderwall")
PrecacheParticleSystem("bo3_aat_deadwire")
PrecacheParticleSystem("bo3_aat_deadwire_ground")
PrecacheParticleSystem("bo3_aat_deadwire_jump")
PrecacheParticleSystem("bo3_aat_fireworks")
PrecacheParticleSystem("bo3_aat_freeze")
PrecacheParticleSystem("bo3_aat_freeze_explode")
PrecacheParticleSystem("bo3_aat_turned")

PrecacheParticleSystem("nz_magicbox")
PrecacheParticleSystem("nz_magicbox_sharing")

util.PrecacheModel("models/nzr/2022/perks/v_perkbottle.mdl")
util.PrecacheModel("models/nzr/2022/perks/w_perkbottle.mdl")

local nzombies = engine.ActiveGamemode() == "nzombies"

TFA.AlternateAmmoTypes = {
	[1] = {Cooldown = 15, icon = Material("vgui/aat/t7_hud_wp_aat_blastfurance.png", "smooth unlitgeneric")}, //Blast Furnace
	[2] = {Cooldown = 05, icon = Material("vgui/aat/t7_hud_wp_aat_deadwire.png", "smooth unlitgeneric")}, //Dead Wire
	[3] = {Cooldown = 20, icon = Material("vgui/aat/t7_hud_wp_aat_fireworks.png", "smooth unlitgeneric")}, //Fireworks
	[4] = {Cooldown = 10, icon = Material("vgui/aat/t7_hud_wp_aat_thunderwall.png", "smooth unlitgeneric")}, //Thunder Wall
	[5] = {Cooldown = 15, icon = Material("vgui/aat/t7_hud_wp_aat_cryofreeze.png", "smooth unlitgeneric")}, //Cryofreeze
	[6] = {Cooldown = 20, icon = Material("vgui/aat/t7_hud_cp_aat_turned.png", "smooth unlitgeneric")}, //Turned
	[7] = {Cooldown = 15, icon = Material("vgui/aat/t7_hud_cp_aat_bhole.png", "smooth unlitgeneric")}, //Black Hole
	[8] = {Cooldown = 10, icon = Material("vgui/aat/t7_hud_cp_aat_wonder.png", "smooth unlitgeneric")}, //Wonder Weapon
}

TFA.AddSound("NZ.Cherry.Shock", CHAN_STATIC, 1, SNDLVL_NORM, 100, {"nzr/2022/perks/cherry/zm_common.all.sabl.1796.wav", "nzr/2022/perks/cherry/zm_common.all.sabl.1797.wav", "nzr/2022/perks/cherry/zm_common.all.sabl.1798.wav", "nzr/2022/perks/cherry/zm_common.all.sabl.1799.wav", "nzr/2022/perks/cherry/zm_common.all.sabl.1800.wav", "nzr/2022/perks/cherry/zm_common.all.sabl.1801.wav"},")")

TFA.AddSound("NZ.PHD.Wubz", CHAN_USER_BASE, 1, SNDLVL_GUNFIRE, 100, "nzr/2022/perks/phd/mori2_perk_phd_explode.wav",")")
TFA.AddSound("NZ.PHD.Explode", CHAN_AUTO, 1, SNDLVL_TALKING, 100, "nzr/2022/perks/phd/c4_det.wav",")")
TFA.AddSound("NZ.PHD.Impact", CHAN_VOICE_BASE, 1, SNDLVL_NORM, 100, {"nzr/2022/perks/phd/impact_00.wav", "nzr/2022/perks/phd/impact_01.wav"},")")

TFA.AddSound("NZ.ZombShell.Start", CHAN_STATIC, 1, SNDLVL_GUNFIRE, 100, "nzr/2022/perks/zombshell/zm_common.all.p.sabl.105.wav",")")
TFA.AddSound("NZ.ZombShell.Loop", CHAN_WEAPON, 1, SNDLVL_NORM, 100, "nzr/2022/perks/zombshell/zm_common.all.p.sabl.104.wav",")")
TFA.AddSound("NZ.ZombShell.End", CHAN_WEAPON, 1, SNDLVL_TALKING, 100, {"nzr/2022/perks/zombshell/zm_common.all.p.sabl.99.wav", "nzr/2022/perks/zombshell/zm_common.all.p.sabl.100.wav", "nzr/2022/perks/zombshell/zm_common.all.p.sabl.101.wav", "nzr/2022/perks/zombshell/zm_common.all.p.sabl.102.wav"},")")

TFA.AddSound("NZ.POP.BlastFurnace.Die", CHAN_STATIC, 1, SNDLVL_NORM, 100, {"nzr/2022/perks/pop/blastfurnace/flame_burst_00.wav", "nzr/2022/perks/pop/blastfurnace/flame_burst_01.wav", "nzr/2022/perks/pop/blastfurnace/flame_burst_02.wav", "nzr/2022/perks/pop/blastfurnace/flame_burst_03.wav"},")")
TFA.AddSound("NZ.POP.BlastFurnace.Expl", CHAN_STATIC, 1, SNDLVL_GUNFIRE, 100, {"nzr/2022/perks/pop/blastfurnace/exp_incendiary_00.wav", "nzr/2022/perks/pop/blastfurnace/exp_incendiary_01.wav", "nzr/2022/perks/pop/blastfurnace/exp_incendiary_02.wav"},")")
TFA.AddSound("NZ.POP.BlastFurnace.Sweet", CHAN_STATIC, 1, SNDLVL_GUNFIRE, 100, "nzr/2022/perks/pop/blastfurnace/flame_burst_00.wav", "nzr/2022/perks/pop/blastfurnace/wpn_incindiary_core_start.wav",")")

TFA.AddSound("NZ.POP.Deadwire.Die", CHAN_STATIC, 1, SNDLVL_NORM, 100, {"nzr/2022/perks/pop/deadwire/zmb_dg2_death_soul_00.wav", "nzr/2022/perks/pop/deadwire/zmb_dg2_death_soul_01.wav", "nzr/2022/perks/pop/deadwire/zmb_dg2_death_soul_02.wav", "nzr/2022/perks/pop/deadwire/zmb_dg2_death_soul_03.wav", "nzr/2022/perks/pop/deadwire/zmb_dg2_death_soul_04.wav", "nzr/2022/perks/pop/deadwire/zmb_dg2_death_soul_05.wav", "nzr/2022/perks/pop/deadwire/zmb_dg2_death_soul_06.wav"},")")
TFA.AddSound("NZ.POP.Deadwire.Shock", CHAN_STATIC, 1, SNDLVL_GUNFIRE, 100, {"nzr/2022/perks/pop/deadwire/shock_effect_01.wav", "nzr/2022/perks/pop/deadwire/shock_effect_02.wav"},")")

TFA.AddSound("NZ.POP.Fireworks.Whistle", CHAN_STATIC, 1, SNDLVL_GUNFIRE, 100, {"nzr/2022/perks/pop/fireworks/whistle_00.wav", "nzr/2022/perks/pop/fireworks/whistle_01.wav", "nzr/2022/perks/pop/fireworks/whistle_02.wav", "nzr/2022/perks/pop/fireworks/whistle_03.wav", "nzr/2022/perks/pop/fireworks/whistle_04.wav"},")")
TFA.AddSound("NZ.POP.Fireworks.Expl", CHAN_STATIC, 1, SNDLVL_GUNFIRE, 100, {"nzr/2022/perks/pop/fireworks/explo_small_00.wav", "nzr/2022/perks/pop/fireworks/explo_small_01.wav", "nzr/2022/perks/pop/fireworks/explo_small_02.wav", "nzr/2022/perks/pop/perks/fireworks/explo_small_03.wav", "nzr/2022/perks/pop/fireworks/explo_small_04.wav"},")")
TFA.AddSound("NZ.POP.Fireworks.Shoot", CHAN_STATIC, 1, SNDLVL_TALKING, 100, "nzr/2022/perks/pop/fireworks/wpn_pap_first.wav",")")

TFA.AddSound("NZ.POP.Thunderwall.Shoot", CHAN_STATIC, 1, SNDLVL_GUNFIRE, 90, "nzr/2022/perks/pop/thunderwall/wpn_pap_launcher.wav",")")

TFA.AddSound("NZ.POP.Cryofreeze.Freeze", CHAN_STATIC, 1, SNDLVL_NORM, 100, {"nzr/2022/perks/pop/cryofreeze/bo4_winters_zombfreeze01.wav", "nzr/2022/perks/pop/cryofreeze/bo4_winters_zombfreeze02.wav", "nzr/2022/perks/pop/cryofreeze/bo4_winters_zombfreeze03.wav"},")")
TFA.AddSound("NZ.POP.Cryofreeze.Shatter", CHAN_STATIC, 1, SNDLVL_TALKING, 100, {"nzr/2022/perks/pop/cryofreeze/bo4_winters_zombshatter01.wav", "nzr/2022/perks/pop/cryofreeze/bo4_winters_zombshatter02.wav", "nzr/2022/perks/pop/cryofreeze/bo4_winters_zombshatter03.wav"},")")
TFA.AddSound("NZ.POP.Cryofreeze.Wind", CHAN_STATIC, 1, SNDLVL_NORM, 100, {"nzr/2022/perks/pop/cryofreeze/fly_freezegun_proj_wind01.wav", "nzr/2022/perks/pop/cryofreeze/fly_freezegun_proj_wind02.wav"},")")

TFA.AddSound("NZ.Vulture.Stink.Start", CHAN_WEAPON, 1, SNDLVL_IDLE, 100, "nzr/2022/perks/vultures/stink/start.wav",")")
TFA.AddSound("NZ.Vulture.Stink.Loop", CHAN_VOICE2, 0.3, SNDLVL_IDLE, 100, "nzr/2022/perks/vultures/stink/loop.wav",")")
TFA.AddSound("NZ.Vulture.Stink.Stop", CHAN_VOICE2, 1, SNDLVL_IDLE, 100, "nzr/2022/perks/vultures/stink/stop.wav",")")

TFA.AddSound("NZ.ChuggaBud.Charge", CHAN_STATIC, 1, SNDLVL_NORM, 100, "nzr/2022/perks/chuggabud/ww_deactivate.wav",")")
TFA.AddSound("NZ.ChuggaBud.Stinger", CHAN_VOICE2, 1, SNDLVL_TALKING, 100, "nzr/2022/perks/chuggabud/ww_looper.wav",")")
TFA.AddSound("NZ.ChuggaBud.Teleport", CHAN_STATIC, 1, SNDLVL_TALKING, 100, "nzr/2022/perks/chuggabud/mpl_flashback_reappear_plr.wav",")")
TFA.AddSound("NZ.ChuggaBud.Sweet", CHAN_STATIC, 1, SNDLVL_GUNFIRE, 100, {"nzr/2022/perks/chuggabud/teleport_out_00.wav", "nzr/2022/perks/chuggabud/teleport_out_01.wav"},")")

TFA.AddSound("NZ.BO2.Box.Open", CHAN_STATIC, 1, SNDLVL_NORM, 100, "nzr/2022/magicbox/bo2/open_00.wav",")")
TFA.AddSound("NZ.BO2.Box.Close", CHAN_STATIC, 1, SNDLVL_NORM, 100, "nzr/2022/magicbox/bo2/close_00.wav",")")
TFA.AddSound("NZ.BO2.Box.Land", CHAN_STATIC, 1, SNDLVL_TALKING, 100, "nzr/2022/magicbox/bo2/land_00.wav",")")
TFA.AddSound("NZ.BO2.Box.Disappear", CHAN_STATIC, 1, SNDLVL_TALKING, 100, "nzr/2022/magicbox/bo2/disappear_00.wav",")")
TFA.AddSound("NZ.BO2.Box.Flux", CHAN_STATIC, 1, SNDLVL_GUNFIRE, 100, "nzr/2022/magicbox/bo2/flux_00.wav",")")
TFA.AddSound("NZ.BO2.Box.Poof", CHAN_STATIC, 1, SNDLVL_GUNFIRE, 100, "nzr/2022/magicbox/bo2/poof_00.wav",")")
TFA.AddSound("NZ.BO2.Box.Woosh", CHAN_STATIC, 1, SNDLVL_TALKING, 100, "nzr/2022/magicbox/bo2/whoosh_00.wav",")")
TFA.AddSound("NZ.BO2.Box.Spin", CHAN_STATIC, 1, SNDLVL_TALKING, 100, "nzr/2022/magicbox/bo2/zmb_box_spin.wav",")")
TFA.AddSound("NZ.BO2.Box.Music", CHAN_ITEM, 1, SNDLVL_TALKING, 100, "nzr/2022/magicbox/bo2/music_box_00.wav",")")

TFA.AddSound("NZ.BOTD.Box.Open", CHAN_STATIC, 1, SNDLVL_NORM, 100, "nz/mysterybox/BotD_box_open.wav",")")
TFA.AddSound("NZ.BOTD.Box.Close", CHAN_STATIC, 1, SNDLVL_NORM, 100, "nz/mysterybox/BotD_box_close.wav",")")

TFA.AddSound("NZ.Chaos.Box.Open", CHAN_STATIC, 1, SNDLVL_NORM, 100, "nz/mysterybox/chaos_box_open.wav",")")
TFA.AddSound("NZ.Chaos.Box.Close", CHAN_STATIC, 1, SNDLVL_NORM, 100, "nz/mysterybox/chaos_box_close.wav",")")

TFA.AddSound("NZ.SOE.Box.Open", CHAN_STATIC, 1, SNDLVL_NORM, 100, "nz/mysterybox/SoE_Box_Open.wav",")")
TFA.AddSound("NZ.SOE.Box.Close", CHAN_STATIC, 1, SNDLVL_NORM, 100, "nz/mysterybox/SoE_Box_Close.wav",")")

TFA.AddSound("NZ.DS.Box.Open", CHAN_STATIC, 1, SNDLVL_NORM, 100, "enemies/bosses/raz/melee_start.ogg",")")
TFA.AddSound("NZ.DS.Box.Close", CHAN_STATIC, 1, SNDLVL_NORM, 100, "enemies/bosses/raz/raz_gun_charge.ogg",")")

TFA.AddSound("NZ.BO2.TombBox.Open", CHAN_STATIC, 1, SNDLVL_NORM, 100, "nzr/2022/magicbox/bo2/tomb/magic_box_open.wav",")")
TFA.AddSound("NZ.BO2.TombBox.Close", CHAN_STATIC, 1, SNDLVL_NORM, 100, "nzr/2022/magicbox/bo2/tomb/magic_box_close.wav",")")
TFA.AddSound("NZ.BO2.TombBox.Arrive", CHAN_STATIC, 1, SNDLVL_TALKING, 100, "nzr/2022/magicbox/bo2/tomb/magicbox_arrive.wav",")")
TFA.AddSound("NZ.BO2.TombBox.Leave", CHAN_STATIC, 1, SNDLVL_TALKING, 100, "nzr/2022/magicbox/bo2/tomb/magicbox_leave.wav",")")
TFA.AddSound("NZ.BO2.TombBox.Spin", CHAN_STATIC, 1, SNDLVL_TALKING, 100, "nzr/2022/magicbox/bo2/tomb/magicbox_gun_select.wav",")")

TFA.AddSound ("NZ.Misc.Achievment", CHAN_STATIC, 1, SNDLVL_NORM, 100, "nzr/2022/effects/player/unlock.wav",")")

TFA.AddWeaponSound("NZ.Bottle.Belch", "nzr/2022/perks/bottle/belch.wav")
TFA.AddWeaponSound("NZ.Bottle.Break", "nzr/2022/perks/bottle/break.wav")
TFA.AddWeaponSound("NZ.Bottle.Dispense", "nzr/2022/perks/bottle/dispense.wav")
TFA.AddWeaponSound("NZ.Bottle.Open", "nzr/2022/perks/bottle/open.wav")
TFA.AddWeaponSound("NZ.Bottle.Drink", "nzr/2022/perks/bottle/swallow.wav")

TFA.AddWeaponSound("NZ.Hands.Knuckle0", "nzr/2022/pap/knuckle_00.wav")
TFA.AddWeaponSound("NZ.Hands.Knuckle1", "nzr/2022/pap/knuckle_01.wav")

if not ConVarExists("nz_perkmodifiers") then CreateConVar("nz_perkmodifiers", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}) end

local sp = game.SinglePlayer()
local cvar_modifiers = GetConVar("nz_perkmodifiers")
local cvar_downtime = GetConVar("nz_downtime")

if nzombies then
	////////////////////////////////////////////////////////////////////
	////						SERVER HOOKS						////
	////////////////////////////////////////////////////////////////////

	if SERVER then
		hook.Add("PlayerRevived", "nzcanigetaREVIVE", function(ply, revivor)
			local count = 0
			for k, v in RandomPairs(ply.OldPerks) do
				if IsValid(revivor) and revivor:HasUpgrade("revive") then
					if revivor == ply and v == "revive" then continue end
					ply:GivePerk(v)

					continue
				elseif ply:GetNW2Bool("nz.GinMod") then
					if v == "gin" then continue end
					ply:GivePerk(v)

					continue
				else
					if count >= math.floor(#ply.OldPerks/2) then break end
					if #player.GetAll() <= 1 and v == "revive" then continue end

					ply:GivePerk(v)
					count = count + 1
				end
			end

			if ply:GetNW2Bool("nz.GinMod") then
				ply:SetNW2Bool("nz.GinMod", false)
			end
		end)

		hook.Add("OnRoundStart", "nzbegaydodrugshailsatan", function(num)
			for _, ply in pairs(player.GetAll()) do
				if ply:Alive() and ply:HasPerk("everclear") then
					ply.ZombShellCount = 1
				end

				if ply:Alive() and ply:HasUpgrade("mulekick") then
					for _, wep in pairs(ply:GetWeapons()) do
						if wep.NZSpecialCategory == "specialgrenade" then
							local ammocount = ply:GetAmmoCount(GetNZAmmoID("specialgrenade"))
							ply:SetAmmo(math.Min(ammocount + 1, 3), GetNZAmmoID("specialgrenade"))
						end
					end
				end

				if ply:Alive() and ply:HasUpgrade("tortoise") then
					local shield = ply:GetShield()
					local fuck = false
					for k, v in pairs(ply:GetWeapons()) do
						if v.NZSpecialCategory == "shield" then
							fuck = true
						end
					end

					if not IsValid(shield) and not fuck then
						ply:Give("tfa_bo2_tranzitshield")
					elseif IsValid(shield) then
						shield:SetHealth(shield:GetMaxHealth())
						if IsValid(shield:GetWeapon()) then
							shield:GetWeapon():SetDamage(0)
						end
					end
				end
			end
		end)

		hook.Add("OnRoundEnd", "akdljmfnadkjfjaldkfdkjl", function(num)
			for k, v in pairs(player.GetAll()) do
				v.OldWeapons = {}
			end
		end)

		hook.Add("OnPlayerGetPerk", "nzbo4porpoganda", function(ply, perk, machine)
			if cvar_modifiers:GetBool() and #ply:GetPerks() == 4 then
				ply:GiveUpgrade(perk)
				if perk == "gin" then
					ply:SetNW2Bool("nz.GinMod", true)
				end
			end
		end)

		hook.Add("OnPlayerBuyPerk", "nztombstoneunstinkifier2", function(ply, perk, machine)
			local fuck = false
			for k, v in pairs(player.GetAll()) do
				if v:HasPerk("tombstone") then
					fuck = true	
				break end
			end

			if perk == "tombstone" and not fuck then
				cvar_downtime:SetFloat(cvar_downtime:GetFloat() * 2)
			end
		end)

		hook.Add("OnPlayerLostPerk", "nztombstonebleeding", function(ply, perk, forced)
			local fuck = false
			for k, v in pairs(player.GetAll()) do
				if v:HasPerk("tombstone") then
					fuck = true	
				break end
			end

			if perk == "tombstone" and not fuck then
				cvar_downtime:SetFloat(cvar_downtime:GetFloat() * 0.5)
			end
		end)

		hook.Add("OnPlayerPickupPowerUp", "nztemporalgift", function(ply, id, ent)
			local fuck = false
			for k, v in pairs(player.GetAll()) do
				if v:HasUpgrade("time") then
					fuck = true	
				break end
			end

			local PowerupData = nzPowerUps:Get(id)
			if fuck and PowerupData.duration ~= 0 then
				nzPowerUps.ActivePowerUps[id] = (nzPowerUps.ActivePowerUps[id] or CurTime()) + (PowerupData.duration * 2)
				nzPowerUps:SendSync()
			end
		end)
	end

	////////////////////////////////////////////////////////////////////
	////						CLIENT HOOKS						////
	////////////////////////////////////////////////////////////////////

	if CLIENT then
		local tab = {
			["$pp_colour_addr"] = 0.05,
			["$pp_colour_addg"] = 0.2,
			["$pp_colour_addb"] = 0.0,
			["$pp_colour_brightness"] = 0.0,
			["$pp_colour_contrast"] = 1,
			["$pp_colour_colour"] = 1.1,
			["$pp_colour_mulr"] = 0,
			["$pp_colour_mulg"] = 0,
			["$pp_colour_mulb"] = 0,
		}

		hook.Add("RenderScreenspaceEffects","nzUhohhhhStinky",function()
			local ply = LocalPlayer()
			if not IsValid(ply) then return end

			if ply:HasVultureStink() then
				DrawColorModify(tab)
			end
			if ply:HasPerkBlur() then
				DrawMotionBlur(0.4, ply:PerkBlurIntensity(), 0.015)
			end
		end)

		hook.Add("HUDPaint", "nzElementalHud", function()
			local ply = LocalPlayer()
			if not IsValid(ply) then return end

			if ply:HasPerk("pop") then
				local fadefac = 0
				local PopDelay = ply:GetNW2Float("nz.EPopDecay", 0)
				local PopEffect = ply:GetNW2Int("nz.EPopEffect", 1)

				local aats ={
					[1] = Material("vgui/aat/t7_hud_cp_aat_blastfurnace.png", "smooth unlitgeneric"),
					[2] = Material("vgui/aat/t7_hud_cp_aat_deadwire.png", "smooth unlitgeneric"),
					[3] = Material("vgui/aat/t7_hud_cp_aat_fireworks.png", "smooth unlitgeneric"),
					[4] = Material("vgui/aat/t7_hud_cp_aat_thunderwall.png", "smooth unlitgeneric"),
					[5] = Material("vgui/aat/t7_hud_cp_aat_cryofreeze.png", "smooth unlitgeneric"),
					[6] = Material("vgui/aat/t7_hud_cp_aat_turned.png", "smooth unlitgeneric"),
					[7] = Material("vgui/aat/t7_hud_cp_aat_bhole.png", "smooth unlitgeneric"),
					[8] = Material("vgui/aat/t7_hud_cp_aat_wonder.png", "smooth unlitgeneric"),
				}

				if PopDelay > CurTime() then
					fadefac = PopDelay - CurTime()
					fadefac = math.Clamp(fadefac / 2, 0, 1)
				end

				surface.SetMaterial(aats[PopEffect])
				surface.SetDrawColor(255,255,255,255*fadefac)
				surface.DrawTexturedRect(ScrW() / 2 - 32, ScrH() / 2 - 32, 64, 128)
			end

			if ply:HasPerk("deadshot") then
				local fadefac = 0
				local notifdelay = ply:GetNW2Float("nz.DeadshotDecay", 0)
				if notifdelay > CurTime() then
					fadefac = notifdelay - CurTime()
					fadefac = math.Clamp(fadefac / 1, 0, 1)
				end

				surface.SetMaterial(Material("vgui/hud/hud_headshoticon.png", "smooth unlitgeneric"))
				surface.SetDrawColor(255,255,255,255*fadefac)
				surface.DrawTexturedRect(ScrW() / 2 - 32, ScrH() / 2 - 32, 64, 128)
			end
		end)

		hook.Add("HUDWeaponPickedUp", "nzFUCKYOUUUUUUUU", function(wep)
			if not IsValid(wep) then return end
			if wep:GetClass() == "tfa_perk_bottle" then
				return true
			end
			if wep:GetClass() == "tfa_paparms" then
				return true
			end
			if wep:GetClass() == "tfa_zomdeath" then
				return true
			end
		end)
	end

	////////////////////////////////////////////////////////////////////
	////						SHARED HOOKS						////
	////////////////////////////////////////////////////////////////////

	hook.Add("TFA_PostPrimaryAttack", "nzimafirinmahlaza", function(wep)
		local ply = wep:GetOwner()
		if not IsValid(ply) or not ply:IsPlayer() then return end

		if SERVER then
			local fuck = false
			if wep:GetStatL("Primary.ClipSize") <= 0 and wep:Ammo1() < wep:GetStatL("Primary.AmmoConsumption") then
				fuck = true
			end
			if wep:GetPrimaryClipSize(true) > 0 and wep:Clip1() < wep:GetStatL("Primary.AmmoConsumption") then
				fuck = true
			end

			if ply:HasUpgrade("cherry") and fuck and ply:GetNW2Float("nz.CherryWaffe", 0) < CurTime() then
				wep:EmitGunfireSound("TFA_BO3_WAFFE.Shoot")

				local waff = ents.Create("bo3_ww_wunderwaffe")
				waff:SetModel("models/dav0r/hoverball.mdl")
				waff:SetPos(ply:GetShootPos())
				waff:SetAngles(wep:GetAimVector():Angle())
				waff:SetOwner(ply)
				waff.Inflictor = wep

				waff.Damage = 115
				waff.mydamage = 115
				waff.MaxChain = math.random(4, 6)
				waff.ZapRange = 300 * (1 - math.Clamp(ply:GetNW2Int("nz.CherryCount", 0) / 10, 0, 0.9))

				waff:Spawn()

				waff:SetOwner(ply)
				waff.Inflictor = wep

				local dir = wep:GetAimVector()
				dir:Mul(2000)

				waff:SetVelocity(dir)
				local phys = waff:GetPhysicsObject()
				if IsValid(phys) then
					phys:SetVelocity(dir)
				end

				ply:SetNW2Float("nz.CherryWaffe", CurTime() + 10)
			end
		end
	end)

	hook.Add("TFA_SecondaryAttack", "nzDeadshotMod", function(wep)
		local ply = wep:GetOwner()
		if not IsValid(ply) or not ply:IsPlayer() then return end

		if ply:HasUpgrade("deadshot") then
			local tr = ply:GetEyeTrace()
			local ent = tr.Entity
			if IsValid(ent) and ent:IsValidZombie() and ent:Health() > 0 then
				local head
				for i = 0, ent:GetHitBoxCount(0) do
					if ent:GetHitBoxHitGroup(i,0) == HITGROUP_HEAD then
						head = ent:GetHitBoxBone(i, 0)
						break
					end
				end

				if not head then
					for i = 0, ent:GetHitBoxCount(0) do
						if ent:GetHitBoxHitGroup(i,0) == HITGROUP_GENERIC then
							head = ent:GetHitBoxBone(i, 0)
							break
						end
					end
				end

				if head then
					local headpos, headang = ent:GetBonePosition(head)
					headpos = ply:KeyDown(IN_ATTACK) and (headpos - Vector(0,0,8)) or headpos
					ply:SetEyeAngles((headpos - ply:GetShootPos()):Angle())
				end
			end
		end
	end)

	hook.Add("TFA_CompleteReload", "nzCherryBool", function(wep)
		if wep.NZSpecialCategory then return end
		local ply = wep:GetOwner()
		if not IsValid(ply) or not ply:IsPlayer() then return end

		if ply:HasPerk("cherry") then
			ply:SetNW2Bool("nz.CherryBool", false)
		end
	end)

	hook.Add("TFA_LoadShell", "nzCherryBool2", function(wep)
		if wep.NZSpecialCategory then return end
		local ply = wep:GetOwner()
		if not IsValid(ply) or not ply:IsPlayer() then return end

		if ply:HasPerk("cherry") then
			ply:SetNW2Bool("nz.CherryBool", false)
		end
	end)

	hook.Add("TFA_Reload", "nzCherry", function(wep)
		local ply = wep:GetOwner()
		if not IsValid(ply) or not ply:IsPlayer() then return end
		if wep.NZSpecialCategory then return end

		if ply:HasPerk("cherry") and not ply:GetNW2Bool("nz.CherryBool") and ply:GetAmmoCount(wep:GetPrimaryAmmoType()) > 0 then
			ply:SetNW2Bool("nz.CherryBool", true)

			local round = nzRound:GetNumber() > 0 and nzRound:GetNumber() or 1

			if ply:GetNW2Float("nz.CherryDelay", 0) < CurTime() and ply:GetNW2Int("nz.CherryCount", 0) > 0 then
				ply:SetNW2Int("nz.CherryCount", 0)
			end

			local scale = 1 - math.Clamp(ply:GetNW2Int("nz.CherryCount", 0) / 10, 0, 0.9)
			local proc = 1 - math.Clamp(wep:Clip1() / wep.Primary.ClipSize, 0, 1)
			local dmg = (200 * math.pow(1.1, math.floor(round/2) - 1)) * proc

			local damage = DamageInfo()
			damage:SetDamage(dmg * scale)
			damage:SetDamageType(DMG_SHOCK)
			damage:SetAttacker(ply)
			damage:SetInflictor(wep)

			for k, v in pairs(ents.FindInSphere(ply:GetPos(), 150 * proc)) do
				if (v:IsNPC() or v:IsNextBot()) and v:Health() > 0 then
					damage:SetDamagePosition(v.EyePos and v:EyePos() or v:WorldSpaceCenter())
					damage:SetDamageForce(v:GetUp())

					if ply:HasUpgrade("cherry") then
						damage:SetDamage(v:Health() + 666)
					end

					if damage:GetDamage() >= v:Health() then
						ParticleEffectAttach("bo3_waffe_electrocute", PATTACH_POINT_FOLLOW, v, 2)
						if v:OnGround() then
							ParticleEffectAttach("bo3_waffe_ground", PATTACH_ABSORIGIN_FOLLOW, v, 0)
						end
						if v:IsValidZombie() and not v.IsMooSpecial then
							ParticleEffectAttach("bo3_waffe_eyes", PATTACH_POINT_FOLLOW, v, 3)
							ParticleEffectAttach("bo3_waffe_eyes", PATTACH_POINT_FOLLOW, v, 4)
						end
					end

					if SERVER then
						v:TakeDamageInfo(damage)
					end

					damage:SetDamage(dmg * scale)
				end
			end

			ply:SetNW2Int("nz.CherryCount", ply:GetNW2Int("nz.CherryCount", 0) + 1)
			ply:SetNW2Float("nz.CherryDelay", CurTime() + 10)

			if IsFirstTimePredicted() then
				ParticleEffectAttach("nz_perks_cherry", PATTACH_ABSORIGIN_FOLLOW, ply, 0)
				ply:EmitSound("NZ.Cherry.Shock")
			end

			timer.Simple(scale, function()
				if not IsValid(ply) then return end
				ply:StopParticles()
			end)
		end
	end)

	hook.Add("TFA_PostReload", "nzRandoPolitan", function(wep)
		if not IsValid(wep) then return end
		local ply = wep:GetOwner()
		if not IsValid(ply) or not ply:IsPlayer() then return end

		if SERVER and ply:HasPerk("politan") then
			if ply:HasPerk("cherry") then
				ply:SetNW2Bool("nz.CherryBool", false)
			end

			for k, v in RandomPairs(nzMapping.Settings.rboxweps) do
				local gun = weapons.Get(k)
				if gun and not gun.NZSpecialCategory then
					ply:StripWeapon(wep:GetClass())
					ply:Give(k)
					break
				end
			end
		end
	end)
end