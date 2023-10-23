function nzEnemies:TotalAlive()
	local c = 0
	local tbl = {}

	-- Count
	for k,v in nzLevel.GetZombieArray() do -- FUCK YOU, ARRAYS ARE AWESOME!!!
		if IsValid(v) and v:Alive() and !v.Dying and !v.NZBossType and !v.IsMooBossZombie then
			--print(k)
			c = 0
			c = c + k
		end
	end

	return c
end

function nzEnemies:OnZombieSpawned(zombie, spawnpoint)

end