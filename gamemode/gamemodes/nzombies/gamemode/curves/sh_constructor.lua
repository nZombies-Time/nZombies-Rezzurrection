if SERVER then
	-- Main Tables
	nzCurves = nzCurves or AddNZModule("Curves")

	function nzCurves.GenerateHealthCurve(round)
		local base = GetConVar("nz_difficulty_zombie_health_base"):GetFloat()
		local scale = GetConVar("nz_difficulty_zombie_health_scale"):GetFloat()
		
		return math.Round(base*math.pow(scale,round - 1))
	end

	function nzCurves.GenerateMaxZombies(round)
		local base = GetConVar("nz_difficulty_zombie_amount_base"):GetInt()
		local scale = GetConVar("nz_difficulty_zombie_amount_scale"):GetFloat()
		local extrazombiesint = nzMapping.Settings.zombiesperplayer
		local extraZombies = 0
		if (isnumber(extrazombiesint)) then -- and nzRound:GetNumber() > 6
			if (#player.GetAllPlayingAndAlive() - 1 > 0) then
				if (extrazombiesint > 0) then
					extraZombies = extrazombiesint * (#player.GetAllPlayingAndAlive() - 1)
				end
			end
		end

		return math.Round((base + (scale * (#player.GetAllPlaying() - 1))) * round) + extraZombies
	end

	function nzCurves.GenerateSpeedTable(round)
		if !round then return {[50] = 100} end -- Default speed for any invalid round (Say, creative mode test zombies)
		local tbl = {}
		local range = 3 -- The range on either side of the tip (current round) of speeds in steps of "steps"
		local min = 30 -- Minimum speed (Round 1)
		local max = 300 -- Maximum speed
		local maxround = 30 -- The round at which the 300 speed has its tip
		local steps = ((max-min)/maxround) -- The different speed steps speed can exist in

		print("Generating round speeds with steps of "..steps.."...")
		for i = -range, range do
			local speed = (min - steps + steps*round) + (steps*i)
			if speed >= min and speed <= max then
				local chance = 100 - 10*math.abs(i)^2
				--print("Speed is "..speed..", with a chance of "..chance)
				tbl[speed] = chance
			elseif speed >= max then
				tbl[max] = 100
			end
		end
		return tbl
	end

	-- Moo's more CoDZ like speed increase.
	function nzCurves.GenerateCoDSpeedTable(round) -- Works best for enemies that obey the speed given to them by an animation rather than code.
		if not round then return {[50] = 100} end
		local tbl = {}
		local round = round
		local multiplier = 8
		local speed = 1 -- BO1 has this start at 1.

		for i = 1,round do -- I've been trolled once more by the "For" loop...
			speed = round * multiplier - multiplier -- Subbing by multiplier as well cause that seems to work.
		end

		-- Hello Mario, you better not be fucking with this.

		if round == 1 then -- We always want walking zombies on the first round(Just like in the real games!).
			tbl[0] = 100
		else
			tbl[speed] = 100 -- This calculates the base number for the zombies of the round to use, further speed adjustments are done in the zombie luas themselves if they support it.
		end
		return tbl
	end

end
