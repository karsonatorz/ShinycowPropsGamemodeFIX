--[[
				  _________.__    .__                                  
				 /   _____/|  |__ |__| ____ ___.__. ____  ______  _  __
				 \_____  \ |  |  \|  |/    <   |  |/ ___\/  _ \ \/ \/ /
				 /        \|   Y  \  |   |  \___  \  \__(  <_> )     / 
				/_______  /|___|  /__|___|  / ____|\___  >____/ \/\_/  
						\/      \/        \/\/         \/              

		Clientside menu for battle results
]]--

local PANEL = {}

function PANEL:Init()
	--self:SetSize( 720, 480 )
	self:SetSize( ScrW() * 0.5, ScrH() * 0.5333 )
	self:Center()
	self:MakePopup()
	
	surface.SetFont( "props_HUDTextLarge" )
	local titlesizew, titlesizeh = surface.GetTextSize( "Battle Results" )
	
	self.TitleHeader = self:Add( "DPanel" )
	self.TitleHeader:SetSize( self:GetWide(), titlesizeh + 3 )
	self.TitleHeader:Dock( TOP )
	self.TitleHeader.Paint = function( self2, w, h ) 
		--draw.RoundedBox( 0, 0, 0, w, h, Color( 100, 100, 100, 255 ) )
	end
	
	self.TitleHeader.Title = self.TitleHeader:Add( "DLabel" )
	self.TitleHeader.Title:SetText( "Battle Results" )
	self.TitleHeader.Title:SetFont( "props_HUDTextLarge" )
	self.TitleHeader.Title:SetPos( (self:GetWide() - titlesizew) / 2, 5 )
	self.TitleHeader.Title:SizeToContents()
	
	self.Grid = self:Add( "DGrid" )
	self.Grid:SetCols( 3 )
	self.Grid:SetColWide( self:GetWide() / 3 + 10 )
	self.Grid:SetRowHeight( self:GetTall() )
	self.Grid:Dock( TOP )
	
	--[[for i=1,3 do
	local but = vgui.Create( "DButton" )
	but:SetText( i )
	but:SetSize( 30, 20 )
	self.Grid:AddItem( but )
	end]]
	
	self.Grid.Content = {}
	for i=1, 3 do
		self.Grid.Content[ i ] = self.Grid:Add( "DPanel" )
		self.Grid.Content[ i ]:SetSize( self:GetWide() / 3 - 20, self:GetTall() )
		self.Grid.Content[ i ].Paint = function( self2, w, h )
			if i % 2 != 1 then return end
			
			draw.RoundedBox( 0, 0, 0, w, h, Color( 100, 100, 100, 150 ) )
		end
		self.Grid:AddItem( self.Grid.Content[ i ] )
	end
	
	for k,v in pairs( self.Grid.Content ) do
		if k % 2 != 1 then continue end
			
		--print( k )
		
		--steamworks.RequestPlayerInfo( util.SteamIDTo64( "STEAM_0:0:59700372" ) )
		--steamworks.RequestPlayerInfo( util.SteamIDTo64( "STEAM_0:0:29257121" ) )
		
		self.Grid.Content[ k ].Avatar = self.Grid.Content[ k ]:Add( "AvatarImage" )
		self.Grid.Content[ k ].Avatar:SetSize( 184, 184 )
		self.Grid.Content[ k ].Avatar:SetPos( self.Grid.Content[ k ]:GetWide() / 2 - 184 / 2, 24 )
		--self.Grid.Content[ k ].Avatar:SetSteamID( k == 1 and "STEAM_0:0:59700372" or "STEAM_0:0:29257121", 64 )
		self.Grid.Content[ k ].Avatar:SetPlayer( LocalPlayer(), 184 )
		self.Grid.Content[ k ].Avatar.Steamid64 = util.SteamIDTo64( LocalPlayer():SteamID() )
		
		self.Grid.Content[ k ].AvatarButton = self.Grid.Content[ k ]:Add( "DButton" )
		self.Grid.Content[ k ].AvatarButton:SetSize( self.Grid.Content[ k ].Avatar:GetWide(), self.Grid.Content[ k ].Avatar:GetTall() )
		self.Grid.Content[ k ].AvatarButton:SetPos( self.Grid.Content[ k ]:GetWide() / 2 - self.Grid.Content[ k ].Avatar:GetWide() / 2, 24 )
		self.Grid.Content[ k ].AvatarButton:SetText( "" )
		self.Grid.Content[ k ].AvatarButton.Paint = function() end
		self.Grid.Content[ k ].AvatarButton.DoClick = function( self2 )
			gui.OpenURL( "http://steamcommunity.com/profiles/" .. self.Grid.Content[ k ].Avatar.Steamid64 )
		end
		
		if k == 1 then
			self.Grid.Content[ k ].PlayerInfo = self.Grid.Content[ k ]:Add( "DLabel" )
			self.Grid.Content[ k ].PlayerInfo:SetFont( "props_HUDTextSmall" )
			self.Grid.Content[ k ].PlayerInfo:SetText(
			[[

			Name: tpopz

			Total Wins: 0

			Total Losses: 38]] )
			self.Grid.Content[ k ].PlayerInfo:SizeToContents()
			local avatarposx, avatarposy = self.Grid.Content[ k ].Avatar:GetPos()
			self.Grid.Content[ k ].PlayerInfo:SetPos( avatarposx + 10, self.Grid.Content[ k ].Avatar:GetTall() + avatarposy + 5 ) 
		else
			self.Grid.Content[ k ].PlayerInfo = self.Grid.Content[ k ]:Add( "DLabel" )
			self.Grid.Content[ k ].PlayerInfo:SetFont( "props_HUDTextSmall" )
			self.Grid.Content[ k ].PlayerInfo:SetText(
			[[

			Name: Shinycow

			Total Wins: 14

			Total Losses: 1]] )
			self.Grid.Content[ k ].PlayerInfo:SizeToContents()
			local avatarposx, avatarposy = self.Grid.Content[ k ].Avatar:GetPos()
			self.Grid.Content[ k ].PlayerInfo:SetPos( avatarposx + 10, self.Grid.Content[ k ].Avatar:GetTall() + avatarposy + 5 ) 
		end
	end

	surface.SetFont( "props_HUDTextMASSIVE" )
	local vstxtsize_w, vstxtsize_h = surface.GetTextSize( "VS" )
	self.Grid.Content[ 2 ].VSText = self.Grid.Content[ 2 ]:Add( "DLabel" )
	self.Grid.Content[ 2 ].VSText:SetFont( "props_HUDTextMASSIVE" )
	self.Grid.Content[ 2 ].VSText:SetText( "VS" )
	self.Grid.Content[ 2 ].VSText:SetPos( self.Grid.Content[ 2 ]:GetWide() / 2 - vstxtsize_w / 2, (self.Grid.Content[ 1 ].Avatar:GetTall() + 24) - (vstxtsize_h - 24) )
	self.Grid.Content[ 2 ].VSText:SizeToContents()
	
	self.Grid.Content[ 2 ].WinnerInfo = self.Grid.Content[ 2 ]:Add( "DLabel" )
	self.Grid.Content[ 2 ].WinnerInfo:SetFont( "props_HUDTextSmall" )
	self.Grid.Content[ 2 ].WinnerInfo:SetText(
	[[

	Winner: Shinycow

	Score: 12 - 15

	Time Taken: 6:04
	]] )
	self.Grid.Content[ 2 ].WinnerInfo:SizeToContents()
	local vsposx, vsposy = self.Grid.Content[ 2 ].VSText:GetPos()
	self.Grid.Content[ 2 ].WinnerInfo:SetPos( vsposx, vstxtsize_h + vsposy - 24 + 5)
	self.Grid.Content[ 2 ].WinnerInfo.Think = function( self2 )
		local col = {}
		col.r = math.sin( RealTime() * 3.5 ) * 255
		col.r = math.max( col.r, 20 )
		col.g = math.sin( RealTime() * 3.5 ) * 59
		col.b = math.sin( RealTime() * 1.5 ) * 8
		col.a = 255
		self2:SetTextColor( col )
	end
	
	self.CloseButton = self:Add( "DButton" )
	self.CloseButton:SetText( "CLOSE" )
	self.CloseButton:SetTextColor( color_white )
	self.CloseButton:SetSize( self:GetWide(), 50 )
	self.CloseButton:Dock( BOTTOM )
	self.CloseButton.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 140, 20, 20,255 ) )
	end
	self.CloseButton.DoClick = function()
		self:Close()
	end
end

function PANEL:SetInformation( tBattler1, tBattler2, Winner, Score, Time )
	if IsValid( Player( tBattler1.Userid ) ) then
		self.Grid.Content[ 1 ].Avatar:SetPlayer( Player( tBattler1.Userid ), 184 )
		self.Grid.Content[ 1 ].Avatar.Steamid64 = util.SteamIDTo64( Player( tBattler1.Userid ):SteamID() )
	else
		self.Grid.Content[ 1 ].Avatar:SetSteamID( tBattler1.Steamid, 184 )
		self.Grid.Content[ 1 ].Avatar.Steamid64 = util.SteamIDTo64( tBattler1.Steamid )
	end
	self.Grid.Content[ 1 ].PlayerInfo:SetText(
	[[

	Name: ]] .. FixLongName( tBattler1.Name, 13 ) .. [[


	Total Wins: ]] .. tBattler1.Wins .. [[


	Total Losses: ]] .. tBattler1.Losses
	)
	self.Grid.Content[ 1 ].PlayerInfo:SizeToContents()
	
	
	if IsValid( Player( tBattler2.Userid ) ) then
		self.Grid.Content[ 3 ].Avatar:SetPlayer( Player( tBattler2.Userid ), 184 )
		self.Grid.Content[ 3 ].Avatar.Steamid64 = util.SteamIDTo64( Player( tBattler2.Userid ):SteamID() )
	else
		self.Grid.Content[ 3 ].Avatar:SetSteamID( tBattler2.Steamid, 184 )
		self.Grid.Content[ 3 ].Avatar.Steamid64 = util.SteamIDTo64( tBattler2.Steamid )
	end
	self.Grid.Content[ 3 ].PlayerInfo:SetText(
	[[

	Name: ]] .. FixLongName( tBattler2.Name, 13 ) .. [[


	Total Wins: ]] .. tBattler2.Wins .. [[


	Total Losses: ]] .. tBattler2.Losses
	)
	self.Grid.Content[ 3 ].PlayerInfo:SizeToContents()
	
	
	self.Grid.Content[ 2 ].WinnerInfo:SetText(
	[[

	Winner: ]] .. Winner .. [[


	Score: ]] .. Score .. [[


	Time Taken: ]] .. string.ToMinutesSeconds( Time )
	)
	self.Grid.Content[ 2 ].WinnerInfo:SizeToContents()
end
	
	
function PANEL:Close()
	SHOWRESULTS = nil
	self:Remove()
end

function PANEL:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 31, 31, 31, 230 ) )
end

function PANEL:Think()
end

vgui.Register( "props_BattleResults", PANEL )