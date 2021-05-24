local function powerOff(trap)
	if (IsValid(trap)) then
		timer.Destroy("nz.activatable.timer." .. trap:EntIndex()) 
		timer.Destroy("nz.activatable.cooldown.timer." .. trap:EntIndex()) 
		trap:PowerOff()
	end
end

local function TurnOffAllTraps(force)
	for _,v in pairs(nzTrapsAndLogic:GetAll()) do
		for _,trap in pairs(ents.FindByClass(v)) do
			if (force or trap:GetElectricityNeeded()) then
				powerOff(trap)
			end
		end	
	end
end

-- Run trap functionality based on power
hook.Add("ElectricityOn", "ActivateableElctricityOn", function()	
	for _,v in pairs(ents.FindByClass("nz_button")) do
		v:Ready()
	end	
end)

hook.Add("ElectricityOff", "ActivateableElectricityOff", function()
	for _,v in pairs(ents.FindByClass("nz_button")) do
		if (IsValid(v) and v:GetElectricityNeeded()) then
			powerOff(v)
		end
	end	

	TurnOffAllTraps()
end)

-- Turn off all traps when the game ends
hook.Add("OnRoundEnd", "ActivateableTurnOffEndRound", function()
	TurnOffAllTraps(true)
		for _,v in pairs(ents.FindByClass("nz_button")) do
		if (IsValid(v)) then
			powerOff(v)
		end
	end
end)

if SERVER then
	-- Force turn off traps when switching from Creative Mode
	local oldState -- because it's never actually passed to RoundChangeState :/
	hook.Add("OnRoundChangeState", "ActivateableForcePreview", function(_, new)
		if (new == 0 and nzRound and nzRound:InState(ROUND_CREATE)) then
			oldState = 0
		end

		if (new != 0 and oldState == 0) then --They are still possibly on from Creative Previews, turn them off
			oldState = 1
			for _,v in pairs(nzTrapsAndLogic:GetAll()) do
				for _,trap in pairs(ents.FindByClass(v)) do
					powerOff(trap)
				end	
			end
		end
	end)
end