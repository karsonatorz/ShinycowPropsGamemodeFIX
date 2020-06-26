--[[
				  _________.__    .__                                  
				 /   _____/|  |__ |__| ____ ___.__. ____  ______  _  __
				 \_____  \ |  |  \|  |/    <   |  |/ ___\/  _ \ \/ \/ /
				 /        \|   Y  \  |   |  \___  \  \__(  <_> )     / 
				/_______  /|___|  /__|___|  / ____|\___  >____/ \/\_/  
						\/      \/        \/\/         \/              

		Scoreboard initialization 
]]--

surface.CreateFont( "ScoreboardDefault",
{
	font		= "Helvetica",
	size		= 22,
	weight		= 800
})

surface.CreateFont( "ScoreboardDefaultTitle",
{
	font		= "Helvetica",
	size		= 32,
	weight		= 800
})

surface.CreateFont( "ScoreboardSmall", 
{
	font = "Helvetica",
	size = 18,
	weight = 800,
} )

surface.CreateFont("ScoreboardLarge", 
{
	size = 36,
	weight = 800,
	antialias = true,
	shadow = true,
	font = "Helvetica"
})

--[[TeamsScoreboard =
{
TEAM_SPECTATOR,
TEAM_DEATHMATCH,
TEAM_RED,
TEAM_BLUE,
}]]

	-- Arrow through, first shows spec / deathmatch,
	-- second shows red / blue
TeamsScoreboard =
{
	[ 1 ] =
		{
		TEAM_SPECTATOR,
		TEAM_DEATHMATCH,
		},
	
	[ 2 ] =
		{
		TEAM_RED,
		TEAM_BLUE,
		},
}

	-- lua_run_cl local f = FindMetaTable("Player").Deaths print( f( LocalPlayer() ) )
	
InfoScoreboard =
{
	{
		-- Nice name for it, How to access it
	id = { "%team", FindMetaTable( "Player" ).Name },
		-- Space needed to hold this info / 1
	space = 0.3,
	},
	
	{
	id = { "Total Kills", FindMetaTable( "Player" ).TotalFrags },
	space = 0.19,
	},
	
	{
	id = { "Total Deaths", FindMetaTable( "Player" ).TotalDeaths },
	space = 0.19,
	},
	
	{
	id = { "Kills", FindMetaTable( "Player" ).Frags },
	space = 0.13,
	},
	
	{
	id = { "Deaths", FindMetaTable( "Player" ).Deaths },
	space = 0.13,
	},
	
	{
	id = { "Ping", FindMetaTable( "Player" ).Ping },
	space = 0.13,
	},
}

	-- add right click option to players to toggle voicechat
	-- "Mute voice" / "Unmute voice"


GRADIENT_HORIZONTAL = 0;
GRADIENT_VERTICAL = 1;
function draw.LinearGradient(x,y,w,h,from,to,dir,res)
	dir = dir or GRADIENT_HORIZONTAL;
	if dir == GRADIENT_HORIZONTAL then res = (res and res <= w) and res or w;
	elseif dir == GRADIENT_VERTICAL then res = (res and res <= h) and res or h; end
	for i=1,res do
		surface.SetDrawColor(
			Lerp(i/res,from.r,to.r),
			Lerp(i/res,from.g,to.g),
			Lerp(i/res,from.b,to.b),
			Lerp(i/res,from.a,to.a)
		);
		if dir == GRADIENT_HORIZONTAL then surface.DrawRect(x + w * (i/res), y, w/res, h );
		elseif dir == GRADIENT_VERTICAL then surface.DrawRect(x, y + h * (i/res), w, h/res ); end
	end
end

-- Example use
--function panel:Paint()
 --     draw.LinearGradient( 0, 0, self:GetWide(), self:GetTall(), color_white, color_black, GRADIENT_VERTICAL );
--end


-- credits : http://facepunch.com/showthread.php?t=1051898&p=27576273&viewfull=1#post27576273


include( "vgui/scoreboard/props_playerrow.lua" )
include( "vgui/scoreboard/props_scoreboard.lua" )

--[[---------------------------------------------------------
   Name: gamemode:ScoreboardShow( )
   Desc: Sets the scoreboard to visible
-----------------------------------------------------------]]
function GM:ScoreboardShow()

	if g_Scoreboard then
		g_Scoreboard:Remove()
		g_Scoreboard = nil
	end

	g_Scoreboard = vgui.Create( "props_scoreboard" )
	
	--[[if ( IsValid( g_Scoreboard ) ) then
		g_Scoreboard:Show()
		g_Scoreboard:MakePopup()
		g_Scoreboard:SetKeyboardInputEnabled( false )
	end]]

end

--[[---------------------------------------------------------
   Name: gamemode:ScoreboardHide( )
   Desc: Hides the scoreboard
-----------------------------------------------------------]]
function GM:ScoreboardHide()

	--[[if ( IsValid( g_Scoreboard ) ) then
		g_Scoreboard:Hide()
	end]]
	
	if g_Scoreboard then
		g_Scoreboard:Remove()
	end

end


--[[---------------------------------------------------------
   Name: gamemode:HUDDrawScoreBoard( )
   Desc: If you prefer to draw your scoreboard the stupid way (without vgui)
-----------------------------------------------------------]]
function GM:HUDDrawScoreBoard()

end