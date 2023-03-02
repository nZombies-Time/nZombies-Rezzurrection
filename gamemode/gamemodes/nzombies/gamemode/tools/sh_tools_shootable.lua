nzTools:CreateTool("shootable", {
	displayname = "Shootable Placer",
	desc = "LMB: Place Shootable, RMB: Remove Shootable",
	condition = function(wep, ply)
		return true
	end,
	PrimaryAttack = function(wep, ply, tr, data)
		nzMapping:SpawnShootable(tr.HitPos + tr.HitNormal, Angle(0,(ply:GetPos() - tr.HitPos):Angle()[2],0), ply, data)
	end,
	SecondaryAttack = function(wep, ply, tr, data)
		if IsValid(tr.Entity) and tr.Entity:GetClass() == "nz_shootable" then
			tr.Entity:Remove()
		end
	end,
	Reload = function(wep, ply, tr, data)
	end,
	OnEquip = function(wep, ply, data)
	end,
	OnHolster = function(wep, ply, data)
	end
}, {
	displayname = "Shootable Placer",
	desc = "LMB: Place Shootable, RMB: Remove Shootable",
	icon = "icon16/gun.png",
	weight = 20,
	condition = function(wep, ply)
		return true
	end,
	interface = function(frame, data)
		local valz = {}
		valz["Row1"] = tobool(data.killall)
		valz["Row2"] = tobool(data.upgrade)
		valz["Row3"] = tobool(data.global)
		valz["Row4"] = tostring(data.door)
		valz["Row5"] = tonumber(data.pointamount)
		valz["Row6"] = tonumber(data.rewardtype)
		valz["Row7"] = tonumber(data.hurttype)
		valz["Row8"] = tostring(data.model)

		local DProperties = vgui.Create( "DProperties", frame )
		DProperties:SetSize( 480, 450 )
		DProperties:SetPos( 10, 10 )

		function DProperties.CompileData()
			data.killall = tobool(valz["Row1"])
			data.upgrade = tobool(valz["Row2"])
			data.global = tobool(valz["Row3"])
			data.door = tostring(valz["Row4"])
			data.pointamount = tonumber(valz["Row5"])
			data.rewardtype = tonumber(valz["Row6"])
			data.hurttype = tonumber(valz["Row7"])
			data.model = tostring(valz["Row8"])

			return data
		end

		function DProperties.UpdateData(data)
			nzTools:UpdateShootables(data)
			nzTools:SendData(data, "shootable")
		end

		local Row1 = DProperties:CreateRow("Options", "Require all targets to be activated")
		Row1:Setup("Boolean")
		Row1:SetValue(valz["Row1"])
		Row1.DataChanged = function( _, val ) valz["Row1"] = val DProperties.UpdateData(DProperties.CompileData()) end
		Row1:SetToolTip("Name.")

		local Row2 = DProperties:CreateRow("Options", "Upgraded weapon only")
		Row2:Setup("Boolean")
		Row2:SetValue(valz["Row2"])
		Row2.DataChanged = function( _, val ) valz["Row2"] = val DProperties.UpdateData(DProperties.CompileData()) end
		Row2:SetToolTip("Require Pack a' Punch to activate.")

		local Row3 = DProperties:CreateRow("Options", "Global")
		Row3:Setup("Boolean")
		Row3:SetValue(valz["Row3"])
		Row3.DataChanged = function( _, val ) valz["Row3"] = val DProperties.UpdateData(DProperties.CompileData()) end
		Row3:SetToolTip("Should all players recieve reward?")

		local Row4 = DProperties:CreateRow("Reward", "Door flag")
		Row4:Setup("Generic")
		Row4:SetValue(valz["Row4"])
		Row4.DataChanged = function( _, val ) valz["Row4"] = val DProperties.UpdateData(DProperties.CompileData()) end
		Row4:SetToolTip("Only applicable if reward is a door.")

		local Row5 = DProperties:CreateRow("Reward", "Point reward amount")
		Row5:Setup("Integer")
		Row5:SetValue(valz["Row5"])
		Row5.DataChanged = function( _, val ) valz["Row5"] = val DProperties.UpdateData(DProperties.CompileData()) end
		Row5:SetToolTip("Only applicable if reward is points.")

		local Row6 = DProperties:CreateRow("Reward", "Reward Type")
		Row6:Setup("Combo")
		Row6:AddChoice("Give points", 1)
		Row6:AddChoice("Give random perk", 2)
		Row6:AddChoice("PAP held weapon", 3)
		Row6:AddChoice("Open door", 4)
		Row6:AddChoice("Activate power", 5)
		Row6.DataChanged = function( _, val ) valz["Row6"] = val DProperties.UpdateData(DProperties.CompileData()) end
		Row6:SetToolTip("Name.")

		local Row7 = DProperties:CreateRow("Options", "Damage Type")
		Row7:Setup("Combo")
		Row7:AddChoice("Melee Damage", 1)
		Row7:AddChoice("Explosive Damage", 2)
		Row7:AddChoice("Fire Damage", 3)
		Row7:AddChoice("Bullet Damage", 4)
		Row7:AddChoice("Shock Damage", 5)
		Row7.DataChanged = function( _, val ) valz["Row7"] = val DProperties.UpdateData(DProperties.CompileData()) end
		Row7:SetToolTip("Damage type required to activate.")

		local Row8 = DProperties:CreateRow("Model", "Model path")
		Row8:Setup("Generic")
		Row8:SetValue(valz["Row8"])
		Row8.DataChanged = function( _, val ) valz["Row8"] = val DProperties.UpdateData(DProperties.CompileData()) end
		Row8:SetToolTip("If no model is provided, defaults to Teddy.")

		return DProperties
	end,

	defaultdata = {
		killall = false,
		upgrade = false,
		global = true,
		door = "",
		pointamount = 1000,
		rewardtype = 2,
		hurttype = 4,
		model = "models/nzr/song_ee/teddybear.mdl",
	},
})

if SERVER then
	nzMapping:AddSaveModule("ShootableSpawns", {
		savefunc = function()
			local shootable_spawns = {}
			for k, v in pairs(ents.FindByClass("nz_shootable")) do
				table.insert(shootable_spawns, {
					pos = v:GetPos(),
					angle = v:GetAngles(),
					tab = {
						model = v:GetModel(),
						hurttype = v:GetHurtType(),
						rewardtype = v:GetRewardType(),
						pointamount = v:GetPointAmount(),
						door = v:GetDoorFlag(),
						killall = v.KillAll,
						upgrade = v:GetUpgrade(),
						global = v:GetGlobal(),
					}
				})
			end

			return shootable_spawns
		end,
		loadfunc = function(data)
			for k, v in pairs(data) do
				nzMapping:SpawnShootable(v.pos, v.angle, nil, v.tab)
			end
		end,
		cleanents = {"nz_shootable"}
	})
end

hook.Add("OnRoundEnd", "NZ.RESPAWN.SHOOTABLES", function()
	if nzRound:InState( ROUND_CREATE ) or nzRound:InState( ROUND_GO ) then
		for k, v in pairs(ents.FindByClass("nz_shootable")) do
			v.Activated = false
			v:SetNoDraw(false)
			v:SetSolid(SOLID_VPHYSICS)
		end
	end
end)

if SERVER then
	util.AddNetworkString( "nzShootsUpdate" )
	
	local function ReceiveData(len, ply)
		local data = net.ReadTable()
		for k, v in pairs(ents.FindByClass("nz_shootable")) do
			v:Update(data)
		end
	end
	net.Receive( "nzShootsUpdate", ReceiveData )
end

if CLIENT then
	function nzTools:UpdateShootables(data)
		PrintTable(data)
		if data then
			net.Start("nzShootsUpdate")
				net.WriteTable(data)
			net.SendToServer()
		end
	end
end