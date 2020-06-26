--[[
				  _________.__    .__                                  
				 /   _____/|  |__ |__| ____ ___.__. ____  ______  _  __
				 \_____  \ |  |  \|  |/    <   |  |/ ___\/  _ \ \/ \/ /
				 /        \|   Y  \  |   |  \___  \  \__(  <_> )     / 
				/_______  /|___|  /__|___|  / ____|\___  >____/ \/\_/  
						\/      \/        \/\/         \/              

		Clientside tab showing of the top props
]]--

local PANEL = {}

function PANEL:Init()
	self:SetPos( 20, 20 )
	self:SetSize( self:GetParent():GetWide() - 40, self:GetParent():GetTall() - 40 )
	
	self:RebuildMenu()
	
end

function PANEL:RebuildMenu()
	if self.SessionProps then 
		if self.SessionProps.propsession:GetExpanded() then
			self.Expanded = "session"
		end
		self.SessionProps:Remove()
	end
	if self.TotalProps then 
		if self.TotalProps.proptotal:GetExpanded() then
			self.Expanded = "total"
		end
		self.TotalProps:Remove() 
	end
	
	self.SessionProps = self:Add( "DCategoryList" )
	self.SessionProps:SetWide( self:GetWide() )
	self.SessionProps:SetTall( self:GetTall() - 30 )--- self.TotalProps:GetTall() )
	self.SessionProps:Dock( TOP )
	self.SessionProps.propsession = self.SessionProps:Add( "Session" )
	self.SessionProps.Think = function( pnl )
		if self.proptotal and self.proptotal:GetExpanded() then self.SessionProps.propsession:SetExpanded( false ) end
		if not self.SessionProps.propsession:GetExpanded() then
			pnl:SetTall( 20 )
			if not pnl.VBarSize then pnl.VBarSize = pnl.VBar:GetSize() end
			pnl.VBar:SetSize( 0, 0 )
			pnl.VBar:SetEnabled( false )
		else
			pnl:SetTall( self:GetTall() - 30 )
			if pnl.VBarSize then pnl.VBar:SetSize( pnl.VBarSize ) end
		end
	end
	self.SessionProps.propsession.Header.DoClick = function( pnl )
		self.SessionProps.propsession:Toggle()
		
		self.TotalProps.proptotal:SetExpanded( false )
		self.TotalProps.proptotal.animSlide:Start( self.TotalProps.proptotal:GetAnimTime(),{ From = self.TotalProps.proptotal:GetTall() } )
		self.TotalProps.proptotal:InvalidateLayout( true )
		self.TotalProps.proptotal:GetParent():InvalidateLayout()
		self.TotalProps.proptotal:GetParent():GetParent():InvalidateLayout()
						
		self.TotalProps.proptotal:SetCookie( "Open", "0" )
	end
	
	self.SessionProps.Grid = vgui.Create( "DGrid" )
	self.SessionProps.Grid:SetSize( self:GetWide(), self:GetTall() )
	self.SessionProps.Grid:SetPos( 15, 0 )
	self.SessionProps.Grid:SetCols( 5 )
	self.SessionProps.Grid:SetColWide( 147 )
	self.SessionProps.Grid:SetRowHeight( 135 )
	self.SessionProps.Grid.PerformLayout = function( pnl )

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
			
		if self.SessionProps.VBar.Enabled then
			self.SessionProps.Grid:SetColWide( 144 ) 
		else
			self.SessionProps.Grid:SetColWide( 147 )
		end
		
	end

	for k,v in pairs( PROPKILL.TopPropsSession or {} ) do
		self.SessionProps.Grid.Panel = vgui.Create( "DPanel" )--self.propsContainer.Grid:Add( "DPanel" )
		self.SessionProps.Grid.Panel:SetSize( 125, 125 )
		
		self.SessionProps.Grid.Panel.Image = self.SessionProps.Grid.Panel:Add( "SpawnIcon" )
		self.SessionProps.Grid.Panel.Image:SetModel( v.Model )
		self.SessionProps.Grid.Panel.Image:SetSize( 85, 85 )
		local panelsize_w, panelsize_h = self.SessionProps.Grid.Panel:GetSize()
		local imagesize_w, imagesize_h = self.SessionProps.Grid.Panel.Image:GetSize()
		self.SessionProps.Grid.Panel.Image:SetPos( panelsize_w / 2 - imagesize_w / 2, 3 )
		--self.propsContainer.Grid.Panel.Image:SetSize( self.propsContainer.Grid.Panel:GetWide() - 6, 30 )
		self.SessionProps.Grid.Panel.Image:SetToolTip( "Model: " .. v.Model )
		self.SessionProps.Grid.Panel.Image.DoClick = function( pnl )
			RunConsoleCommand( "gm_spawn", v.Model )
		end
		self.SessionProps.Grid.Panel.Image.DoRightClick = function( pnl )
			local menu = DermaMenu( pnl )
			menu:AddOption( "Copy Model", function() 
				SetClipboardText( v.Model )
			end )
			menu:Open()
			menu:SetPos( gui.MouseX() - 50, gui.MouseY() - 10 )
			menu.Think = function( pnl2 )
				if not IsValid( pnl ) then
					pnl2:Remove()
				end
			end
		end
		
		self.SessionProps.Grid.Panel.Text = self.SessionProps.Grid.Panel:Add( "DLabel" )
		self.SessionProps.Grid.Panel.Text:SetText( "Spawn Count: " .. v.Count )
		self.SessionProps.Grid.Panel.Text:SetFont( "props_HUDTextTiny" )
		surface.SetFont( "props_HUDTextTiny" )
		local textsize_w, textsize_h = surface.GetTextSize( "Spawn Count: " .. v.Count )
		self.SessionProps.Grid.Panel.Text:SetPos( panelsize_w / 2 - textsize_w / 2, imagesize_h + 3 + 5 )
		self.SessionProps.Grid.Panel.Text:SetTextColor( Color( 50, 50, 50, 255 ) )
		self.SessionProps.Grid.Panel.Text:SizeToContents()
		
		self.SessionProps.Grid:AddItem( self.SessionProps.Grid.Panel )
	end
	self.SessionProps.propsession:SetContents( self.SessionProps.Grid )--AddItem( self.SessionProps.Grid )
	
	
	self.TotalProps = self:Add( "DCategoryList" )
	self.TotalProps:SetWide( self:GetWide() )
	self.TotalProps:SetTall( 30 )
	self.TotalProps:Dock( TOP )
	self.TotalProps.proptotal = self.TotalProps:Add( "Total" )
	self.TotalProps.Think = function( pnl )
		if self.SessionProps.propsession:GetExpanded() then self.TotalProps.proptotal:SetExpanded( false ) end
		if not self.TotalProps.proptotal:GetExpanded() then
			pnl:SetTall( 20 )
			if not pnl.VBarSize then pnl.VBarSize = pnl.VBar:GetSize() end
			pnl.VBar:SetSize( 0, 0 )
			pnl.VBar:SetEnabled( false )
		else
			pnl:SetTall( self:GetTall() - 30 )
			if pnl.VBarSize then pnl.VBar:SetSize( pnl.VBarSize ) end
		end
	end
	self.TotalProps.proptotal.Header.DoClick = function( pnl )
		self.TotalProps.proptotal:Toggle()
		
		self.SessionProps.propsession:SetExpanded( false )
		self.SessionProps.propsession.animSlide:Start( self.SessionProps.propsession:GetAnimTime(),{ From = self.SessionProps.propsession:GetTall() } )
		self.SessionProps.propsession:InvalidateLayout( true )
		self.SessionProps.propsession:GetParent():InvalidateLayout()
		self.SessionProps.propsession:GetParent():GetParent():InvalidateLayout()
						
		self.SessionProps.propsession:SetCookie( "Open", "0" )
	end
	
	self.TotalProps.Grid = vgui.Create( "DGrid" )
	self.TotalProps.Grid:SetSize( self:GetWide(), self:GetTall() )
	self.TotalProps.Grid:SetPos( 15, 0 )
	self.TotalProps.Grid:SetCols( 5 )
	self.TotalProps.Grid:SetColWide( 147 )
	self.TotalProps.Grid:SetRowHeight( 135 )
	self.TotalProps.Grid.PerformLayout = function( pnl )

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
			
		if self.TotalProps.VBar.Enabled then
			self.TotalProps.Grid:SetColWide( 144 ) 
		else
			self.TotalProps.Grid:SetColWide( 147 )
		end
		
	end
	
	for k,v in pairs( PROPKILL.TopPropsTotal or {} ) do
		self.TotalProps.Grid.Panel = vgui.Create( "DPanel" )--self.propsContainer.Grid:Add( "DPanel" )
		self.TotalProps.Grid.Panel:SetSize( 125, 125 )
		
		self.TotalProps.Grid.Panel.Image = self.TotalProps.Grid.Panel:Add( "SpawnIcon" )
		self.TotalProps.Grid.Panel.Image:SetModel( v.Model )
		self.TotalProps.Grid.Panel.Image:SetSize( 85, 85 )
		local panelsize_w, panelsize_h = self.TotalProps.Grid.Panel:GetSize()
		local imagesize_w, imagesize_h = self.TotalProps.Grid.Panel.Image:GetSize()
		self.TotalProps.Grid.Panel.Image:SetPos( panelsize_w / 2 - imagesize_w / 2, 3 )
		self.TotalProps.Grid.Panel.Image:SetToolTip( "Model: " .. v.Model )
		self.TotalProps.Grid.Panel.Image.DoClick = function( pnl )
			RunConsoleCommand( "gm_spawn", v.Model )
		end
		self.TotalProps.Grid.Panel.Image.DoRightClick = function( pnl )
			local menu = DermaMenu( pnl )
			menu:AddOption( "Copy Model", function() 
				SetClipboardText( v.Model )
			end )
			menu:Open()
			menu:SetPos( gui.MouseX() - 50, gui.MouseY() - 10 )
			menu.Think = function( pnl2 )
				if not IsValid( pnl ) then
					pnl2:Remove()
				end
			end
		end
		
		surface.SetFont( "props_HUDTextTiny" )
		local textsize_w, textsize_h = surface.GetTextSize( "Spawn Count: " .. v.Count )
		
		self.TotalProps.Grid.Panel.Text = self.TotalProps.Grid.Panel:Add( "DLabel" )
		self.TotalProps.Grid.Panel.Text:SetFont( "props_HUDTextTiny" )
		self.TotalProps.Grid.Panel.Text:SetTextColor( Color( 50, 50, 50, 255 ) )
		
		if textsize_w >= panelsize_w then
			
			local newtextsize_w, newtextsize_h = surface.GetTextSize( "Spawn Count:" )
			local countsize_w, countsize_h = surface.GetTextSize( v.Count )
			
			--print( "count size", v.Model, countsize_w, newtextsize_w / 2 - countsize_w )
			
			self.TotalProps.Grid.Panel.Text:SetText( "Spawn Count:\n " .. string.rep( " ", (newtextsize_w / 2 - countsize_w) / 3 ) .. v.Count  )
			self.TotalProps.Grid.Panel.Text:SetPos( panelsize_w / 2 - newtextsize_w / 2, imagesize_h + 3 + 5 )
		else
			self.TotalProps.Grid.Panel.Text:SetText( "Spawn Count: " .. v.Count )
			self.TotalProps.Grid.Panel.Text:SetPos( panelsize_w / 2 - textsize_w / 2, imagesize_h + 3 + 5 )
		end
		self.TotalProps.Grid.Panel.Text:SizeToContents()
		
		self.TotalProps.Grid:AddItem( self.TotalProps.Grid.Panel )
	end
	self.TotalProps.proptotal:SetContents( self.TotalProps.Grid )--AddItem( self.SessionProps.Grid )
	
	
	if self.Expanded then
		if self.Expanded == "session" then
			self.TotalProps.proptotal:SetExpanded( false )
			self.SessionProps.propsession:SetExpanded( true )
		else
			self.SessionProps.propsession:SetExpanded( false )
			self.TotalProps.proptotal:SetExpanded( true )
		end
	else
		self.TotalProps.proptotal:SetExpanded( false )
		if #self.SessionProps.Grid:GetItems() > 0 then
			self.SessionProps.propsession:SetExpanded( true )
		else
			if #self.TotalProps.Grid:GetItems() > 0 then
				self.TotalProps.proptotal:SetExpanded( true )
			end
			self.SessionProps.propsession:SetExpanded( false )
		end
	end
	

	hook.Add( "props_UpdateTopPropsSession", "props_RebuildTopProps", function()
		if self and self.RebuildMenu then
			self:RebuildMenu()
		end
	end )
	
end

vgui.Register( "props_TopPropsNewMenu", PANEL )