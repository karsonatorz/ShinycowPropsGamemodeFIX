--[[
				  _________.__    .__                                  
				 /   _____/|  |__ |__| ____ ___.__. ____  ______  _  __
				 \_____  \ |  |  \|  |/    <   |  |/ ___\/  _ \ \/ \/ /
				 /        \|   Y  \  |   |  \___  \  \__(  <_> )     / 
				/_______  /|___|  /__|___|  / ____|\___  >____/ \/\_/  
						\/      \/        \/\/         \/              

		Shared file - Everything concerning blocking of models
]]--

if FPP then 
	error( "Falco's Prop Protection was found!\nNot using sh_blockedmodels.lua" )
end


	-- default list of blocked models.
PROPKILL.BlockedModels =
{
	["models/props_phx/mk-82.mdl" ] = true,
	["models/props_ww2bomb.mdl"] = true,
}

if SERVER then
	util.AddNetworkString( "props_UpdateBlockedModels" )
	util.AddNetworkString( "props_SendBlockedModelsList" )
	
	hook.Add( "Initialize", "props_LoadBlockedModels", function( )
		if not file.Exists( "props/blockedmodels.txt", "DATA" ) then
			return
		end
		
		local data = pon.decode( file.Read( "props/blockedmodels.txt", "DATA" ) )
		
		for k,v in pairs( data ) do
			if not PROPKILL.BlockedModels[ k ] then
				PROPKILL.BlockedModels[ k ] = true
			end
		end
	end )
	
	hook.Add( "PlayerInitialSpawn", "props_UpdateBlockedModels", function( pl )
		net.Start( "props_SendBlockedModelsList" )
			net.WriteUInt( table.Count( PROPKILL.BlockedModels ), 8 )
			for k,v in pairs( PROPKILL.BlockedModels ) do
				net.WriteString( k )
			end
		net.Send( pl )
	end )
	
	function PROPKILL.AddBlockedModel( mdl, b_shouldSave )
		if not PROPKILL.BlockedModels[ string.lower( mdl ) ] then
			PROPKILL.BlockedModels[ string.lower( mdl ) ] = true
			
			net.Start( "props_UpdateBlockedModels" )
				net.WriteString( "add" )
				net.WriteString( string.lower( mdl ) )
			net.Broadcast() 
		end
		
		if b_shouldSave then
			print( "Saving blocked model: " .. mdl )
			
			file.Write( "props/blockedmodels.txt", pon.encode( PROPKILL.BlockedModels ) )
		end
	end
	
	function PROPKILL.RemoveBlockedModel( mdl )
		if not PROPKILL.BlockedModels[ string.lower( mdl ) ] then
			return
		end
		
		PROPKILL.BlockedModels[ string.lower( mdl ) ] = nil
		
		net.Start( "props_UpdateBlockedModels" )
			net.WriteString( "remove" )
			net.WriteString( string.lower( mdl ) )
		net.Broadcast()
		
		file.Write( "props/blockedmodels.txt", pon.encode( PROPKILL.BlockedModels ) )
	end
	
	concommand.Add( "props_blockmodel", function( pl, cmd, arg )
		if not IsValid( pl ) then
			if not arg[ 1 ] then
				print( "\nProps: Can't block model: No model given!" )
				return
			end
			
			PROPKILL.AddBlockedModel( arg[ 1 ], arg[ 2 ] and tobool( arg[ 2 ] ) or false )
			return
		end
		
		if not pl:IsSuperAdmin() then
			pl:Notify( NOTIFY_ERROR, 4, "Access denied" )
			return
		end
		
		if not arg[ 1 ] and not IsValid( pl:GetEyeTrace().Entity ) then
			pl:Notify( NOTIFY_ERROR, 4, "Can't block model: No model given!", true )
			return
		end
		
		local mdl = arg[ 1 ] and arg[ 1 ] or pl:GetEyeTrace().Entity:GetModel()

		for k,v in pairs( player.GetAll() ) do
			v:Notify( NOTIFY_GENERIC, 4, pl:Nick() .. " blocked " .. mdl, true )
		end
		
		PROPKILL.AddBlockedModel( mdl, arg[ 2 ] and tobool( arg[ 2 ] ) or false )
	end )
	
	concommand.Add( "props_unblockmodel", function( pl, cmd, arg )
		if not IsValid( pl ) then
			if not arg[ 1 ] then
				print( "\nProps: Can't unblock model: No model given!" )
				return
			end
			
			PROPKILL.RemoveBlockedModel( arg[ 1 ] )
			return
		end
		
		if not pl:IsSuperAdmin() then
			pl:Notify( NOTIFY_ERROR, 4, "Access denied" )
			return
		end
		
		if not arg[ 1 ] and not IsValid( pl:GetEyeTrace().Entity ) then
			pl:Notify( NOTIFY_ERROR, 4, "Can't block model: No model given!", true )
			return
		end
		
		local mdl = arg[ 1 ] and arg[ 1 ] or pl:GetEyeTrace().Entity:GetModel()
		
		for k,v in pairs( player.GetAll() ) do
			v:Notify( NOTIFY_GENERIC, 4, pl:Nick() .. " unblocked " .. mdl, true )
		end
		
		PROPKILL.RemoveBlockedModel( arg[ 1 ] )
	end )
	
else

	net.Receive( "props_UpdateBlockedModels", function()
		local type = net.ReadString()
		local mdl = net.ReadString()
		
		if type == "add" then
			PROPKILL.BlockedModels[ mdl ] = true
		else
			PROPKILL.BlockedModels[ mdl ] = nil
		end
	end )
	
	net.Receive( "props_SendBlockedModelsList", function()
		local count = net.ReadUInt( 8 )
		for i=1,count do
			PROPKILL.BlockedModels[ net.ReadString() ] = true
		end
	end )
	
	properties.Add( "propsBlockModel",
	{
	MenuLabel = "Block model from spawning.",
	Order = 2003,
	MenuIcon = "icon16/cross.png",
	
	Filter = function( self, ent, pl )
		if not IsValid( ent ) or ent:IsPlayer() or PROPKILL.BlockedModels[ ent:GetModel() ] then
			return false
		end
		
		return pl:IsSuperAdmin()
	end,
	
	Action = function( self, ent )
		if not IsValid( ent ) then return end
		
		RunConsoleCommand( "props_blockmodel", ent:GetModel(), "true" )
	end
	}
	)
	
	properties.Add( "propsUnblockModel",
	{
	MenuLabel = "Unblock model from spawning.",
	Order = 2004,
	MenuIcon = "icon16/tick.png",
	
	Filter = function( self, ent, pl )
		if not IsValid( ent ) or ent:IsPlayer() or not PROPKILL.BlockedModels[ ent:GetModel() ] then
			return false
		end
		
		return pl:IsSuperAdmin()
	end,
	
	Action = function( self, ent )
		if not IsValid( ent ) then return end
		
		RunConsoleCommand( "props_unblockmodel", ent:GetModel() )
	end
	}
	)

end
	
	