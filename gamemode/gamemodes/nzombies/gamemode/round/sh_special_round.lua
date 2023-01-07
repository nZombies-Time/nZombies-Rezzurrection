if SERVER then
	function nzRound:SetNextSpecialRound( num )
		self.NextSpecialRound = num
	end

	function nzRound:GetNextSpecialRound()
		return self.NextSpecialRound
	end

	function nzRound:MarkedForSpecial( num )
		return ((self.NextSpecialRound == num and self.SpecialRoundType and self.SpecialData[self.SpecialRoundType] and true) or (nzConfig.RoundData[ num ] and nzConfig.RoundData[ num ].special)) or false
	end
	
	function nzRound:SetSpecialRoundType(id)
		if id == "None" then
			self.SpecialRoundType = nil -- "None" makes a nil key
		else
			self.SpecialRoundType = id or "Hellhounds" -- A nil id defaults to "Hellhounds", otherwise id
		end
	end
	
	function nzRound:GetSpecialRoundType(id)
		return self.SpecialRoundType
	end
	
	function nzRound:GetSpecialRoundData()
		if !self.SpecialRoundType then return nil end
		return self.SpecialData[self.SpecialRoundType]
	end

	util.AddNetworkString("nz_hellhoundround")
	function nzRound:CallHellhoundRound()
		net.Start("nz_hellhoundround")
			net.WriteBool(true)
		net.Broadcast()
	end
end


nzRound.PerkSelectData = nzRound.PerkSelectData or {}
function nzRound:AddMachineType(id, class)
	if SERVER then
		if class then
			local data = {}
			-- Which entity to spawn
			data.class = class
			nzRound.PerkSelectData[id] = data
		else
			nzRound.PerkSelectData[id] = nil -- Remove it if no valid class was added
		end
	else
		-- Clients only need it for the dropdown, no need to actually know the data and such
		nzRound.PerkSelectData[id] = class
	end
end

nzRound:AddMachineType("Original", "nz_zombie_walker", {
}) 
nzRound:AddMachineType("Infinite Warfare", "nz_zombie_walker", {
}) 

nzRound.eemodel = nzRound.eemodel or {}
function nzRound:AddSongType(id, class)
	if SERVER then
		if class then
			local data = {}
			-- Which entity to spawn
			data.class = class
			nzRound.eemodel[id] = data
		else
			nzRound.eemodel[id] = nil -- Remove it if no valid class was added
		end
	else
		-- Clients only need it for the dropdown, no need to actually know the data and such
		nzRound.eemodel[id] = class
	end
end

nzRound:AddSongType("Hula Doll", "nz_zombie_walker", {
}) 
nzRound:AddSongType("115 Meteor", "nz_zombie_walker", {
}) 
nzRound:AddSongType("Origins Rock", "nz_zombie_walker", {
})
nzRound:AddSongType("Phone", "nz_zombie_walker", {
})
nzRound:AddSongType("Teddybear", "nz_zombie_walker", {
})
nzRound:AddSongType("Teddybear(Moon)", "nz_zombie_walker", {
})
nzRound:AddSongType("Teddybear(Shanks)", "nz_zombie_walker", {
})
nzRound:AddSongType("Vodka Bottle", "nz_zombie_walker", {
})

function nzRound:GetSongType(id)
	if id == "Hula Doll" then
	return "models/props_lab/huladoll.mdl"
	end
	if id == "115 Meteor" then
	return "models/nzr/song_ee/meteor.mdl"
	end
	if id == "Origins Rock" then
	return "models/nzr/song_ee/origins_rock.mdl"
	end
	if id == "Phone" then
	return "models/nzr/song_ee/phone.mdl"
	end
	if id == "Teddybear" then
	return "models/nzr/song_ee/teddybear.mdl"
	end
	if id == "Teddybear(Moon)" then
	return "models/nzr/song_ee/teddybear_moon.mdl"
	end
	if id == "Teddybear(Shanks)" then
	return "models/nzr/song_ee/teddybear_shanks.mdl"
	end
	if id == "Vodka Bottle" then
	return "models/nzr/song_ee/vodka.mdl"
	end
	if id == nil then
	return "models/props_lab/huladoll.mdl"
	end
end

nzRound.PAPSelectData = nzRound.PAPSelectData or {}
function nzRound:AddPAPType(id, class)
	if SERVER then
		if class then
			local data = {}
			-- Which entity to spawn
			data.class = class
			nzRound.PAPSelectData[id] = data
		else
			nzRound.PAPSelectData[id] = nil -- Remove it if no valid class was added
		end
	else
		-- Clients only need it for the dropdown, no need to actually know the data and such
		nzRound.PAPSelectData[id] = class
	end
end

nzRound:AddPAPType("Original", "nz_zombie_walker", {
}) 
nzRound:AddPAPType("Black Ops Cold War", "nz_zombie_walker", {
}) 
nzRound:AddPAPType("World War II", "nz_zombie_walker", {
})

nzRound.PAPSoundData = nzRound.PAPSoundData or {}
function nzRound:AddPAPsound(id, class)
	if SERVER then
		if class then
			local data = {}
			-- Which entity to spawn
			data.class = class
			nzRound.PAPSoundData[id] = data
		else
			nzRound.PAPSoundData[id] = nil -- Remove it if no valid class was added
		end
	else
		-- Clients only need it for the dropdown, no need to actually know the data and such
		nzRound.PAPSoundData[id] = class
	end
end

nzRound:AddPAPsound("Classic", "nz_zombie_walker", {
}) 

nzRound:AddPAPsound("Black Ops 3", "nz_zombie_walker", {
})

nzRound:AddPAPsound("Black Ops Cold War", "nz_zombie_walker", {
})

nzRound:AddPAPsound("Infinite Warfare", "nz_zombie_walker", {
})

nzRound:AddPAPsound("Tyler1", "nz_zombie_walker", {
})

nzRound.IconSelectData = nzRound.IconSelectData or {}
function nzRound:AddIconType(id, class)
	if SERVER then
		if class then
			local data = {}
			-- Which entity to spawn
			data.class = class
			nzRound.IconSelectData[id] = data
		else
			nzRound.IconSelectData[id] = nil -- Remove it if no valid class was added
		end
	else
		-- Clients only need it for the dropdown, no need to actually know the data and such
		nzRound.IconSelectData[id] = class
	end
end

nzRound:AddIconType("Rezzurrection", "nz_zombie_walker", {}) 
nzRound:AddIconType("World at War/ Black Ops 1", "nz_zombie_walker", {}) 
nzRound:AddIconType("Black Ops 2", "nz_zombie_walker", {}) 
nzRound:AddIconType("Black Ops 3", "nz_zombie_walker", {}) 
nzRound:AddIconType("Black Ops 4", "nz_zombie_walker", {}) 
nzRound:AddIconType("Infinite Warfare", "nz_zombie_walker", {}) 
nzRound:AddIconType("Modern Warfare", "nz_zombie_walker", {}) 
nzRound:AddIconType("Cold War", "nz_zombie_walker", {}) 
nzRound:AddIconType("April Fools", "nz_zombie_walker", {}) 
nzRound:AddIconType("No Background", "nz_zombie_walker", {}) 
nzRound:AddIconType("Hololive", "nz_zombie_walker", {}) 

function nzRound:GetIconType(id)
	if id == "Rezzurrection" then
	return "Rezzurrection"
	end
	if id == "World at War/ Black Ops 1" then
	return "World at War/ Black Ops 1"
	end
	if id == "Black Ops 2" then
	return "Black Ops 2"
	end
	if id == "Black Ops 3" then
	return "Black Ops 3"
	end
	if id == "Infinite Warfare" then
	return "Infinite Warfare"
	end
	if id == "Modern Warfare" then
	return "Modern Warfare"
	end
		if id == "Cold War" then
	return "Cold War"
	end
		if id == "No Background" then
	return "No Background"
	end
		if id == "April Fools" then
	return "April Fools"
	end
	if id == "Hololive" then
	return "Hololive"
	end
	if id == "Black Ops 4" then
	return "Black Ops 4"
	end
	if id == nil then
	return  "Rezzurrection"
	end
end

nzRound.FontSelection = nzRound.FontSelection or {}
function nzRound:AddFontType(id, class)
	if SERVER then
		if class then
			local data = {}
			-- Which entity to spawn
			data.class = class
			nzRound.FontSelection[id] = data
		else
			nzRound.FontSelection[id] = nil -- Remove it if no valid class was added
		end
	else
		-- Clients only need it for the dropdown, no need to actually know the data and such
		nzRound.FontSelection[id] = class
	end
end

nzRound:AddFontType("Classic NZ", "nz_zombie_walker", {}) 
nzRound:AddFontType("Old Treyarch", "nz_zombie_walker", {}) 
nzRound:AddFontType("BO2/3", "nz_zombie_walker", {})  
nzRound:AddFontType("BO4", "nz_zombie_walker", {}) 
nzRound:AddFontType("Comic Sans", "nz_zombie_walker", {}) 
nzRound:AddFontType("Warprint", "nz_zombie_walker", {}) 
nzRound:AddFontType("Road Rage", "nz_zombie_walker", {}) 
nzRound:AddFontType("Black Rose", "nz_zombie_walker", {})  
nzRound:AddFontType("Reborn", "nz_zombie_walker", {}) 
nzRound:AddFontType("Rio Grande", "nz_zombie_walker", {}) 
nzRound:AddFontType("Bad Signal", "nz_zombie_walker", {}) 
nzRound:AddFontType("Infection", "nz_zombie_walker", {}) 
nzRound:AddFontType("Brutal World", "nz_zombie_walker", {}) 
nzRound:AddFontType("Generic Scifi", "nz_zombie_walker", {}) 
nzRound:AddFontType("Tech", "nz_zombie_walker", {}) 
nzRound:AddFontType("Krabby", "nz_zombie_walker", {}) 
nzRound:AddFontType("Default NZR", "nz_zombie_walker", {}) 

nzRound.BoxSkinData = nzRound.BoxSkinData or {}
function nzRound:AddBoxType(id, class)
	if SERVER then
		if class then
			local data = {}
			-- Which entity to spawn
			data.class = class
			nzRound.BoxSkinData[id] = data
		else
			nzRound.BoxSkinData[id] = nil -- Remove it if no valid class was added
		end
	else
		-- Clients only need it for the dropdown, no need to actually know the data and such
		nzRound.BoxSkinData[id] = class
	end
end

nzRound:AddBoxType("Original", "", {}) 
nzRound:AddBoxType("Mob of the Dead", "", {}) 
nzRound:AddBoxType("Origins", "", {}) 
nzRound:AddBoxType("Dead Space", "", {}) 
nzRound:AddBoxType("Call of Duty: WW2", "", {}) 
nzRound:AddBoxType("Chaos", "", {}) 
nzRound:AddBoxType("DOOM", "", {}) 
nzRound:AddBoxType("Resident Evil", "", {}) 
nzRound:AddBoxType("Shadows of Evil", "", {}) 

nzRound.HudSelectData = nzRound.HudSelectData or {}
function nzRound:AddHUDType(id, class)
	if SERVER then
		if class then
			local data = {}
			-- Which entity to spawn
			data.class = class
			nzRound.HudSelectData[id] = data
		else
			nzRound.HudSelectData[id] = nil -- Remove it if no valid class was added
		end
	else
		-- Clients only need it for the dropdown, no need to actually know the data and such
		nzRound.HudSelectData[id] = class
	end
end

nzRound:AddHUDType("Black Ops 3", "nz_zombie_walker", {
}) 
nzRound:AddHUDType("Infinite Warfare", "nz_zombie_walker", {
}) 
nzRound:AddHUDType("Cold War", "nz_zombie_walker", {
}) 
nzRound:AddHUDType("Division 9", "nz_zombie_walker", {
}) 
nzRound:AddHUDType("Mob of the Dead", "nz_zombie_walker", {
}) 
nzRound:AddHUDType("Fade", "nz_zombie_walker", {
}) 
nzRound:AddHUDType("Shadows of Evil", "nz_zombie_walker", {
}) 
nzRound:AddHUDType("Black Ops 1", "nz_zombie_walker", {
}) 
nzRound:AddHUDType("Buried", "nz_zombie_walker", {
}) 
nzRound:AddHUDType("Origins (Black Ops 2)", "nz_zombie_walker", {
}) 
nzRound:AddHUDType("Tranzit (Black Ops 2)", "nz_zombie_walker", {
}) 
nzRound:AddHUDType("nZombies Classic(HD)", "nz_zombie_walker", {
}) 
nzRound:AddHUDType("Covenant", "nz_zombie_walker", {
}) 
nzRound:AddHUDType("UNSC", "nz_zombie_walker", {
}) 
nzRound:AddHUDType("Dead Space", "nz_zombie_walker", {
}) 
nzRound:AddHUDType("Devil May Cry - Dante", "nz_zombie_walker", {
}) 
nzRound:AddHUDType("Devil May Cry - Nero", "nz_zombie_walker", {
}) 
nzRound:AddHUDType("Devil May Cry - V", "nz_zombie_walker", {
}) 
nzRound:AddHUDType("Devil May Cry - Vergil", "nz_zombie_walker", {
}) 
nzRound:AddHUDType("Gears of War", "nz_zombie_walker", {
}) 
nzRound:AddHUDType("Killing Floor 2", "nz_zombie_walker", {
}) 
nzRound:AddHUDType("Resident Evil", "nz_zombie_walker", {
}) 
nzRound:AddHUDType("Simple (Black)", "nz_zombie_walker", {
}) 
nzRound:AddHUDType("Simple (Outline)", "nz_zombie_walker", {
}) 
nzRound:AddHUDType("Breen Desk", "nz_zombie_walker", {
}) 
nzRound:AddHUDType("Castle", "nz_zombie_walker", {
}) 
nzRound:AddHUDType("Sus", "nz_zombie_walker", {
}) 

function nzRound:GetHUDType(id)
	if id == "Black Ops 3" then
	return "b03_hud.png"
	end
	if id == "Cold War" then
	return "cw_hud.png"
	end
	if id == "Sus" then
	return "kawaii_hud.png"
	end
	if id == "Breen Desk" then
	return "BREEN.png"
	end
	if id == "Castle" then
	return "bloxo_big.png"
	end
	if id == "Infinite Warfare" then
	return "iw_hud.png"
	end
	if id == "Division 9" then
	return "D9.png"
	end
	if id == "Mob of the Dead" then
	return "motd.png"
	end
	if id == "Shadows of Evil" then
	return "SOE_HUD_NEW.png"
	end
	if id == "Fade" then
	return "fade.png"
	end
	if id == "Black Ops 1" then
	return "bo1.png"
	end
		if id == "Buried" then
	return "buried_hud.png"
	end
		if id == "Origins (Black Ops 2)" then
	return "origins_hud.png"
	end
		if id == "Tranzit (Black Ops 2)" then
	return "tranzit_hud.png" 
	end
		if id == "nZombies Classic(HD)" then
	return "HD_hud.png"
	end
	if id == "Covenant" then
	return "covenant_hud.png"
	end
	if id == "UNSC" then
	return "Halo_hud.png"
	end
	if id == "Dead Space" then
	return "deadspace_hud.png"
	end
	if id == "Devil May Cry - Dante" then
	return "DMC_Dante__hud.png"
	end
	if id == "Devil May Cry - Nero" then
	return "DMC_Nero__hud.png"
	end
	if id == "Devil May Cry - V" then
	return "DMC_V__hud.png"
	end
	if id == "Devil May Cry - Vergil" then
	return "DMC_Vergil__hud.png"
	end
	if id == "Gears of War" then
	return "gears_hud.png"
	end
	if id == "Killing Floor 2" then
	return "KF2__hud.png"
	end
	if id == "Resident Evil" then
	return "RE_hud.png"
	end
	if id == "Simple (Black)" then
	return "simple_hud.png"
	end
	if id == "Simple (Outline)" then
	return "simple_hud2.png"
	end
	if id == nil then
	return "origins_hud.png"
	end
end


nzRound.ZombieSkinData = nzRound.ZombieSkinData or {}
function nzRound:AddZombieType(id, class)
	if SERVER then
		if class then
			local data = {}
			-- Which entity to spawn
			data.class = class
			nzRound.ZombieSkinData[id] = data
		else
			nzRound.ZombieSkinData[id] = nil -- Remove it if no valid class was added
		end
	else
		-- Clients only need it for the dropdown, no need to actually know the data and such
		nzRound.ZombieSkinData[id] = class
	end
end

nzRound:AddZombieType("Kino der Toten (Chronicles)", "nz_zombie_walker", {
}) 
nzRound:AddZombieType("Kino der Toten", "nz_zombie_walker_kino", {
}) 
nzRound:AddZombieType("Ascension", "nz_zombie_walker_ascension_classic", {
}) 
nzRound:AddZombieType("Ascension (Chronicles)", "nz_zombie_walker_ascension", {
}) 
nzRound:AddZombieType("Call of the Dead", "nz_zombie_walker_cotd", {
}) 
nzRound:AddZombieType("FIVE", "nz_zombie_walker_five", {
}) 
nzRound:AddZombieType("Classified", "nz_zombie_walker_classified", {
}) 
nzRound:AddZombieType("Gorod Krovi", "nz_zombie_walker_gorodkrovi", {
}) 
nzRound:AddZombieType("Mob of the Dead", "nz_zombie_walker_motd", {
})
nzRound:AddZombieType("Shadows of Evil", "nz_zombie_walker_soemale", {
}) 
nzRound:AddZombieType("Zetsubou no Shima", "nz_zombie_walker_zetsubou", {
}) 
nzRound:AddZombieType("Origins", "nz_zombie_walker_origins", {
}) 
nzRound:AddZombieType("World War 1 Soldiers", "nz_zombie_walker_origins_soldier", {
}) 
nzRound:AddZombieType("Crusader Zombies", "nz_zombie_walker_origins_templar", {
}) 
nzRound:AddZombieType("Moon", "nz_zombie_walker_moon_classic", {
}) 
nzRound:AddZombieType("Moon (Chronicles)", "nz_zombie_walker_moon", {
}) 
nzRound:AddZombieType("Area 51 Guard", "nz_zombie_walker_moon_guard", {
}) 
nzRound:AddZombieType("Moon Tech", "nz_zombie_walker_moon_tech", {
}) 
nzRound:AddZombieType("Der Eisendrache", "nz_zombie_walker_eisendrache", {
}) 
nzRound:AddZombieType("Buried", "nz_zombie_walker_buried", {
}) 
nzRound:AddZombieType("Shangri-La", "nz_zombie_walker_shangrila", {
}) 
nzRound:AddZombieType("Shi no Numa", "nz_zombie_walker_sumpf", {
}) 
nzRound:AddZombieType("Tranzit", "nz_zombie_walker_greenrun", {
}) 
nzRound:AddZombieType("Nuketown", "nz_zombie_walker_nuketown", {
}) 
nzRound:AddZombieType("Zombies in Spaceland", "nz_zombie_walker_clown", {
}) 
nzRound:AddZombieType("Deathtrooper", "nz_zombie_walker_deathtrooper", {
}) 
nzRound:AddZombieType("Die Maschine", "nz_zombie_walker_diemachine", {
}) 
nzRound:AddZombieType("Tag der Toten", "nz_zombie_walker_orange", {
})
nzRound:AddZombieType("Skeleton", "nz_zombie_walker_skeleton", {
}) 
nzRound:AddZombieType("Xenomorph", "nz_zombie_walker_xeno", {
}) 
nzRound:AddZombieType("Necromorph", "nz_zombie_walker_necromorph", {
}) 


function nzRound:GetZombieType(id)
	if id == "Skeleton" then
	return "nz_zombie_walker_skeleton"
	end
	if id == "Kino der Toten (Chronicles)" then
	return "nz_zombie_walker"
	end
	if id == "Ascension (Chronicles)" then
	return "nz_zombie_walker_ascension"
	end
	if id == "Classified" then
	return "nz_zombie_walker_classified"
	end
		if id == "Moon (Chronicles)" then
	return "nz_zombie_walker_moon"
	end
	if id == "Die Maschine" then
	return "nz_zombie_walker_diemachine"
	end
	if id == "Tag der Toten" then
	return "nz_zombie_walker_orange"
	end
	if id == "Deathtrooper" then
	return "nz_zombie_walker_deathtrooper"
	end
		if id == "Zombies in Spaceland" then
	return "nz_zombie_walker_clown"
	end
		if id == "Tranzit" then
	return "nz_zombie_walker_greenrun" 
	end
		if id == "Mob of the Dead" then
	return "nz_zombie_walker_motd" 
	end
		if id == "Nuketown" then
	return "nz_zombie_walker_nuketown"
	end
	if id == "Ascension" then
	return "nz_zombie_walker_ascension"
	end
	if id == "Call of the Dead" then
	return "nz_zombie_walker_cotd"
	end
	if id == "FIVE" then
	return "nz_zombie_walker_five"
	end
	if id == "Gorod Krovi" then
	return "nz_zombie_walker_gorodkrovi"
	end
	if id == "Shadows of Evil" then
	return "nz_zombie_walker_soemale"
	end
	if id == "Zetsubou no Shima" then
	return "nz_zombie_walker_zetsubou"
	end
	if id == "Xenomorph" then
	return "nz_zombie_walker_xeno"
	end
	if id == "Necromorph" then
	return "nz_zombie_walker_necromorph"
	end
	if id == "Kino der Toten" then
	return "nz_zombie_walker_kino"
	end
	if id == "Origins" then
	return "nz_zombie_walker_origins"
	end
	if id == "World War 1 Soldiers" then
	return "nz_zombie_walker_origins_soldier"
	end
	if id == "Origins" then
	return "nz_zombie_walker_origins"
	end
	if id == "Crusader Zombies" then
	return "nz_zombie_walker_origins_templar"
	end
	if id == "Moon" then
	return "nz_zombie_walker_moon"
	end
	if id == "Moon Tech" then
	return "nz_zombie_walker_moon_guard"
	end
	if id == "Area 51 Guard" then
	return "nz_zombie_walker_moon_guard"
	end
	if id == "Buried" then
	return "nz_zombie_walker_buried"
	end
	if id == "Der Eisendrache" then
	return "nz_zombie_walker_eisendrache"
	end
	if id == "Shangri-La" then
	return "nz_zombie_walker_shangrila"
	end
	if id == "Shi no Numa" then
	return "nz_zombie_walker_sumpf"
	end
	if id == nil then
	return "nz_zombie_walker"
	end
end

nzRound.SpecialData = nzRound.SpecialData or {}
function nzRound:AddSpecialRoundType(id, data, spawnfunc, roundfunc, endfunc)
	if SERVER then
		nzRound.SpecialData[id] = {}
		-- Zombie data, like those in the configuration files
		nzRound.SpecialData[id].data = data
		-- Optional spawn function, runs when a zombie spawns (can be used to set health, speed, etc)
		if spawnfunc then nzRound.SpecialData[id].spawnfunc = spawnfunc end
		-- Optional round function, runs when the round starts (can be used to set amount, sounds, fog, etc)
		if roundfunc then nzRound.SpecialData[id].roundfunc = roundfunc end
		-- Optional end function, runs when the special round ends (can be used to clean up changes)
		if endfunc then nzRound.SpecialData[id].endfunc = endfunc end
	else
		-- Clients only need it for the dropdown, no need to actually know the data and such
		nzRound.SpecialData[id] = (data and true or nil)
	end
end

nzRound:AddSpecialRoundType("Hellhounds", {
	specialTypes = {
		["nz_zombie_special_dog"] = {chance = 100}
	},
	specialDelayMod = function() return math.Clamp(2 - #player.GetAllPlaying()*0.5, 0.5, 2) end, -- Dynamically change spawn speed depending on player count
	specialCountMod = function() return nzRound:GetNumber() * #player.GetAllPlaying() end, -- Modify the count
}, function(dog) -- We want to modify health
	local round = nzRound:GetNumber()
	if round == -1 then
		dog:SetHealth(math.random(120, 1200))
	else
	local hp = 55
	for i=1,nzRound:GetNumber() do 
	hp = hp* 1.13
								end 
		dog:SetHealth(hp)
	end
end) -- No round func or end func

nzRound:AddSpecialRoundType("Helldonkeys", {
	specialTypes = {
		["nz_zombie_special_donkey"] = {chance = 100}
	},
	specialDelayMod = function() return math.Clamp(2 - #player.GetAllPlaying()*0.5, 0.5, 2) end, -- Dynamically change spawn speed depending on player count
	specialCountMod = function() return nzRound:GetNumber() * #player.GetAllPlaying() end, -- Modify the count
}, function(dog) -- We want to modify health
	local round = nzRound:GetNumber()
	if round == -1 then
		dog:SetHealth(math.random(120, 1200))
	else
	local hp = 55
	for i=1,nzRound:GetNumber() do 
	hp = hp* 1.13
								end 
		dog:SetHealth(hp)
	end
end) -- No round func or end func

nzRound:AddSpecialRoundType("Keepers", {
	specialTypes = {
		["nz_zombie_special_keeper"] = {chance = 100}
	},
	specialDelayMod = function() return math.Clamp(2 - #player.GetAllPlaying()*0.5, 0.5, 2) end, -- Dynamically change spawn speed depending on player count
	specialCountMod = function() return nzRound:GetNumber() * #player.GetAllPlaying() end, -- Modify the count
}, function(dog) -- We want to modify health
	local round = nzRound:GetNumber()
	if round == -1 then
		dog:SetHealth(math.random(120, 1200))
	else
	local hp = 50
	for i=1,nzRound:GetNumber() do 
	hp = hp* 1.05
								end 
		dog:SetHealth(hp)
	end
end) -- No round func or end func

nzRound:AddSpecialRoundType("Nova Crawlers", {
	specialTypes = {
		["nz_zombie_special_nova"] = {chance = 100}
	},
	specialDelayMod = function() return math.Clamp(2 - #player.GetAllPlaying()*0.5, 0.5, 2) end, -- Dynamically change spawn speed depending on player count
	specialCountMod = function() return nzRound:GetNumber() * #player.GetAllPlaying() end, -- Modify the count
}, function(dog) -- We want to modify health
	local round = nzRound:GetNumber()
	if round == -1 then
		dog:SetHealth(math.random(120, 1200))
	else
	local hp = 40
	for i=1,nzRound:GetNumber() do 
	hp = hp* 1.1
								end 
		dog:SetHealth(hp)
	end
end) -- No round func or end func

nzRound:AddSpecialRoundType("Nova Bombers", {
	specialTypes = {
		["nz_zombie_special_nova_bomber"] = {chance = 100}
	},
	specialDelayMod = function() return math.Clamp(2 - #player.GetAllPlaying()*0.5, 0.5, 2) end, -- Dynamically change spawn speed depending on player count
	specialCountMod = function() return nzRound:GetNumber() * #player.GetAllPlaying() end, -- Modify the count
}, function(dog) -- We want to modify health
	local round = nzRound:GetNumber()
	if round == -1 then
		dog:SetHealth(math.random(120, 1200))
	else
	local hp = 40
	for i=1,nzRound:GetNumber() do 
	hp = hp* 1.1
								end 
		dog:SetHealth(hp)
	end
end) -- No round func or end func

nzRound:AddSpecialRoundType("Jolting Jacks", {
	specialTypes = {
		["nz_zombie_special_nova_electric"] = {chance = 100}
	},
	specialDelayMod = function() return math.Clamp(2 - #player.GetAllPlaying()*0.5, 0.5, 2) end, -- Dynamically change spawn speed depending on player count
	specialCountMod = function() return nzRound:GetNumber() * #player.GetAllPlaying() end, -- Modify the count
}, function(dog) -- We want to modify health
	local round = nzRound:GetNumber()
	if round == -1 then
		dog:SetHealth(math.random(120, 1200))
	else
	local hp = 40
	for i=1,nzRound:GetNumber() do 
	hp = hp* 1.1
								end 
		dog:SetHealth(hp)
	end
end) -- No round func or end func

nzRound:AddSpecialRoundType("Lickers", {
	specialTypes = {
		["nz_zombie_special_licker"] = {chance = 100}
	},
	specialDelayMod = function() return math.Clamp(2 - #player.GetAllPlaying()*0.5, 0.5, 2) end, -- Dynamically change spawn speed depending on player count
	specialCountMod = function() return nzRound:GetNumber() * #player.GetAllPlaying() end, -- Modify the count
}, function(dog) -- We want to modify health
	local round = nzRound:GetNumber()
	if round == -1 then
		dog:SetHealth(math.random(120, 1200))
	else
	local hp = 54
	for i=1,nzRound:GetNumber() do 
	hp = hp* 1.17
								end 
		dog:SetHealth(hp)
	end
end) -- No round func or end func

nzRound:AddSpecialRoundType("Raptors", {
	specialTypes = {
		["nz_zombie_special_raptor"] = {chance = 100}
	},
	specialDelayMod = function() return math.Clamp(2 - #player.GetAllPlaying()*0.5, 0.5, 2) end, -- Dynamically change spawn speed depending on player count
	specialCountMod = function() return nzRound:GetNumber() * #player.GetAllPlaying() end, -- Modify the count
}, function(dog) -- We want to modify health
	local round = nzRound:GetNumber()
	if round == -1 then
		dog:SetHealth(math.random(120, 1200))
	else
	local hp = 70
	for i=1,nzRound:GetNumber() do 
	hp = hp* 1.05
								end 
		dog:SetHealth(hp)
	end
end) -- No round func or end func

nzRound:AddSpecialRoundType("Facehuggers", {
	specialTypes = {
		["nz_zombie_special_facehugger"] = {chance = 100}
	},
	specialDelayMod = function() return math.Clamp(2 - #player.GetAllPlaying()*0.5, 0.5, 2) end, -- Dynamically change spawn speed depending on player count
	specialCountMod = function() return nzRound:GetNumber() * #player.GetAllPlaying() end, -- Modify the count
}, function(dog) -- We want to modify health
	local round = nzRound:GetNumber()
	if round == -1 then
		dog:SetHealth(50)
	else
	local hp = 32
	for i=1,nzRound:GetNumber() do 
	hp = hp* 1.1
								end 
		dog:SetHealth(hp)
	end
end) -- No round func or end func

nzRound:AddSpecialRoundType("The Pack (Dead Space)", {
	specialTypes = {
		["nz_zombie_special_pack"] = {chance = 100}
	},
	specialDelayMod = function() return math.Clamp(2 - #player.GetAllPlaying()*0.5, 0.5, 2) end, -- Dynamically change spawn speed depending on player count
	specialCountMod = function() return nzRound:GetNumber() * #player.GetAllPlaying() end, -- Modify the count
}, function(dog) -- We want to modify health
	local round = nzRound:GetNumber()
	if round == -1 then
		dog:SetHealth(math.random(120, 1200))
	else
	local hp = 50
	for i=1,nzRound:GetNumber() do 
	hp = hp* 1.1
								end 
		dog:SetHealth(hp)
	end
end) -- No round func or end func

nzRound:AddSpecialRoundType("Spiders", {
	specialTypes = {
		["nz_zombie_special_spooder"] = {chance = 100}
	},
	specialDelayMod = function() return math.Clamp(2 - #player.GetAllPlaying()*0.5, 0.5, 2) end, -- Dynamically change spawn speed depending on player count
	specialCountMod = function() return nzRound:GetNumber() * #player.GetAllPlaying() end, -- Modify the count
}, function(dog) -- We want to modify health
	local round = nzRound:GetNumber()
	if round == -1 then
		dog:SetHealth(math.random(120, 1200))
	else
	local hp = 48
	for i=1,nzRound:GetNumber() do 
	hp = hp* 1.1
								end 
		dog:SetHealth(hp)
	end
end) -- No round func or end func

nzRound:AddSpecialRoundType("Burning Zombies", {
	normalTypes = {
		["nz_zombie_special_burning"] = {chance = 100}
	},
	normalDelay = 0.75,
	normalCountMod = function(original) return original * 0.5 end, -- Half the normal count here
}) -- No special functions or anything really

nzRound:AddSpecialRoundType("Burning Zombies (Ascension)", {
	normalTypes = {
		["nz_zombie_special_burning_ascension"] = {chance = 100}
	},
	normalDelay = 0.75,
	normalCountMod = function(original) return original * 0.5 end, -- Half the normal count here
}) -- No special functions or anything really

nzRound:AddSpecialRoundType("Burning Zombies (Buried)", {
	normalTypes = {
		["nz_zombie_special_burning_buried"] = {chance = 100}
	},
	normalDelay = 0.75,
	normalCountMod = function(original) return original * 0.5 end, -- Half the normal count here
}) -- No special functions or anything really

nzRound:AddSpecialRoundType("Burning Clowns", {
	normalTypes = {
		["nz_zombie_special_burning_clown"] = {chance = 100}
	},
	normalDelay = 0.75,
	normalCountMod = function(original) return original * 0.5 end, -- Half the normal count here
}) -- No special functions or anything really

nzRound:AddSpecialRoundType("Burning Zombies (Call of the Dead)", {
	normalTypes = {
		["nz_zombie_special_burning_cotd"] = {chance = 100}
	},
	normalDelay = 0.75,
	normalCountMod = function(original) return original * 0.5 end, -- Half the normal count here
}) -- No special functions or anything really

nzRound:AddSpecialRoundType("Burning Zombies (Der Eisendrache)", {
	normalTypes = {
		["nz_zombie_special_burning_eisendrache"] = {chance = 100}
	},
	normalDelay = 0.75,
	normalCountMod = function(original) return original * 0.5 end, -- Half the normal count here
}) -- No special functions or anything really

nzRound:AddSpecialRoundType("Burning Zombies (FIVE)", {
	normalTypes = {
		["nz_zombie_special_burning_five"] = {chance = 100}
	},
	normalDelay = 0.75,
	normalCountMod = function(original) return original * 0.5 end, -- Half the normal count here
}) -- No special functions or anything really

nzRound:AddSpecialRoundType("Burning Zombies (Gorod Krovi)", {
	normalTypes = {
		["nz_zombie_special_burning_gorodkrovi"] = {chance = 100}
	},
	normalDelay = 0.75,
	normalCountMod = function(original) return original * 0.5 end, -- Half the normal count here
}) -- No special functions or anything really

nzRound:AddSpecialRoundType("Burning Zombies (TranZit)", {
	normalTypes = {
		["nz_zombie_special_burning_greenrun"] = {chance = 100}
	},
	normalDelay = 0.75,
	normalCountMod = function(original) return original * 0.5 end, -- Half the normal count here
}) -- No special functions or anything really

nzRound:AddSpecialRoundType("Burning Zombies (Hazmat)", {
	normalTypes = {
		["nz_zombie_special_burning_hazmat"] = {chance = 100}
	},
	normalDelay = 0.75,
	normalCountMod = function(original) return original * 0.5 end, -- Half the normal count here
}) -- No special functions or anything really
nzRound:AddSpecialRoundType("Burning Zombies (Moon)", {
	normalTypes = {
		["nz_zombie_special_burning_moon"] = {chance = 100}
	},
	normalDelay = 0.75,
	normalCountMod = function(original) return original * 0.5 end, -- Half the normal count here
}) -- No special functions or anything really
nzRound:AddSpecialRoundType("Burning Zombies (Mob of the Dead)", {
	normalTypes = {
		["nz_zombie_special_burning_motd"] = {chance = 100}
	},
	normalDelay = 0.75,
	normalCountMod = function(original) return original * 0.5 end, -- Half the normal count here
}) -- No special functions or anything really
nzRound:AddSpecialRoundType("Burning Zombies (Nuketown)", {
	normalTypes = {
		["nz_zombie_special_burning_nuketown"] = {chance = 100}
	},
	normalDelay = 0.75,
	normalCountMod = function(original) return original * 0.5 end, -- Half the normal count here
}) -- No special functions or anything really
nzRound:AddSpecialRoundType("Burning Zombies (Origins)", {
	normalTypes = {
		["nz_zombie_special_burning_origins"] = {chance = 100}
	},
	normalDelay = 0.75,
	normalCountMod = function(original) return original * 0.5 end, -- Half the normal count here
}) -- No special functions or anything really

nzRound:AddSpecialRoundType("Burning Zombies (Shangri-La)", {
	normalTypes = {
		["nz_zombie_special_burning_shangrila"] = {chance = 100}
	},
	normalDelay = 0.75,
	normalCountMod = function(original) return original * 0.5 end, -- Half the normal count here
}) -- No special functions or anything really

nzRound:AddSpecialRoundType("Burning Boney Bois", {
	normalTypes = {
		["nz_zombie_special_burning_skeleton"] = {chance = 100}
	},
	normalDelay = 0.75,
	normalCountMod = function(original) return original * 0.5 end, -- Half the normal count here
}) -- No special functions or anything really

nzRound:AddSpecialRoundType("Burning Zombies (Shadows of Evil)", {
	normalTypes = {
		["nz_zombie_special_burning_soe"] = {chance = 100}
	},
	normalDelay = 0.75,
	normalCountMod = function(original) return original * 0.5 end, -- Half the normal count here
}) -- No special functions or anything really
nzRound:AddSpecialRoundType("Burning Zombies (Shi no Numa)", {
	normalTypes = {
		["nz_zombie_special_burning_sumpf"] = {chance = 100}
	},
	normalDelay = 0.75,
	normalCountMod = function(original) return original * 0.5 end, -- Half the normal count here
}) -- No special functions or anything really
nzRound:AddSpecialRoundType("Burning Zombies (Templar)", {
	normalTypes = {
		["nz_zombie_special_burning_templar"] = {chance = 100}
	},
	normalDelay = 0.75,
	normalCountMod = function(original) return original * 0.5 end, -- Half the normal count here
}) -- No special functions or anything really
nzRound:AddSpecialRoundType("Burning Zombies (Zetsubou no Shima)", {
	normalTypes = {
		["nz_zombie_special_burning_zetsubou"] = {chance = 100}
	},
	normalDelay = 0.75,
	normalCountMod = function(original) return original * 0.5 end, -- Half the normal count here
}) -- No special functions or anything really


nzRound.AdditionalZombieData = nzRound.AdditionalZombieData or {}
function nzRound:AddAdditionalZombieType(id, class)
	if SERVER then
		if class then
			local data = {}
			-- Which entity to spawn
			data.class = class
			nzRound.AdditionalZombieData[id] = data
		else
			nzRound.AdditionalZombieData[id] = nil -- Remove it if no valid class was added
		end
	else
		-- Clients only need it for the dropdown, no need to actually know the data and such
		nzRound.AdditionalZombieData[id] = class
	end
end

nzRound:AddAdditionalZombieType("Nazi Zombies", "nz_zombie_walker", {
}) 
nzRound:AddAdditionalZombieType("Ascension Zombies", "nz_zombie_walker_ascension", {
}) 
nzRound:AddAdditionalZombieType("Siberian Zombies", "nz_zombie_walker_cotd", {
}) 
nzRound:AddAdditionalZombieType("Pentagon Zombies", "nz_zombie_walker_five", {
}) 
nzRound:AddAdditionalZombieType("Gorod Krovi Zombies", "nz_zombie_walker_gorodkrovi", {
}) 
nzRound:AddAdditionalZombieType("Mob of the Dead Zombies", "nz_zombie_walker_motd", {
})
nzRound:AddAdditionalZombieType("Shadows of Evil Zombies", "nz_zombie_walker_soemale", {
}) 
nzRound:AddAdditionalZombieType("Zetsubou no Shima Zombies", "nz_zombie_walker_zetsubou", {
}) 
nzRound:AddAdditionalZombieType("Origins Zombies", "nz_zombie_walker_origins", {
}) 
nzRound:AddAdditionalZombieType("World War 1 Soldiers", "nz_zombie_walker_origins_soldier", {
}) 
nzRound:AddAdditionalZombieType("Crusader Zombies", "nz_zombie_walker_origins_templar", {
}) 
nzRound:AddAdditionalZombieType("Moon Zombies", "nz_zombie_walker_moon", {
}) 
nzRound:AddAdditionalZombieType("Moon Tech Zombies", "nz_zombie_walker_moon_tech", {
})
nzRound:AddAdditionalZombieType("Area 51 Guard Zombies", "nz_zombie_walker_moon_guard", {
})
nzRound:AddAdditionalZombieType("Der Eisendrache Zombies", "nz_zombie_walker_eisendrache", {
}) 
nzRound:AddAdditionalZombieType("Western Zombies", "nz_zombie_walker_buried", {
}) 
nzRound:AddAdditionalZombieType("Vietnamese Zombies", "nz_zombie_walker_shangrila", {
}) 
nzRound:AddAdditionalZombieType("Shi no Numa Zombies", "nz_zombie_walker_sumpf", {
}) 
nzRound:AddAdditionalZombieType("Tranzit Zombies", "nz_zombie_walker_greenrun", {
}) 
nzRound:AddAdditionalZombieType("Nuketown Zombies", "nz_zombie_walker_nuketown", {
}) 
nzRound:AddAdditionalZombieType("Clowns", "nz_zombie_walker_clown", {
}) 
nzRound:AddAdditionalZombieType("Deathtroopers", "nz_zombie_walker_deathtrooper", {
}) 
nzRound:AddAdditionalZombieType("Skeletons", "nz_zombie_walker_skeleton", {
}) 
nzRound:AddAdditionalZombieType("Xenomorphs", "nz_zombie_walker_xeno", {
}) 
nzRound:AddAdditionalZombieType("Necromorphs", "nz_zombie_walker_necromorph", {
}) 
nzRound:AddAdditionalZombieType("Burning Zombie", "nz_zombie_special_burning", {
}) 
nzRound:AddAdditionalZombieType("Burning Zombie (Ascension)", "nz_zombie_special_burning_ascension", {
}) 
nzRound:AddAdditionalZombieType("Burning Zombie (Buried)", "nz_zombie_special_burning_buried", {
}) 
nzRound:AddAdditionalZombieType("Burning Clowns", "nz_zombie_special_burning_clown", {
}) 
nzRound:AddAdditionalZombieType("Burning Zombie (Call of the Dead)", "nz_zombie_special_burning_cotd", {
}) 
nzRound:AddAdditionalZombieType("Burning Zombie (Der Eisendrache)", "nz_zombie_special_burning_eisendrache", {
}) 
nzRound:AddAdditionalZombieType("Burning Zombie (FIVE)", "nz_zombie_special_burning_five", {
}) 
nzRound:AddAdditionalZombieType("Burning Zombie (Gorod Krovi)", "nz_zombie_special_burning_gorodkrovi", {
}) 
nzRound:AddAdditionalZombieType("Burning Zombie (TranZit)", "nz_zombie_special_burning_greenrun", {
}) 
nzRound:AddAdditionalZombieType("Burning Zombie (Hazmat)", "nz_zombie_special_burning_hazmat", {
}) 
nzRound:AddAdditionalZombieType("Burning Zombie (Moon)", "nz_zombie_special_burning_moon", {
}) 
nzRound:AddAdditionalZombieType("Burning Zombie (Mob of the Dead)", "nz_zombie_special_burning_motd", {
}) 
nzRound:AddAdditionalZombieType("Burning Zombie (Nuketown)", "nz_zombie_special_burning_nuketown", {
}) 
nzRound:AddAdditionalZombieType("Burning Zombie (Origins)", "nz_zombie_special_burning_origins", {
}) 
nzRound:AddAdditionalZombieType("Burning Zombie (Shangri-La)", "nz_zombie_special_burning_shangrila", {
}) 
nzRound:AddAdditionalZombieType("Burning Boney Bois", "nz_zombie_special_burning_skeleton", {
}) 
nzRound:AddAdditionalZombieType("Burning Zombie (Shadows of Evil)", "nz_zombie_special_burning_soe", {
}) 
nzRound:AddAdditionalZombieType("Burning Zombie (Shi no Numa)", "nz_zombie_special_burning_sumpf", {
}) 
nzRound:AddAdditionalZombieType("Burning Zombie (Templar)", "nz_zombie_special_burning_templar", {
}) 
nzRound:AddAdditionalZombieType("Burning Zombie (Zetsubou no Shima)", "nz_zombie_special_burning_zetsubou", {
}) 
nzRound:AddAdditionalZombieType("Spiders", "nz_zombie_special_spooder", {
}) 
nzRound:AddAdditionalZombieType("The Pack (Dead Space)", "nz_zombie_special_pack", {
}) 
nzRound:AddAdditionalZombieType("Facehuggers", "nz_zombie_special_facehugger", {
}) 
nzRound:AddAdditionalZombieType("Raptors", "nz_zombie_special_raptor", {
}) 
nzRound:AddAdditionalZombieType("Lickers", "nz_zombie_special_licker", {
}) 
nzRound:AddAdditionalZombieType("Nova Crawlers", "nz_zombie_special_nova", {
}) 
nzRound:AddAdditionalZombieType("Nova Bombers", "nz_zombie_special_nova_bomber", {
}) 
nzRound:AddAdditionalZombieType("Jolting Jacks", "nz_zombie_special_nova_electric", {
}) 
nzRound:AddAdditionalZombieType("Keepers", "nz_zombie_special_keeper", {
}) 
nzRound:AddAdditionalZombieType("Hellhounds", "nz_zombie_special_dog", {
}) 
nzRound:AddAdditionalZombieType("Helldonkeys", "nz_zombie_special_donkey", {
}) 
nzRound:AddAdditionalZombieType("Panzer", "nz_zombie_boss_panzer", {
}) 
nzRound:AddAdditionalZombieType("Dilophosaurus", "nz_zombie_boss_dilophosaurus", {
}) 
nzRound:AddAdditionalZombieType("Brute (Dead Space)", "nz_zombie_boss_brute", {
})
nzRound:AddAdditionalZombieType("Brutus", "nz_zombie_boss_brutus", {
}) 
nzRound:AddAdditionalZombieType("Divider (Dead Space)", "nz_zombie_boss_Divider", {
}) 
nzRound:AddAdditionalZombieType("William Birkin", "nz_zombie_boss_G1", {
}) 
nzRound:AddAdditionalZombieType("The Mangler", "nz_zombie_boss_mangler", {
})
nzRound:AddAdditionalZombieType("The Margwa", "nz_zombie_boss_margwa", {
})
nzRound:AddAdditionalZombieType("Napalm Zombie", "nz_zombie_boss_napalm", {
})
nzRound:AddAdditionalZombieType("Shrieker Zombie", "nz_zombie_boss_shrieker", {
})
nzRound:AddAdditionalZombieType("Panzer (Der Eisendrache)", "nz_zombie_boss_panzer_bo3", {
})
nzRound:AddAdditionalZombieType("Fuel Junkie", "nz_zombie_boss_spicy", {
})
nzRound:AddAdditionalZombieType("Nemesis", "nz_zombie_boss_nemesis", {
})
nzRound:AddAdditionalZombieType("Thrasher", "nz_zombie_boss_thrasher", {
})    
nzRound:AddAdditionalZombieType("Avogadro", "nz_zombie_boss_avogadro", {
})  
function nzRound:GetSpecialType(id)
	if id == "Panzer (Der Eisendrache)" then
	return "nz_zombie_boss_panzer_bo3"
	end
	if id == "Fuel Junkie" then
	return "nz_zombie_boss_spicy"
	end
	if id == "Avogadro" then
	return "nz_zombie_boss_avogadro"
	end
	if id == "Burning Zombie" then
	return "nz_zombie_special_burning"
	end
	if id == "Burning Zombie (Ascension)" then
	return "nz_zombie_special_burning_ascension"
	end
	if id == "Burning Zombie (Buried)" then
	return "nz_zombie_special_burning_buried"
	end
	if id == "Burning Clowns" then
	return "nz_zombie_special_burning_clown"
	end
	if id == "Burning Zombie (Call of the Dead)" then
	return "nz_zombie_special_burning_cotd"
	end
	if id == "Burning Zombie (Der Eisendrache)" then
	return "nz_zombie_special_burning_eisendrache"
	end
	if id == "Burning Zombie (FIVE)" then
	return "nz_zombie_special_burning_five"
	end
	if id == "Burning Zombie (Gorod Krovi)" then
	return "nz_zombie_special_burning_gorodkrovi"
	end
	if id == "Burning Zombie (TranZit)" then
	return "nz_zombie_special_burning_greenrun"
	end
	if id == "Burning Zombie (Hazmat)" then
	return "nz_zombie_special_burning_hazmat"
	end
	if id == "Burning Zombie (Moon)" then
	return "nz_zombie_special_burning_moon"
	end
	if id == "Burning Zombie (Mob of the Dead)" then
	return "nz_zombie_special_burning_motd"
	end
	if id == "Burning Zombie (Nuketown)" then
	return "nz_zombie_special_burning_nuketown"
	end
	if id == "Burning Zombie (Origins)" then
	return "nz_zombie_special_burning_origins"
	end
	if id == "Burning Zombie (Shangri-La)" then
	return "nz_zombie_special_burning_shangrila"
	end
	if id == "Burning Boney Bois" then
	return "nz_zombie_special_burning_skeleton"
	end
	if id == "Burning Zombie (Shadows of Evil)" then
	return "nz_zombie_special_burning_soe"
	end
	if id == "Burning Zombie (Shi no Numa)" then
	return "nz_zombie_special_burning_sumpf"
	end
	if id == "Burning Zombie (Templar)" then
	return "nz_zombie_special_burning_templar"
	end
	if id == "Burning Zombie (Zetsubou no Shima)" then
	return "nz_zombie_special_burning_zetsubou"
	end
		if id == "Spiders" then
	return "nz_zombie_special_spooder"
	end
		if id == "The Pack (Dead Space)" then
	return "nz_zombie_special_pack"
	end
		if id == "Facehuggers" then
	return "nz_zombie_special_facehugger" 
	end
		if id == "Raptors" then
	return "nz_zombie_special_raptor" 
	end
		if id == "Lickers" then
	return "nz_zombie_special_licker"
	end
	if id == "Nova Crawlers" then
	return "nz_zombie_special_nova"
	end
	if id == "Nova Bombers" then
	return "nz_zombie_special_nova_bomber"
	end
	if id == "Jolting Jacks" then
	return "nz_zombie_special_nova_electric"
	end
	if id == "Keepers" then
	return "nz_zombie_special_keeper"
	end
	if id == "Hellhounds" then
	return "nz_zombie_special_dog"
	end
	if id == "Helldonkeys" then
	return "nz_zombie_special_donkey"
	end
	if id == "Panzer" then
	return "nz_zombie_boss_panzer"
	end
	if id == "Dilophosaurus" then
	return "nz_zombie_boss_dilophosaurus"
	end
	if id == "Brute (Dead Space)" then
	return "nz_zombie_boss_brute"
	end
	if id == "Brutus" then
	return "nz_zombie_boss_brutus"
	end
	if id == "Divider (Dead Space)" then
	return "nz_zombie_boss_Divider"
	end
	if id == "William Birkin" then
	return "nz_zombie_boss_G1"
	end
	if id == "The Mangler" then
	return "nz_zombie_boss_mangler"
	end
	if id == "The Margwa" then
	return "nz_zombie_boss_margwa"
	end
	if id == "Napalm Zombie" then
	return "nz_zombie_boss_Napalm"
	end
	if id == "Nemesis" then
	return "nz_zombie_boss_Nemesis"
	end
	if id == "George Romero" then
	return "nz_zombie_boss_romero"
	end
	if id == "Shrieker Zombie" then
	return "nz_zombie_boss_shrieker"
	end
	if id == "Thrasher" then
	return "nz_zombie_boss_thrasher"
	end
	if id == "Skeletons" then
	return "nz_zombie_walker_skeleton"
	end
		if id == "Deathtroopers" then
	return "nz_zombie_walker_deathtrooper"
	end
		if id == "Clowns" then
	return "nz_zombie_walker_clown"
	end
		if id == "Tranzit Zombies" then
	return "nz_zombie_walker_greenrun" 
	end
		if id == "Mob of the Dead Zombies" then
	return "nz_zombie_walker_motd" 
	end
		if id == "Nuketown Zombies" then
	return "nz_zombie_walker_nuketown"
	end
	if id == "Ascension Zombies" then
	return "nz_zombie_walker_ascension"
	end
	if id == "Siberian Zombies" then
	return "nz_zombie_walker_cotd"
	end
	if id == "Pentagon Zombies" then
	return "nz_zombie_walker_five"
	end
	if id == "Gorod Krovi Zombies" then
	return "nz_zombie_walker_gorodkrovi"
	end
	if id == "Shadows of Evil Zombies" then
	return "nz_zombie_walker_soemale"
	end
	if id == "Zetsubou no Shima Zombies" then
	return "nz_zombie_walker_zetsubou"
	end
	if id == "Xenomorphs" then
	return "nz_zombie_walker_xeno"
	end
	if id == "Necromorphs" then
	return "nz_zombie_walker_necromorph"
	end
	if id == "Nazi Zombies" then
	return "nz_zombie_walker"
	end
	if id == "Origins Zombies" then
	return "nz_zombie_walker_origins"
	end
	if id == "World War 1 Zombies" then
	return "nz_zombie_walker_origins_soldier"
	end
	if id == "Crusader Zombies" then
	return "nz_zombie_walker_origins_templar"
	end
	if id == "Moon Zombies" then
	return "nz_zombie_walker_moon"
	end
	if id == "Moon Tech Zombies" then
	return "nz_zombie_walker_moon_tech"
	end
	if id == "Area 51 Guard Zombies" then
	return "nz_zombie_walker_moon_guard"
	end
	if id == "Western Zombies" then
	return "nz_zombie_walker_buried"
	end
	if id == "Der Eisendrache Zombies" then
	return "nz_zombie_walker_eisendrache"
	end
	if id == "Vietnamese Zombies" then
	return "nz_zombie_walker_shangrila"
	end
	if id == "Shi no Numa Zombies" then
	return "nz_zombie_walker_sumpf"
	end
	if id == nil then
	return "nz_zombie_special_dog"
	end
end