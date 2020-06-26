--[[
				  _________.__    .__                                  
				 /   _____/|  |__ |__| ____ ___.__. ____  ______  _  __
				 \_____  \ |  |  \|  |/    <   |  |/ ___\/  _ \ \/ \/ /
				 /        \|   Y  \  |   |  \___  \  \__(  <_> )     / 
				/_______  /|___|  /__|___|  / ____|\___  >____/ \/\_/  
						\/      \/        \/\/         \/              

		Serverside hooks made for this gamemode
]]--

--[[

*

* Configurations

*

--]]

function GM:OnSettingChanged( pl, setting_id, s_from, s_to )
	local canChange
	local configList = {}

	local txt = "%s changed config setting %s to %s"
	if not s_from and not s_to then
		txt = "%s ran config option %s"
	end
	
	for k,v in pairs( player.GetAll() ) do
		if v:IsAdmin() then
			v:ChatPrint( string.format( txt, pl:Nick(), setting_id, s_to or "nothing" ) )
		else
			v:ChatPrint( string.format( txt, "SOMEONE", setting_id, s_to or "nothing" ) )
		end
		
		canChange = hook.Call( "PlayerCanChangeSetting", GAMEMODE, v, setting_id )
		if canChange then
			configList[ #configList + 1 ] = v
		end
	end

	net.Start( "props_UpdateConfig" )
		net.WriteString( setting_id )
		net.WriteString( s_to or "" )
		net.WriteString( PROPKILL.Config[ setting_id ].type )
	net.Send( configList )
end

--[[

*

* Battling

*

--]]
function GM:PlayerCanBattle( pl, target )	
	if PROPKILL.Battling then
		return false, "Someone is already battling!"
	end
	
	if pl == target then
		return false, "You can't battle yourself!"
	end
	
	if pl.BattleBanned or target.BattleBanned then
		return false, "Can't battle this player."
	end
	
	if target.BattleInvites and target.BattleInvites[ pl ] then
		return false, "You have already sent an invitation to this player."
	end
	
	return true, "success"
end

function GM:StartBattle( pl, target, kills, props, funfight, playerdormant, propsdormant )
	for k,v in pairs( player.GetAll() ) do
		v:Notify( 0, 6, pl:Nick() .. " has started a battle with " .. target:Nick() .. " to " .. kills .. " kills", true )
	end
	
	PROPKILL.Battling = true
	PROPKILL.Battlers = { inviter = pl, invitee = target }
	PROPKILL.BattleAmount = kills
	PROPKILL.BattleProps = props
	PROPKILL.BattleFun = funfight
	PROPKILL.BattlePlayerDormant = playerdormant
	PROPKILL.BattlePropsDormant = propsdormant
	
	for k,v in pairs( player.GetAll() ) do
		v.OldKillstreak = v:GetKillstreak()
		v.OldTeam = v:Team()
		v:SetKillstreak( 0 )
		if v != pl and v != target then
			v:SetTeam( TEAM_SPECTATOR )
			v:Spawn()
		end
	end
	
	for k,v in pairs( PROPKILL.Battlers ) do
		v:SetTeam( TEAM_DEATHMATCH )
		v:UnLock()
		v:Spawn()
	end
	
	timer.Simple( 0.1, function()
		if not IsValid( pl ) or not IsValid( target  ) then
			return
		end
		pl:Lock()
		target:Lock()
	end )
	
	
	for k,v in pairs( PROPKILL.Battlers ) do
		v:SetNWInt( "props_BattleProps", 0 )
	end
	
	util.CleanUpMap( true )
	
	oldproplimit = GetConVarNumber( "sbox_maxprops" )
	RunConsoleCommand( "sbox_maxprops", props )
	
	timer.Create( "props_Begincountdown", 0.1, 1, function()
		if not PROPKILL.Battling then return end
		
					
		PROPKILL.ServerBattleTime = PROPKILL.Config[ "battle_time" ].default * 60
		local battleExtension = hook.Call( "props_GetBattleTimeExtension", GAMEMODE, PROPKILL.Battlers[ "inviter" ], PROPKILL.Battlers[ "invitee" ], PROPKILL.BattleAmount, PROPKILL.ServerBattleTime )
		if battleExtension then
			PROPKILL.ServerBattleTime = PROPKILL.ServerBattleTime + battleExtension
			PROPKILL.BattleExtensionTime = battleExtension
		end

		net.Start( "props_BattleInit" )
			for k,v in pairs( PROPKILL.Battlers ) do
				net.WriteEntity( v )
			end
			net.WriteUInt( 1, 2 )
			net.WriteFloat( 0 )
			if battleExtension then
				net.WriteFloat( battleExtension )
			end
		net.Broadcast()
		
		timer.Create( "props_Beginfight", 4.8, 1, function()
			if not PROPKILL.Battling then return end
			
			PrintMessage( HUD_PRINTCENTER, "Begin!" )
			for k,v in pairs( PROPKILL.Battlers ) do
				v:UnLock()
			end
			
			timer.Create( "props_Battlecountdown", 1, PROPKILL.ServerBattleTime, function()
				PROPKILL.ServerBattleTime = PROPKILL.ServerBattleTime - 1
					-- helps prevent malicious activity, bans them from initiating a fight for 7 minutes.
				
					-- potential problem if superadmin changes this setting mid fight..
				if timer.RepsLeft( "props_Battlecountdown" ) / (PROPKILL.Config[ "battle_time" ].default * 60) <= 0.34 then
					if (PROPKILL.Battlers[ "invitee" ]:GetKillstreak() / PROPKILL.BattleAmount) + (PROPKILL.Battlers[ "inviter" ]:GetKillstreak() / PROPKILL.BattleAmount) <= 0.46 then
						PROPKILL.PlayerBattleCooldowns[ PROPKILL.Battlers[ "invitee" ]:SteamID64() ] = CurTime() + (7*60)
						PROPKILL.PlayerBattleCooldowns[ PROPKILL.Battlers[ "inviter" ]:SteamID64() ] = CurTime() + (7*60)
						GAMEMODE:EndBattle( PROPKILL.Battlers[ "inviter" ], PROPKILL.Battlers[ "invitee" ], nil, "Fight took too long." )
					end
				end		
			end )
			
			timer.Create( "props_Autostopfight", PROPKILL.ServerBattleTime, 1, function()
				if not PROPKILL.Battling then return end
				
				GAMEMODE:EndBattle( PROPKILL.Battlers[ "inviter" ], PROPKILL.Battlers[ "invitee" ], nil, "Fight took too long." )
			end )	
		end )
	end )
	
	PROPKILL.Statistics[ "totalfights" ] = ( PROPKILL.Statistics[ "totalfights" ] or 0 ) + 1
end	

function GM:EndBattle( pl, pl2, forfeiter, stopped, winner, score, msg )
	PROPKILL.ServerBattleTime = PROPKILL.ServerBattleTime - (PROPKILL.BattleExtensionTime or 0)

	local triggerSave = true
	if forfeiter then--and IsValid( forfeiter ) then
		forfeiter = isstring( forfeiter ) and forfeiter or forfeiter:Nick()
		
		for k,v in pairs( player.GetAll() ) do
			v:Notify( 0, 6, forfeiter .. " has forfeited the fight." )
		end
		
		if not PROPKILL.BattleFun then
			PROPKILL.RecentBattles[ #PROPKILL.RecentBattles + 1 ] = { time = os.time(), timetook = (PROPKILL.Config[ "battle_time" ].default * 60) - PROPKILL.ServerBattleTime, proplimit = PROPKILL.BattleProps, battleroneprops = pl:GetNWInt( "props_BattleProps", 0 ), battlertwoprops = pl2:GetNWInt( "props_BattleProps", 0 ), Inviter = pl:Nick(), Invitee = pl2:Nick(), forfeit = true, forfeiter = forfeiter, winner = winner, score = "FF" }
			if winner == pl2:Nick() then
				pl2:AddFightsWon( 1 )
				pl:AddFightsLost( 1 )
			elseif winner == pl:Nick() then
				pl:AddFightsWon( 1 )
				pl2:AddFightsLost( 1 )
			end
		end
	elseif stopped then
		for k,v in pairs( player.GetAll() ) do
			v:Notify( 0, 6, msg or "The fight has been stopped." )
		end
		
		if not PROPKILL.BattleFun then
			PROPKILL.RecentBattles[ #PROPKILL.RecentBattles + 1 ] = { time = os.time(), timetook = (PROPKILL.Config[ "battle_time" ].default * 60) - PROPKILL.ServerBattleTime, proplimit = PROPKILL.BattleProps, battleroneprops = pl:GetNWInt( "props_BattleProps", 0 ), battlertwoprops = pl2:GetNWInt( "props_BattleProps", 0 ), Inviter = pl:Nick(), Invitee = pl2:Nick(), stopped = true, winner = "Nobody", score = "N/A" }
		end
	elseif winner then
		for k,v in pairs( player.GetAll() ) do
			v:Notify( 0, 6, msg or "The fight has ended" )
		end
		
		if not PROPKILL.BattleFun then
			PROPKILL.RecentBattles[ #PROPKILL.RecentBattles + 1 ] = { time = os.time(), timetook = (PROPKILL.Config[ "battle_time" ].default * 60) - PROPKILL.ServerBattleTime, proplimit = PROPKILL.BattleProps, battleroneprops = pl:GetNWInt( "props_BattleProps", 0 ), battlertwoprops = pl2:GetNWInt( "props_BattleProps", 0 ), Inviter = pl:Nick(), Invitee = pl2:Nick(), winner = winner, score = score }
			if winner == pl2:Nick() then
				pl2:AddFightsWon( 1 )
				pl:AddFightsLost( 1 )
			elseif winner == pl:Nick() then
				pl:AddFightsWon( 1 )
				pl2:AddFightsLost( 1 )
			end
		end
	else
		for k,v in pairs( player.GetAll() ) do
			v:Notify( 0, 6, msg or "The fight has ended" )
		end
		
		triggerSave = false
	end
	
	PROPKILL.Battling = false
	
	for k,v in pairs( player.GetAll() ) do
		if v.OldTeam then
			v:SetTeam( v.OldTeam )
			v:SetKillstreak( v.OldKillstreak )
		end
		v.OldTeam, v.OldKillstreak = nil, nil
		v:Spawn()
	end
	
	for k,v in pairs( PROPKILL.Battlers ) do
		if IsValid( v ) then
			v:SetNWInt( "PK_BattleProps", 0 )
			v:UnLock()
			v.BattlePauses = 0
		end
	end
	
	RunConsoleCommand( "sbox_maxprops", oldproplimit )
	oldproplimit = nil
	
	net.Start( "props_EndBattle" )
	net.Broadcast()
	
		-- will be invalid ? if a player d/c
		-- oh whale we will solve another day X)
	net.Start( "props_FightResults" )
		net.WriteTable( 
		{
			Userid = PROPKILL.Battlers[ "inviter" ]:UserID(),
			Steamid = PROPKILL.Battlers[ "inviter" ]:SteamID(),
			Name = PROPKILL.Battlers[ "inviter" ]:Name(),
			Wins = PROPKILL.Battlers[ "inviter" ]:GetFightsWon(),
			Losses = PROPKILL.Battlers[ "inviter" ]:GetFightsLost(),
		} )
		net.WriteTable( 
		{
			Userid = PROPKILL.Battlers[ "invitee" ]:UserID(),
			Steamid = PROPKILL.Battlers[ "invitee" ]:SteamID(),
			Name = PROPKILL.Battlers[ "invitee" ]:Name(),
			Wins = PROPKILL.Battlers[ "invitee" ]:GetFightsWon(),
			Losses = PROPKILL.Battlers[ "invitee" ]:GetFightsLost(),
		} )
		net.WriteString( winner or "N/A" )
		net.WriteString( score or "N/A" )
		net.WriteString( (PROPKILL.Config[ "battle_time" ].default * 60) - PROPKILL.ServerBattleTime )
	net.Broadcast()

	PROPKILL.Battlers = {}
	PROPKILL.BattleAmount = 0
	PROPKILL.BattleProps = 0
	PROPKILL.BattlePaused = false
	PROPKILL.BattleFun = false
	PROPKILL.BattlePlayerDormant = false
	PROPKILL.BattlePropsDormant = false
	PROPKILL.BattleExtensionTime = 0
	
	timer.Destroy( "props_BattleResume" )
	timer.Destroy( "props_Battlecountdown" )
	
	if triggerSave then
		file.Write( "props/recentbattles.txt", pon.encode( PROPKILL.RecentBattles ) )
		props_SendRecentBattles()
	end
	

	PROPKILL.BattleCooldown = CurTime() + PROPKILL.Config[ "battle_cooldown" ].default
		-- Player's battle cooldown is set to the battle cooldown plus additional 60 seconds.
		-- This will help prevent malicious behaviour.
	--pl.BattleCooldown = CurTime() + ( PROPKILL.Config[ "battle_cooldown" ].default + 60 )
	PROPKILL.PlayerBattleCooldowns[ pl:SteamID64() ] = CurTime() + ( PROPKILL.Config[ "battle_cooldown" ].default + 60 )
end

function GM:PauseBattle( pl )
		-- implement later, admins will be able to pause the fight
	local fighter = false
	for k,v in pairs( PROPKILL.Battlers ) do
		if v == pl then 
			fighter = true
			break
		end
	end

	timer.Stop( "props_Battlecountdown" )
	timer.Stop( "props_Autostopfight" )
	
	if fighter then
		for k,v in pairs( player.GetAll() ) do
			v:Notify( 0, 4, pl:Nick() .. " has paused the fight for " .. PROPKILL.Config[ "battle_pausetime" ].default .. " seconds" )
		end
		
		timer.Create( "props_BattleResume", PROPKILL.Config[ "battle_pausetime" ].default, 1, function()
			if not PROPKILL.Battling then return end
			
			timer.Start( "props_Battlecountdown" )
			timer.Start( "props_Autostopfight" )
			
			PROPKILL.BattlePaused = false
			game.ConsoleCommand( "sbox_maxprops " .. PROPKILL.BattleProps .. "\n" )
			
			net.Start( "props_StopResumeBattle" )
				net.WriteUInt( 1, 2 )
			net.Broadcast()
			
			for k,v in pairs( player.GetAll() ) do
				v:Notify( 0, 4, "The fight has been resumed!" )
			end
		end )
	else
		for k,v in pairs( player.GetAll() ) do
			v:Notify( 0, 4, pl:Nick() .. " has paused the fight" )
		end
	end
	
	net.Start( "props_StopResumeBattle" )
		net.WriteUInt( 0, 2 )
	net.Broadcast()
	
	for k,v in pairs( PROPKILL.Battlers ) do
		v:Cleanup()
	end
	game.ConsoleCommand( "sbox_maxprops 0\n" )
	
	PROPKILL.BattlePaused = true
end

function props_SendRecentBattles( pl )
	local count = table.Count( PROPKILL.RecentBattles )
	if count == 0 then return end

	table.SortByMember( PROPKILL.RecentBattles, "time", false )
	local output = {}
	for i=1,math.Clamp(#PROPKILL.RecentBattles, 0, 9) do
		output[ #output + 1 ] = PROPKILL.RecentBattles[ i ]
	end
	
	net.Start( "props_SendRecentBattles" )
			-- later
		--[[net.WriteUInt( #output, 8 )
		for k,v in ipairs( output ) do
			net.Write]]
		net.WriteTable( output )
	net.Send( pl or player.GetAll() )
end


	

