
AddCSLuaFile( "shared.lua" )

SWEP.Author			= "Zet0r"
SWEP.Instructions	= "Fancy Viewmodel Animations"
SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.ViewModel			= "models/nzr/2022/perks/v_perkbottle.mdl"
SWEP.WorldModel			= "models/perks/bottle/perk_bottle_bo3.mdl"

SWEP.UseHands 			= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Delay = 1
SWEP.Primary.Ammo = -1
SWEP.ViewModelFOV = 75
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			= -1

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false

SWEP.PrintName			= "Perk Bottle"			
SWEP.Slot				= 3
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false

SWEP.SwayScale = 0
SWEP.BobScale = 0

SWEP.NZPreventBox = true -- Prevents from being in the box by default


if SERVER then
	util.AddNetworkString("perk_blur_screen")
end

function SWEP:SetupDataTables()

	self:NetworkVar( "String", 0, "Perk" )

end

function SWEP:Initialize()

end


function SWEP:Equip( owner )
	timer.Simple(3.2,function()
		owner:SetUsingSpecialWeapon(false)
		owner:EquipPreviousWeapon()
	end)
	owner:SetActiveWeapon("nz_perk_bottle")
	
end

function SWEP:Deploy()
	
		
		
	timer.Simple(0.5,function()
		if IsValid(self) and IsValid(self.Owner) then
			if self.Owner:Alive() then
				self:EmitSound("nz/perks/open.wav")
				self.Owner:ViewPunch( Angle( -1, -1, 0 ) )
			end
		end
	end)

	timer.Simple(0.9,function()
		if IsValid(self) and IsValid(self.Owner) then
			if self.Owner:Alive() then
				self:EmitSound("nz/perks/drink.wav")
				self.Owner:ViewPunch( Angle( -3, 0, 0 ) )
			end
		end
	end)

	timer.Simple(2.1,function()
		if IsValid(self) and IsValid(self.Owner) then
			if self.Owner:Alive() then
				self:EmitSound("nz/perks/smash.wav")
				net.Start("perk_blur_screen")
				net.Send(self.Owner)
			end
		end
	end)

	timer.Simple(3,function()
		if IsValid(self) and IsValid(self.Owner) then
			if self.Owner:Alive() then
				self:EmitSound("nz/perks/burp.wav")
			end
		end
	end)


end

function PerkBlurScreen()
	local mat = Material( "pp/blurscreen" )
	local function blurhook()
		DrawMotionBlur(0.4, 0.8, 0.01)
	end
	hook.Add( "RenderScreenspaceEffects", "PaintPerkBlur", blurhook )
	timer.Simple(0.7,function() hook.Remove( "RenderScreenspaceEffects", "PaintPerkBlur" ) end)
end
net.Receive("perk_blur_screen", PerkBlurScreen)

function SWEP:Holster()
	return false
end

function SWEP:PrimaryAttack()
end

function SWEP:OnRemove()

	if CLIENT then
		local ply = LocalPlayer()
		if IsValid(ply) and self.Owner == ply then
			local vm = ply:GetViewModel()
			--vm:SetMaterial(oldmat)
		end
	end
	
	hook.Remove( "RenderScreenspaceEffects", "PaintPerkBlur" )

end

function SWEP:GetViewModelPosition( pos, ang )
 
			local ply = LocalPlayer()
			if self.Owner == ply then
			local vm = ply:GetViewModel()
			local mat = nzPerks:Get(self:GetPerk()).material --perk_materials[self:GetPerk()]
			--oldmat = vm:GetMaterial() or ""
			vm:SetSkin(mat)
				end
	
	
	
 	local newpos = ply:EyePos()
	local newang = ply:EyeAngles()
	local up = newang:Up()
	
	--newpos = newpos + ply:GetAimVector()*3 - up*65
	
	return newpos, newang
 
end

function SWEP:SecondaryAttack()
end

function SWEP:ShouldDropOnDie()
	return false
end

-- So it counts as special weapon in the gamemode
function SWEP:IsSpecial()
	return true
end