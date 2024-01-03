if SERVER then
	-- Main Tables
	nzCurves = nzCurves or AddNZModule("Curves")

	function nzCurves.GenerateHealthCurve(round)
		local hp = 75
		local hpinc = 50
		local hpmult = 0.1

		for i=2, round do -- Now featuring 1:1 Health Scaling.
			if i >= 10 then
				hp = hp + (math.floor(hp * hpmult))
			else
				hp = math.Round(hp + hpinc)
			end
		end

		if hp > 60000 then
			hp = 60000
		end

		local nextround = 163
		if round >= 163 and round == nextround then -- Forced insta kill rounds.
			hp = 1
			if round > 185 then
				nextround = round + math.random(5) -- Literally just mimicking insta-kill rounds down to the slight randomness past round 185 :wind_blowing_face:
			else
				nextround = round + 2 -- Every other round until past 185.
			end
		end

		return hp
	end

	function nzCurves.GenerateMaxZombies(round)
		local round = round
		local ply = #player.GetAllPlaying()
		local extrazombiesint = nzMapping.Settings.zombiesperplayer
		local extraZombies = 0
		local cap = nzMapping.Settings.amountcap or 240 -- In this context, the amount of zombies the "max" has will be capped by the value set here.

		local max = 24
		local multiplier = math.max(1, round / 5)
		local sp = (ply == 1)

		if round > 10 then
			multiplier = multiplier * round * 0.15
		end

		-- The actual code uses "+=" which just means it adds to the variable which in this case is "max"
		max = max + (sp and 0.5 or (ply - 1)) * 6 * multiplier

		--[[Rounds 1 to 5]]--
		local roundtab = {
			[1] = function(max) return max * 0.25 end,
			[2] = function(max) return max * 0.3 end,
			[3] = function(max) return max * 0.5 end,
			[4] = function(max) return max * 0.7 end,
			[5] = function(max) return max * 0.9 end,
		}

		if max > cap then
			max = cap + ((ply - 1) * 6) -- Did the amount of zombies go over the cap? Force it to the capped value. (Considering for multiple players of course.)
		end

		return (round == -1 and 6 or round <= 5 and math.floor(roundtab[round](max)) or math.floor(max))
	end

	function nzCurves.GenerateSpeedTable(round)
		if not round then return {[50] = 100} end -- Default speed for any invalid round (Say, creative mode test zombies)
		local tbl = {}
		local round = round
		local range = 3 -- The range on either side of the tip (current round) of speeds in steps of "steps"
		local min = 20 -- Minimum speed (Round 1)
		local max = 300 -- Maximum speed
		local maxround = 27 -- The round at which the speed has its tip
		local steps = ((max-min)/maxround) -- The different speed steps speed can exist in
		--print("Generating round speeds with steps of "..steps.."...")
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
		local multiplier = nzMapping.Settings.speedmulti or 4 -- Actual value used in BO3 onward. If you want Pre-BO3 Speed increases, use 8 instead.
		local speed = 1 -- BO1 has this start at 1.

		for i = 1,round do
			speed = round * multiplier - multiplier -- Subbing by multiplier as well cause that seems to work.
		end

		if round == 1 then -- We always want walking zombies on the first round(Just like in the real games!).
			tbl[0] = 100
		else
			tbl[speed] = 100 -- This calculates the base number for the zombies of the round to use, further speed adjustments are done in the zombie luas themselves if they support it.
		end
		return tbl
	end
end

-- :sleeping_accommodation:
-- I understood the assignment
