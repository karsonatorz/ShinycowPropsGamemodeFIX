hook.Add( "props_GetBattleTimeExtension", "givethemaminute", function( pl, invitee, kills, oldtime )
	local extend = false
	
	for k,v in pairs( player.GetAll() ) do
		if v:IsAdmin() or (v.query and v:query( "ulx kick" ) or v.query and v:query( "ulx ban" )) then
			extend = true
			break
		end
	end
	
	return extend and 60 or nil
end )