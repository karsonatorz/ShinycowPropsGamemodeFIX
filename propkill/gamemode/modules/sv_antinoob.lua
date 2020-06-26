if not props_antinoobdetectionRadius then print( "SV_ANTINOOB NOT LOADING." ) return end

-- check an even bigger distance for props staying in an area for a long period of time, also increase big props to be blacklisted.


--[[util.AddNetworkString( "plspawns" )
local aids = true
if aids then
	local aidsss= {}
	net.Start( "plspawns" )
		for k,v in pairs( ents.FindByClass( "info_player_start" ) ) do
			aidsss[ #aidsss + 1 ] = v:GetPos()
		end
		net.WriteTable( aidsss )
	net.Broadcast()
end]]

	-- holds table of player spawns
local props_playerSpawns = {}

local function AddPlayerSpawn()
	for k,v in pairs( ents.GetAll() ) do
		
		if v:GetClass() == "info_player_start" then
			props_playerSpawns[ #props_playerSpawns + 1 ] = v
		end
		
	end
	
	if game.GetMap() == "gm_construct" then props_antinoobdetectionRadius = 238^2 end
		-- alternatively, add another player spawn point with LUA .. near the exit ?
	if game.GetMap() == "pk_downtown_reworkv1" then props_antinoobdetectionRadius = 359^2 end
end
hook.Add( "InitPostEntity", "props_AddSpawns", AddPlayerSpawn )
hook.Add( "OnReloaded", "props_AddSpawns", AddPlayerSpawn )

hook.Add( "PlayerInitialSpawn", "props_RegisterWhitelist", function( pl )
		-- don't bitch that I'm using table.HasValue
		-- It's easier to modify the whitelist
	if table.HasValue( props_antinoobwhitelist, pl:SteamID() ) then
			
		pl.propsWhitelisted = true
	
	end
end )

timer.Create( "props_antiNoob", 0.96--[[1.36]], 0, function()
	if not PROPKILL.Config[ "spawnprotection" ].default then return end
	if PROPKILL.Battling then return end
	
	for i=1,#props_playerSpawns do
		
		for k,v in pairs( ents.GetAll() ) do
			if v.beingRemoved or not v.Owner or not v.Owner:IsPlayer() or (v:IsWeapon() and IsValid( v:GetOwner() )) or v.Owner.propsWhitelisted then continue end
			
			--if v:GetPos():Distance( props_playerSpawns[ i ]:GetPos() ) <= props_antinoobdetectionRadius then
			if v:GetPos():DistToSqr( props_playerSpawns[ i ]:GetPos() ) <= props_antinoobdetectionRadius then	
				
				if v.GetPhysicsObject and IsValid( v:GetPhysicsObject() ) then
					local phys = v:GetPhysicsObject()
					
					--print( v:GetClass() )
					
						-- frozen
					if not phys:IsMotionEnabled() then
						v.beingRemoved = true
						v.Owner:Notify( NOTIFY_ERROR, 4, "Frozen objects aren't allowed in this area" )
						v:Remove()
					else
						if not v.Owner.babyGod then
							v.beingRemoved = true
							v.Owner:Notify( NOTIFY_ERROR, 4, "Prop was removed for entering spawn" )
							v:Remove()
						else
							if phys:GetVolume() > 4*10^5 then
								v.beingRemoved = true
								v.Owner:Notify( NOTIFY_ERROR, 4, "Prop was removed due to being huge" )
								v:Remove()
							end
						end
					end
				end
			end
			
			if v:GetPos():DistToSqr( props_playerSpawns[ i ]:GetPos() ) <= ( (props_antinoobdetectionRadius + 1) * 2 ) then
				if v.GetPhysicsObject and IsValid( v:GetPhysicsObject() ) then
					v.RemovalCount = (v.RemovalCount or 0) + 1
					--print( v.RemovalCount )
					if v.RemovalCount >= 3*#props_playerSpawns then
						v.beingRemoved = true
						v.Owner:Notify( NOTIFY_ERROR, 4, "Props are not allowed to stay in the spawn area" )
						v:Remove()
					end
				end
			end
					
		end
		
	end
end )


--[[hook.Add( "Think", "props_babyGod", function()
	for k,v in pairs( player.GetAll() ) do
		if not v:Alive() then continue end
		
		if not v.leftSpawn then
			if not v.spawnPos then continue end
			
			if v.spawnPos:Distance( v:GetPos() ) >= 275 then
				
				v.leftSpawn = true
				if PROPKILL.Config[ "babygod_time" ].default < 1 then
					v.babyGod = false
				else
					timer.Create( "props_babyGod" .. v:UserID(), PROPKILL.Config[ "babygod_time" ].default, 1, function()
						if not IsValid( v ) then return end
						
						v.babyGod = false
					end )
				end
			
			end
		end
	end
end )]]
hook.Add( "PlayerTick", "props_babyGod", function( pl, mv )
	if not pl:Alive() then return end
		
	if not pl.leftSpawn then
		if not pl.spawnPos then return end
			
		if pl.spawnPos:Distance( pl:GetPos() ) >= 275 then
				
			pl.leftSpawn = true
			if PROPKILL.Config[ "babygod_time" ].default < 1 then
				pl.babyGod = false
			else
				timer.CreatePlayer( pl, "props_babyGod", PROPKILL.Config[ "babygod_time" ].default, 1, function()
					pl.babyGod = false
				end )
			end
			
		end
	end
end )

hook.Add( "PlayerSpawn", "props_babyGod", function( pl )
	if not PROPKILL.Config[ "babygod" ].default then
		pl.babyGod = false
		return
	end
	
	pl.babyGod = true
	pl.leftSpawn = false
	pl.spawnPos = pl:GetPos()
end )

hook.Add( "PlayerShouldTakeDamage", "props_babyGod", function( pl, attacker, inflictor )
	if (not IsValid( attacker ) and attacker != Entity( 0 )) or ( not pl:IsPlayer() and pl.IsBot and not pl:IsBot() ) then
		print( "sh_antinoob.lua" )
		return false
	end
	
	if PROPKILL.Battling then return end
	
	if not PROPKILL.Config[ "babygod" ].default then
		return true
	end
	
	if attacker.Owner and attacker.Owner:IsPlayer() then
		
		if attacker.Owner.propsWhitelisted then
			return true
		end
		
		if pl:Team() == attacker.Owner:Team() and pl:Team() != TEAM_DEATHMATCH and pl != attacker.Owner then
			return GetConVarNumber( "mp_friendlyfire" ) > 0
		end
		
		if pl.babyGod then
			return false
		end
		if attacker.Owner.babyGod then
			return false
		end
		
	elseif attacker == Entity(0) then

		--return not pl.babyGod
		local prop_owner = pl:GetNearestProp()
		if IsValid( prop_owner ) and prop_owner.Owner and prop_owner.Owner:IsPlayer() then
			
			prop_owner = prop_owner.Owner
			
			if prop_owner.propsWhitelisted then
				return true
			end
			
			if prop_owner:Team() == pl:Team() and pl:Team() != TEAM_DEATHMATCH then
				return GetConVarNumber( "mp_friendlyfire" ) > 0
			end
			
			if pl.babyGod then
				return false
			end
			
			if prop_owner.babyGod then
				return false
			end
		
		else
		
			return not pl.babyGod
		
		end
	
	end
	
	return true
end )