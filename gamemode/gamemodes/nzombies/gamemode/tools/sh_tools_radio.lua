nzTools:CreateTool("radio", {
	displayname = "Radio Placer",
	desc = "LMB: Place Radio, RMB: Remove Radio",
	condition = function(wep, ply)
		return true
	end,
	PrimaryAttack = function(wep, ply, tr, data)
		nzMapping:Radio(tr.HitPos + tr.HitNormal, Angle(0,(ply:GetPos() - tr.HitPos):Angle()[2],0)+Angle(0,-90,0), data.sound, ply)
	end,
	SecondaryAttack = function(wep, ply, tr, data)
		if IsValid(tr.Entity) and tr.Entity:GetClass() == "nz_radio" then
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
	displayname = "Radio Placer",
	desc = "LMB: Place Radio, RMB: Remove Radio",
	icon = "icon16/drive.png",
	weight = 20,
	condition = function(wep, ply)
		return true
	end,
	interface = function(frame, data)
		local valz = {}
		valz["Row1"] = tostring(data.sound)

		local DProperties = vgui.Create( "DProperties", frame )
		DProperties:SetSize( 480, 450 )
		DProperties:SetPos( 10, 10 )

		function DProperties.CompileData()
			data.sound = tostring(valz["Row1"])

			return data
		end

		function DProperties.UpdateData(data)
			nzTools:SendData(data, "radio")
		end

		local Row1 = DProperties:CreateRow("Sound", "Sound path")
		Row1:Setup("Generic")
		Row1:SetValue(valz["Row1"])
		Row1.DataChanged = function( _, val ) valz["Row1"] = val DProperties.UpdateData(DProperties.CompileData()) end
		Row1:SetToolTip("Path to the desired sound file. Be sure to properly setup the file for use with 44100 sample rate.")

		return DProperties
	end,

	defaultdata = {
		sound = "sound/arccw.wav"
	},
})

if SERVER then
	nzMapping:AddSaveModule("RadioSpawns", {
		savefunc = function()
			local radio_spawns = {}
			for k, v in pairs(ents.FindByClass("nz_radio")) do
				table.insert(radio_spawns, {
					pos = v:GetPos(),
					angle = v:GetAngles(),
					sound = v:GetRadio()
				})
			end

			return radio_spawns
		end,
		loadfunc = function(data)
			for k, v in pairs(data) do
				nzMapping:Radio(v.pos, v.angle , v.sound)
			end
		end,
		cleanents = {"nz_radio"}
	})
end