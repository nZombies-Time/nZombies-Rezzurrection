-- Client Server Syncing

if SERVER then

	-- Server to client (Server)
	util.AddNetworkString( "nz.Perks.Sync" )
	util.AddNetworkString( "nz.Perks.UpgradeSync" )
	util.AddNetworkString( "nz.Perks.FullSync" )
	util.AddNetworkString( "nz.Perks.UpgradeFullSync" )
	
	function nzPerks:SendSync(ply, receiver)
		if !ply then nzPerks:SendFullSync(receiver) return end -- No valid player set, just do a full sync
		if !nzPerks.Players[ply] then nzPerks.Players[ply] = {} end -- Create table should it not exist (for some reason)
		
		local data = table.Copy(nzPerks.Players[ply])
		
		net.Start( "nz.Perks.Sync" )
			net.WriteEntity( ply )
			net.WriteTable( data )
		return receiver and net.Send(receiver) or net.Broadcast()
	end
	
	function nzPerks:SendUpgradeSync(ply, receiver)
		if !ply then nzPerks:SendFullUpgradeSync(receiver) return end -- No valid player set, just do a full sync
		if !nzPerks.PlayerUpgrades[ply] then nzPerks.PlayerUpgrades[ply] = {} end -- Create table should it not exist (for some reason)
		
		local data = table.Copy(nzPerks.PlayerUpgrades[ply])
		print("syncnet")
		net.Start( "nz.Perks.UpgradeSync" )
			net.WriteEntity( ply )
			net.WriteTable( data )
		return receiver and net.Send(receiver) or net.Broadcast()
	end
	
	function nzPerks:SendFullSync(receiver)
		local data = table.Copy(nzPerks.Players)
		
		net.Start( "nz.Perks.FullSync" )
			net.WriteTable( data )
		return receiver and net.Send(receiver) or net.Broadcast()
	end
	
	function nzPerks:SendFullUpgradeSync(receiver)
		local data = table.Copy(nzPerks.PlayerUpgrades)
		
		net.Start( "nz.Perks.UpgradeFullSync" )
			net.WriteTable( data )
		return receiver and net.Send(receiver) or net.Broadcast()
	end
	
	FullSyncModules["Perks"] = function(ply)
		nzPerks:SendFullSync(ply)
		nzPerks:SendFullUpgradeSync(ply)
	end

end

if CLIENT then
	
	-- Server to client (Client)
	local function ReceiveSync( length )
		print("Received Player Perks Sync")
		local ply = net.ReadEntity()
		nzPerks.Players[ply] = net.ReadTable()
		--PrintTable(nzPerks.Players)
	end
	
	local function ReceiveFullSync( length )
		print("Received Full Perks Sync")
		nzPerks.Players = net.ReadTable()
		PrintTable(nzPerks.Players)
	end
	
	local function ReceiveUpgradeSync( length )
		print("Received Player Upgrades Sync")
		local ply = net.ReadEntity()
		nzPerks.PlayerUpgrades[ply] = net.ReadTable()
		PrintTable(nzPerks.PlayerUpgrades[ply])
	end
	
	local function ReceiveFullUpgradeSync( length )
		print("Received Full Upgrades Sync")
		nzPerks.PlayerUpgrades = net.ReadTable()
		PrintTable(nzPerks.PlayerUpgrades)
	end
	
	-- Receivers 
	net.Receive( "nz.Perks.Sync", ReceiveSync )
	net.Receive( "nz.Perks.FullSync", ReceiveFullSync )
	net.Receive( "nz.Perks.UpgradeSync", ReceiveUpgradeSync )
	net.Receive( "nz.Perks.UpgradeFullSync", ReceiveFullUpgradeSync )
end