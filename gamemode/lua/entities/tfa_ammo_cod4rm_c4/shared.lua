if SERVER then
	AddCSLuaFile()
end

ENT.Type = "anim"
ENT.Base = "tfa_ammo_base"
ENT.PrintName = "C4"
ENT.Category = "TFA Ammunition"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Class = ""
ENT.MyModel = "models/krazy/cod4rm/misc/c4.mdl"
ENT.ImpactSound = "Default.ImpactSoft"
ENT.AmmoCount = 1
ENT.AmmoType = "cod4rm_c4"
ENT.DrawText = false
ENT.TextColor = Color(5, 5, 5, 255)
ENT.TextPosition = Vector(-10, 3.5, 26.0)
ENT.TextAngles = Vector(0, 180, 0)
ENT.ShouldDrawShadow = true
ENT.ImpactSound = "Default.ImpactSoft"
ENT.Damage = 35
ENT.Text = "Infared Guided SAMs"
