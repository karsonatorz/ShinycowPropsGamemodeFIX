local PANEL = {}

function PANEL:Init()
	self:SetPos( 20, 20 )
	--print( self:GetParent() )
	self:SetSize( self:GetParent():GetWide() - 40, self:GetParent():GetTall() - 40 )
	
	self.propsContainer = self:Add( "DScrollPanel" )--"DPanel" )
	self.propsContainer:SetWide( self:GetWide() )
		-- button will be 25 pixels tall?
	self.propsContainer:SetTall( self:GetTall() - 35 )
	self.propsContainer:Dock( TOP )

	self.propsContainer.Grid = vgui.Create( "DGrid" )--self.propsContainer:Add( "DGrid" )
	self.propsContainer.Grid:SetSize( self:GetWide(), self:GetTall() )
	self.propsContainer.Grid:SetPos( 15, 0 )
	self.propsContainer.Grid:SetCols( 5 )
	self.propsContainer.Grid:SetColWide( 135 )
	self.propsContainer.Grid:SetRowHeight( 135 )
	self.propsContainer.Grid.PerformLayout = function( pnl )

		local i = 0
		
		pnl.m_iCols = math.floor( pnl.m_iCols )
		
		for k, panel in pairs( pnl.Items ) do
			
			local x = ( i%pnl.m_iCols ) * pnl.m_iColWide
			local y = math.floor( i / pnl.m_iCols )  * pnl.m_iRowHeight
			
			panel:SetPos( x, y )
			
			i = i + 1 
		end
	
		--self:SetWide( self.m_iColWide * self.m_iCols )
		pnl:SetTall( math.ceil( i / pnl.m_iCols )  * pnl.m_iRowHeight )
	end
	
	for k,v in pairs( PROPKILL.TopProps ) do
		self.propsContainer.Grid.Panel = vgui.Create( "DPanel" )--self.propsContainer.Grid:Add( "DPanel" )
		self.propsContainer.Grid.Panel:SetSize( 125, 125 )
		
		self.propsContainer.Grid.Panel.Image = self.propsContainer.Grid.Panel:Add( "SpawnIcon" )
		self.propsContainer.Grid.Panel.Image:SetModel( v.Model )
		self.propsContainer.Grid.Panel.Image:SetSize( 85, 85 )
		local panelsize_w, panelsize_h = self.propsContainer.Grid.Panel:GetSize()
		local imagesize_w, imagesize_h = self.propsContainer.Grid.Panel.Image:GetSize()
		self.propsContainer.Grid.Panel.Image:SetPos( panelsize_w / 2 - imagesize_w / 2, 3 )
		--self.propsContainer.Grid.Panel.Image:SetSize( self.propsContainer.Grid.Panel:GetWide() - 6, 30 )
		self.propsContainer.Grid.Panel.Image:SetToolTip( "Model: " .. v.Model )
		self.propsContainer.Grid.Panel.Image.DoClick = function( pnl )
			RunConsoleCommand( "gm_spawn", v.Model )
		end
		self.propsContainer.Grid.Panel.Image.DoRightClick = function( pnl )
			local menu = DermaMenu()
			menu:AddOption( "Copy Model", function() 
				SetClipboardText( v.Model )
			end )
			menu:Open()
		end
		
		self.propsContainer.Grid.Panel.Text = self.propsContainer.Grid.Panel:Add( "DLabel" )
		self.propsContainer.Grid.Panel.Text:SetText( "Spawn Count: " .. v.Count )
		self.propsContainer.Grid.Panel.Text:SetFont( "props_HUDTextTiny" )
		surface.SetFont( "props_HUDTextTiny" )
		local textsize_w, textsize_h = surface.GetTextSize( "Spawn Count: " .. v.Count )
		self.propsContainer.Grid.Panel.Text:SetPos( panelsize_w / 2 - textsize_w / 2, imagesize_h + 3 + 5 )
		self.propsContainer.Grid.Panel.Text:SetTextColor( Color( 50, 50, 50, 255 ) )
		self.propsContainer.Grid.Panel.Text:SizeToContents()
		
			-- add dlabel wiht # of spawns
		
		self.propsContainer.Grid:AddItem( self.propsContainer.Grid.Panel )
	end
	self.propsContainer:AddItem( self.propsContainer.Grid )
	
	-- create dgrid, dverticalscrollbar
	-- for each prop have the image, and a dlabel under it EAch INsIDE a DPANEL
	-- parent the dpanel to the dgrid.
	
	-- underneath everything put a button that says "Clear Props (Admin Only)"
	
	self.propsClearList = self:Add( "DPanel" )
	self.propsClearList:SetWide( self:GetWide() )
	self.propsClearList:SetTall( 30 )
	self.propsClearList:Dock( BOTTOM )
	self.propsClearList.Paint = function() end
	
	self.propsClearList.Content = self.propsClearList:Add( "DButton" )
	self.propsClearList.Content:SetText( "Reset Top Props (Admin Only)" )
	self.propsClearList.Content:SetTextColor( Color( 50, 50, 50, 255 ) )
	self.propsClearList.Content:SetFont( "props_HUDTextSmall" )
	surface.SetFont( "props_HUDTextSmall" )
	local listtextsize_w, listtextsize_h = surface.GetTextSize( "Reset Top Props (Admin Only)" )
	self.propsClearList.Content:SetSize( listtextsize_w + 15, listtextsize_h + 5 )
	self.propsClearList.Content:SetPos( (self.propsClearList:GetWide() / 2 - self.propsClearList.Content:GetWide() / 2) + 15, self.propsClearList:GetTall() / 2 - self.propsClearList.Content:GetTall() / 2 )
	self.propsClearList.Content.DoClick = function( self )
		net.Start( "props_ClearTopProps" )
		net.SendToServer()
	end
	
end

vgui.Register( "props_TopPropsMenu", PANEL )