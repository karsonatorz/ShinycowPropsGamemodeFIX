--
-- This defines a new panel type for the player row. The player row is given a player
-- and then from that point on it pretty much looks after itself. It updates player info
-- in the think function, and removes itself when the player leaves the server.
--
local PANEL = {}

function PANEL:Init()
	
	self.AvatarButton = self:Add( "DButton" )
	self.AvatarButton:SetPos( 5, 5 )
	--self.AvatarButton:Dock( LEFT )
	self.AvatarButton:SetSize( 32, 32 )
	self.AvatarButton.DoClick = function()
		self.Player:ShowProfile()
	end
	
	self.Avatar	= vgui.Create( "AvatarImage", self.AvatarButton )
	self.Avatar:SetSize( 32, 32 )
	self.Avatar:SetMouseInputEnabled( false )	
	
	self.InfoButton = self:Add( "DButton" )
	self.InfoButton:SetPos( 37, 0 )
	self.InfoButton:SetWide( self:GetParent():GetWide() )
	self.InfoButton:SetTall( self:GetParent():GetTall() )
	self.InfoButton.Paint = function() end
	self.InfoButton.DoClick = function()
		local dmenu = DermaMenu()
		
		if self.Player:IsMuted() then
			local unmute = dmenu:AddOption( "Unmute Player", function()
				if not IsValid( self.Player ) then
					return
				end
				self.Player:SetMuted( true )
			end )
			
			unmute:SetIcon( "icon16/telephone_add.png" )
		else
			local mute = dmenu:AddOption( "Mute Player", function()
				if not IsValid( self.Player ) then
					return
				end
				self.Player:SetMuted( false )
			end )
			
			mute:SetIcon( "icon16/telephone_delete.png" )
		end
		
			-- check ulx permissions?
		if LocalPlayer():IsSuperAdmin() then
			local grabip = dmenu:AddOption( "Grab IP", function()
				if not IsValid( self.Player ) then
					return
				end
				RunConsoleCommand( "ulx", "grabip", self.Player:Nick() )
			end )
			
			grabip:SetIcon( "icon16/eye.png" )
		end
			
		
		dmenu:AddSpacer()
		dmenu:AddOption( "Close", function()
			dmenu:Hide()
		end )
		
		dmenu:Open()
		
		dmenu.Think = function()
			if not IsValid( self ) then
				dmenu:Hide()
				if IsValid( dmenu ) then
					dmenu:Remove()
				end
			end
		end
	end
	
	self.Content = {}
	
	local width = self:GetParent():GetWide()
	for x=1, #InfoScoreboard do
		local y = InfoScoreboard[ x ]
		
		surface.SetFont( "ScoreboardSmall" )
		if x == 1 then
			local contentsizew,contentsizeh = surface.GetTextSize( y.id[ 2 ]( LocalPlayer() ) )
			
			local contentplus = #self.Content + 1
			
			self.Content[ contentplus ] = self:Add( "DLabel" )
			self.Content[ contentplus ]:SetText( y.id[ 2 ]( LocalPlayer() ) )
			self.Content[ contentplus ]:SetFont( "ScoreboardSmall" )
			self.Content[ contentplus ]:SetTextColor( Color( 230, 230, 230, 255 ) )
			self.Content[ contentplus ]:SetPos( 40, self:GetTall() / 2 )
			--self.Content[ contentplus ]:SetSize( width * y.space, contentsizeh )
		else				
			local contentplus = #self.Content + 1
			
			local contentsizew,contentsizeh = surface.GetTextSize( y.id[ 2 ]( LocalPlayer() ) )
			local previousposx, previousposy = self.Content[ contentplus - 1 ]:GetPos()
			local previoussizew, previoussizeh = self.Content[ contentplus - 1 ]:GetSize()
			
			self.Content[ contentplus ] = self:Add( "DLabel" )
			self.Content[ contentplus ]:SetText( y.id[ 2 ]( LocalPlayer() ) )
			self.Content[ contentplus ]:SetFont( "ScoreboardSmall" )
			self.Content[ contentplus ]:SetTextColor( Color( 230, 230, 230, 255 ) )
			--self.Content[ contentplus ]:SetPos( previoussizew + previousposx - (contentsizew * 0.6), self:GetTall() / 2 )
			
			--self.Content[ contentplus ]:SetPos( previoussizew + previousposx - 20, self:GetTall() / 2)
			--self.Content[ contentplus ]:SetSize( width * y.space, contentsizeh2 )
			
				-- centers content.
			self.Content[ contentplus ]:SetPos( y.text_posw + (y.text_sizew/2 - contentsizew/2), self:GetTall() / 2 )
				-- if you want it all on left side:
			--self.Content[ contentplus ]:SetPos( y.text_posw, self:GetTall() / 2 )
		end
	end
	
	self.updatescores = CurTime()
	
end

function PANEL:Setup( pl )
	
	self.Player = pl
	
	self.Avatar:SetPlayer( pl )
	--self.Name:SetText( )
	
	for k,v in pairs( self.Content ) do
	
		v:SetText( InfoScoreboard[ k ].id[ 2 ]( pl ) )
		
	end
	
	--self.Content_1:SetText( pl:Nick() )
	
	self:Think()

end

function PANEL:Think()
	if not self.updatescores or self.updatescores > CurTime() then
		return
	end
	
	if not IsValid( self.Player ) then
		self:Remove()
		return
	end
	
	local width = self:GetWide()
	for x=1, #InfoScoreboard do
		local y = InfoScoreboard[ x ]
		
		surface.SetFont( "ScoreboardSmall" )
		if x == 1 then
			local contentsizew,contentsizeh = surface.GetTextSize( y.id[ 2 ]( self.Player ) )
			
			local previousposx, previousposy = self.Content[ x ]:GetPos()
			
			print( #y.id[ 2 ]( self.Player ) )
			
			self.Content[ x ]:SetText( FixLongName( y.id[ 2 ]( self.Player ), 18 ) )
			self.Content[ x ]:SetPos( 40, previousposy )
			self.Content[ x ]:SizeToContents()
			--self.Content[ x ]:SetSize( width * y.space, contentsizeh )
		else		
			local contentplus = #self.Content + 1
			
			local contentsizew,contentsizeh = surface.GetTextSize( y.id[ 2 ]( self.Player ) )
			local previousposx, previousposy = self.Content[ x ]:GetPos()
	
			self.Content[ x ]:SetText( y.id[ 2 ]( self.Player ) )
			y.text_sizew = y.text_sizew or 0
			self.Content[ x ]:SetPos( y.text_posw + (y.text_sizew/2 - contentsizew/2), previousposy )
		end
	end
	
	self.updatescores = CurTime() + 0.7
end


function PANEL:Paint( w, h )
	
	if ( !IsValid( self.Player ) ) then
		return
	end

	--
	-- We draw our background a different colour based on the status of the player
	--

	if ( self.Player:Team() == TEAM_CONNECTING ) then
		draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 200, 200, 215 ) )
		return
	end

	if not self.Player:Alive() then
		for k,v in pairs( self.Content ) do
		
			v:SetTextColor( Color( 198, 38, 38, 255 ) )
		
		end
	else
		for k,v in pairs( self.Content ) do
		
			v:SetTextColor( Color( 255, 255, 255, 255 ) )
		
		end
	end

		
	if self.Player == LocalPlayer() then
		draw.RoundedBox( 0, 0, 0, w, h, Color( 51, 51, 51, 255 ) )
	end
	
		-- 2nd is 32 - avatar
	draw.RoundedBox( 0, 32, h - 2, w - 32, 2, Color( 51, 51, 51, 255 ) )
		
end

vgui.Register( "props_playerrow", PANEL, "Panel" )