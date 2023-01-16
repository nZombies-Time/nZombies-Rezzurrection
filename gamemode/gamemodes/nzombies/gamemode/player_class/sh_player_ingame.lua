DEFINE_BASECLASS( "player_default" )

local PLAYER = {}

PLAYER.Health 			= nzMapping.Settings.hp
PLAYER.WalkSpeed 			= 195 -- Moo Mark. Lowered player speed slightly, Sprinting Zombies should only slowly lose distance on you. But Supersprinting Zombies have no issue catching up. This was done testing player speed in BO4 so I don't wanna hear any shit.
PLAYER.RunSpeed				= 310 -- Don't worry, the overall stamina is being increased to around 8 seconds to make up for this.
PLAYER.JumpPower			= 200
PLAYER.CanUseFlashlight     = true

function PLAYER:SetupDataTables()
	self.Player:NetworkVar("Bool", 0, "UsingSpecialWeapon")
end

function PLAYER:Init()
end

if not ConVarExists("nz_failsafe_preventgrenades") then CreateConVar("nz_failsafe_preventgrenades", 0, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_NOTIFY}) end

function PLAYER:Loadout()
	if nzMapping.Settings.startwep then
		self.Player:Give(nzMapping.Settings.startwep)
	else
		self.Player:Give("robotnik_bo1_1911")
	end

	self.Player:GiveMaxAmmo()

	if not GetConVar("nz_papattachments"):GetBool() and FAS2_Attachments ~= nil then
		for k,v in pairs(FAS2_Attachments) do
			self.Player:FAS2_PickUpAttachment(v.key)
		end
	end

	if nzMapping.Settings.knife then
		self.Player:Give(nzMapping.Settings.knife)
	else
		self.Player:Give("nz_knife_boring")
	end

	if not GetConVar("nz_failsafe_preventgrenades"):GetBool() then
		self.Player:Give("tfa_bo1_m67")
	end

	timer.Simple(1, function()
		if not IsValid(ply) then return end

		if ply.OldWeapons and not table.IsEmpty(ply.OldWeapons) then
			for k, v in pairs(ply.OldWeapons) do
				local wep = ply:Give(v.class)
				ply:PrintMessage(HUD_PRINTTALK, "Restored player "..ply:Nick().."'s "..v.class)

				if IsValid(wep) and v.pap then
					timer.Simple(0, function()
						if not IsValid(wep) then return end
						wep:ApplyNZModifier("pap")
					end)
				end
			end
		end

		ply.OldWeapons = nil
	end)
end

function PLAYER:Spawn()
	local starting = nzMapping.Settings.startpoints or 500
	local round = nzRound:GetNumber() > 0 and nzRound:GetNumber() or 1
	local points = round * starting

	if not self.Player:CanAfford(starting) then
		self.Player:SetPoints(points)
	end

	local health = nzMapping.Settings.hp
	self.Player:SetHealth(health and health or 100)
	self.Player:SetMaxHealth(health and health or 100)

	self.Player:RemovePerks()
	nzPerks.PlayerUpgrades[self] = {}

	self.Player:SetTargetPriority(TARGET_PRIORITY_PLAYER)

	local spawns = ents.FindByClass("player_spawns")
	for k, v in pairs(player.GetAll()) do
		if v == self.Player then
			if IsValid(spawns[k]) then
				v:SetPos(spawns[k]:GetPos())
			else
				print("No spawn set for player: " .. v:Nick())
			end
		end
	end
	
	self.Player:SetUsingSpecialWeapon(false)
end

function PLAYER:OnTakeDamage(dmginfo)
end

player_manager.RegisterClass( "player_ingame", PLAYER, "player_default" )
