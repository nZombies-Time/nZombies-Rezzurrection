
	-- Weapon base courtesy of CptFuzzies SWEP Bases project
	-- Recoded to do more balanced damage

SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""
SWEP.ViewModelFOV	= 85
SWEP.ViewModelFlip	= false
SWEP.ViewModel = "models/weapons/yamato/yamato.mdl"
SWEP.WorldModel = "models/weapons/w_yamato.mdl"
--SWEP.AnimPrefix		= "crowbar"
SWEP.HoldType		= "melee2"
SWEP.PrintName     	    = "Yamato)Old)"	
SWEP.UseHands = true

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false
SWEP.DrawCrosshair		= false

CROWBAR_RANGE	= 155
CROWBAR_REFIRE	= 0.9

--SWEP.Primary.Sound			= "nz/knife/weapons/whoosh.wav"
SWEP.Primary.Hit			= Sound("weapons/yamato_slash.wav")
SWEP.Primary.Range			= CROWBAR_RANGE
SWEP.Primary.Damage			= 110
SWEP.Primary.DamageType		= DMG_SLASH
SWEP.Primary.Force			= 0.75
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= CROWBAR_REFIRE
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "None"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "None"

SWEP.NZPreventBox = true



/*---------------------------------------------------------
   Name: SWEP:Initialize( )
   Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end


/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
	if SERVER then
	// Only the player fires this way so we can cast
	local pPlayer		= self.Owner;

	if ( !pPlayer ) then
		return;
	end

	// Make sure we can swing first
	if ( !self:CanPrimaryAttack() ) then return end

	local vecSrc		= pPlayer:GetShootPos();
	local vecDirection	= pPlayer:GetAimVector();

	local trace			= {}
		trace.start		= vecSrc
		trace.endpos	= vecSrc + ( vecDirection * self:GetRange() )
		trace.filter	= pPlayer
	
	local traceHit		= util.TraceLine( trace )

	if ( traceHit.Hit ) then
		local zombie = traceHit.Entity
		if ( IsValid(zombie) and zombie.Type == "nextbot" and zombie:Alive() ) then -- They stabbed a zombie
			-- New damage handling by Ethorbit for compatibility with COLLISION_GROUP_DEBRIS_TRIGGER:
			local slashdmg = DamageInfo()
			slashdmg:SetAttacker(self.Owner)
			slashdmg:SetInflictor(self)
			slashdmg:SetDamage(self.Primary.Damage)
			slashdmg:SetDamageType(self.Primary.DamageType)
			slashdmg:SetDamageForce(self.Owner:GetAimVector() * math.random(3000, 4000))
			zombie:TakeDamageInfo(slashdmg)
			self.Owner:EmitSound("weapons/yamato_slash2.wav", 100, 100, 1) 
		else -- Play default stab sound
			--timer.Simple(0.1, function() self:EmitSound("nz/knife/knife_stab.wav") end)
			self.Owner:EmitSound("weapons/yamato_slash3.wav")
		end
	

		self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
		pPlayer:SetAnimation( PLAYER_ATTACK1 )
		self.Owner:ViewPunch( Angle( math.Rand(-3, -2.5), math.Rand(-7, -4.5), 0 ) )

		--if math.random(0,1) == 0 and !self.Owner:KeyDown(IN_BACK) then

		-- else
		-- 	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		-- 	pPlayer:SetAnimation( PLAYER_ATTACK1 )
		-- 	self.nzHolsterTime = CurTime() + 0.5
		-- 	timer.Simple(0.1, function() self:EmitSound("nz/knife/knife_slash.wav") end)
		-- 	self.Owner:ViewPunch( Angle( math.Rand(-3, -2.5), math.Rand(-7, -4.5), 0 ) )
		-- end

		self.Weapon:SetNextPrimaryFire( CurTime() + self:GetFireRate() );
		self.Weapon:SetNextSecondaryFire( CurTime() + self.Weapon:SequenceDuration() );

		--timer.Simple(0.1, function() self:Hit( traceHit, pPlayer ); end)
		return	
	end

	self.Owner:EmitSound("weapons/yamato_slash.wav" )

	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	pPlayer:SetAnimation( PLAYER_ATTACK1 );
	self.Owner:ViewPunch( Angle( math.Rand(-3, -2.5), math.Rand(-7, -4.5), 0 ) )

	self.Weapon:SetNextPrimaryFire( CurTime() + self:GetFireRate() );
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Weapon:SequenceDuration()+1 );

	self:Swing( traceHit, pPlayer );

	return
end
end


/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack( )
   Desc: +attack2 has been pressed
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
	return false
end

/*---------------------------------------------------------
   Name: SWEP:Reload( )
   Desc: Reload is being pressed
---------------------------------------------------------*/
function SWEP:Reload()
	return false
end

//-----------------------------------------------------------------------------
// Purpose: Get the damage amount for the animation we're doing
// Input  : hitActivity - currently played activity
// Output : Damage amount
//-----------------------------------------------------------------------------
function SWEP:GetDamageForActivity( hitActivity )
	return nzRound:InProgress() and 30 + (45/nzRound:GetNumber()) or 75
end

/*---------------------------------------------------------
   Name: SWEP:Deploy( )
   Desc: Whip it out
---------------------------------------------------------*/
function SWEP:Deploy()

	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	self:SetDeploySpeed( self.Weapon:SequenceDuration() )

	return true

end


-- function SWEP:Hit( traceHit, pPlayer )
-- 	local vecSrc = pPlayer:GetShootPos();

-- 	if ( SERVER ) then
-- 		pPlayer:TraceHullAttack( vecSrc, traceHit.HitPos, Vector( -5, -5, -5 ), Vector( 5, 5, 36 ), self:GetDamageForActivity(), self.Primary.DamageType, self.Primary.Force );
-- 	end

-- 	// self:AddViewKick();

-- end



function SWEP:Swing( traceHit, pPlayer )
end


function SWEP:CanPrimaryAttack()
	return true
end


function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:SetDeploySpeed( speed )

	self.m_WeaponDeploySpeed = tonumber( speed / GetConVarNumber( "phys_timescale" ) )

	self.Weapon:SetNextPrimaryFire( CurTime() + speed )
	self.Weapon:SetNextSecondaryFire( CurTime() + speed )

end



function SWEP:Drop( vecVelocity )
if ( !CLIENT ) then
	self:Remove();
end
end

function SWEP:GetRange()
	return	self.Primary.Range;
end

function SWEP:GetFireRate()
	return	self.Primary.Delay;
end