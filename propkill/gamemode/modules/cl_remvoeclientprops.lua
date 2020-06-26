--[[
				  _________.__    .__                                  
				 /   _____/|  |__ |__| ____ ___.__. ____  ______  _  __
				 \_____  \ |  |  \|  |/    <   |  |/ ___\/  _ \ \/ \/ /
				 /        \|   Y  \  |   |  \___  \  \__(  <_> )     / 
				/_______  /|___|  /__|___|  / ____|\___  >____/ \/\_/  
						\/      \/        \/\/         \/              

		Clientside code to remove broken props every 5 minutes
		Used for entities like broken monitors
]]--

hook.Add( "Initialize", "startremoval", function()
	timer.Create( "RemoveClientsidePhysProp", 300, 0, function()
		for k,v in pairs( ents.GetAll() ) do
				-- did u know: the class is different on mac and windows!
			if string.find( v:GetClass(), "PhysPropClientside" ) then
				v:Remove()
			end
		end
	end )
end )
