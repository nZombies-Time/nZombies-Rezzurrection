---------------------------------------------------------------------------------------------------------
-- This is a slightly modified version of bob's nade base. As he said this is mostly base code however
-- credits go to Bob and the people that helped him.
---------------------------------------------------------------------------------------------------------

SWEP.Gun = ("")
SWEP.Category						= ""
SWEP.Author							= ""
SWEP.Contact						= ""
SWEP.Purpose						= ""
SWEP.Instructions					= ""
SWEP.MuzzleAttachment				= "1" 	
SWEP.ShellEjectAttachment			= "2" 	
SWEP.PrintName						= ""		
SWEP.Slot					= 4			
SWEP.SlotPos				= 3			
SWEP.DrawAmmo				= true		
SWEP.DrawWeaponInfoBox		= false		
SWEP.BounceWeaponIcon   	= false	
SWEP.DrawCrosshair			= false		
SWEP.Weight					= 2		
SWEP.AutoSwitchTo			= true	
SWEP.AutoSwitchFrom			= true
SWEP.HoldType 				= "grenade"	
SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/c_grenade.mdl"
SWEP.WorldModel				= "models/weapons/w_grenade.mdl"
SWEP.Base					= "holy_gun_base"
SWEP.Spawnable				= false
SWEP.AdminSpawnable			= false
SWEP.FiresUnderwater 		= false

SWEP.Primary.Sound			= Sound("")		
SWEP.Primary.RPM			= 60		
SWEP.Primary.ClipSize		= 1		
SWEP.Primary.DefaultClip	= 1		
SWEP.Primary.KickUp			= 0		
SWEP.Primary.KickDown		= 0		
SWEP.Primary.KickHorizontal	= 0		
SWEP.Primary.Automatic		= false		
SWEP.Primary.Ammo			= "Grenade"				
SWEP.Primary.Round 			= ("")
SWEP.Secondary.IronFOV			= 0	 	
SWEP.Primary.NumShots		= 0		
SWEP.Primary.Damage			= 0	
SWEP.Primary.Spread			= 0	
SWEP.Primary.IronAccuracy 	= 0 

SWEP.IronSightsPos 	= 	Vector(0, 0, 0)
SWEP.IronSightsAng 	= 	Vector(0, 0, 0)
SWEP.SightsPos 		=	Vector(0, 0, 0)
SWEP.SightsAng 		=	Vector(0, 0, 0)	
SWEP.RunSightsPos 	= 	Vector(0, 0, 0)
SWEP.RunSightsAng 	= 	Vector(0, 0, 0)

---------------------------------------------------------------------------------
-- Functions
---------------------------------------------------------------------------------

function SWEP:PrimaryAttack()
	if self.Owner:IsNPC() then return end
	if self:CanPrimaryAttack() then
		self.Weapon:SendWeaponAnim(ACT_VM_PULLPIN)
		self.Weapon:SetNextPrimaryFire(CurTime()+1/(self.Primary.RPM/60))	
		timer.Simple( 0.6, function() if SERVER then if not IsValid(self) then return end 
			if IsValid(self.Owner) then 
				if (self:LifeCheck()) then 
					self:Throw() 
				end 
			end
		end 
		end)
	end
end

function SWEP:Throw()

	if SERVER then
	
	if self.Owner != nil and self.Weapon != nil then 
	if self.Owner:GetActiveWeapon():GetClass() == self.Gun then

	self.Weapon:SendWeaponAnim(ACT_VM_THROW)
	timer.Simple( 0.35, function() if not IsValid(self) then return end 
	if self.Owner != nil
	and self.Weapon != nil
	then if(self:LifeCheck()) then 
	self.Owner:SetAnimation(PLAYER_ATTACK1)
			aim = self.Owner:GetAimVector()
			side = aim:Cross(Vector(0,0,1))
			up = side:Cross(aim)
			pos = self.Owner:GetShootPos() + side * 5 + up * -1
			if SERVER then
				local rocket = ents.Create(self.Primary.Round)
				if !rocket:IsValid() then return false end
				rocket:SetNWEntity("Owner", self.Owner)
				rocket:SetAngles(aim:Angle()+Angle(90,0,0))
				rocket:SetPos(pos)
				rocket:SetOwner(self.Owner)
				rocket.Owner = self.Owner
				rocket:SetNWEntity("Owner", self.Owner)
				rocket:Spawn()
				local phys = rocket:GetPhysicsObject()
				if self.Owner:KeyDown(IN_ATTACK2) and (phys:IsValid()) then
					if phys != nil then phys:ApplyForceCenter(self.Owner:GetAimVector() * 2000) end
				else 
					if phys != nil then phys:ApplyForceCenter(self.Owner:GetAimVector() * 5500) end
				end
				self.Weapon:TakePrimaryAmmo(1)
			end
				self:CheckAmmo()
		end 
	end
	end)	
	end
	end
	end
end
function SWEP:SecondaryAttack()
end	
function SWEP:CheckAmmo()
	timer.Simple(.15, function() if not IsValid(self) then return end 
	if IsValid(self.Owner) then 
		if SERVER and (self:LifeCheck()) then	
			if self.Weapon:Clip1() == 0 
			and self.Owner:GetAmmoCount( self.Weapon:GetPrimaryAmmoType() ) == 0 then
					self.Owner:StripWeapon(self.Gun)
				else
					self.Weapon:DefaultReload( ACT_VM_DRAW )
				end
			end
		end 
	end)
end

function SWEP:LifeCheck()
	if self.Owner != nil and self.Weapon != nil then
		if self.Weapon:GetClass() == self.Gun and self.Owner:Alive() then
			return true
			else return false
		end
		else 
			return false
	end
end
function SWEP:Think()
end