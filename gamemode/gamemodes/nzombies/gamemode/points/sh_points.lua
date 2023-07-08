local _PLAYER = FindMetaTable("Player")

function _PLAYER:GetPoints()
	return self:GetNW2Int("points") or 0
end

function _PLAYER:HasPoints(amount)
	return self:GetPoints() >= amount
end

function _PLAYER:CanAfford(amount)
	return (self:GetPoints() - amount) >= 0
end

if (SERVER) then
	local hudnetstring = {
		["Shadows of Evil"] = "nz_points_notification_bo3_zod",
		["Black Ops 3"] = "nz_points_notification_bo3",
		["Black Ops 1"] = "nz_points_notification_bo1",
		["Tranzit (Black Ops 2)"] = "nz_points_notification_bo2",
		["Mob of the Dead"] = "nz_points_notification_bo2_dlc",
		["Buried"] = "nz_points_notification_bo2_dlc",
		["Origins (Black Ops 2)"] = "nz_points_notification_bo2_dlc",
	}

	util.AddNetworkString("nz_points_notification")
	util.AddNetworkString("nz_points_notification_bo1")
	util.AddNetworkString("nz_points_notification_bo2")
	util.AddNetworkString("nz_points_notification_bo2_dlc")
	util.AddNetworkString("nz_points_notification_bo2_dlc")
	util.AddNetworkString("nz_points_notification_bo2_dlc")
	util.AddNetworkString("nz_points_notification_bo3")
	util.AddNetworkString("nz_points_notification_bo3_zod")

	-- Sets the character's amount of currency to a specific value.
	function _PLAYER:SetPoints(amount)
		amount = math.Round(amount, 2)
		if not GetConVar("nz_point_notification_clientside"):GetBool() then
			local num = amount - self:GetPoints()
			if num ~= 0 then -- 0 points doesn't get sent
				local netstring = hudnetstring[nzMapping.Settings.hudtype] or "nz_points_notification"

				net.Start(netstring)
					net.WriteInt(num, 20)
					net.WriteEntity(self)
				net.Broadcast()
			end
		end
		self:SetNW2Int("points", amount)
	end

	-- Quick function to set the money to the current amount plus an amount specified.
	function _PLAYER:GivePoints(amount, ignoredp)
		-- If double points is on.
		if nzPowerUps:IsPowerupActive("dp") and not ignoredp then
			amount = amount * 2
		end
		amount = hook.Call("OnPlayerGetPoints", nil, self, amount) or amount
		self:SetPoints(self:GetPoints() + amount)
	end

	-- Takes away a certain amount by inverting the amount specified.
	function _PLAYER:TakePoints(amount, nosound)
		-- Changed to prevent double points from removing double the points. - Don't even think of changing this back Ali, Love Ali.
		amount = hook.Call("OnPlayerLosePoints", nil, self, amount) or amount
		self:SetPoints(self:GetPoints() - amount)
		
		if not nosound then
			self:EmitSound("nz/effects/buy.wav")
		end

		-- If you have a clone like this, it tracks money spent which will be refunded on revival
		if self.WhosWhoMoney then self.WhosWhoMoney = self.WhosWhoMoney + amount end
	end
	
	function _PLAYER:Buy(amount, ent, func)
		local new = hook.Call("OnPlayerBuy", nil, self, amount, ent, func) or amount
		if type(new) == "number" then
			if self:CanAfford(new) then
				local success = func()
				if success then
					self:TakePoints(new)
					hook.Call("OnPlayerBought", nil, self, new, ent)
					return true -- If the buy was successfull, this function also returns true
				end
			else
				self:EmitSound("nz_moo/effects/purchases/deny.wav")
				return false -- Return false if we can't afford
			end
		else
			return false -- And return false if the hook blocked the event by returning true
		end
	end

end
