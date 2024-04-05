function GM:ContextMenuOpen()
	return nzRound:InState( ROUND_CREATE ) and LocalPlayer():IsAdmin()
end

function GM:PopulateMenuBar(panel)
	panel:Remove()
	return false
end

function GM:OnUndo( name, strCustomString )

	local text = strCustomString

	if ( !text ) then
		local strId = "#Undone_" .. name
		text = language.GetPhrase( strId )
		if ( strId == text ) then
			-- No translation available, generate our own
			text = string.format( language.GetPhrase( "hint.undoneX" ), language.GetPhrase( name ) )
		end
	end

	-- This is a hack for SWEPs, Tools, etc, that already have hardcoded English only translations
	local strMatch = string.match( text, "^Undone (.*)$" )
	if ( strMatch ) then
		text = string.format( language.GetPhrase( "hint.undoneX" ), language.GetPhrase( strMatch ) )
	end

	self:AddNotify( text, NOTIFY_UNDO, 2 )

	surface.PlaySound( "buttons/button15.wav" )

end
