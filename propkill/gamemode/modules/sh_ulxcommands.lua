--[[
				  _________.__    .__                                  
				 /   _____/|  |__ |__| ____ ___.__. ____  ______  _  __
				 \_____  \ |  |  \|  |/    <   |  |/ ___\/  _ \ \/ \/ /
				 /        \|   Y  \  |   |  \___  \  \__(  <_> )     / 
				/_______  /|___|  /__|___|  / ____|\___  >____/ \/\_/  
						\/      \/        \/\/         \/              

		Adds propkilling commands to ULX
]]--

if not ulx then return end

-- add ulx stopfight command for admins

-- add ulx forfeit command for battlers

-- add !putteam

local CATEGORY_NAME = "Propkill"

function ulx.pkCleanup( calling_ply )
	util.CleanUpMap( true )
	
	ulx.fancyLogAdmin( calling_ply, "#A cleaned up the map!" )
end
local pkCleanup = ulx.command( CATEGORY_NAME, "ulx pkcleanup", ulx.pkCleanup, "!cleanup" )
pkCleanup:defaultAccess( ULib.ACCESS_ADMIN )
pkCleanup:help( "Clean up the map." )

function ulx.pkStopFight( calling_ply )
	if not PROPKILL.Battling then return end

	GAMEMODE:EndBattle( PROPKILL.Battlers[ "inviter" ], PROPKILL.Battlers[ "invitee" ], nil, true )
	
	ulx.fancyLogAdmin( calling_ply, "#A has stopped the fight!" )
end
local pkStopFight = ulx.command( CATEGORY_NAME, "ulx stopfight", ulx.pkStopFight, "!stopfight" )
pkStopFight:defaultAccess( ULib.ACCESS_ADMIN )
pkStopFight:help( "Stops the current fight" )

function ulx.pkForfeit( calling_ply )
	if not PROPKILL.Battling then return end
	if PROPKILL.Battlers[ "inviter" ] != calling_ply and PROPKILL.Battlers[ "invitee" ] != calling_ply then return end
	
	if calling_ply == PROPKILL.Battlers[ "inviter" ] then
	GAMEMODE:EndBattle( PROPKILL.Battlers[ "inviter" ], PROPKILL.Battlers[ "invitee" ], calling_ply:Nick(), false, PROPKILL.Battlers[ "invitee" ]:Nick() )
	else
	GAMEMODE:EndBattle( PROPKILL.Battlers[ "inviter" ], PROPKILL.Battlers[ "invitee" ], PROPKILL.Battlers[ "invitee" ]:Nick(), false, PROPKILL.Battlers[ "inviter" ]:Nick() )
	end
	
	ulx.fancyLogAdmin( calling_ply, "#A has forfeited the fight!" )
end
local pkForfeit = ulx.command( CATEGORY_NAME, "ulx forfeit", ulx.pkForfeit, {"!forfeit", "!leavefight", "!endfight"} )
pkForfeit:defaultAccess( ULib.ACCESS_ALL )
pkForfeit:help( "Forfeits the current fight" )

function ulx.pkRespawn( calling_ply, target_plys )
	for k,v in pairs( target_plys ) do
		v:Spawn()
	end
	
	ulx.fancyLogAdmin( calling_ply, "#A respawned #T", target_plys )
end
local pkRespawn = ulx.command( CATEGORY_NAME, "ulx respawn", ulx.pkRespawn, "!respawn" )
pkRespawn:addParam{ type=ULib.cmds.PlayersArg }
pkRespawn:defaultAccess( ULib.ACCESS_ADMIN )
pkRespawn:help( "Respawns specified target(s)" )


local teamList = { "spectator", "deathmatch", "red", "blue" }
function ulx.pkSetTeam( calling_ply, target_plys, team )
	if #target_plys == 0 then return end
	if not team or not PROPKILL.ValidTeams[ team ] then
		team = "spectator"
	end
	
	local oldteam = team
	team = PROPKILL.ValidTeams[ team ]
	
	for k,v in pairs( target_plys ) do
		v:SetTeam( team )
		v:Spawn()
	end
	
	ulx.fancyLogAdmin( calling_ply, "#A set the team of #T to #s", target_plys, oldteam )
end
local pkSetTeam = ulx.command( CATEGORY_NAME, "ulx setteam", ulx.pkSetTeam, "!setteam" )
pkSetTeam:addParam{ type=ULib.cmds.PlayersArg }
pkSetTeam:addParam{ type=ULib.cmds.StringArg, hint="team", completes=teamList, ULib.cmds.restrictToCompletes }
pkSetTeam:defaultAccess( ULib.ACCESS_ADMIN )
pkSetTeam:help( "Sets the target(s) to a certain team" )

function ulx.pkGiveToolgun( calling_ply )
	calling_ply:Give( "gmod_tool" )
	
	ulx.fancyLogAdmin( calling_ply, "#A gave themself the tool gun." )
end
local pkGiveToolgun = ulx.command( CATEGORY_NAME, "ulx toolgun", ulx.pkGiveToolgun, "!toolgun" )
pkGiveToolgun:defaultAccess( ULib.ACCESS_SUPERADMIN )
pkGiveToolgun:help( "Gives yourself the tool gun" )


function ulx.pkSetKills( calling_ply, target_plys, amount )
	-- set the permanent frags of the player(s)
	for k,v in pairs( target_plys ) do
		v:SetTotalFrags( amount, true )
	end
	
	ulx.fancyLogAdmin( calling_ply, "#A set the total kills of #T to #i", target_plys, amount )
end
local pkSetKills = ulx.command( CATEGORY_NAME, "ulx setkills", ulx.pkSetKills, "!setkills" )
pkSetKills:addParam{ type=ULib.cmds.PlayersArg }
pkSetKills:addParam{ type=ULib.cmds.NumArg, min=0, max=999999, hint="amount", ULib.cmds.round }
pkSetKills:defaultAccess( ULib.ACCESS_SUPERADMIN )
pkSetKills:help( "Changes the total kills of the target(s)" )

function ulx.pkSetDeaths( calling_ply, target_plys, amount )
	-- set the permanent deaths of the player(s)
	for k,v in pairs( target_plys ) do
		v:SetTotalDeaths( amount )
	end
	
	ulx.fancyLogAdmin( calling_ply, "#A set the total deaths of #T to #i", target_plys, amount )
end
local pkSetDeaths = ulx.command( CATEGORY_NAME, "ulx setdeaths", ulx.pkSetDeaths, "!setdeaths" )
pkSetDeaths:addParam{ type=ULib.cmds.PlayersArg }
pkSetDeaths:addParam{ type=ULib.cmds.NumArg, min=0, max=999999, hint="amount", ULib.cmds.round }
pkSetDeaths:defaultAccess( ULib.ACCESS_SUPERADMIN )
pkSetDeaths:help( "Changes the total deaths of the target(s)" )

function ulx.pkPauseBattle( calling_ply )
	if not PROPKILL.Battling or PROPKILL.BattlePaused then return end
	if PROPKILL.Battlers[ "inviter" ] != calling_ply and PROPKILL.Battlers[ "invitee" ] != calling_ply then return end
	calling_ply:ConCommand( "props_pausebattle" )
	
	ulx.fancyLogAdmin( calling_ply, "#A paused the battle." )
end
local pkPauseBattle = ulx.command( CATEGORY_NAME, "ulx pause", ulx.pkPauseBattle, {"!pause", "!pausebattle"} )
pkPauseBattle:defaultAccess( ULib.ACCESS_ALL )
pkPauseBattle:help( "Pauses the current battle" )

function ulx.pkResetMyStats( calling_ply )
	local notify = calling_ply:TotalFrags() >= 100
	calling_ply:ConCommand( "props_resetmystats" )
	
	if notify then
		ulx.fancyLogAdmin( calling_ply, "#A reset their stats." )
	end
end
local pkResetMyStats = ulx.command( CATEGORY_NAME, "ulx resetmystats", ulx.pkResetMyStats, "!resetmystats" )
pkResetMyStats:defaultAccess( ULib.ACCESS_ALL )
pkResetMyStats:help( "Resets your stats (total kills,deaths,streaks,bonuses)" )





-- NON Pk RELATED


local CATEGORY_NAME = "Utility"

function ulx.banid2( calling_ply, steamid, minutes, reason )
	steamid = steamid:upper()
	if not ULib.isValidSteamID( steamid ) then
		ULib.tsayError( calling_ply, "Invalid steamid." )
		return
	end

	local name = nil
	local plys = player.GetAll()
	for i=1, #plys do
		if plys[ i ]:SteamID() == steamid then
			name = plys[ i ]:Nick()
			break
		end
	end
	
	if not name then
		calling_ply:ChatPrint( "Couldn't find that player, sorry!" )
		return
	end

	local time = "for #i minute(s)"
	if minutes == 0 then time = "permanently" end
	local str = "#A banned steamid #s "
	displayid = steamid
	if name then
		displayid = displayid .. "(" .. name .. ") "
	end
	str = str .. time
	if reason and reason ~= "" then str = str .. " (#4s)" end
	ulx.fancyLogAdmin( calling_ply, str, displayid, minutes ~= 0 and minutes or reason, reason )
	-- Delay by 1 frame to ensure any chat hook finishes with player intact. Prevents a crash.
	ULib.queueFunctionCall( ULib.addBan, steamid, minutes, reason, name, calling_ply )
end
local banid = ulx.command( CATEGORY_NAME, "ulx banid2", ulx.banid2 )
banid:addParam{ type=ULib.cmds.StringArg, hint="steamid" }
banid:addParam{ type=ULib.cmds.NumArg, hint="minutes, 0 for perma", ULib.cmds.optional, ULib.cmds.allowTimeString, min=0 }
banid:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes=ulx.common_kick_reasons }
banid:defaultAccess( ULib.ACCESS_SUPERADMIN )
banid:help( "Bans steamid." )