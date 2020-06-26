--[[
				  _________.__    .__                                  
				 /   _____/|  |__ |__| ____ ___.__. ____  ______  _  __
				 \_____  \ |  |  \|  |/    <   |  |/ ___\/  _ \ \/ \/ /
				 /        \|   Y  \  |   |  \___  \  \__(  <_> )     / 
				/_______  /|___|  /__|___|  / ____|\___  >____/ \/\_/  
						\/      \/        \/\/         \/              

		Forces player wheelspeed's to be under specified amount
]]--

AddConfigItem( "wheelspeed_amount",
	{
	Name = "Wheelspeed amount",
	default = 300,
	min = 10,
	max = 600,
	type = "integer",
	desc = "Player's wheelspeeds must be under this amount",
	}
)

AddConfigItem( "wheelspeed_enforce",
	{
	Name = "Force wheelspeed",
	default = nil,
	type = "button",
	desc = "Force wheelspeeds of players",
	func = function( pl )
		if not SERVER then return end
		
		local amount = 0
		
		for k,v in pairs( player.GetAll() ) do
		
			if tonumber( v:GetInfo( "physgun_wheelspeed" ) ) >= PROPKILL.Config[ "wheelspeed_amount" ].default then
				amount = amount + 1
				v:SendLua( [[RunConsoleCommand( "physgun_wheelspeed", PROPKILL.Config[ "wheelspeed_amount" ].default )]] )
			end
			
		end
		
		pl:ChatPrint( "Forced wheelspeed to " .. PROPKILL.Config[ "wheelspeed_amount" ].default .. " on " .. amount .. " players." )
	end,
	}
)

	-- yes thats it