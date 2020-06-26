--[[
				  _________.__    .__                                  
				 /   _____/|  |__ |__| ____ ___.__. ____  ______  _  __
				 \_____  \ |  |  \|  |/    <   |  |/ ___\/  _ \ \/ \/ /
				 /        \|   Y  \  |   |  \___  \  \__(  <_> )     / 
				/_______  /|___|  /__|___|  / ____|\___  >____/ \/\_/  
						\/      \/        \/\/         \/              

		Clientside overrides of gamemode derivatives - base / sandbox
]]--


--[[

*

* Initializing of client

*

--]]
function GM:Initialize()
	for k,v in pairs( properties.List ) do
		if v.Order < 2000 and k != "remove" then
			properties.List[ k ] = nil
		end
	end
	
	MsgC( Color( 255, 127, 127, 255 ), "Welcome to " .. GAMEMODE.Name .. " " .. GAMEMODE.Version .. " - Created by Shinycow\n" )
end

function GM:PhysgunPickup( pl )
	return false
end

function GM:OnCleanup( name )

	--self:AddNotify( "#Cleaned_"..name, NOTIFY_CLEANUP, 5 )
	
	-- Find a better sound :X
	surface.PlaySound( "buttons/button15.wav" )

end

net.Receive( "PlayerKilled", function()
	local victim = net.ReadEntity()
	if not IsValid( victim ) then
		return
	end
	local inflictor = net.ReadString()
	local attacker = net.ReadEntity()
	
	if IsValid( attacker ) then
		GAMEMODE:AddDeathNotice( attacker:Nick(), attacker:Team(), inflictor, victim:Nick(), victim:Team() )
	end
end )

hook.Add( "HUDShouldDraw", "props_StopThatWeaponSelection!", function( name )
	if name == "CHudWeaponSelection" then return false end
end )
