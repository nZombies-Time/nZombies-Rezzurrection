function nzCamos:NewCamo(id, data)
	nzCamos.Data[id] = data
end

function nzCamos:Get(id)
	return nzCamos.Data[id]
end

function nzCamos:GetCamos(id) //returns camo table
	return nzCamos.Data[id].camotable
end

function nzCamos:GetList()
	local tbl = {}

	for k,v in pairs(nzCamos.Data) do
		tbl[k] = v.name
	end

	return tbl
end

nzCamos:NewCamo("bo3_dlc4", {
	name = "Revelations (BO3)",
	camotable = {
		"camos/bo3/pap/dlc4_01.vmt",
		"camos/bo3/pap/dlc4_02.vmt",
		"camos/bo3/pap/dlc4_03.vmt",
		"camos/bo3/pap/dlc4_04.vmt",
		"camos/bo3/pap/dlc4_05.vmt",
	},
})

nzCamos:NewCamo("bo3_dlc3", {
	name = "Gorod Krovi (BO3)",
	camotable = {
		"camos/bo3/pap/dlc3_01.vmt",
		"camos/bo3/pap/dlc3_02.vmt",
		"camos/bo3/pap/dlc3_03.vmt",
		"camos/bo3/pap/dlc3_04.vmt",
		"camos/bo3/pap/dlc3_05.vmt",
	},
})

nzCamos:NewCamo("bo3_dlc2", {
	name = "Der Eisendrache (BO3)",
	camotable = {
		"camos/bo3/pap/dlc2_01.vmt",
		"camos/bo3/pap/dlc2_02.vmt",
		"camos/bo3/pap/dlc2_03.vmt",
		"camos/bo3/pap/dlc2_04.vmt",
		"camos/bo3/pap/dlc2_05.vmt",
	},
})

nzCamos:NewCamo("bo3_island", {
	name = "Zetsubou No Shima (BO3)",
	camotable = {
		"camos/bo3/pap/island.vmt",
	},
})

nzCamos:NewCamo("bo3_zod", {
	name = "Shadows of Evil (BO3)",
	camotable = {
		"camos/bo3/pap/zod.vmt",
	},
})

nzCamos:NewCamo("bo3_etching", {
	name = "The Giant (BO3)",
	camotable = {
		"camos/bo3/pap/etching.vmt",
	},
})

nzCamos:NewCamo("bo3_bo1hd", {
	name = "Circuit (BO3)",
	camotable = {
		"camos/bo3/pap/bo1hd.vmt",
	},
})

nzCamos:NewCamo("bo3_115hd", {
	name = "Element 115 (BO3)",
	camotable = {
		"camos/bo3/pap/115hd.vmt",
	},
})

nzCamos:NewCamo("bo3_wep115", {
	name = "Weaponized 115 (BO3)",
	camotable = {
		"camos/bo3/pap/weaponized_115.vmt",
	},
})

nzCamos:NewCamo("bo2_victis", {
	name = "Victis (BO2)",
	camotable = {
		"camos/bo2/pap/victis.vmt",
	},
})

nzCamos:NewCamo("waw_etching", {
	name = "Silver Etching (W@W)",
	camotable = {
		"camos/waw/pap/silver_etching.vmt",
	},
})

nzCamos:NewCamo("nz_classic", {
	name = "Classic (NZR)",
	camotable = {
		"models/XQM/LightLinesRed_tool",
	},
})
