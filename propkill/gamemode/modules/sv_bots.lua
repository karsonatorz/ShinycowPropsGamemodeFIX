--[[
				  _________.__    .__                                  
				 /   _____/|  |__ |__| ____ ___.__. ____  ______  _  __
				 \_____  \ |  |  \|  |/    <   |  |/ ___\/  _ \ \/ \/ /
				 /        \|   Y  \  |   |  \___  \  \__(  <_> )     / 
				/_______  /|___|  /__|___|  / ____|\___  >____/ \/\_/  
						\/      \/        \/\/         \/              

		Makes bots follow a certain path and spawn props to simulate a propkilling environment
		
		... really all they do is prop surf around the map to allow players to practice
]]--


-- todo: prediction ??
-- possbile todo: make harder difficulty: instead of prop start from bots eyes, go to where a player would start the prop shoot?
-- add fake latency ?
	
props_BotEnabled = props_BotEnabled or false
hook.Add( "InitPostEntity", "props_BotSurfCheckMap", function()
	--[[if game.GetMap() != "rp_downtown_v2_propkill_v1b" then
		props_BotEnabled = false
		return
	end]]
	file.CreateDir( "props/botpaths" )

	if file.Exists( "props/botpaths/" .. string.lower( game.GetMap() ) .. ".txt", "DATA" ) then
		RECORDING = pon.decode( file.Read( "props/botpaths/" .. string.lower( game.GetMap() ) .. ".txt" ) )
	else
		props_BotEnabled = false
	end
end )

--[[hook.Add( "PlayerSpawn", "props_BotSpawns", function( pl )
	if not props_BotEnabled or not pl:IsBot() then return end
	
		-- this is temporary, im just testing out shit
	timer.Create( "props_SetBotSpeed" .. pl:UserID(), 0.15, 1, function()
		if not IsValid( pl ) then return end
		
		pl:SetWalkSpeed( 2 )
		pl:SetRunSpeed( 2 )
	end )
end )]]

concommand.Add( "props_botpaths_save", function( pl )
	if not pl:IsSuperAdmin() then return end

	file.Write( "props/botpaths/" .. string.lower( game.GetMap() ) .. ".txt", pon.encode( RECORDING ) )
	pl:Notify( NOTIFY_GENERIC, 8, "Saved bot paths.", true )
end )

--[[hook.Add( "StartCommand", "props_BotTest", function( pl, cmd )
	if not props_BotEnabled or not pl:IsBot() then return end
	
	cmd:SetButtons( bit.bor( cmd:GetButtons(), IN_ATTACK ) )
end )]]

	-- RECORDING
	--		1 (first bot):
	--				first:
	--					replaypos
	--					startpos
	--					starteyes
	--					data:
	--						1:
	--							velocity
	--							eyes
	--							pos
	--						2:
	--							velocity
	--							eyes
	--							pos
	--				second:
	--					replaypos
	--					startpos
	--					starteyes
	--					data:
	--						1:
	--							velocity
	--							eyes
	--							pos
	--		2 (second bot):


RECORDING = RECORDING or {}
local bottargets = {}

concommand.Add( "props_record_reset", function( pl, cmd, arg ) 
	if not IsValid( pl ) then return end
	if not arg[1] or not arg[1] == "yes" then
		pl:ChatPrint( "This will reset ALL bot paths. Use argument 'yes' to continue.")
		return
	end

	RECORDING = {}
end )
concommand.Add( "props_record_start", function( pl, cmd, arg )
	if not IsValid( pl ) then return end
	if #player.GetBots() > 0 then 
		pl:ChatPrint( "You can't record a path while a bot is online!" )
		return
	end
	if not arg[1] then 
		pl:ChatPrint( "Supply a bot path\nCheck console for details")
		pl:PrintMessage( HUD_PRINTCONSOLE, "\nBot path examples:\nprops_record_start first\nprops_record_start second" )
		return
	end

	local botpath = arg[ 1 ]

	RECORDING[ botpath ] = RECORDING[ botpath ] or {}
	RECORDING[ botpath ][ "replayingpos" ] = 0
	RECORDING[ botpath ][ "startpos" ] = pl:GetPos()
	RECORDING[ botpath ][ "starteyes" ] = pl:EyeAngles()
	RECORDING[ botpath ][ "data" ] = {}
	
	--pl.RecordMovement = { botnum = botnum, place = arg[ 2 ] }
	pl.RecordMovement = arg[ 1 ]
	
	pl:ChatPrint( "started" )
end )
concommand.Add( "props_record_stop", function( pl )
	pl.RecordMovement = nil
	pl:ChatPrint( "stopped" )
end )

--[[concommand.Add( "props_replay_start", function( pl, cmd, arg )
	if not pl:IsSuperAdmin() then return end

	if not arg[1] or not arg[2] then 
		pl:ChatPrint( "Supply a bot # and a path\nCheck console for details")
		pl:PrintMessage( HUD_PRINTCONSOLE, "\nBot # and path examples:\nprops_replay_start 1 first\nprops_replay_start 1 second\nprops_replay_start 2 first\n" )
		return
	end

	pl.ReplayMarked = tonumber( arg[ 1 ] )
	pl.ReplayMovement = arg[ 2 ]
end )
concommand.Add( "props_replay_stop", function( pl )
	pl.ReplayMarked = nil
	pl.ReplayMovement = nil
	--REPLAYING_POS = 0
	pl.ReplayTrigger = false
end)]]

REPLAYING_POS = 0

hook.Add( "PlayerSpawn", "props_ReplayPlayerMovement", function( pl )
	--if pl:IsBot() and pl.ReplayMarked then
	if pl:IsBot() and PROPKILL.Config[ "bots_enable" ] and PROPKILL.Config[ "bots_enable" ].default then
	
		local values, key = table.Random( RECORDING )
		if not key then return end
		pl.ReplayMovement = key
		pl.ReplayTable = table.Copy( RECORDING[ pl.ReplayMovement ] )

		print( pl.ReplayMovement, pl:Nick() )
		if not pl.ReplayTable[ "startpos" ] then return end
		pl:SetPos( pl.ReplayTable[ "startpos" ] )
		pl:SetEyeAngles( pl.ReplayTable[ "starteyes" ] )
		timer.Create( "props_ReplayPlayerMovement", 0.1, 1, function()
			if not IsValid( pl ) then return end

			pl.ReplayTrigger = true
		end )
	end
end )

hook.Add( "DoPlayerDeath", "props_ReplayPlayerMovement", function( pl )
	if pl:IsBot() and pl.ReplayMovement then
		if not RECORDING[ pl.ReplayMovement ] then return end
		
		pl.ReplayTable[ "replayingpos" ] = 0
		pl.ReplayMovement = nil
		pl.ReplayTable = {}
	end
end )

hook.Add( "PlayerSpawn", "fdsf", function( pl )
	--[[ent:AddCallback( "PhysicsCollide", function( ent, data )
		Entity(1):ChatPrint( tostring( data.HitEntity ) )
	end )]]
	
	if not pl.HasCallback and pl:IsBot() then
		pl:AddCallback( "PhysicsCollide", function( ent, data )
			--Entity(1):ChatPrint( "testestssss`" )
			--print( "\n\n" )
			if not pl.ReplayMovement then return end
			if not RECORDING[ pl.ReplayMovement ] then return end
			if not pl.ReplayTable then print( "no replay table, l-191" ) return end
			--print( "(DEBUG) got hit " .. pl:Nick() )
			if pl:HasGodMode() then return end
			pl.ReplayTable[ "replayingpos" ] = 0
			pl.ReplayMovement = nil
			
			timer.CreatePlayer( pl, "respawnbot", 1.5, 1, function()
				if not pl.ReplayMovement and PROPKILL.Config[ "bots_enable" ].default then
					pl:Kill()
				end
			end )
						
			if data.HitEntity:GetClass() == "prop_physics" and data.TheirOldVelocity:Length() >= 1500 and not data.HitEntity:IsPlayerHolding() then
				pl:TakeDamage( pl:Health(), data.HitEntity, data.HitEntity )
			end
		end )
		
		pl.HasCallback = true 
	end
	
	if pl:IsBot() and PROPKILL.Battling and not pl:IsBattleInviter() and not pl:IsBattleInvitee() then
		pl:Kick( "" )
	end
end )

hook.Add( "PlayerTick", "props_RecordPlayerMovement", function( pl, mv)
	if pl.RecordMovement then
		
		local movement_botplace = pl.RecordMovement

		local buttons = mv:GetButtons()
		local jumping = bit.band( buttons, IN_JUMP ) == IN_JUMP
		local ducking = bit.band( buttons, IN_DUCK ) == IN_DUCK

		RECORDING[ movement_botplace ][ "data" ][ #RECORDING[ movement_botplace ][ "data" ] + 1 ] = { origin = mv:GetOrigin(), eyes = pl:EyeAngles(), jumping = jumping, crouching = ducking}

	end

	if pl:IsBot() and pl.ReplayMovement then
		if not pl:Alive() then pl:Spawn() end
		if not pl.ReplayTrigger then return end
		if not RECORDING[ pl.ReplayMovement ] then return end

		local replaying_pos = pl.ReplayTable[ "replayingpos" ] 

		if not (pl.ReplayTable[ "data" ][ replaying_pos + 1 ]) then
			pl:ChatPrint( "finished" )
			pl:Spawn()
			pl.ReplayTrigger = false
			pl.ReplayTable[ "replayingpos" ] = 0
		end

		pl.ReplayTable[ "replayingpos" ] = pl.ReplayTable[ "replayingpos" ]  + 1

		local replaymovement = pl.ReplayTable
		local jumping, ducking = replaymovement[ "data" ][ replaymovement[ "replayingpos" ] ].jumping, replaymovement[ "data" ][ replaymovement[ "replayingpos" ] ].crouching
		if jumping and ducking then
			mv:SetButtons( IN_JUMP + IN_DUCK )
		elseif jumping then
			mv:SetButtons( IN_JUMP )
		elseif ducking then
			mv:SetButtons( IN_DUCK )
		end
			
		local replaymovement = pl.ReplayTable

		local trace = 
		{
			start = pl:EyePos(),--mv:GetOrigin(),
			endpos = replaymovement[ "data" ][ replaymovement[ "replayingpos" ] ].origin,
			filter = function( ent ) if ent:GetClass() == "prop_physics" then return true end end,
			--filter = pl,
			mask = MASK_PLAYERSOLID,
			ignoreworld = true,
		}
			
		local tr = util.TraceLine( trace )
		
		if tr.Hit and tr.Entity.Owner and tr.Entity.Owner != pl and not pl:HasGodMode() then
			--print( "HIT SOMETHING \n" )
			--PrintTable( tr )
			
			pl.ReplayTable[ "replayingpos" ] = 0
			pl.ReplayMovement = nil
			return
		end
		mv:SetOrigin( replaymovement[ "data" ][ replaymovement[ "replayingpos" ] ].origin )
			-- neccesary for when the bot FLINGS PROPS AT YOU SON
		mv:SetMoveAngles( replaymovement[ "data" ][ replaymovement[ "replayingpos" ] ].eyes )
		if not pl.LookingAtPlayer then
			pl:SetEyeAngles( replaymovement[ "data" ][ replaymovement[ "replayingpos" ] ].eyes )
		end
			
		if pl.TargetAssigned and IsValid( pl.TargetAssigned ) then
			local dir = ( pl:GetPos() - pl.TargetAssigned:GetPos() ):GetNormal(); -- replace with eyepos if you want
				 -- -1 is directly opposite, 1 is self:GetForward(), 0 is orthogonal
			local canSee = dir:Dot( pl.TargetAssigned:GetForward() ) < 0.5	-- from behind(-ish)

			if canSee and pl:Visible( pl.TargetAssigned ) then
				--pl.TargetAssigned:ChatPrint( "HE CAN SEE U " .. CurTime() )
				pl.LookatPlayerTime = pl.LookatPlayerTime or CurTime()
				if math.random( 1, 9 ) == 5 and not pl.LookingAtPlayer and pl.LookatPlayerTime < CurTime() then
					pl.LookingAtPlayer = true
					pl:Cleanup()
						
					pl:SetEyeAngles( ( (pl.TargetAssigned:GetPos() + Vector( 0, 0, 64 )) - pl:EyePos() ):GetNormalized():Angle() )
					local ent = ents.Create( "prop_physics" )
					ent:SetModel( "models/props/de_tides/gate_large.mdl" )
					ent:SetPos( pl:EyePos() + ( pl:GetAimVector() * 120 ) )
					local ang = pl:EyeAngles()
					ang.y = ang.y + 180
					ang.p = 0
					ent:SetAngles( ang )
					ent:Spawn()
					ent:GetPhysicsObject():SetVelocity( pl:GetAimVector() * (1300 * pl:GetPos():Distance( pl.TargetAssigned:GetPos() ) ) )
						
					ent.Owner = pl
					pl.Entities = pl.Entities or {}
					pl.Entities[ #pl.Entities + 1 ] = ent
					cleanup.Add( pl, "props", ent )

					undo.Create( "prop_thrown" )
						undo.AddEntity( ent )
						undo.SetPlayer( pl )
					undo.Finish()
						
					pl.LookingAtPlayer = false
					pl.LookatPlayerTime = CurTime() + math.Clamp( 0.9 + (pl:GetPos():Distance( pl.TargetAssigned:GetPos() ) / 1300), 0.8, 2.53 )
					timer.Create( "removepropthrownbybot" .. tostring(ent), pl.LookatPlayerTime - CurTime(), 1, function()
						if not IsValid( ent ) then return end
						
						ent:Remove()
					end )
					--pl.TargetAssigned:ChatPrint( pl.LookatPlayerTime - CurTime() )
				end
						
			end
		end

	end
end )


local _R = debug.getregistry()
function _R.Player:GetNearestPlayer( tbl_ignore, bots )
	local pFound = NULL
	local mindist = math.huge
	
	local targets = bots and player.GetBots() or player.GetHumans()
	
	for k,v in next, targets do
		if tbl_ignore[ v ] then continue end

		local dist = (self:GetPos() - v:GetPos()):LengthSqr()
		if dist < mindist then
			mindist = dist
			pFound = v
		end
	end
	
	--if pFound == NULL then
		--print( "WAT " )
	--end
	
	return pFound
end

timer.Create( "props_BOTFINDNEXTTARGET", 1, 0, function()
	if #player.GetBots() == 0 or #player.GetHumans() == 0 then return end
	if not PROPKILL.Config[ "bots_kill" ].default then return end
	
	--local pl = player.GetBots()[ 1 ]
	
	local killbots = PROPKILL.Config[ "bots_killbots" ].default
	
	for k,pl in pairs( player.GetBots() ) do
		pl.TargetAssigned = NULL
	
		local ignore = {}
		local options = killbots and #player.GetBots() or #player.GetHumans()
	
		local function getNearest()
			if table.Count( ignore ) == ( killbots and #player.GetBots() or #player.GetHumans() ) then
				return NULL
			end
			
			--print( "\n\n" )
			--PrintTable( ignore )
			
			
			if options > 0 then
				local nearest = pl:GetNearestPlayer( ignore, killbots )
				local notfound = false
				if not IsValid( nearest ) then
					ignore[ nearest ] = true
					options = options - 1
					notfound = true
				elseif not nearest:Alive() or nearest:Team() == TEAM_SPECTATOR or not nearest:Visible( pl ) then
					ignore[ nearest ] = true
					options = options - 1 
					notfound = true
				elseif killbots and nearest:GetPos():Distance( pl:GetPos() ) < 3 then
					ignore[ nearest ] = true
					options = options - 1
					notfound = true
				end
				--print("test")
				
				if notfound then
					getNearest()
				end
			else
				return NULL
			end
			
			return pl:GetNearestPlayer( ignore, killbots )
		end
		
		local nearest = getNearest()
		if not IsValid( nearest ) then return end

		--nearest:ChatPrint( " I FOUND U ")
		--print( "nearest ?? " , tostring( nearest ) )
		pl.TargetAssigned = nearest
	end
end )
		
	

concommand.Add( "testpropthrow", function( pl )
local dir = ( pl:GetPos() - Entity(2):GetPos() ):GetNormal(); -- replace with eyepos if you want

	pl:SetEyeAngles( ( (Entity(2):GetPos() + Vector( 0, 0, 64 )) - pl:EyePos() ):GetNormalized():Angle() )
					local ent = ents.Create( "prop_physics" )
					ent:SetModel( "models/props/de_tides/gate_large.mdl" )
					ent:SetPos( pl:EyePos() + ( pl:GetAimVector() * 100 ) )
					local ang = pl:EyeAngles()
					ang.y = ang.y + 180
					ang.p = 0
					ent:SetAngles( ang )
					ent:Spawn()
					ent:GetPhysicsObject():SetVelocity( pl:GetAimVector() * (1300 * pl:GetPos():Distance( Entity(2):GetPos() ) ) )
					
	ent.Owner = pl
	pl.Entities = pl.Entities or {}
	pl.Entities[ #pl.Entities + 1 ] = ent
	cleanup.Add( pl, "props", ent )

	undo.Create( "thrown_prop" )
		undo.AddEntity( ent )
		undo.SetPlayer( pl )
	undo.Finish()
end )
