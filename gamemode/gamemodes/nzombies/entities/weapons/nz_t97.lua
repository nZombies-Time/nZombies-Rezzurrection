if SERVER then
	AddCSLuaFile("nz_t97.lua")
	SWEP.Weight			= 1
	SWEP.AutoSwitchTo	= false
	SWEP.AutoSwitchFrom	= true	
end

if CLIENT then

	SWEP.PrintName     	    = "Type 97 Grenade"			
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false

end


SWEP.Author			= "Hidden"
SWEP.Category				= "nZombies"
SWEP.Contact		= ""
SWEP.Purpose		= "Throws a grenade if you have any"
SWEP.Instructions	= "Let the gamemode give you it"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.HoldType = "grenade"

SWEP.ViewModelFOV	= 74
SWEP.ViewModel				= "models/nz_equipment/v_type97.mdl"
SWEP.WorldModel				= "models/weapons/w_type97.mdl"
SWEP.UseHands = true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "grenade"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.NextReload				= 1

SWEP.cooktime = 0
SWEP.CrossShrink = 50
SWEP.restorerun = 0
SWEP.ct = nil
SWEP.FuckedUp = false

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end

function SWEP:Deploy()
	if self.Owner:GetAmmoCount(GetNZAmmoID("grenade")) <= 0 then return end
	self.ct = CurTime()
	self.Owner:GetViewModel():SetPlaybackRate( 1.6 )
	self.restorerun = self.Owner:GetRunSpeed()
	self:SendWeaponAnim(ACT_VM_PULLBACK_HIGH)
	--if !self.Owner:GetUsingSpecialWeapon() then
		--self.Owner:EquipPreviousWeapon()
	--end
	timer.Simple(0.1, function() self.Owner:SetRunSpeed( self.Owner:GetWalkSpeed() ) end)
	if !self.Owner:HasPerk("widowswine") then
		timer.Create(self.Owner:EntIndex().."YouFuckedUp", 4.0, 1, function()
			if self.Owner:GetAmmoCount(GetNZAmmoID("grenade")) <= 0 then return end
			if self.Owner:GetActiveWeapon() != self then return end -- Something weird happened and this is not their weapon, don't blow them up!

			util.BlastDamage(self, self.Owner, self.Owner:GetShootPos(), 32, 200)
			local vPoint = self.Owner:GetShootPos()
			local effectdata = EffectData()
			effectdata:SetOrigin( vPoint )
			util.Effect( "Explosion", effectdata )
			self.FuckedUp = true
			--self:PrimaryAttack()
		end)
		self.CrossShrink = 50
		self:CallOnClient("CrossShrinkTimer")
	end
end

function SWEP:CrossShrinkTimer()
	self.CrossShrink = 50
	timer.Create(self.Owner:EntIndex().."Cooking2", 0.75, 3, function()
		--print("cooking2")
		self.CrossShrink = 50
	end)
end

function SWEP:PrimaryAttack()
	if self.Owner:GetAmmoCount(GetNZAmmoID("grenade")) <= 0 then return end
	if self.FuckedUp then return end
	self:ThrowGrenade(800)
end

function SWEP:SecondaryAttack()
return end

function SWEP:ThrowGrenade(force)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(ACT_VM_THROW)
	
	if SERVER then
		local nade = ents.Create("nz_ww2_type97_explosive")
		nade:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector() * 20))
		nade:SetAngles( Angle(30,0,0)  )
		nade:Spawn()
		nade:Activate()
		nade:SetOwner(self.Owner)
		
		local throwdir = Vector(self.Owner:GetAimVector()[1],self.Owner:GetAimVector()[2],self.Owner:GetAimVector()[3]+0.2)
		local nadePhys = nade:GetPhysicsObject()
			if !IsValid(nadePhys) then return end
		nadePhys:ApplyForceCenter(throwdir:GetNormalized() * force + self.Owner:GetVelocity())
		nadePhys:AddAngleVelocity(Vector(1000,0,0))	
		local ct2 = CurTime()
		if self.Owner:HasPerk("widowswine") then
			--nade.WidowsWine = true
			nade:SetKaboom(2.0)
		else
			nade:SetKaboom((self.ct+4.0) - ct2)
		end
	end
	timer.Remove(self.Owner:EntIndex().."Cooking2")
	timer.Remove(self.Owner:EntIndex().."YouFuckedUp")
end

function SWEP:DrawHUD()
	local x = ScrW()
	local y = ScrH()
	
	local td = {}
	local tr = util.TraceLine(td)
	
	if lp then
		td.start = self.Owner:GetShootPos()
		td.endpos = td.start + (self.Owner:EyeAngles() + self.Owner:GetPunchAngle()):Forward() * 16384
		td.filter = self.Owner
		
		tr = util.TraceLine(td)
		
		x2 = tr.HitPos:ToScreen()
		x2, y2 = x2.x, x2.y
	else
		x2, y2 = math.Round(x * 0.5), math.Round(y * 0.5)
	end
	
	self.CrossShrink = Lerp(0.02, self.CrossShrink, 1)
	surface.SetDrawColor( 0, 0, 0, 200 ) --Black
	surface.DrawRect( x2 - 31 - self.CrossShrink, y2 - 1, 14, 3 ) --horizontal
	surface.DrawRect( x2 + 18 + self.CrossShrink, y2 - 1, 14, 3 )
	surface.DrawRect( x2 - 1, y2 - 31 - self.CrossShrink, 3, 14 ) --vertical
	surface.DrawRect( x2 - 1, y2 + 19 + self.CrossShrink, 3, 14 )
	surface.SetDrawColor( 255, 255, 255, 255 ) --White
	surface.DrawRect( x2 - 30 - self.CrossShrink, y2 , 12, 1 ) --horizontal
	surface.DrawRect( x2 + 19 + self.CrossShrink, y2 , 12, 1 )
	surface.DrawRect( x2 - 0, y2 - 30 - self.CrossShrink, 1, 12 ) --vertical
	surface.DrawRect( x2 - 0, y2 + 20 + self.CrossShrink, 1, 12 )
end

function SWEP:OnRemove()
	self.cooktime = 0
	if IsValid(self.Owner) then
		self.Owner:SetRunSpeed(self.restorerun)
		self.CrossShrink = 50
		timer.Remove(self.Owner:EntIndex().."Cooking2")
		timer.Remove(self.Owner:EntIndex().."YouFuckedUp")
		self.FuckedUp = false
	end
end

function SWEP:Holster( wep )
	self.cooktime = 0
	self.CrossShrink = 50
	self.Owner:SetRunSpeed(self.restorerun)
	timer.Remove(self.Owner:EntIndex().."Cooking2")
	timer.Remove(self.Owner:EntIndex().."YouFuckedUp")
	self.FuckedUp = false
	--if not IsFirstTimePredicted() then return end
	return true
end