--[[
				  _________.__    .__                                  
				 /   _____/|  |__ |__| ____ ___.__. ____  ______  _  __
				 \_____  \ |  |  \|  |/    <   |  |/ ___\/  _ \ \/ \/ /
				 /        \|   Y  \  |   |  \___  \  \__(  <_> )     / 
				/_______  /|___|  /__|___|  / ____|\___  >____/ \/\_/  
						\/      \/        \/\/         \/              

		Serverside utilities
]]--

--[[

*

* Cleans up entities not wanted in a propkilling environment.

*

--]]
function util.CleanUpMap( b_Props )
	for k,v in next, ents.GetAll() do
	
			-- sounds
		if v:GetClass() == "env_soundscape" or v:GetClass() == "ambient_generic"
		or string.find( tostring( v ) , "scene" )
		or string.find( tostring( v ), "illusion" ) then
			v:Remove()
		end
		
			-- windows
		if v:GetClass() == "func_breakable_surf" then
			v:Remove()
		end
		
			-- props created by map
		if v:GetClass() == "prop_static" then
			v:Remove()
		end
		
	end
	
	if b_Props then
		
		for k,v in next, ents.GetAll() do
			
			if v:GetClass() == "prop_physics" then
				v:Remove()
			end
		
		end
	
	end
end

--[[

*

* Registers all entities that players spawn to them.

*

--]]
	-- 5 million
local autoremove = 5000000
	-- 730k
local autotrigger = 730000

local volumewhitelist = {}
volumewhitelist[ "models/props_combine/breen_tube.mdl" ] = true

--if not oldcleanupAdd then
	oldcleanupAdd = oldcleanupAdd or cleanup.Add
	function cleanup.Add( pl, num, ent )
		if not IsValid(pl) or not IsValid(ent) then return end
		
		if IsValid( ent:GetPhysicsObject() ) and ent.GetModel and ent:GetModel() then
			local physobj = ent:GetPhysicsObject()

			if physobj:GetVolume() >= autoremove and not volumewhitelist[ string.lower( ent:GetModel() ) ] then
				pl:Notify( 1, 4, "Prop removed: It was too large" )
				PROPKILL.HugeProps[ string.lower( ent:GetModel() ) ] = true
				ent:Remove()
				return
			end
		end
		
		--print( pl:Nick() .. " spawned a " .. ent:GetClass() .. " (" .. ent:GetModel() .. ")" )
		ent.Owner = pl
			-- won't let the player kill themselves
		--ent:SetPhysicsAttacker( pl )
		if ent:GetClass() == "prop_physics" then
			pl.Props = (pl.Props or 0) + 1
		end
		pl.Entities = pl.Entities or {}
		local entsNum = 0
		for k,v in next, pl.Entities do
			if v == NULL then
				entsNum = k
				break
			end
		end
		if entsNum == 0 then
			pl.Entities[ #pl.Entities + 1 ] = ent
		else
			pl.Entities[ entsNum ] = ent
		end
		
		if ent:GetClass() != "prop_physics" then
			PROPKILL.Statistics[ "otherspawns" ] = PROPKILL.Statistics[ "otherspawns" ] or 0
			PROPKILL.Statistics[ "otherspawns" ] = PROPKILL.Statistics[ "otherspawns" ] + 1
		end
				
		oldcleanupAdd( pl, num, ent )
	end
--end

function timer.CreatePlayer( pl, identifier, delay, reps, callback )
	timer.Create( identifier .. "_" .. pl:UserID(), delay, reps, function()
			-- add to global table and remove them on disconnect instead.
		if not IsValid( pl ) then return end--timer.Destroy( identifier .. "_" .. pl:UserID() ) return end
		
		callback()
	end )
	pl.RemoveTimerDC = pl.RemoveTimerDC or {}
	pl.RemoveTimerDC[ identifier .. "_" .. pl:UserID() ] = true
end

gameevent.Listen( "player_disconnect" )
hook.Add( "player_disconnect", "props_DestroyPlayerTimers", function( data )
	for k,v in pairs( Player( data.userid ).RemoveTimerDC or {} ) do
		timer.Destroy( k )
	end
end )
	