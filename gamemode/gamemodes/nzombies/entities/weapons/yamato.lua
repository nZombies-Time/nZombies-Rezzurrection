SWEP.Base = "tfa_melee_base"
SWEP.Category = "DMC5"
SWEP.PrintName = "Yamato"
SWEP.Author				= "YongLi" --Author Tooltip
SWEP.Type	= "Vergil's Katana"
SWEP.ViewModel = "models/weapons/yamato/yamato.mdl"
SWEP.WorldModel = "models/weapons/w_yamato.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 85
SWEP.UseHands = true
SWEP.HoldType = "melee"
SWEP.DrawCrosshair = false

SWEP.Primary.Directional = true

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.DisableIdleAnimations = true


SWEP.Secondary.CanBash = true
SWEP.Secondary.BashDamage = 250
SWEP.Secondary.BashDelay = 0.25
SWEP.Secondary.BashLength = 16 * 4.5

SWEP.Precision = 50
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1

SWEP.Offset = {
		Pos = {
		Up = 0,
		Right = 0,
		Forward = 0,
		},
		Ang = {
		Up = 0,
		Right = 0,
		Forward = 0
		},
		Scale = 1
}

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 24*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-180,30,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 1200, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.06, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.035,
		["viewpunch"] = Angle(2,2,2), --viewpunch angle
		['end'] = 0.5, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "F", --Swing dir,
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_MISSLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 24*5, -- Trace distance
		['dir'] = Vector(-180,0,0), -- Trace arc cast
		['dmg'] = 80, --Damage
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 1,
		["viewpunch"] = Angle(1,-5,0), --viewpunch angle
		['end'] = 0.14, --time before next attack
		['hull'] = 16, --Hullsize
		['direction'] = "L", --Swing dir,
	},
	{
		['act'] = ACT_VM_MISSRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 24*5, -- Trace distance
		['dir'] = Vector(180,0,0), -- Trace arc cast
		['dmg'] = 80, --Damage
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0, --Delay
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['spr'] = true, --Allow attack while sprinting?
		['snd_delay'] = 0,
		["viewpunch"] = Angle(1,5,0), --viewpunch angle
		['end'] = 0.14, --time before next attack
		['hull'] = 16, --Hullsize
		['direction'] = "R", --Swing dir
	},

}

SWEP.Secondary.Attacks =  { 

	{
		['act'] = ACT_VM_SECONDARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 28*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(180,60,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 4500, --Nope!! Not overpowered!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.06, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.4,
		["viewpunch"] = Angle(3,10,0), --viewpunch angle
		['end'] = 0.9, --time before next attack
		['hull'] = 128, --Hullsize
		['direction'] = "F", --Swing dir
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_SECONDARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 28*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(180,60,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 4500, --Nope!! Not overpowered!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.06, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.4,
		["viewpunch"] = Angle(3,10,0), --viewpunch angle
		['end'] = 0.9, --time before next attack
		['hull'] = 128, --Hullsize
		['direction'] = "L", --Swing dir
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_SECONDARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 28*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(180,60,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 4500, --Nope!! Not overpowered!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.06, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.4,
		["viewpunch"] = Angle(3,10,0), --viewpunch angle
		['end'] = 0.9, --time before next attack
		['hull'] = 128, --Hullsize
		['direction'] = "R", --Swing dir
		['maxhits'] = 25
	},
	
	{
	
		['act'] = ACT_VM_HITCENTER, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 28*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(0,0,90), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 4500, --Nope!! Not overpowered!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.06, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.4,
		["viewpunch"] = Angle(3,10,5), --viewpunch angle
		['end'] = 1.63, --time before next attack
		['hull'] = 128, --Hullsize
		['direction'] = "B", --Swing dir
		['maxhits'] = 25
	}
	
}



if SERVER then

	function SWEP:rapidcut()
	if IsValid(self.Owner) then
		local k, v
		local dmg = DamageInfo()
			dmg:SetDamage(34)
			dmg:SetDamageType(DMG_SLASH)
			dmg:SetAttacker(self.Owner)
			dmg:SetInflictor(self.Owner)
		for k, v in pairs ( ents.FindInSphere( self.Owner:GetPos(), 200 ) ) do 
			if v:IsValid() and self.Owner:Alive() and  v != self.Owner then
				dmg:SetDamageForce( ( v:GetPos() - self.Owner:GetPos() ):GetNormalized() * 100 )
				v:TakeDamageInfo( dmg )
			end	
		end
	end
	end
	
	function SWEP:rapidcutf()
	if IsValid(self.Owner) then
		local k, v
		local dmg = DamageInfo()
			dmg:SetDamage(120)
			dmg:SetDamageType(DMG_SLASH)
			dmg:SetAttacker(self.Owner)
			dmg:SetInflictor(self.Owner)
		for k, v in pairs ( ents.FindInSphere( self.Owner:GetPos(), 220 ) ) do 
			if v:IsValid() and self.Owner:Alive() and  v != self.Owner then
				dmg:SetDamageForce( ( v:GetPos() - self.Owner:GetPos() ):GetNormalized() * 100 )
				v:TakeDamageInfo( dmg )
			end	
		end
	end
	end
	
	function SWEP:liftcut()
	if IsValid(self.Owner) then
		local k, v
		local dmg = DamageInfo()
			dmg:SetDamage(80)
			dmg:SetDamageType(DMG_SLASH)
			dmg:SetAttacker(self.Owner)
			dmg:SetInflictor(self.Owner)
		for k, v in pairs ( ents.FindInSphere( self.Owner:GetPos(), 150 ) ) do 
			if v:IsValid() and self.Owner:Alive() and  v != self.Owner then
				dmg:SetDamageForce( ( v:GetPos() - self.Owner:GetPos() ):GetNormalized() * 100 )
				v:TakeDamageInfo( dmg )
			end	
		end
	end
	end
	

	function SWEP:Jcn()
	if IsValid(self.Owner) then
		local k, v
		local dmg = DamageInfo()
			dmg:SetDamage(95)
			dmg:SetDamageType(DMG_SLASH)
			dmg:SetAttacker(self.Owner)
			dmg:SetInflictor(self.Owner)
			
		

		for k, v in pairs ( ents.FindInSphere( self.Owner:GetEyeTrace().HitPos, 150 ) ) do
			if v:IsValid() and v != self.Owner then
				dmg:SetDamageForce( ( v:GetPos() - self.Owner:GetPos() ):GetNormalized() * 100 )
				v:TakeDamageInfo( dmg )
			end	
		end
	end
	end
	
	function SWEP:Jc()
	if IsValid(self.Owner) then
		local k, v
		local dmg = DamageInfo()
			dmg:SetDamage(4000)
			dmg:SetDamageType(DMG_SLASH)
			dmg:SetAttacker(self.Owner)
			dmg:SetInflictor(self.Owner)
		
		for k, v in pairs ( ents.FindInSphere( self.Owner:GetPos(), 1400 ) ) do
			if v:IsValid() and v != self.Owner then
				dmg:SetDamageForce( ( v:GetPos() - self.Owner:GetPos() ):GetNormalized() * 100 )
				v:TakeDamageInfo( dmg )
			end	
		end
	end
	end
end

function SWEP:Deploy()

	self.Owner:SetRunSpeed(800)
	self.sm = 0
end
SWEP.SlashTime 		= CurTime()
SWEP.st = 0
SWEP.dodgetime = 0
SWEP.sm = 0
function SWEP:Reload()
	if SERVER and self.Owner:KeyDown(IN_USE) and self.SlashTime < CurTime() then
	self.Weapon:EmitSound("yamato_jc", 50, 100)
		self.Owner:GodEnable()
		util.ScreenShake( self.Owner:GetPos(), 5, 5, 0.3, 300 )
		self.Owner:Freeze( true )
		self.Weapon:SendWeaponAnim(ACT_VM_HITLEFT)
		self.Weapon:SetNextPrimaryFire(CurTime() + 6)
		self.Weapon:SetNextSecondaryFire(CurTime() + 6)
		self.SlashTime = CurTime() + 7			
		util.Effect( "camera_flash", EffectData() )
			self.ent = ents.Create("prop_dynamic")
				self.ent:SetModel("models/hunter/misc/shell2x2a.mdl")
				self.ent:SetColor( Color( 29, 0, 255, 200 ) )
				self.ent:SetMaterial( "models/shiny" )
				self.ent:SetModelScale( 20,0.2,1 )
				self.ent:SetPos(self.Owner:GetPos() )
				self.ent:SetLocalAngles(Angle(0,0,0))
				self.ent:SetParent(self.Owner)
				self.ent:Spawn()			
				self.ent:SetRenderMode( RENDERMODE_TRANSALPHA )
			self.ent2 = ents.Create("prop_dynamic")
				self.ent2:SetModel("models/hunter/tubes/circle2x2.mdl")
				self.ent2:SetColor( Color( 160, 150, 255, 255 ) )
				self.ent2:SetMaterial( "models/props_combine/portalball001_sheet" )
				self.ent2:SetModelScale( 30,0.2,1 )
				self.ent2:SetPos(self.Owner:GetPos() + Vector( 0, 0, -30 ))
				self.ent2:SetLocalAngles(Angle(0,0,0))
				self.ent2:SetParent(self.Owner)
				self.ent2:Spawn()			
				self.ent2:SetRenderMode( RENDERMODE_TRANSALPHA )
	timer.Simple(0.2, function()	self.ent:Remove() 
			self.ent3 = ents.Create("prop_dynamic")
				self.ent3:SetModel("models/3dsky/moving_clouds_01a.mdl")
				self.ent3:SetColor( Color( 0, 54, 204, 200 ) )
				self.ent3:SetPos(self.Owner:GetPos() )
				self.ent3:SetLocalAngles(Angle(0,0,0))
				self.ent3:SetParent(self.Owner)
				self.ent3:Spawn()			
				self.ent3:SetRenderMode( RENDERMODE_TRANSALPHA )
	end)
	timer.Simple( 4.2, function() 
	self.ent3:Remove()
			self.ent4 = ents.Create("prop_physics")
				self.ent4:SetModel("models/3dsky/r_skyfog.mdl")
				self.ent4:SetPos(self.Owner:GetPos() )
				self.ent4:SetLocalAngles(Angle(0,0,0))
				self.ent4:SetColor( Color( 255, 255, 255, 100 ) )
				self.ent4:SetParent(self.Owner)
				self.ent4:Spawn()			
				self.ent4:SetRenderMode( RENDERMODE_TRANSALPHA )
				
	end)
	timer.Simple( 4.21, function()
			util.ScreenShake( self.Owner:GetPos(), 50, 5, 0.3, 3000 )
               EffectData():SetOrigin( self.Owner:GetEyeTrace().HitPos )
               EffectData():SetNormal( self.Owner:GetEyeTrace().HitNormal )
               util.Effect( "camera_flash", EffectData() )
			self.ent5 = ents.Create("prop_dynamic")
				self.ent5:SetModel("models/dmc5/cut1.mdl")
				self.ent5:SetPos(self.Owner:GetPos() )
				self.ent5:SetColor( Color( 48, 103, 255, 200 ) )
				self.ent5:SetLocalAngles(Angle(0,0,0))
				self.ent5:SetParent(self.Owner)
				self.ent5:Spawn()			
				self.ent5:SetRenderMode( RENDERMODE_TRANSALPHA )end)
	timer.Simple( 4.24, function()
			util.ScreenShake( self.Owner:GetPos(), 50, 5, 0.3, 3000 )
               EffectData():SetOrigin( self.Owner:GetEyeTrace().HitPos )
               EffectData():SetNormal( self.Owner:GetEyeTrace().HitNormal )
               util.Effect( "camera_flash", EffectData() )
			self.ent6 = ents.Create("prop_dynamic")
				self.ent6:SetModel("models/dmc5/cut2.mdl")
				self.ent6:SetPos(self.Owner:GetPos() )
				self.ent6:SetColor( Color( 48, 103, 255, 200 ) )
				self.ent6:SetLocalAngles(Angle(0,0,0))
				self.ent6:SetParent(self.Owner)
				self.ent6:Spawn()			
				self.ent6:SetRenderMode( RENDERMODE_TRANSALPHA )
				self.ent4:SetColor( Color( 255, 255, 255, 250 ) )
				end)
	timer.Simple( 4.27, function()
			util.ScreenShake( self.Owner:GetPos(), 50, 5, 0.3, 3000 )
               EffectData():SetOrigin( self.Owner:GetEyeTrace().HitPos )
               EffectData():SetNormal( self.Owner:GetEyeTrace().HitNormal )
               util.Effect( "camera_flash", EffectData() )			self.ent7 = ents.Create("prop_dynamic")
				self.ent7:SetModel("models/dmc5/cut3.mdl")
				self.ent7:SetPos(self.Owner:GetPos() )
				self.ent7:SetColor( Color( 48, 103, 255, 200 ) )
				self.ent7:SetLocalAngles(Angle(0,0,0))
				self.ent7:SetParent(self.Owner)
				self.ent7:Spawn()			
				self.ent7:SetRenderMode( RENDERMODE_TRANSALPHA ) 
				self.ent2:SetColor( Color( 160, 150, 255, 200 ) )end)
	timer.Simple( 4.30, function()
			util.ScreenShake( self.Owner:GetPos(), 50, 5, 0.3, 3000 )
               EffectData():SetOrigin( self.Owner:GetEyeTrace().HitPos )
               EffectData():SetNormal( self.Owner:GetEyeTrace().HitNormal )
               util.Effect( "camera_flash", EffectData() )			self.ent8 = ents.Create("prop_dynamic")
				self.ent8:SetModel("models/dmc5/cut4.mdl")
				self.ent8:SetPos(self.Owner:GetPos() )
				self.ent8:SetColor( Color( 48, 103, 255, 200 ) )
				self.ent8:SetLocalAngles(Angle(0,0,0))
				self.ent8:SetParent(self.Owner)
				self.ent8:Spawn()			
				self.ent8:SetRenderMode( RENDERMODE_TRANSALPHA )
				self.ent2:SetColor( Color( 160, 150, 255, 150 ) )end)
	timer.Simple( 4.33, function()
			util.ScreenShake( self.Owner:GetPos(), 50, 5, 0.3, 3000 )
               EffectData():SetOrigin( self.Owner:GetEyeTrace().HitPos )
               EffectData():SetNormal( self.Owner:GetEyeTrace().HitNormal )
               util.Effect( "camera_flash", EffectData() )			self.ent9 = ents.Create("prop_dynamic")
				self.ent9:SetModel("models/dmc5/cut5.mdl")
				self.ent9:SetPos(self.Owner:GetPos() )
				self.ent9:SetColor( Color( 48, 103, 255, 200 ) )
				self.ent9:SetLocalAngles(Angle(0,0,0))
				self.ent9:SetParent(self.Owner)
				self.ent9:Spawn()			
				self.ent9:SetRenderMode( RENDERMODE_TRANSALPHA ) 
				self.ent2:SetColor( Color( 160, 150, 255, 100 ) )end)
	timer.Simple( 4.36, function()
			util.ScreenShake( self.Owner:GetPos(), 50, 5, 0.3, 3000 )
               EffectData():SetOrigin( self.Owner:GetEyeTrace().HitPos )
               EffectData():SetNormal( self.Owner:GetEyeTrace().HitNormal )
               util.Effect( "camera_flash", EffectData() )			self.ent10 = ents.Create("prop_dynamic")
				self.ent10:SetModel("models/dmc5/cut6.mdl")
				self.ent10:SetPos(self.Owner:GetPos() )
				self.ent10:SetColor( Color( 48, 103, 255, 200 ) )
				self.ent10:SetLocalAngles(Angle(0,0,0))
				self.ent10:SetParent(self.Owner)
				self.ent10:Spawn()			
				self.ent10:SetRenderMode( RENDERMODE_TRANSALPHA )
				self.ent2:SetColor( Color( 160, 150, 255, 50 ) )
				end)
	timer.Simple( 4.39, function()
			util.ScreenShake( self.Owner:GetPos(), 50, 5, 0.3, 3000 )
               EffectData():SetOrigin( self.Owner:GetEyeTrace().HitPos )
               EffectData():SetNormal( self.Owner:GetEyeTrace().HitNormal )
               util.Effect( "camera_flash", EffectData() )			self.ent11 = ents.Create("prop_dynamic")
				self.ent11:SetModel("models/dmc5/cut7.mdl")
				self.ent11:SetPos(self.Owner:GetPos() )
				self.ent11:SetColor( Color( 48, 103, 255, 200 ) )
				self.ent11:SetLocalAngles(Angle(0,0,0))
				self.ent11:SetParent(self.Owner)
				self.ent11:Spawn()			
				self.ent11:SetRenderMode( RENDERMODE_TRANSALPHA )
				self.ent2:Remove()
				end)
	timer.Simple( 4.41, function()
			util.ScreenShake( self.Owner:GetPos(), 50, 5, 0.3, 3000 )
               EffectData():SetOrigin( self.Owner:GetEyeTrace().HitPos )
               EffectData():SetNormal( self.Owner:GetEyeTrace().HitNormal )
               util.Effect( "camera_flash", EffectData() )			self.ent12 = ents.Create("prop_dynamic")
				self.ent12:SetModel("models/dmc5/cut8.mdl")
				self.ent12:SetPos(self.Owner:GetPos() )
				self.ent12:SetColor( Color( 48, 103, 255, 200 ) )
				self.ent12:SetLocalAngles(Angle(0,0,0))
				self.ent12:SetParent(self.Owner)
				self.ent12:Spawn()			
				self.ent12:SetRenderMode( RENDERMODE_TRANSALPHA )
				end)
	timer.Simple( 4.44, function()
			util.ScreenShake( self.Owner:GetPos(), 50, 5, 0.3, 3000 )
               EffectData():SetOrigin( self.Owner:GetEyeTrace().HitPos )
               EffectData():SetNormal( self.Owner:GetEyeTrace().HitNormal )
               util.Effect( "camera_flash", EffectData() )			self.ent13 = ents.Create("prop_dynamic")
				self.ent13:SetModel("models/dmc5/cut9.mdl")
				self.ent13:SetPos(self.Owner:GetPos() )
				self.ent13:SetColor( Color( 48, 103, 255, 200 ) )
				self.ent13:SetLocalAngles(Angle(0,0,0))
				self.ent13:SetParent(self.Owner)
				self.ent13:Spawn()			
				self.ent13:SetRenderMode( RENDERMODE_TRANSALPHA )
				self.ent4:SetColor( Color( 255, 255, 255, 200 ) )
				end)
	timer.Simple( 4.47, function()
			util.ScreenShake( self.Owner:GetPos(), 50, 5, 0.3, 3000 )
               EffectData():SetOrigin( self.Owner:GetEyeTrace().HitPos )
               EffectData():SetNormal( self.Owner:GetEyeTrace().HitNormal )
               util.Effect( "camera_flash", EffectData() )			self.ent14 = ents.Create("prop_dynamic")
				self.ent14:SetModel("models/dmc5/cut10.mdl")
				self.ent14:SetPos(self.Owner:GetPos() )
				self.ent14:SetColor( Color( 48, 103, 255, 200 ) )
				self.ent14:SetLocalAngles(Angle(0,0,0))
				self.ent14:SetParent(self.Owner)
				self.ent14:Spawn()			
				self.ent14:SetRenderMode( RENDERMODE_TRANSALPHA )
				self.ent4:SetColor( Color( 255, 255, 255, 150 ) )
				end)
	timer.Simple( 4.5, function()
			util.ScreenShake( self.Owner:GetPos(), 50, 5, 0.3, 3000 )
               EffectData():SetOrigin( self.Owner:GetEyeTrace().HitPos )
               EffectData():SetNormal( self.Owner:GetEyeTrace().HitNormal )
               util.Effect( "camera_flash", EffectData() )			self.ent15 = ents.Create("prop_dynamic")
				self.ent15:SetModel("models/dmc5/cut11.mdl")
				self.ent15:SetPos(self.Owner:GetPos() )
				self.ent15:SetColor( Color( 48, 103, 255, 200 ) )
				self.ent15:SetLocalAngles(Angle(0,0,0))
				self.ent15:SetParent(self.Owner)
				self.ent15:Spawn()			
				self.ent15:SetRenderMode( RENDERMODE_TRANSALPHA )
				self.ent4:SetColor( Color( 255, 255, 255, 100 ) )
				end)
	timer.Simple( 4.53, function()
			util.ScreenShake( self.Owner:GetPos(), 50, 5, 0.3, 3000 )
				self.ent4:SetColor( Color( 255, 255, 255, 50 ) )
	end)
	timer.Simple( 4.53, function()
			util.ScreenShake( self.Owner:GetPos(), 50, 5, 0.3, 3000 )
	end)
	timer.Simple( 4.56, function()	end)
	timer.Simple( 4.59, function()	end)
	timer.Simple( 4.61, function()self.ent5:SetColor( Color( 48, 103, 255, 100 ) )  end)
	timer.Simple( 4.64, function()self.ent6:SetColor( Color( 48, 103, 255, 100 ) )	end)
	timer.Simple( 4.67, function()self.ent7:SetColor( Color( 48, 103, 255, 100 ) )	end)
	timer.Simple( 4.70, function()self.ent8:SetColor( Color( 48, 103, 255, 100 ) )	end)
	timer.Simple( 4.73, function()self.ent9:SetColor( Color( 48, 103, 255, 100 ) )	end)
	timer.Simple( 4.76, function()self.ent10:SetColor( Color( 48, 103, 255, 100 ) )	end)
	timer.Simple( 4.79,function()self.ent11:SetColor( Color( 48, 103, 255, 100 ) )	end)
	timer.Simple( 4.82,function()self.ent12:SetColor( Color( 48, 103, 255, 100 ) )	end)
	timer.Simple( 4.85,function()self.ent13:SetColor( Color( 48, 103, 255, 100 ) )	end)
	timer.Simple( 4.88,function()self.ent14:SetColor( Color( 48, 103, 255, 100 ) )	end)
	timer.Simple( 4.91,function()self.ent15:SetColor( Color( 48, 103, 255, 100 ) )	end)
	timer.Simple( 5, function() self.Weapon:SendWeaponAnim(ACT_VM_HITRIGHT)	end)
	timer.Simple( 6,function() 
	self:Jc()self.ent8:SetColor( Color( 48, 103, 255, 100 ) )
	self.ent4:Remove()
			self.ent16 = ents.Create("prop_dynamic")
				self.ent16:SetModel("models/hunter/misc/shell2x2a.mdl")
				self.ent16:SetColor( Color( 29, 0, 255, 150 ) )
				self.ent16:SetMaterial( "models/shiny" )
				self.ent16:SetModelScale( 20,1,1 )
				self.ent16:SetPos(self.Owner:GetPos() )
				self.ent16:SetLocalAngles(Angle(0,0,0))
				self.ent16:SetParent(self.Owner)
				self.ent16:Spawn()			
			   end)
	timer.Simple( 6.05,function() self.ent16:SetColor( Color( 29, 0, 255, 100 ) )  end)
	timer.Simple( 6.1,function() self.ent16:SetColor( Color ( 29, 0, 255, 50 ) )  end)
	timer.Simple( 6.15,function()  self.ent5:Remove()self.ent6:Remove()self.ent7:Remove()self.ent8:Remove()self.ent9:Remove()self.ent10:Remove()
	self.ent11:Remove()self.ent12:Remove()self.ent13:Remove()self.ent14:Remove()self.ent15:Remove() self.ent16:Remove() self.Owner:GodDisable() end)
	timer.Simple( 6.05,function()	self.Owner:Freeze( false ) end)
	elseif self.Owner:KeyDown(IN_BACK) and self.SlashTime < CurTime() and SERVER then
		self.SlashTime = CurTime() + 1
		self.Owner:GodEnable()
		self.Owner:ViewPunch(Angle(1, 2, 2))
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
		timer.Simple(0.01, function() self:Jcn() self.ent05:SetModelScale( 15,0.005,1 ) self.ent06:SetModelScale( 15,0.005,1 ) end)
				util.ScreenShake( self.Owner:GetEyeTrace().HitPos, 5, 5, 0.3, 300 )
					self.ent05 = ents.Create("prop_dynamic")
				self.ent05:SetModel("models/maxofs2d/hover_rings.mdl")
				self.ent05:SetColor( Color( 120, 110, 255, 250 ) )
				self.ent05:SetMaterial( "models/effects/comball_sphere" )
				self.ent05:SetModelScale( 0,0.02,1 )
				self.ent05:SetPos(self.Owner:GetEyeTrace().HitPos + Vector( 0, 0, 80 ) )
				self.ent05:SetLocalAngles(Angle(0,0,0))		
				self.ent05:Spawn()			
				self.ent05:SetRenderMode( RENDERMODE_TRANSALPHA )
					self.ent06 = ents.Create("prop_dynamic")
				self.ent06:SetModel("models/maxofs2d/hover_rings.mdl")
				self.ent06:SetColor( Color( 29, 0, 255, 150 ) )
				self.ent06:SetMaterial( "models/shiny" )
				self.ent06:SetModelScale( 0,0.02,1 )
				self.ent06:SetPos(self.Owner:GetEyeTrace().HitPos + Vector( 0, 0, 80 ) )
				self.ent06:SetLocalAngles(Angle(0,0,0))
				self.ent06:SetParent(self.ent05)
				self.ent06:Spawn()			
				self.ent06:SetRenderMode( RENDERMODE_TRANSALPHA )
		timer.Simple(0.1, function()  self.ent05:SetModelScale( 0,0.05,1 ) self.ent06:SetModelScale( 0,0.05,1 ) end)
		timer.Simple(0.2, function()  self.ent05:Remove()  self.ent06:Remove() self.Owner:GodDisable() end)
	elseif self.SlashTime < CurTime() and self.sm == 0 then	
	self.sm = 1
	
	end
end


SWEP.CanBlock = true
SWEP.BlockAnimation = {
	["in"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_DEPLOY, --Number for act, String/Number for sequence
		["transition"] = true
	}, --Inward transition
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_IDLE_DEPLOYED, --Number for act, String/Number for sequence
		["is_idle"] = true
	},--looping animation
	["hit"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_RELOAD_DEPLOYED, --Number for act, String/Number for sequence
		["is_idle"] = true
	},--when you get hit and block it
	["out"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_UNDEPLOY, --Number for act, String/Number for sequence
		["transition"] = true
	} --Outward transition
}
SWEP.BlockCone = 100 --Think of the player's view direction as being the middle of a sector, with the sector's angle being this
SWEP.BlockDamageMaximum = 0.0 --Multiply damage by this for a maximumly effective block
SWEP.BlockDamageMinimum = 0.2 --Multiply damage by this for a minimumly effective block
SWEP.BlockTimeWindow = 0.5 --Time to absorb maximum damage
SWEP.BlockTimeFade = 0.7 --Time for blocking to do minimum damage.  Does not include block window
SWEP.BlockSound = "yamato_block"
SWEP.BlockDamageCap = 80
SWEP.BlockDamageTypes = {
	DMG_SLASH,DMG_CLUB
}

SWEP.InspectionActions = {ACT_VM_RECOIL1}

DEFINE_BASECLASS(SWEP.Base)

if CLIENT then
	
end


function SWEP:Think()
		if self.Owner:KeyReleased(IN_RELOAD) and self.sm == 1 then
		self.Owner:ViewPunch(Angle(5, 0, 0))	util.ScreenShake( self.Owner:GetPos(), 3, 3, 0.2, 300 ) self.Owner:DoAnimationEvent( ACT_LAND ) self.Owner:SetPos(self.Owner:GetEyeTrace().HitPos) 	self.Weapon:EmitSound("yamato_tele", 100, 100)	self.SlashTime = CurTime() + 1.7 		
		self.sm = 0
		end
		if not self.Owner:Alive()  then 
		self.Owner:Freeze( false )
		end
		if not self.Owner:IsOnGround() and self.Owner:KeyDown(IN_USE) and CurTime() > self.dodgetime then
		if self.Owner:KeyDown(IN_MOVELEFT) then
		self.Owner:SetLocalVelocity((self.Owner:GetRight() * -1) * 700)
		self.dodgetime = CurTime() + 1
		self.Owner:ViewPunch(Angle(0, -10, 0))
		self.Weapon:EmitSound("yamato_tele", 100, 100)
		elseif self.Owner:KeyDown(IN_MOVERIGHT) then
		self.Owner:SetLocalVelocity((self.Owner:GetRight() * 1) * 700)
		self.dodgetime = CurTime() + 1
		self.Owner:ViewPunch(Angle(0, 10, 0))
		self.Weapon:EmitSound("yamato_tele", 100, 100)
		end
		end
		if self.Owner:IsOnGround() and self.Owner:KeyDown(IN_USE) and CurTime() > self.dodgetime then
		if self.Owner:KeyDown(IN_MOVELEFT) then
		self.Owner:SetLocalVelocity((self.Owner:GetRight() * -1) * 3700)
		self.dodgetime = CurTime() + 1
		self.Owner:ViewPunch(Angle(0, -10, 0))
		self.Weapon:EmitSound("yamato_tele", 100, 100)
		elseif self.Owner:KeyDown(IN_MOVERIGHT) then
		self.Owner:SetLocalVelocity((self.Owner:GetRight() * 1) * 3700)
		self.dodgetime = CurTime() + 1
		self.Owner:ViewPunch(Angle(0, 10, 0))
		self.Weapon:EmitSound("yamato_tele", 100, 100)
		end 
		
		end
		if self.Owner:KeyDown(IN_FORWARD) and SERVER and self.Owner:IsOnGround() and self.Owner:KeyDown(IN_USE) and self.Owner:KeyDown(IN_ATTACK) and CurTime() > self.st then
		local aimvec = self.Owner:GetAimVector()
		self.Owner:SetVelocity(Vector(aimvec.x*100,aimvec.y*100,aimvec.z*0.5)*1024)
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
		self.st = CurTime() + 1 
		self.Owner:ViewPunch(Angle(4, 0, 0))
		if self.Owner:Alive() then
		self.Owner:GodEnable()
		timer.Simple(0.05, function()	if self.Owner:Alive() then self.Owner:SetAnimation( PLAYER_ATTACK1 ) self:rapidcut() self.Weapon:SendWeaponAnim(ACT_VM_MISSLEFT) end	end)
		timer.Simple(0.07, function()	if self.Owner:Alive() then self:rapidcut() end end) 
		timer.Simple(0.09, function()	if self.Owner:Alive() then self:rapidcut() end end)
		timer.Simple(0.11, function()	if self.Owner:Alive() then self:rapidcut() self.Weapon:SendWeaponAnim(ACT_VM_MISSRIGHT) end	end)
		timer.Simple(0.13, function()	if self.Owner:Alive() then self.Owner:SetAnimation( PLAYER_ATTACK1 ) self:rapidcut() end end)
		timer.Simple(0.14, function()	if self.Owner:Alive() then self:rapidcut() self.Weapon:SendWeaponAnim(ACT_VM_MISSLEFT)	 end end)
		timer.Simple(0.15, function()	if self.Owner:Alive() then self:rapidcut() self.Owner:SetVelocity(Vector(aimvec.x*100,aimvec.y*100,aimvec.z*0.5)*1024) end end)
		timer.Simple(0.24, function()	
		
		self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK) self.Owner:ViewPunch(Angle(0, -260, 3))
		self.Weapon:SetNextPrimaryFire(CurTime() + 1)
		if self.Owner:Alive() then
		self:rapidcutf()
		end 
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self.Owner:GodDisable()
			
		end)
		end
		end
		if self.Owner:KeyDown(IN_BACK) and 	SERVER and self.Owner:IsOnGround() and self.Owner:KeyDown(IN_USE) and self.Owner:KeyDown(IN_ATTACK) and CurTime() > self.st then
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.85)
		if self.Owner:Alive() then
		self.Owner:GodEnable()
		self:liftcut()
		end
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		timer.Simple(0.2, function()
		if self.Owner:KeyDown(IN_ATTACK) then	
		self.Owner:SetVelocity(Vector(0,0,500))	
		if self.Owner:Alive() then
		self:rapidcut()
		self.Owner:GodDisable()
		end
		end
		end)
		self.st = CurTime() + 1.7
		self.Owner:ViewPunch(Angle(-30, -6, -4))
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
		end

end

