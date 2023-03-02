AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

DEFINE_BASECLASS( "base_anim" )

local nzombies = engine.ActiveGamemode() == "nzombies"

function ENT:Initialize()
	local mdl = self:GetModel()
	if not mdl or mdl == "" or mdl == "models/error.mdl" then
		self:SetModel("models/nzr/song_ee/teddybear.mdl")
	end

	if self:GetHurtType() == nil then
		self:SetHurtType(4)
	end
	if self:GetRewardType() == nil then
		self:SetRewardType(2)
	end
	if self:GetPointAmount() == nil then
		self:SetPointAmount(1000)
	end
	if self:GetGlobal() == nil and #player.GetAllPlaying() > 1 then
		self:SetGlobal(true)
	end

	self:DrawShadow(true)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:SetTrigger(true)
	self:SetUseType(SIMPLE_USE)
end

local switch_reward = {
	[1] = function(self, ply)
		local count = 1
		for k, v in pairs(ents.FindByClass("nz_shootable")) do
			if not v.Activated then
				count = count + 1
			end
		end

		if self.KillAll and count > 1 then
			count = count - 1
			PrintMessage(HUD_PRINTTALK, ply:Nick().." found a secret! "..count.." remaining.")
		else
			PrintMessage(HUD_PRINTTALK, ply:Nick().." found a secret! Bonus points rewarded.")
			if self:GetGlobal() then
				for k, v in pairs(player.GetAllPlaying()) do
					v:GivePoints(self:GetPointAmount())
				end
			else
				ply:GivePoints(self:GetPointAmount())
			end
		end

		ply:EmitSound("NZ.Misc.Stinger")
		self:SetNoDraw(true)
		self:SetSolid(SOLID_NONE)
	end,
	[2] = function(self, ply)
		local count = 1
		for k, v in pairs(ents.FindByClass("nz_shootable")) do
			if not v.Activated then
				count = count + 1
			end
		end

		if self.KillAll and count > 1 then
			count = count - 1
			PrintMessage(HUD_PRINTTALK, ply:Nick().." found a secret! "..count.." remaining.")
		else
			PrintMessage(HUD_PRINTTALK, ply:Nick().." found a secret! Random perk rewarded.")
			if self:GetGlobal() then
				for k, v in pairs(player.GetAllPlaying()) do
					v:GivePerk(self:RandomPerk(v))
				end
			else
				ply:GivePerk(self:RandomPerk(ply))
			end
		end

		ply:EmitSound("NZ.Misc.Stinger")
		self:SetNoDraw(true)
		self:SetSolid(SOLID_NONE)
	end,
	[3] = function(self, ply)
		local count = 1
		for k, v in pairs(ents.FindByClass("nz_shootable")) do
			if not v.Activated then
				count = count + 1
			end
		end

		if self.KillAll and count > 1 then
			count = count - 1
			PrintMessage(HUD_PRINTTALK, ply:Nick().." found a secret! "..count.." remaining.")
		else
			PrintMessage(HUD_PRINTTALK, ply:Nick().." found a secret! Pack a' Punch rewarded.")
			if self:GetGlobal() then
				for k, v in pairs(player.GetAllPlaying()) do
					self:GivePap(v)
				end
			else
				self:GivePap(ply)
			end
		end

		ply:EmitSound("NZ.Misc.Stinger")
		self:SetNoDraw(true)
		self:SetSolid(SOLID_NONE)
	end,
	[4] = function(self, ply)
		local count = 1
		for k, v in pairs(ents.FindByClass("nz_shootable")) do
			if not v.Activated then
				count = count + 1
			end
		end

		if self.KillAll and count > 1 then
			count = count - 1
			PrintMessage(HUD_PRINTTALK, ply:Nick().." found a secret! "..count.." remaining.")
		else
			PrintMessage(HUD_PRINTTALK, ply:Nick().." found a secret! A Door somewhere has opened...")
			print(self:GetDoorFlag())
			nzDoors:OpenLinkedDoors(self:GetDoorFlag())
		end

		ply:EmitSound("NZ.Misc.Stinger")
		self:SetNoDraw(true)
		self:SetSolid(SOLID_NONE)
	end,
	[5] = function(self, ply)
		local count = 1
		for k, v in pairs(ents.FindByClass("nz_shootable")) do
			if not v.Activated then
				count = count + 1
			end
		end

		if self.KillAll and count > 1 then
			count = count - 1
			PrintMessage(HUD_PRINTTALK, ply:Nick().." found a secret! "..count.." remaining.")
		else
			PrintMessage(HUD_PRINTTALK, ply:Nick().." found a secret! Electricity Activated.")
			nzElec:Activate()
		end

		ply:EmitSound("NZ.Misc.Stinger")
		self:SetNoDraw(true)
		self:SetSolid(SOLID_NONE)
	end,
}

function ENT:GivePap(ply)
	local wep = ply:GetActiveWeapon()
	if wep.NZPaPReplacement then
		timer.Simple(0, function()
			if not IsValid(ply) or not IsValid(wep) then return end

			ply:StripWeapon(wep:GetClass())
			local wep2 = ply:Give(wep.NZPaPReplacement)
			wep2:ApplyNZModifier("pap")
		end)
	elseif wep.OnPaP then
		timer.Simple(0, function()
			if not IsValid(ply) or not IsValid(wep) then return end

			ply:StripWeapon(wep:GetClass())
			local wep2 = ply:Give(wep:GetClass())
			wep2:ApplyNZModifier("pap")
		end)
	end
end

function ENT:Update(data)
	if data then
		if data.model and util.IsValidModel(data.model) then
			self:SetModel(tostring(data.model))
		end
		if data.hurttype then
			self:SetHurtType(tonumber(data.hurttype))
		end
		if data.rewardtype then
			self:SetRewardType(tonumber(data.rewardtype))
		end
		if data.pointamount then
			self:SetPointAmount(tonumber(data.pointamount))
		end
		if data.door then
			self:SetDoorFlag(tostring(data.door))
		end
		if data.killall then
			self.KillAll = tobool(data.killall)
		end
		if data.upgrade then
			self:SetUpgrade(tobool(data.upgrade))
		end
		if data.global then
			self:SetGlobal(tobool(data.global))
		end
	end
end

function ENT:RandomPerk(ply)
	local blockedperks = {
		["wunderfizz"] = true,
		["pap"] = true,
		["gum"] = true,
		["ammo"] = true,
	}

	local wunderfizzlist = {}
	for k, v in pairs(nzPerks:GetList()) do
		if !blockedperks[k] then
			wunderfizzlist[k] = {true, v}
		end
	end

	local available = nzMapping.Settings.wunderfizzperklist or wunderfizzlist
	local tbl = {}
	for k, v in pairs(available) do
		if !ply:HasPerk(k) and !blockedperks[k] then
			if (v[1] == nil || v[1] == true) then
				table.insert(tbl, k)
			end
		end
	end

	local outcome = tbl[math.random(#tbl)]
	return outcome
end

local meleetypes = {
	[DMG_CLUB] = true,
	[DMG_SLASH] = true,
	[DMG_CRUSH] = true,
}

local burntypes = {
	[DMG_BURN] = true,
	[DMG_SLOWBURN] = true,
}

local shocktypes = {
	[DMG_SHOCK] = true,
	[DMG_ENERGYBEAM] = true,
}

function ENT:OnTakeDamage(dmginfo)
	if not nzRound:InProgress() then return end
	if self.Activated then return end

	local ply = dmginfo:GetAttacker()
	local wep = dmginfo:GetInflictor()

	if not IsValid(ply) then return end
	if not IsValid(wep) then return end
	if not ply:IsPlayer() then return end
	if self:GetUpgrade() and not wep:HasNZModifier("pap") then return end

	if self:GetHurtType() == 1 then
		if meleetypes[dmginfo:GetDamageType()] then
			self.Activated = true
			switch_reward[self:GetRewardType()](self, ply)
		end
	elseif self:GetHurtType() == 2 then
		if dmginfo:IsExplosionDamage() then
			self.Activated = true
			switch_reward[self:GetRewardType()](self, ply)
		end
	elseif self:GetHurtType() == 3 then
		if burntypes[dmginfo:GetDamageType()] then
			self.Activated = true
			switch_reward[self:GetRewardType()](self, ply)
		end
	elseif self:GetHurtType() == 4 then
		if dmginfo:IsBulletDamage() then
			self.Activated = true
			switch_reward[self:GetRewardType()](self, ply)
		end
	elseif self:GetHurtType() == 5 then
		if shocktypes[dmginfo:GetDamageType()] then
			self.Activated = true
			switch_reward[self:GetRewardType()](self, ply)
		end
	end
end
