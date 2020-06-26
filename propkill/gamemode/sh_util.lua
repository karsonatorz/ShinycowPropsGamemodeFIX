--[[
				  _________.__    .__                                  
				 /   _____/|  |__ |__| ____ ___.__. ____  ______  _  __
				 \_____  \ |  |  \|  |/    <   |  |/ ___\/  _ \ \/ \/ /
				 /        \|   Y  \  |   |  \___  \  \__(  <_> )     / 
				/_______  /|___|  /__|___|  / ____|\___  >____/ \/\_/  
						\/      \/        \/\/         \/              

		Shared utilities
]]--

function FindPlayer( info )
	for k,v in next, player.GetAll() do
		if string.find( string.lower( v:Nick() ), string.lower( info ) ) then
			return v
		elseif string.find( v:SteamID(), info ) then
			return v
		elseif v:UserID() == tonumber(info) then
			return v
		elseif v:UniqueID() == info then
			return v
		end
	end
	
	return nil
end

function ChatPrint( msg )
	for k,v in next, player.GetAll() do
		v:ChatPrint( msg )
	end
end