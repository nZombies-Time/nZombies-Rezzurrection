AddCSLuaFile( )

ENT.Type = "anim"
 
ENT.PrintName		= "random_box_spawns"
ENT.Author			= "Zet0r"
ENT.Contact			= "Don't"
ENT.Purpose			= ""
ENT.Instructions	= ""

function ENT:Initialize()

	self.AutomaticFrameAdvance = true

	local nzmapsettings = nzMapping.Settings.boxtype
	local platform = "models/moo/_codz_ports_props/t6/global/p6_anim_zm_magic_box_fake/moo_codz_p6_magic_box_pile.mdl"
	local result

	local boxmdl = {
		["UGX Coffin"] = function() 
			platform = "models/wavy_ports/ugx/ugx_coffin_teddy_platform.mdl"
			return platform
		end,
		["Black Ops 3"] = function() 
			platform = "models/moo/_codz_ports_props/t7/_der/p7_zm_der_magic_box_fake/moo_codz_p7_der_magic_box_platform.mdl"
			return platform
		end,
		["Black Ops 3(Quiet Cosmos)"] = function() 
			platform = "models/moo/_codz_ports_props/t7/_der/p7_zm_der_magic_box_fake/moo_codz_p7_der_magic_box_platform.mdl"
			return platform
		end,
		["Mob of the Dead"] = function() 
			platform = "models/moo/_codz_ports_props/t6/alcatraz/p6_anim_zm_al_magic_box/moo_codz_t6_al_magic_box_platform.mdl"
			return platform
		end,
		["Verruckt"] = function() 
			platform = "models/moo/_codz_ports_props/t4/zombie/zombie_treasure_box_rubble/p4_zombie_treasure_box_rubble.mdl"
			return platform
		end,
		["Nacht Der Untoten"] = function() 
			platform = "models/moo/_codz_ports_props/t6/global/p6_anim_zm_magic_box_fake/moo_codz_p6_magic_box_pile_noplank.mdl"
			return platform
		end,
		["Original"] = function() 
			platform = "models/moo/_codz_ports_props/t6/global/p6_anim_zm_magic_box_fake/moo_codz_p6_magic_box_pile.mdl"
			return platform
		end,
	}

	if isstring(nzmapsettings) then
		result = boxmdl[nzmapsettings](platform)
	end

	if isstring(result) then
		platform = result
	end

	self:SetModel(platform)

	self:PhysicsInit(SOLID_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	
	--[[if (nzMapping.Settings.boxtype == "UGX Coffin") then
		ParticleEffectAttach("zmb_zct_fire_yellow",PATTACH_POINT_FOLLOW,self,1)
	end]]

	if CLIENT then return end
	self:SetTrigger(true)
end

function ENT:Think()
	self:NextThink(CurTime())
	return true
end

function ENT:PhysicsCollide(data, phys)
	self:SetMoveType(MOVETYPE_NONE)
end

if CLIENT then 
	function ENT:Draw()
		self:DrawModel()
			
		self:EffectsAndSounds()
	end

	function ENT:EffectsAndSounds()
			-- Credit: FlamingFox for Code and fighting the PVS monster -- 
			if !IsValid(self) then return end
			if (!self.Draw_FX or !IsValid(self.Draw_FX)) and self:GetModel() == "models/wavy_ports/ugx/ugx_coffin_teddy_platform.mdl" then -- PVS will no longer eat the particle effect.
				self.Draw_FX = CreateParticleSystem(self, "zmb_zct_fire_yellow", PATTACH_POINT_FOLLOW, 1)
			end
		end
	return 
end
