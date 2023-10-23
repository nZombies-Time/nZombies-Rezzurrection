
if CLIENT then
	local timeusetime = nil
	local completetime = nil
	local color_black_180 = Color(0, 0, 0, 180)

	local cl_drawhud = GetConVar("cl_drawhud")
	local nz_betterscaling = GetConVar("nz_hud_better_scaling")

	local function DrawUseProgress()		
		local time = timeusetime
		local ctime = completetime
		if !time or !ctime then return end
		
		local w, h = ScrW(), ScrH()
		local scale = 1
		if nz_betterscaling:GetBool() then
			scale = (w/1920 + 1)/2
		end

		surface.SetDrawColor(color_black_180)
		surface.DrawRect(w/2 - 150, h - 400*scale, 300, 20)
		surface.SetDrawColor(color_white)

		if time < CurTime() then			
			surface.DrawRect(w/2 - 145, h - 395*scale, 290 * (1-(completetime - CurTime())/time), 10)
		else
			surface.DrawRect(w/2 - 145, h - 395*scale, 290, 10)
		end
	end
	hook.Add("HUDPaint", "nzItemUseTimeDrawProgress", DrawUseProgress)

	net.Receive("nzTimedUse", function()
		local start = net.ReadBool()
		if start then
			local time = net.ReadFloat()
			timeusetime = time
			completetime = CurTime() + time
		else
			timeusetime = nil
			completetime = nil
		end
	end)
end

if SERVER then
	local function DetermineItemUseTime(ply, ent)
		if ent.RelayUse then ent = ent.RelayUse end -- If we relay uses, we refer to the relay entity

		if ply.TimedUseEntity then
			if ply.TimedUseEntity == ent and !ply:KeyReleased(IN_USE) then
				if ply.TimedUseComplete < CurTime() then
					ply:FinishTimedUse()
				end
			else
				ply:StopTimedUse()
			end
		end
	
		if IsValid(ent) and ent.StartTimedUse then
			local blockedwep = false
			local wep = ply:GetActiveWeapon()
			if IsValid(wep) and wep:IsSpecial() then
				blockedwep = true
			end

			if not blockedwep then
				if ply:KeyPressed(IN_USE) then
					ply:StartTimedUse(ent)
				end
				return false
			end
		end
	end
	hook.Add( "FindUseEntity", "nzItemUseTime", DetermineItemUseTime )
	
	local meta = FindMetaTable("Player")
	util.AddNetworkString("nzTimedUse")
	
	function meta:StartTimedUse(ent)
		if IsValid(self.TimedUseEntity) then self:StopTimedUse() end
		
		local time = ent:StartTimedUse(self, self, USE_OFF, 0)
		if time then
			self.TimedUseEntity = ent
			self.TimedUseComplete = CurTime() + time
			
			net.Start("nzTimedUse")
				net.WriteBool(true)
				net.WriteFloat(time)
			net.Send(self)
		end
	end
	
	function meta:StopTimedUse()
		local ent = self.TimedUseEntity
		if !IsValid(ent) then return end
		
		ent:StopTimedUse(self, self, USE_OFF, 0)
		self.TimedUseEntity = nil
		self.TimedUseEntity = nil
		
		net.Start("nzTimedUse")
			net.WriteBool(false)
		net.Send(self)
	end
	
	function meta:FinishTimedUse()
		local ent = self.TimedUseEntity
		if !IsValid(ent) then return end
		
		ent:FinishTimedUse(self, self, USE_ON, 0) -- Imitate ENTITY:Use arguments
		self.TimedUseEntity = nil
		self.TimedUseComplete = nil
		
		net.Start("nzTimedUse")
			net.WriteBool(false)
		net.Send(self)
	end

end

