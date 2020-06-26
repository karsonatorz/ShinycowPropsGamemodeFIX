AddConfigItem( "bots_enable",
	{
	Name = "Enable bot surfing",
	Category = "Bots",
	default = true,
	type = "boolean",
	desc = "Allow bots to surf around the map",
	}
)

AddConfigItem( "bots_kill",
	{
	Name = "Enable bot killing",
	Category = "Bots",
	default = true,
	type = "boolean",
	desc = "Allow bots to kill other players",
	}
)

AddConfigItem( "bots_maxplayers",
	{
	Name = "Max Players + bots",
	Category = "Bots",
	default = 2,
	type = "integer",
	desc = "How many players are allowed to be on with a bot",
	}
)

AddConfigItem( "bots_killbots",
	{
	Name = "Enable bots targeting bots",
	Category = "Bots",
	default = false,
	type = "boolean",
	desc = "Allow bots to target and kill other bots",
	}
)

if not ulx then return end

local CATEGORY_NAME = "Propkill"

function ulx.pkBot( calling_ply )
	if #player.GetBots() > 0 then return end
	local pls = #player.GetAll()
	local bos = #player.GetBots()
		-- change to 1
	if pls - bos > PROPKILL.Config[ "bots_maxplayers" ].default then return end
	
	game.ConsoleCommand( "bot\n" )
	
	ulx.fancyLogAdmin( calling_ply, "#A spawned a bot!" )
end
local pkBot = ulx.command( CATEGORY_NAME, "ulx pkbot", ulx.pkBot, "!bot" )
pkBot:defaultAccess( ULib.ACCESS_ALL )
pkBot:help( "Spawns a bot." )

if not SERVER then return end

local _R = debug.getregistry()
function _R.Player:BotTalk( msg )
	for k,v in next, player.GetHumans() do
		PROPKILL.ChatText( v, team.GetColor( self:Team() ), self:Nick(), color_white, ": " .. msg )
	end
end
	

hook.Add( "PlayerInitialSpawn", "kickbots", function( pl )
	local pls = #player.GetAll()
	local bos = #player.GetBots()
		-- change to 1
	if pls - bos > PROPKILL.Config[ "bots_maxplayers" ].default then
		for k,v in pairs( player.GetBots() ) do
			v:Kick( " N OLONGER WELCOME " )
		end
	end
	
	timer.Create( "LETSODTHIS" .. pl:UserID(), 1, 1, function()
		if IsValid( pl ) and pl:IsBot() then
			pl:BotTalk( "let's do this" )
		end
	end )
end )