--[[
				  _________.__    .__                                  
				 /   _____/|  |__ |__| ____ ___.__. ____  ______  _  __
				 \_____  \ |  |  \|  |/    <   |  |/ ___\/  _ \ \/ \/ /
				 /        \|   Y  \  |   |  \___  \  \__(  <_> )     / 
				/_______  /|___|  /__|___|  / ____|\___  >____/ \/\_/  
						\/      \/        \/\/         \/              

		Main scoreboard
]]--

local PANEL = {}

hook.Add( "Initialize", "props_RegisterScoreboardArrow", function()
	timer.Simple(3, function()
		LocalPlayer().ScoreboardArrow = 1
	end)
end )


function PANEL:Init()
		-- 1440 x 900
	LocalPlayer().ScoreboardArrow = LocalPlayer().ScoreboardArrow or 1
	
	--self:SetSize( 1300, 820 )
	self:SetSize( math.ceil( ScrW() * 0.9027 ), math.ceil( ScrH() * 0.9111 ) )
	self:SetPos( 70, 30 )
	self:MakePopup()
	self.Paint = function( self, w, h ) end
	
	self.MainHeader = self:Add( "DPanel" )
	--self.MainHeader:SetWide( 1300 )
	self.MainHeader:SetWide( math.ceil( ScrW() * 0.9027 ) )
	--self.MainHeader:SetTall( 60 )
	self.MainHeader:SetTall( math.ceil( ScrH() * 0.0666 ) )
	self.MainHeader:Dock( TOP )
	self.MainHeader.Paint = function( self, w, h ) end

	self.MainHeader.Text = self.MainHeader:Add( "DLabel" )
	self.MainHeader.Text:SetText( GetHostName() )
	self.MainHeader.Text:SetFont( "ScoreboardLarge" )
	self.MainHeader.Text:Dock( FILL )
	self.MainHeader.Text:SetTextColor( color_white )
	self.MainHeader.Text:SetContentAlignment( 5 )
	
	self.ContentGap = self:Add( "DPanel" )
	--self.ContentGap:SetWide( 1300 )
	self.ContentGap:SetWide( math.ceil( ScrW() * 0.9027 ) )
	--self.ContentGap:SetTall( 20 )
	self.ContentGap:SetTall( math.ceil( ScrH() * 0.02222 ) )
	self.ContentGap:Dock( TOP )
	self.ContentGap.Paint = function() end
	
	self.ContentGap.ArrowLeft = self.ContentGap:Add( "DImageButton" )
	self.ContentGap.ArrowLeft:SetImage( "icon16/arrow_left.png" )
	--self.ContentGap.ArrowLeft:SetWide( 24 )
	self.ContentGap.ArrowLeft:SetWide( math.ceil( ScrW() * 0.0166 ) )
	self.ContentGap.ArrowLeft:SetToolTip( "Select previous group of teams" )
	self.ContentGap.ArrowLeft:Dock( LEFT )
	self.ContentGap.ArrowLeft:SetTextColor( color_white )
	self.ContentGap.ArrowLeft.Paint = function() end
	self.ContentGap.ArrowLeft.DoClick = function()
		LocalPlayer().ScoreboardArrow = LocalPlayer().ScoreboardArrow - 1
		if not TeamsScoreboard[ LocalPlayer().ScoreboardArrow ] then
			LocalPlayer().ScoreboardArrow = #TeamsScoreboard
		end
		self:Update()
	end
	
	self.ContentGap.ArrowRight = self.ContentGap:Add( "DImageButton" )
	self.ContentGap.ArrowRight:SetImage( "icon16/arrow_right.png" )
	--self.ContentGap.ArrowRight:SetWide( 24 )
	self.ContentGap.ArrowRight:SetWide( math.ceil( ScrW() * 0.0166 ) )
	self.ContentGap.ArrowRight:SetToolTip( "Select next group of teams" )
	self.ContentGap.ArrowRight:Dock( RIGHT )
	self.ContentGap.ArrowRight:SetTextColor( color_white )
	self.ContentGap.ArrowRight.Paint = function() end
	self.ContentGap.ArrowRight.DoClick = function()
		LocalPlayer().ScoreboardArrow = LocalPlayer().ScoreboardArrow + 1
		if not TeamsScoreboard[ LocalPlayer().ScoreboardArrow ] then
			LocalPlayer().ScoreboardArrow = 1
		end
		self:Update()
	end
	
		-- This is where the scores will parent to
	self.Content = self:Add( "DPanel" )
	--self.Content:SetWide( 1300 )
	self.Content:SetWide( math.ceil( ScrW() * 0.9027 ) )
	--self.Content:SetTall( 740 )
	self.Content:SetTall( math.ceil( ScrH() *0.8222 ) )
	self.Content:Dock( TOP )
	self.Content.Paint = function( self ) end
	
	self:Update()

end

function PANEL:Update()

	self.Content:Remove()
	
		-- This is where the scores will parent to
	self.Content = self:Add( "DPanel" )
	--self.Content:SetWide( 1300 )
	self.Content:SetWide( math.ceil( ScrW() * 0.9027 ) )
	--self.Content:SetTall( 740 )
	self.Content:SetTall( math.ceil( ScrH() *0.8222 ) )
	self.Content:Dock( TOP )
	self.Content.Paint = function( self ) end

	local teamCount = #TeamsScoreboard[ LocalPlayer().ScoreboardArrow ]
	for i=1,#TeamsScoreboard[ LocalPlayer().ScoreboardArrow ] do
		local v = TeamsScoreboard[ LocalPlayer().ScoreboardArrow ][ i ]
			-- account for the padding between contents
		self.Content[ "Panel_" .. i ] = self.Content:Add( "DPanel" )
		--self.Content[ "Panel_" .. i ]:SetWide( (1300 - (10 * (teamCount - 1))) / teamCount )
		self.Content[ "Panel_" .. i ]:SetWide( ScrW() / ( 1440 / ( (1300 - (10 * (teamCount - 1))) / teamCount ) ) )
		--self.Content[ "Panel_" .. i ]:SetTall( 740 )
		self.Content[ "Panel_" .. i ]:SetTall( math.ceil( ScrH() *0.8222 ) )
		self.Content[ "Panel_" .. i ]:Dock( LEFT )
		self.Content[ "Panel_" .. i ].Paint = function( self )
			draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 31, 31, 31, 255 ) )
		end
		
		if teamCount != i then
			
			self.Content[ "Padding_" .. i ] = self.Content:Add( "DPanel" )
			--self.Content[ "Padding_" .. i ]:SetWide( 10 )
			self.Content[ "Padding_" .. i ]:SetWide( ScrW() / (1440 / 10) )
			--self.Content[ "Padding_" .. i ]:SetTall( 740 )
			self.Content[ "Padding_" .. i ]:SetTall( math.ceil( ScrH() *0.8222 ) )
			self.Content[ "Padding_" .. i ]:Dock( LEFT )
			self.Content[ "Padding_" .. i ].Paint = function() end
			
		end
		
		self.Content[ "Panel_" .. i ].TeamHeader = self.Content[ "Panel_" .. i ]:Add( "DPanel" )
		self.Content[ "Panel_" .. i ].TeamHeader:SetWide( self.Content[ "Panel_" .. i ]:GetWide() )
		--self.Content[ "Panel_" .. i ].TeamHeader:SetTall( 30 )
		self.Content[ "Panel_" .. i ].TeamHeader:SetTall( math.ceil( ScrH() * 0.0333 ) )
		self.Content[ "Panel_" .. i ].TeamHeader:Dock( TOP )
		self.Content[ "Panel_" .. i ].TeamHeader.Paint = function( self )
			draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), team.GetColor( v ) )
		end
		
		local width = self.Content[ "Panel_" .. i ]:GetWide()
		for x=1,#InfoScoreboard do
			local y = InfoScoreboard[ x ]
		
			local id = y.id[ 1 ]
			
			if y.id[ 1 ] == "%team" then
				id = string.gsub( y.id[ 1 ], "%%team", string.upper( team.GetName( v ) .. " ( " .. #team.GetPlayers( v ) .. " )" ) )
			end
			
			surface.SetFont( "ScoreboardSmall" )
			if x == 1 then
				local scoresizew,scoresizeh = surface.GetTextSize( id )
				
				self.Content[ "Panel_" .. i ].TeamHeader[ x ] = self.Content[ "Panel_" .. i ].TeamHeader:Add( "DLabel" )
				self.Content[ "Panel_" .. i ].TeamHeader[ x ]:SetText( id )
				self.Content[ "Panel_" .. i ].TeamHeader[ x ]:SetFont( "ScoreboardSmall" )
				self.Content[ "Panel_" .. i ].TeamHeader[ x ]:SetTextColor( Color( 230, 230, 230, 255 ) )
				self.Content[ "Panel_" .. i ].TeamHeader[ x ]:SetPos( 5, self.Content[ "Panel_" .. i ].TeamHeader:GetTall() / 4 )
				self.Content[ "Panel_" .. i ].TeamHeader[ x ]:SetSize( width * y.space, scoresizeh )
			else
				local scoresizew,scoresizeh = surface.GetTextSize( id )
				local previousposx, previousposy = self.Content[ "Panel_" .. i ].TeamHeader[ x - 1 ]:GetPos()
				local previoussizew, previoussizeh = self.Content[ "Panel_" .. i ].TeamHeader[ x - 1 ]:GetSize()
				
				self.Content[ "Panel_" .. i ].TeamHeader[ x ] = self.Content[ "Panel_" .. i ].TeamHeader:Add( "DLabel" )
				self.Content[ "Panel_" .. i ].TeamHeader[ x ]:SetText( id )
				self.Content[ "Panel_" .. i ].TeamHeader[ x ]:SetFont( "ScoreboardSmall" )
				self.Content[ "Panel_" .. i ].TeamHeader[ x ]:SetTextColor( Color( 230, 230, 230, 255 ) )
				self.Content[ "Panel_" .. i ].TeamHeader[ x ]:SetPos( previoussizew + previousposx, self.Content[ "Panel_" .. i ].TeamHeader:GetTall() / 4 )
				self.Content[ "Panel_" .. i ].TeamHeader[ x ]:SetSize( width * y.space, scoresizeh )
				
					-- text wasn't centered below columns - now they will be.
				InfoScoreboard[ x ].text_sizew = scoresizew
				InfoScoreboard[ x ].text_posw = self.Content[ "Panel_" .. i ].TeamHeader[ x ]:GetPos()
			end
		end

			-- Content (player rows)
		self.Content[ "Panel_" .. i ].TeamContent = self.Content[ "Panel_" .. i ]:Add( "DPanelList" )
		self.Content[ "Panel_" .. i ].TeamContent:EnableVerticalScrollbar()
		self.Content[ "Panel_" .. i ].TeamContent:SetWide( self.Content[ "Panel_" .. i ]:GetWide() )
		self.Content[ "Panel_" .. i ].TeamContent:SetTall( self.Content[ "Panel_" .. i ]:GetTall() )
		self.Content[ "Panel_" .. i ].TeamContent:Dock( TOP )
		self.Content[ "Panel_" .. i ].TeamContent.Paint = function() end
		
		for a,b in pairs( team.GetPlayers( v ) ) do
			self.Content[ "Panel_" .. i ].TeamContent.PlayerRow = self.Content[ "Panel_" .. i ].TeamContent:Add( "props_playerrow" )
			self.Content[ "Panel_" .. i ].TeamContent.PlayerRow:Setup( b )
			self.Content[ "Panel_" .. i ].TeamContent.PlayerRow:SetWide( self.Content[ "Panel_" .. i ]:GetWide() )
			--self.Content[ "Panel_" .. i ].TeamContent.PlayerRow:SetTall( 37 )
			self.Content[ "Panel_" .. i ].TeamContent.PlayerRow:SetTall( math.ceil( ScrH() * 0.04111 ) )
			self.Content[ "Panel_" .. i ].TeamContent:AddItem( self.Content[ "Panel_" .. i ].TeamContent.PlayerRow )
		end
		
		
		--print( self.Content[ "Panel_" .. i ]:GetWide() )
	end
	
	if PROPKILL.Battling then
		self.MainHeader.Text:SetTextColor( Color( 255, 255, 255, 0 ) )
	else
		self.MainHeader.Text:SetTextColor( color_white )
	end
end
	

function PANEL:Think()

end

vgui.Register( "props_scoreboard", PANEL )