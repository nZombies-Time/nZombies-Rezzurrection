
AddCSLuaFile( "shared.lua" )

SWEP.Author			= "Hoff"
SWEP.Instructions	= ""

SWEP.Category = "nZombies"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/hoff/weapons/seal6_claymore/v_claymore.mdl"
SWEP.WorldModel			= "models/hoff/weapons/seal6_claymore/w_claymore.mdl"
SWEP.ViewModelFOV = 65

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= ""
SWEP.Primary.Delay = 0

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.PrintName			= "Claymore"			
SWEP.Slot				= 3
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false

SWEP.SwayScale = 1
SWEP.BobScale = 1	

SWEP.Next = CurTime()
SWEP.Primed = 0

SWEP.Offset = {
Pos = {
Up = -6,
Right = -5,
Forward = 3,
},
Ang = {
Up = 240,
Right = 0,
Forward = 0,
}
}

function SWEP:DrawWorldModel( )
local hand, offset, rotate

if not IsValid( self.Owner ) then
self:DrawModel( )
return
end

if not self.Hand then
self.Hand = self.Owner:LookupAttachment( "anim_attachment_rh" )
end

hand = self.Owner:GetAttachment( self.Hand )

if not hand then
self:DrawModel( )
return
end

offset = hand.Ang:Right( ) * self.Offset.Pos.Right + hand.Ang:Forward( ) * self.Offset.Pos.Forward + hand.Ang:Up( ) * self.Offset.Pos.Up

hand.Ang:RotateAroundAxis( hand.Ang:Right( ), self.Offset.Ang.Right )
hand.Ang:RotateAroundAxis( hand.Ang:Forward( ), self.Offset.Ang.Forward )
hand.Ang:RotateAroundAxis( hand.Ang:Up( ), self.Offset.Ang.Up )

self:SetRenderOrigin( hand.Pos + offset )
self:SetRenderAngles( hand.Ang )

self:DrawModel( )
end

function SWEP:Deploy()
self:SetNWString("CanMelee",true)
self.Next = CurTime()
self.Primed = 0
end

function SWEP:Initialize()
self:SetWeaponHoldType("fist")
end

function SWEP:Equip(NewOwner)
end

function SWEP:Holster()
	self.Next = CurTime()
	self.Primed = 0
	return true
end

function SWEP:PrimaryAttack()
	if self.Next < CurTime() and self.Primed == 0 then
		self.Next = CurTime() + self.Primary.Delay
		
		self.Weapon:SendWeaponAnim(ACT_VM_THROW)
		self.Primed = 1
	end
end


-- function Ragdoll(npc,time)

	-- local hp = npc:Health()
	-- local mdl = npc:GetModel()
	-- local skin = npc:GetSkin()
	-- local class = npc:GetClass()
	-- local wep = npc:GetActiveWeapon()
	-- if wep:IsValid() then wep = wep:GetClass() else wep = nil end
	-- local bones = {}
	-- for i=1,npc:GetBoneCount() do
		-- bones[i] = npc:GetBoneMatrix(i)
	-- end
	
	-- local rag = ents.Create("prop_ragdoll")
	-- rag:SetModel(mdl)
	-- rag:SetPos(npc:GetPos())
	-- rag:SetAngles(npc:GetAngles())
	-- npc:Remove()
	
	-- local tbl = {hp=hp,mdl=mdl,skin=skin,class=class,rag=rag,wep=wep}
	
	-- rag:Spawn()
	-- rag:SetSkin(skin)
	
	-- for k,v in pairs (bones) do
		-- rag:SetBoneMatrix(k,v)
	-- end
	
	
	-- return rag

-- end

function SWEP:SecondaryAttack()
end

function SWEP:DeployShield()
timer.Simple(0.4,function()
if SERVER and self:IsValid() then
local ent = ents.Create("nz_seal6-claymore-ent")
ent:SetPos(self.Owner:GetPos() + (self.Owner:GetForward() * 30))
ent:Spawn()
ent.ClayOwner = self.Owner	
ent:EmitSound("hoff/mpl/seal_claymore/plant.wav")
ent:SetAngles(Angle(self.Owner:GetAngles().x,self.Owner:GetAngles().y,self.Owner:GetAngles().z) + Angle(0,-90,0))
end
end)
end

function SWEP:Think()
	if self.Next < CurTime() then
		if self.Primed == 1 and not self.Owner:KeyDown(IN_ATTACK) then
--			self.Weapon:SendWeaponAnim(ACT_VM_THROW)
			self.Owner:SetAnimation(ACT_VM_PRIMARYATTACK)
			self.Primed = 2
			self.Next = CurTime() + .3
		elseif self.Primed == 2 then
			self.Primed = 0
			self:DeployShield()
			self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)			
			self.Next = CurTime() + 2
		end
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:ShouldDropOnDie()
	return false
end

-- function SWEP:Reload()
-- if self:GetNWString("CanMelee") ~= true then return end
-- self:SendWeaponAnim(ACT_VM_RELOAD)
	-- local aim = self.Owner:GetAimVector( )
	-- local force  = aim*(3*200)+Vector(0,0,700)
	-- for k,v in pairs (ents.FindInCone(self.Owner:GetPos(),aim,40,0)) do
			-- if v ~= self.Owner then
		-- if v:IsNPC() == true or v:IsVehicle() then self:EmitSound("hoff/mpl/seal_assult_shield/hit_0"..math.random(1,8)..".wav") else  end 
-- timer.Simple(0.1,function()
			-- if v:IsNPC() and v:GetMoveType() == 3 then
				-- local rag = Ragdoll(v,5)
				-- rag:GetPhysicsObject():SetVelocity(force*5)
				-- v:TakeDamage( math.random( 90, 1000 ), self.Owner, self )				
			-- elseif v:GetMoveType( ) == MOVETYPE_VPHYSICS then
				-- v:GetPhysicsObject():SetVelocity(force)
			-- else
				-- v:SetVelocity(force)
			-- end
-- end)
-- end
-- end
-- self:SetNWString("CanMelee",false)
-- timer.Simple(1.5,function() self:SetNWString("CanMelee",true) end)
-- end
