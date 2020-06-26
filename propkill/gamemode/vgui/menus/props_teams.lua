local PANEL = {}

function PANEL:Init()
	
	self:SetPos( 15, 15 )
	--self:SetSize( , 400 )
	self:SetCols( 2 )
	self:SetColWide( self:GetParent():GetWide() / 2 )
	self:SetRowHeight( self:GetParent():GetTall() / 2 - 10 )
	
	for i=1,#team.GetAllTeams() do
		local v = team.GetAllTeams()[ i ]
		
		local teamButton = vgui.Create( "DButton" )
		teamButton:SetText( v.Name )
		teamButton:SetFont( "props_HUDTextMedium" )
		teamButton:SetSize( self:GetParent():GetWide() / 2 - 10, self:GetParent():GetTall() / 2 - 20 )
		teamButton:SetColor( Color( 230, 230, 230, 255 ) )
		teamButton.DoClick = function( pnl )
			RunConsoleCommand( "props_changeteam", i )
			self:GetParent():GetParent():Close()
		end
		teamButton.Paint = function( pnl, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( v.Color.r, v.Color.g, v.Color.b, v.Color.a ) )
		end
		self:AddItem( teamButton )
	end

end

function PANEL:PerformLayout()

	local i = 0
	
	self.m_iCols = math.floor( self.m_iCols )
	
	for k, panel in pairs( self.Items ) do
		
		local x = ( i%self.m_iCols ) * self.m_iColWide
		local y = math.floor( i / self.m_iCols )  * self.m_iRowHeight
		
		panel:SetPos( x, y )
		
		i = i + 1 
	end
	
	--self:SetWide( self.m_iColWide * self.m_iCols )
	--self:SetTall( math.ceil( i / self.m_iCols )  * self.m_iRowHeight )
end

function PANEL:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 200, 200, 255 ) )
end

vgui.Register( "props_TeamsMenu", PANEL, "DGrid" )