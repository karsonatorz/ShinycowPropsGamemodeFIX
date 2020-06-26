-- only allow people with over 100 total kills to save their bot paths
-- limit each both path to 20 seconds long
	-- find out by using    1 / engine.TickInterval()   OR    1 / FrameTime()
	--		find refresh rate, get # of frames divided by it. bam.
-- reset bot paths on each bot disconnect

-- add button to the menu for admins / the creator to delete paths?

local PANEL = {}

local cominsoon = false

function PANEL:Init()
	self:SetPos( 20, 20 )
	--print( self:GetParent() )
	self:SetSize( self:GetParent():GetWide() - 20 + 4, self:GetParent():GetTall() - 40 )
	
	if cominsoon then
		surface.SetFont( "props_HUDTextHuge" )
		local soontxtw, soontxth = surface.GetTextSize( "COMING SOON!" )
		
		self.ComingSoon = self:Add( "DLabel" )
		self.ComingSoon:SetFont( "props_HUDTextHuge" ) 
		self.ComingSoon:SetText( "COMING SOON!" )
		self.ComingSoon:SizeToContents()
		self.ComingSoon:SetPos( self:GetWide() / 2 - soontxtw / 2, self:GetTall() / 2 - soontxth / 2 ) 
		return
	end
	
	--[[local pnltest = self:Add( "DPanel" )
	pnltest:SetSize( self:GetWide(), self:GetTall() )
	pnltest:SetPos( 0, 0 )]]
	
	self.CAT_newpath = self:Add( "DCategoryList" )
	self.CAT_newpath:SetWide( self:GetTall() )
	self.CAT_newpath:SetTall( self:GetTall() )
	self.CAT_newpath:Dock( TOP )
	self.CAT_newpath.newpath = self.CAT_newpath:Add( "New Path" )
	self.CAT_newpath.Think = function( pnl )
		--if self.proptotal and self.proptotal:GetExpanded() then self.SessionProps.propsession:SetExpanded( false ) end
		if not self.CAT_newpath.newpath:GetExpanded() then
			pnl:SetTall( 20 )
			if not pnl.VBarSize then pnl.VBarSize = pnl.VBar:GetSize() end
			pnl.VBar:SetSize( 0, 0 )
			pnl.VBar:SetEnabled( false )
		else
			pnl:SetTall( self:GetTall() )
			if pnl.VBarSize then pnl.VBar:SetSize( pnl.VBarSize ) end
		end
	end
	--[[self.CAT_newpath.newpath.Header.DoClick = function( pnl )
		self.CAT_newpath.newpath:Toggle()
		
		self.TotalProps.proptotal:SetExpanded( false )
		self.TotalProps.proptotal.animSlide:Start( self.TotalProps.proptotal:GetAnimTime(),{ From = self.TotalProps.proptotal:GetTall() } )
		self.TotalProps.proptotal:InvalidateLayout( true )
		self.TotalProps.proptotal:GetParent():InvalidateLayout()
		self.TotalProps.proptotal:GetParent():GetParent():InvalidateLayout()
						
		self.TotalProps.proptotal:SetCookie( "Open", "0" )
	end]]
	
	
	local loadcategory = nil
	
end

vgui.Register( "props_BotsMenu", PANEL )