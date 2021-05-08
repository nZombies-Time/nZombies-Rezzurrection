if SERVER then
	AddCSLuaFile("nz_rpg.lua")
	SWEP.Weight			= 5
	SWEP.AutoSwitchTo	= false
	SWEP.AutoSwitchFrom	= true
end

if CLIENT then

	SWEP.PrintName     	    = "RPG"			
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= true
	
	SWEP.Category			= "nZombies"

end


SWEP.Author			= "Zet0r"
SWEP.Contact		= "youtube.com/Zet0r"
SWEP.Purpose		= "Places a claymore if you have any"
SWEP.Instructions	= "Let the gamemode give you it"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.HoldType = "rpg"

SWEP.ViewModelFOV = 55
SWEP.ViewModel			= "models/krazy/cod4rm/rpg_v.mdl" --Viewmodel path
SWEP.WorldModel			= "models/krazy/cod4rm/rpg_w.mdl" -- Weapon world model path
SWEP.UseHands = true
SWEP.VMPos = Vector(1,-1,-1)
SWEP.VMAng = Vector(0, 0, 0)
SWEP.VMPos_Additive = false --Set to false for an easier time using VMPos. If true, VMPos will act as a constant delta ON TOP OF ironsights, run, whateverelse

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "nz_specialgrenade"
SWEP.Primary.Sound			= Sound("robotnik_bo1_law.Single")	

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.NextReload				= 1

SWEP.PrimeSounds = {
	"nz/monkey/voice_prime/raise_vox_00.wav",
	"nz/monkey/voice_prime/raise_vox_01.wav",
	"nz/monkey/voice_prime/raise_vox_02.wav",
	"nz/monkey/voice_prime/raise_vox_03.wav",
	"nz/monkey/voice_prime/raise_vox_04.wav",
	"nz/monkey/voice_prime/raise_vox_05.wav",
	"nz/monkey/voice_prime/raise_vox_06.wav",
	"nz/monkey/voice_prime/raise_vox_07.wav",
	"nz/monkey/voice_prime/raise_vox_08.wav",
	"nz/monkey/voice_prime/raise_vox_09.wav",
	"nz/monkey/voice_prime/raise_vox_10.wav",
	"nz/monkey/voice_prime/raise_vox_11.wav",
}

function SWEP:Initialize()

	self:SetHoldType( "rpg" )

end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
	if CLIENT then
	
	else
		self:CallOnClient("Deploy")
	end
end

function SWEP:PrimaryAttack()
	if SERVER then
		self:FireShot()
	end
end

function SWEP:FireShot()

		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self:EmitSound("weapons/robotnik_bo1_rpg/fire.wav")
		local SelfPos=self.Owner:GetShootPos()+self:GetUp()*-6+self:GetForward()*80+self:GetRight()*33
		local Vec=(SelfPos)
		local Dir=Vec:GetNormalized()
		local aim = self.Owner:GetAimVector()
		Dir=(Dir+Vector(0,0,.5)):GetNormalized()
		local Spred=self.ShotSpread
		--fire round
		local Miss=ents.Create("ent_nz_rpgrocket")
		local Ang=Dir:Angle()
		local angl = self:EyeAngles()
		local aim = self.Owner:GetAimVector()
		Miss.RPGOwner = self.Owner
		Miss.ParentLauncher=self.Entity
		Miss:SetNetworkedEntity("Owenur",self.Entity)
		Miss:SetPos(SelfPos-self:GetRight()*30)
		Miss.InitialAng=(Angle(0,angl.y+90,angl.x))
		Ang:RotateAroundAxis(Ang:Up(),90)
		Miss:SetAngles(Angle(0,angl.y+90,angl.x))
		constraint.NoCollide(self.Entity,Miss)
		--Miss.InitialVel=self:GetPhysicsObject():GetVelocity()+Dir*1000
		Miss:Spawn()
		Miss:Activate()
		--Miss:GetPhysicsObject():SetVelocity(Miss.InitialVel)
		local PosAng=self:GetAttachment(1)
		local effectd=EffectData()
		effectd:SetScale(1)
		util.Effect("eff_jack_turretmuzzlelight",effectd,true,true)
		local effectd=EffectData()
		effectd:SetScale(1)
		util.Effect("eff_jack_turretmuzzlelight",effectd,true,true)
		self.FiredAtCurrentTarget=true
		self.RoundInChamber=false
		self.RoundsOnBelt=0
		self.NextNoMovementCheckTime=CurTime()+5
		self:SetDTBool(2,self.RoundInChamber)
		self.RoundsOnBelt=0
	end
function SWEP:PostDrawViewModel()

end

function SWEP:DrawWorldModel()

end

function SWEP:OnRemove()
	
end
