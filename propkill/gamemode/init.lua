--[[
				  _________.__    .__                                  
				 /   _____/|  |__ |__| ____ ___.__. ____  ______  _  __
				 \_____  \ |  |  \|  |/    <   |  |/ ___\/  _ \ \/ \/ /
				 /        \|   Y  \  |   |  \___  \  \__(  <_> )     / 
				/_______  /|___|  /__|___|  / ____|\___  >____/ \/\_/  
						\/      \/        \/\/         \/              

		Initializes gamemode..
]]--

-- Switch from having to network all this shit pointlessly to NWVars ??

	-- add !aliases command -- view stored player names over time

PROPKILL = PROPKILL or {}
PROPKILL.TopPropsSession = PROPKILL.TopPropsSession or {}
PROPKILL.TopPropsCache = PROPKILL.TopPropsCache or {}
PROPKILL.TopPropsTotal = PROPKILL.TopPropsTotal or {}
PROPKILL.TopPropsTotalCache = PROPKILL.TopPropsTotalCache or {}
PROPKILL.TopPlayers = PROPKILL.TopPlayers or {}
PROPKILL.TopPlayersCache = PROPKILL.TopPlayersCache or {}
PROPKILL.RecentBattles = PROPKILL.RecentBattles or {}

PROPKILL.Statistics = PROPKILL.Statistics or {}

PROPKILL.HugeProps = PROPKILL.HugeProps or {}

PROPKILL.Battling = PROPKILL.Battling or false
PROPKILL.BattleAmount = PROPKILL.BattleAmount or 0
PROPKILL.Battlers = PROPKILL.Battlers or {}
PROPKILL.BattleInvited = PROPKILL.BattleInvited or {}
PROPKILL.BattleCooldown = 0--PROPKILL.BattleCooldown or 0
PROPKILL.BattlePaused = PROPKILL.BattlePaused or false
PROPKILL.BattleFun = PROPKILL.BattleFun or false

PROPKILL.PlayerBattleCooldowns = PROPKILL.PlayerBattleCooldowns or {}
	-- steamid64: seconds

DEFINE_BASECLASS( "gamemode_sandbox" )

util.AddNetworkString( "PK_HUDMessage" )
util.AddNetworkString( "PK_UpdateConfig" )
util.AddNetworkString( "PK_BattleEnd" )
util.AddNetworkString( "PK_UpdateKillstreak" )
util.AddNetworkString( "props_NetworkPlayerKill" )
util.AddNetworkString( "props_NetworkPlayerTotals" )
util.AddNetworkString( "props_UpdateConfig" )
util.AddNetworkString( "props_UpdateTopPropsSession" )
util.AddNetworkString( "props_UpdateTopPropsTotal" )
util.AddNetworkString( "props_ClearTopProps" )
util.AddNetworkString( "props_FightInvite" )
util.AddNetworkString( "props_ShowClicker" )
util.AddNetworkString( "props_BattleInit" )
util.AddNetworkString( "props_EndBattle" )
util.AddNetworkString( "props_UpdateFullConfig" )
util.AddNetworkString( "props_SendRecentBattles" )
util.AddNetworkString( "props_StopResumeBattle" )
util.AddNetworkString( "props_FightResults" )
util.AddNetworkString( "props_PlaySoundURL" )

AddCSLuaFile( "sh_init.lua" )
include( "sh_init.lua" )

AddCSLuaFile( "sh_config.lua" )
include( "sh_config.lua" )

AddCSLuaFile( "sh_kd.lua" )
include( "sh_kd.lua" )

AddCSLuaFile( "cl_init.lua" )

--AddCSLuaFile( "player_class/player_propkill.lua" )
--include( "player_class/player_propkill.lua" )

AddCSLuaFile( "cl_hooks_base.lua" )
AddCSLuaFile( "cl_hooks.lua" )

include( "sv_util.lua" )
AddCSLuaFile( "sh_util.lua" )
include( "sh_util.lua" )
AddCSLuaFile( "cl_util.lua" )
include( "sv_player.lua" )

AddCSLuaFile( "sh_player.lua" )
include( "sh_player.lua" )

include( "pon.lua" )
include( "sv_util.lua" )
include( "sv_data.lua" )
include( "sv_hooks_base.lua" )
include( "sv_hooks.lua" )

AddCSLuaFile( "sh_hooks.lua" )
include( "sh_hooks.lua" )

AddCSLuaFile( "sh_blockedmodels.lua" )
include( "sh_blockedmodels.lua" )

include( "sv_commands.lua" )

AddCSLuaFile( "sh_speedy.lua")
include( "sh_speedy.lua" )

AddCSLuaFile( "cl_scoreboard.lua" )
AddCSLuaFile( "vgui/scoreboard/props_playerrow.lua" )
AddCSLuaFile( "vgui/scoreboard/props_scoreboard.lua" )

AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "vgui/hud/horizontalbar.lua" )

AddCSLuaFile( "cl_menus.lua" )
AddCSLuaFile( "vgui/menus/dswitch.lua" )
AddCSLuaFile( "vgui/menus/props_main.lua" )
AddCSLuaFile( "vgui/menus/props_teams.lua" )
AddCSLuaFile( "vgui/menus/props_topprops.lua" )
AddCSLuaFile( "vgui/menus/props_battle.lua" )
AddCSLuaFile( "vgui/menus/props_newbattle.lua" )
AddCSLuaFile( "vgui/menus/props_config.lua" )
AddCSLuaFile( "vgui/menus/props_battleinvite.lua" )
AddCSLuaFile( "vgui/menus/props_stats.lua" )
AddCSLuaFile( "vgui/menus/props_bots.lua" )
AddCSLuaFile( "vgui/menus/props_battleresults.lua" )
AddCSLuaFile( "vgui/menus/props_topprops_new.lua" )

local pkfiles, pkfolders = file.Find( "gamemodes/" .. GM.FolderName .. "/gamemode/modules/*.lua", "GAME" )
--PrintTable( pkfiles )
for k,v in next, pkfiles do
	if string.find( v, "sv_" ) then
		print( "\n" .. GM.Name .. "; Found server module: " .. v )
		include( "modules/" .. v )
	elseif string.find(v, "cl_") then
		print( "\n" .. GM.Name .. "; Found client module: " .. v )
		AddCSLuaFile( "modules/" .. v )
	else
		print( "\n" .. GM.Name .."; Found shared module: " .. v )
		include( "modules/" .. v )
		AddCSLuaFile( "modules/" .. v )
	end
end