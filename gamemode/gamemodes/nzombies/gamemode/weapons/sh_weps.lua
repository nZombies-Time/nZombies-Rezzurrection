local wepMeta = FindMetaTable("Weapon")

function nzWeps:GetReplacement(class) -- The weapon that the one provided turns into when PaP'd
	local selectedWep = weapons.Get(class)
	local replacement = ""
	if istable(selectedWep) then
		replacement = selectedWep.NZPaPReplacement
	end

	if (isstring(replacement)) then return weapons.Get(replacement) end
end

function wepMeta:GetReplacement() -- The weapon that the one provided turns into when PaP'd
	return nzWeps:GetReplacement(self:GetClass())
end

function nzWeps:GetAllReplacements(class) -- All weapons that this one can turn into when PaPing
	local replacements = {}
	local newClass = nzWeps:GetReplacement(class)
	
	for i = 1, 100 do -- While loop not needed, but feel free to turn this into one
		if !istable(newClass) then break end
		local shouldStop = false
		for _,v in pairs(replacements) do
			if (v.ClassName == newClass.ClassName) then
				shouldStop = true
				break
			end
		end

		if (shouldStop) then break end -- Could stop repeating the same values over and over if both weapons reference eachother as replacements
		table.insert(replacements, newClass)
		newClass = nzWeps:GetReplacement(newClass.ClassName)
	end

	return replacements
end

function wepMeta:GetAllReplacements() -- All weapons that this one can turn into when PaPing
	return nzWeps:GetAllReplacements(self:GetClass())
end

function nzWeps:GetReplaceChild(class) -- What this weapon was before it was turned into another weapon via PaPing
	local replacedBy = nil
	for _,v in pairs(weapons.GetList()) do
		if (isstring(v.NZPaPReplacement)) then
			if (v.NZPaPReplacement == class) then
				replacedBy = v
			end
		end
	end

	return replacedBy
end

function wepMeta:GetReplaceChild() -- What this weapon was before it was turned into another weapon via PaPing
	return nzWeps:ReplacedBy(self:GetClass())
end

function wepMeta:NZPerkSpecialTreatment( )
	if self:IsFAS2() or self:IsCW2() or self:IsTFA() then
		return true
	end

	return false
end

function wepMeta:IsFAS2()
	if self.Category == "FA:S 2 Weapons" or self.Base == "fas2_base" then
		return true
	else
		local base = weapons.Get(self.Base)
		if base and base.Base == "fas2_base" then
			return true
		end
	end

	return false
end

function wepMeta:IsArc()
	if  self.Base == "arccw_base" then
		return true
	else
		local base = weapons.Get(self.Base)
		if base and base.Base == "arccw_base" then
			return true
		end
	end

	return false
end


function wepMeta:IsCW2()
	if self.Category == "CW 2.0" or self.Base == "cw_base" then
		return true
	else
		local base = weapons.Get(self.Base)
		if base and base.Base == "cw_base" then
			return true
		end
	end

	return false
end

function wepMeta:IsTFA()
	if self.Category == "TFA" or self.Base == "tfa_gun_base" or string.sub(self:GetClass(), 1, 3) == "tfa" then
		return true
	else
		local base = weapons.Get(self.Base)
		if base and base.Base == "tfa_gun_base" then
			return true
		end
	end

	return false
end

function wepMeta:CanRerollPaP()
	return (self.OnRePaP or (self.Attachments and ((self:IsCW2() and CustomizableWeaponry) or self:IsTFA()) or self:IsFAS2()))
end

local old = wepMeta.GetPrintName
function wepMeta:GetPrintName()
	local name = old(self)
	if !name or name == "" then name = self:GetClass() end
	if self:HasNZModifier("pap") then
		name = self.NZPaPName or nz.Display_PaPNames[self:GetClass()] or nz.Display_PaPNames[name] or "Upgraded "..name
	end
	return name
end