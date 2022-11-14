if SERVER then
	AddCSLuaFile("nz_zombieshield.lua")
	SWEP.Weight			= 5
	SWEP.AutoSwitchTo	= true
	SWEP.AutoSwitchFrom	= false
end

if CLIENT then

	SWEP.PrintName     	    = "Zombie Shield"			
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= true
	
	SWEP.Category			= "nZombies"

end


SWEP.Author			= "Zet0r"
SWEP.Contact		= "youtube.com/Zet0r"
SWEP.Purpose		= "Your back is now protected!"
SWEP.Instructions	= "Build it by finding all its parts!"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.HoldType = "fist"

SWEP.ViewModel = "models/weapons/c_zombieshield.mdl"
SWEP.WorldModel = "models/weapons/w_zombieshield_equipped.mdl"
SWEP.UseHands = true
SWEP.vModel = true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.NZPreventBox = true
--SWEP.NZTotalBlacklist = true
SWEP.NZSpecialCategory = "shield" -- This makes it count as special, as well as what category it replaces
-- Since this is a unique ID, it won't replace any other special weapon and it won't be selectable, so we call this function:

function SWEP:NZSpecialHolster(wep)
	return true -- This lets us always holster it even though it is a special weapon
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Electrified")
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
end

function SWEP:Deploy()
	local ply = self:GetOwner()

	if SERVER then
		if IsValid(ply) and IsValid(self.Shield) then
			ply:GetShield():SetNoDraw(true)
		else
			self:Remove()
		end
	end

	self:SendWeaponAnim(ACT_VM_DRAW)
	self.WepOwner = ply
	self:CallOnClient("Deploy")
	
	local viewmodel = ply:GetViewModel()
	if IsValid(viewmodel) then
		viewmodel:SetBodygroup(0,self:GetBodygroup(0))
		viewmodel:SetBodygroup(1,self:GetBodygroup(1))
		viewmodel:SetBodygroup(2,self:GetBodygroup(2))
	end
end

function SWEP:Holster()
	local ply = self:GetOwner()

	if SERVER then
		if IsValid(ply) and IsValid(self.Shield) then
			ply:GetShield():SetNoDraw(false)
		else
			self:Remove()
		end
	end

	local viewmodel = ply:GetViewModel()
	if IsValid(viewmodel) then
		viewmodel:SetBodygroup(0,0)
		viewmodel:SetBodygroup(1,0)
		viewmodel:SetBodygroup(2,0)
	end
	return true
end

function SWEP:CreateBackShield(ply)
	if not SERVER then return end
	ply:SetShield(ents.Create("nz_zombieshield_back"))
	ply:GetShield():SetOwner(ply)
	ply:GetShield().Weapon = self
	ply:GetShield():Spawn()
	ply:GetShield().Weapon = self

	self.Shield = ply:GetShield()
end

function SWEP:Equip( owner )
	self:CreateBackShield(owner)
end

function SWEP:PrimaryAttack()
	local ply = self:GetOwner()
	self:SetNextPrimaryFire(CurTime() + 1)

	local vecSrc		= ply:GetShootPos()
	local vecDirection	= ply:GetAimVector()

	local trace			= {}
		trace.start		= vecSrc
		trace.endpos	= vecSrc + ( vecDirection * 100)
		trace.filter	= ply

	local tracehit		= util.TraceLine( trace )
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	ply:SetAnimation( PLAYER_ATTACK1 )
	
	if ( tracehit.Hit ) then
		if ( SERVER ) then
			self:EmitSound("physics/metal/metal_box_impact_hard"..math.random(1,3)..".wav")
			if self:GetElectrified() then
				local ent = ply:TraceHullAttack( vecSrc, tracehit.HitPos, Vector( -5, -5, -5 ), Vector( 5, 5, 36 ), 450, DMG_SHOCK, 100 )
				if IsValid(ent) then timer.Simple(0, function() self:EmitSound("ambient/energy/zap"..math.random(1,9)..".wav") end) end
			else
				ply:TraceHullAttack( vecSrc, tracehit.HitPos, Vector( -5, -5, -5 ), Vector( 5, 5, 36 ), 250, DMG_CLUB, 100 )
			end
		end
	end
	
end

function SWEP:OnRemove()
	if SERVER then
		if IsValid(self.Shield) then
			self.Shield:Remove()
		end
	end
end

function SWEP:GetViewModelPosition( pos, ang )
 
	return pos, ang
 
end

function SWEP:SetDamage(value)
	if self.DamagedVariant == value then return end
	
	self.DamagedVariant = value
	self:SetBodygroup(0,value)
	self:SetBodygroup(1,value)
	self:SetBodygroup(2,value)
	
	if self.Owner:GetActiveWeapon() == self then
		local viewmodel = self.Owner:GetViewModel()
		if IsValid(viewmodel) then
			viewmodel:SetBodygroup(0,value)
			viewmodel:SetBodygroup(1,value)
			viewmodel:SetBodygroup(2,value)
		end
	end
	
	self:EmitSound("physics/metal/metal_sheet_impact_hard"..math.random(6,8)..".wav")
end
	

if CLIENT then
	function SWEP:DrawWorldModel()
		self:DrawModel()
		if self:GetElectrified() then
			local pos, ang = self:GetBonePosition(1)
			nzEffects:DrawElectricArcs( self, pos, ang, 1, 1, 0.3 )
		end
	end
	
	function SWEP:PostDrawViewModel(vm)
		if self:GetElectrified() then
			local pos, ang = vm:GetBonePosition(23)
			nzEffects:DrawElectricArcs( self, pos, ang, 1, 1, 0.3 )
		end
	end

end
