
function nzRandomBox:GetBoxUses()
	self.BoxUses = self.BoxUses or 0
	return self.BoxUses
end

function nzRandomBox:IncreaseBoxUses()
	self.BoxUses = self.BoxUses + 1
end

function nzRandomBox:DecreaseBoxUses()
	self.BoxUses = self.BoxUses - 1
end

function nzRandomBox:ResetBoxUses()
	self.BoxUses =  0
end
