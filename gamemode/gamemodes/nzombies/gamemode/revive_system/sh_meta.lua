local playerMeta = FindMetaTable("Player")
if SERVER then
	function playerMeta:DownPlayer()
		local id = self:EntIndex()

		local reviving = self:GetPlayerReviving()
		if IsValid(reviving) then //stop reviving if u die
			local revid = reviving:EntIndex()
			local data = nzRevive.Players[revid]
			if data and data.ReviveTime then
				reviving:StopRevive()
				self.Reviving = nil
			end
		end

		nzRevive.Players[id] = {}
		nzRevive.Players[id].DownTime = CurTime()

		-- downed players are not targeted
		self:SetTargetPriority(TARGET_PRIORITY_NONE)
		self:SetHealth(100)

		if self:HasPerk("tombstone") then
			nzRevive.Players[id].tombstone = true
		end

		if #player.GetAllPlaying() <= 1 and self:HasPerk("revive") and (!self.SoloRevive or self.SoloRevive < 3) then
			self.SoloRevive = self.SoloRevive and self.SoloRevive + 1 or 1
			self.DownedWithSoloRevive = true
			self:StartRevive(self)
			timer.Simple(8, function()
				if IsValid(self) and !self:GetNotDowned() then
					self:RevivePlayer(self)
				end
			end)
		end

		if #player.GetAllPlaying() <= 1 and !nzRound:InState(ROUND_CREATE) or nzRound:InState(ROUND_GO) then
			for k,v in pairs(ents.FindByClass("player_spawns")) do
				v:SetTargetPriority(TARGET_PRIORITY_SPECIAL) -- This allows zombies to retreat to player spawns in solo games.
			end
		end

		self.OldUpgrades = self:GetUpgrades()
		self.OldPerks = self:GetPerks()
		self.OldWeapons = {}

		for k, v in pairs(self:GetWeapons()) do
			if v.IsTFAWeapon then
				if v.NZSpecialCategory == "display" then continue end
				table.insert(self.OldWeapons, {class = v:GetClass(), pap = v:HasNZModifier("pap")})
			end
		end

		self:RemovePerks()
		self:RemoveUpgrades()

		self.DownPoints = math.Round(self:GetPoints()*0.05, -1)
		if self.DownPoints >= self:GetPoints() then
			self:SetPoints(0)
		else
			self:TakePoints(self.DownPoints, true)
		end

		hook.Call("PlayerDowned", nzRevive, self)

		-- Equip the first pistol found in inventory - unless a pistol is already equipped
		local wep = self:GetActiveWeapon()
		if IsValid(wep) and wep.GetHoldType and wep:GetHoldType() == "pistol" or wep.HoldType == "pistol" then
			return
		end
		for k,v in pairs(self:GetWeapons()) do
			if v.GetHoldType and v:GetHoldType() == "pistol" or v.HoldType == "pistol" then
				self:SelectWeapon(v:GetClass())
				return
			end
		end
	end

	function playerMeta:RevivePlayer(revivor, nosync)
		local id = self:EntIndex()
		local tbl = {}
		if !nzRevive.Players[id] then return end
		nzRevive.Players[id] = nil
		if !nosync then
			hook.Call("PlayerRevived", nzRevive, self, revivor)
		end
		self:SetTargetPriority(TARGET_PRIORITY_NONE)
        timer.Simple(2, function()
			if (IsValid(self)) and (self:IsPlaying()) then
				self:SetTargetPriority(TARGET_PRIORITY_PLAYER)

				for k,v in pairs(ents.FindByClass("player_spawns")) do
					v:SetTargetPriority(TARGET_PRIORITY_NONE) -- Get rid of the spawn's target priority.
				end
			end
		end)

		if IsValid(revivor) and revivor:IsPlayer() then
			if self.DownPoints then
				revivor:GivePoints(self.DownPoints)
			end
		end

		self.DownPoints = nil
		self.DownedWithSoloRevive = nil

		--[[for k, v in pairs(ents.GetAll()) do
			if v:IsValidZombie() then
				table.insert(tbl, v)
			end
		end
		if !table.IsEmpty(tbl) then
			if #tbl >= 16 then
				local SND = "RevivalStinger"
				nzSounds:Play(SND)
			end
		end]]
		self:ResetHull()
	end

	function playerMeta:StartRevive(revivor, nosync)
		local id = self:EntIndex()
		if not revivor then revivor = self end
		if !nzRevive.Players[id] then return end
		if nzRevive.Players[id].ReviveTime then return end
		if IsValid(nzRevive.Players[id].RevivePlayer) then return end

		nzRevive.Players[id].ReviveTime = CurTime()
		nzRevive.Players[id].RevivePlayer = revivor
		revivor.Reviving = self

		if not revivor:GetUsingSpecialWeapon() and revivor:GetNotDowned() then
			revivor:Give("tfa_bo4_syrette") //alternatively 'tfa_bo2_syrette' or 'tfa_bo3_syrette'
			revivor:SelectWeapon("tfa_bo4_syrette")
		end

		if !nosync then hook.Call("PlayerBeingRevived", nzRevive, self, revivor) end
	end

	function playerMeta:StopRevive(nosync)
		local id = self:EntIndex()
		if !nzRevive.Players[id] then return end

		local revivor = nzRevive.Players[id].RevivePlayer
		nzRevive.Players[id].ReviveTime = nil
		nzRevive.Players[id].RevivePlayer = nil
		revivor.Reviving = nil

		if revivor:HasWeapon("tfa_bo4_syrette") and not revivor:IsRevivingPlayer() then
			revivor:SetUsingSpecialWeapon(false)
			revivor:EquipPreviousWeapon()
			timer.Simple(0, function() 
				if not IsValid(revivor) then return end
				revivor:StripWeapon("tfa_bo4_syrette")
			end)
		end

		if !nosync then hook.Call("PlayerNoLongerBeingRevived", nzRevive, self) end
	end

	function playerMeta:KillDownedPlayer(silent, nosync, nokill)
		local id = self:EntIndex()
		if !nzRevive.Players[id] then return end

		local revivor = nzRevive.Players[id].RevivePlayer

		if !nosync then hook.Call("PlayerKilled", nzRevive, self) end

		nzRevive.Players[id] = nil
		if !nokill then
			if silent then
				self:KillSilent()
			else
				self:Kill()
			end
		end

		self.DownPoints = nil
		self.DownedWithSoloRevive = nil

		for k,v in pairs(player.GetAllPlayingAndAlive()) do
			v:TakePoints(math.Round(v:GetPoints()*0.1, -1), true)
		end
		
		self:RemoveAllPowerUps()
		self:ResetHull()
	end
end

function playerMeta:IsRevivingPlayer()
	for id, data in pairs(nzRevive.Players) do
		if data.RevivePlayer and IsValid(data.RevivePlayer) and data.RevivePlayer == self then
			return true
		end
	end

	return false
end

function playerMeta:GetNotDowned()
	local id = self:EntIndex()
	if nzRevive.Players[id] then
		return false
	else
		return true
	end
end

function playerMeta:GetDownedWithTombstone()
	local id = self:EntIndex()
	if nzRevive.Players[id] then
		return nzRevive.Players[id].tombstone or false
	else
		return false
	end
end

function playerMeta:GetPlayerReviving()
	return self.Reviving
end

//this is to prevent IW anims mod from erroring
function playerMeta:IsReviving()
	return false
end
