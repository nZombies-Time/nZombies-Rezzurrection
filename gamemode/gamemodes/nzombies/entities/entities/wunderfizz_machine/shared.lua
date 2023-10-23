AddCSLuaFile()

ENT.Type			= "anim"

ENT.PrintName		= "wundefizz_machine"
ENT.Author			= "Zet0r"
ENT.Contact			= "youtube.com/Zet0r"
ENT.Purpose			= ""
ENT.Instructions	= ""

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Price")
	self:NetworkVar("Bool", 0, "Active")
	self:NetworkVar("Bool", 1, "BeingUsed")
	self:NetworkVar("Entity", 0, "User")
	
	self:NetworkVar( "String", 0, "PerkID")
	self:NetworkVar( "Bool", 2, "IsTeddy" )
	self:NetworkVar( "Bool", 3, "Sharing" ) ////////////////////Communism
end

function ENT:DecideOutcomePerk(ply, specific)
	if specific then self:SetPerkID(specific) return end
	
	if self.TimesUsed > 1 and math.random(100) <= 20 and #ents.FindByClass("wunderfizz_machine") > 1 then
		return hook.Call("OnPlayerBuyWunderfizz", nil, ply, "teddy") or "teddy"
	else
		local blockedperks = {
			["wunderfizz"] = true, -- lol, this would happen
			["pap"] = true,
		}
		local wunderfizzlist = {}
		for k,v in pairs(nzPerks:GetList()) do
			if k != "wunderfizz" and k != "pap" then
				wunderfizzlist[k] = {true, v}
			end
		end

		local available = nzMapping.Settings.wunderfizzperklist or wunderfizzlist
		local tbl = {}
		for k,v in pairs(available) do
			if !self:GetUser():HasPerk(k) and !blockedperks[k] then
				if (v[1] == nil || v[1] == true) then
					table.insert(tbl, k)
				end
			end
		end
		if #tbl <= 0 then return hook.Call("OnPlayerBuyWunderfizz", nil, ply, "teddy") or "teddy" end -- Teddy bear for no more perks D:
		local outcome = tbl[math.random(#tbl)]
		return hook.Call("OnPlayerBuyWunderfizz", nil, ply, outcome) or outcome
	end
end

function ENT:Initialize()
	if SERVER then
		self:SetModel("models/nzr/2022/machines/wonder/vending_wonder.mdl")
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_VPHYSICS )
		--self:DrawShadow( false )
		self:SetUseType( SIMPLE_USE )
		self:SetBeingUsed(false)
		self:SetIsTeddy(false)
		self:SetPrice(1500)

		self:SetSharing(false) ////////////////////Communism

		self.NextLightning = CurTime() + math.random(10)
		self:SetAutomaticFrameAdvance(true)
		self:TurnOff(true)
		self.TimesUsed = 0
	end
end

function ENT:TurnOn()
	local turnon, dur = self:LookupSequence("turn_on")
	self:SetCycle(0)
	self:ResetSequence(turnon)
	self.GoIdle = CurTime() + dur -- Delay when to go idle (after turn on animation)
	self:EmitSound("nz_moo/perks/wonderfizz/ball_drop.mp3", 100)
end

function ENT:TurnOff(spawn)
	self:SetActive(false)
	local turnoff, dur = self:LookupSequence("turn_off")
	self:ResetSequence(turnoff)
	self:EmitSound("nz_moo/perks/wonderfizz/rand_perk_mach_leave.mp3", 100)
	if spawn then self:SetCycle(1) else self:SetCycle(0) end
	--self:SetCycle(0)
	--self:SetPlaybackRate(10)
	--print(turnoff)
end

function ENT:IsOn()
	return self:GetActive()
end

function ENT:Think()
	if SERVER then
		if self.GoIdle and self.GoIdle < CurTime() then
			local idle = self:LookupSequence("idle")
			self:SetCycle(0)
			self:ResetSequence(idle)
			self:SetActive(true) -- Turn on here
			self.GoIdle = nil
			--print("idling")
		end
		if self:IsOn() and CurTime() > self.NextLightning then
			local e = EffectData()
			e:SetStart(self:GetPos() + Vector(0,0,3000))
			e:SetOrigin(self:GetPos() + Vector(0,0,100))
			e:SetMagnitude(0.5)
			util.Effect("lightning_strike_wunderfizz", e)
			ParticleEffect("ins_skybox_lightning",self:GetPos(),self:GetAngles(),nil)
			--self:EmitSound("amb/weather/lightning/lightning_flash_0"..math.random(0,3)..".wav",511)
			self.NextLightning = CurTime() + math.random(30)
		end
		self:NextThink(CurTime())
		return true
	end
end

function ENT:Use(activator, caller)
	if self:IsOn() and !self.GoIdle then -- Only after fully arriving
		if !IsValid(self.Bottle) and !self:GetBeingUsed() then
			local price = self:GetPrice()
			-- Can only be bought if you have free perk slots
			if #activator:GetPerks() < GetConVar("nz_difficulty_perks_max"):GetInt() then
				-- If they have enough money
				activator:Buy(price, self, function()
					self:SetBeingUsed(true)
					self:SetUser(activator)
					
					self.OutcomePerk = self:DecideOutcomePerk(activator)
					self.Bottle = ents.Create("wunderfizz_windup")
					self.Bottle:SetPos(self:GetPos() + Vector(0,0,50))
					self.Bottle:SetAngles(self:GetAngles() + Angle(0,140,0))
					self.Bottle.WMachine = self
					self.Bottle.Perk = self.OutcomePerk
					self.Bottle:Spawn()
					
					timer.Simple(0, function()
						if IsValid(self.Bottle) then
							local e = EffectData()
							e:SetEntity(self.Bottle)
							e:SetMagnitude(1.1)
							e:SetScale(5)
							util.Effect("lightning_aura", e)
						end
					end)
					
					self.TimesUsed = self.TimesUsed + 1
					return true
				end)
			else
				print(activator:Nick().." already has max perks")
			end
		elseif !self.Bottle:GetWinding() and !self:GetIsTeddy() then  //////////////////// FROM HERE
			if nzMapping.Settings.sharing then
				if activator == self:GetUser() or self:GetSharing() then
					if self:GetSharing() and #activator:GetPerks() >= GetConVar("nz_difficulty_perks_max"):GetInt() then
						activator:PrintMessage( HUD_PRINTTALK, "BITCH YOU THOUGHT" )
						return
					end

					local perk = self:GetPerkID()
					local wep = activator:Give("tfa_perk_bottle")
					if IsValid(wep) then
						wep:SetPerk(perk)
					end
					activator:GivePerk(perk)
					self:SetBeingUsed(false)
					self:SetPerkID("")
					self:SetUser(nil)
					self.Bottle:Remove()
					self:SetSharing(false)
				end
			else
				if activator == self:GetUser() then	
					local perk = self:GetPerkID()
					local wep = activator:Give("tfa_perk_bottle")
					if IsValid(wep) then
						wep:SetPerk(perk)
					end
					activator:GivePerk(perk)
					self:SetBeingUsed(false)
					self:SetPerkID("")
					self:SetUser(nil)
					self.Bottle:Remove()
					self:SetSharing(false)
				else
					activator:PrintMessage( HUD_PRINTTALK, "This is " .. self:GetUser():Nick() .. "'s perk. You cannot take it." )
				end
			end
		end  //////////////////// TO HERE IS COMMUNISM (i think)
	end
end

function ENT:OnRemove()
	if IsValid(self.Bottle) then self.Bottle:Remove() end
end

function ENT:MoveLocation()
	if (#ents.FindByClass("wunderfizz_machine") == 1) then return end -- NO! Don't move if there's nowhere to go
	self:TurnOff()
	self:SetPerkID("")
	self:SetUser(nil)
	self:SetIsTeddy(false)
	
	local tbl = {}
	for k,v in pairs(ents.FindByClass("wunderfizz_machine")) do
		if !v:IsOn() and v != self then
			table.insert(tbl, v)
		end
	end
	local target = tbl[math.random(#tbl)]
	if IsValid(target) then
		target:TurnOn()
	end
end

local offlight = Material( "sprites/redglow1" )
local offpos = Vector(10, 23.6, 61.4)
local red = Color(255,255,255) -- The sprite itself is red
local onlight = Material( "sprites/physg_glow1" )
local onpos = Vector(10, 23.6, 58)
local green = Color(0,255,0) -- That one's white though
if CLIENT then
	function ENT:Draw()
		self:DrawModel()
		if self:IsOn() then
			cam.Start3D(EyePos(),EyeAngles())
				render.SetMaterial( onlight )
				render.DrawSprite( self:LocalToWorld(onpos), 10, 10, green)
			cam.End3D()
		else
			cam.Start3D(EyePos(),EyeAngles())
				render.SetMaterial( offlight )
				render.DrawSprite( self:LocalToWorld(offpos), 10, 10, red)
			cam.End3D()
		end
	end
end