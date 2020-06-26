-- mostly just an edited dcheckbox

local PANEL = {}

AccessorFunc( PANEL, "m_bSwitched", "Switched", FORCE_BOOL )

Derma_Install_Convar_Functions( PANEL )

function PANEL:Init()

	self:SetSize( 100, 36 )
	self:SetText( "" )
	self.onName, self.offName = "ON", "OFF"
	
end

function PANEL:SetValue( val )

	val = tobool( val )
	
	self:SetSwitched( val )
	self.m_bValue = val
	
	self:OnChange( val )
	
	val = val and "1" or "0"
	self:ConVarChanged( val )
	
end

function PANEL:DoClick()

	self:Toggle()
	
end

function PANEL:Toggle()

	local val = not self:GetSwitched() 
	self:SetValue( val )

end

function PANEL:OnChange( bVal )

	-- For override
	
end

function PANEL:Think()

	self:ConVarStringThink()
	
end

function PANEL:SetBackgroundColor( col )
	self.bgColor = col
end

function PANEL:SetOnName( str )
	self.onName = string.upper( str )
end

function PANEL:SetOffName( str )
	self.offName = string.upper( str )
end

function PANEL:Paint( w, h )
	--draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 200, 200, 255 ) )
	draw.RoundedBox( 6, 0, 0, w, h, col or Color( 0, 161, 255, 255 ) )
	--print( w )	
	if not self:GetSwitched() then
		draw.RoundedBox( 6, 0, 0, 4 * (w/7), h, Color( 200, 200, 200, 255 ) )
	else
		draw.RoundedBox( 6, w - (4 * (w/7)), 0, 4 * (w/7), h, Color( 200, 200, 200, 255 ) )
	end
end

function PANEL:PaintOver( w, h )
	--[[local txt = self:GetSwitched() and self.onName or self.offName

	surface.SetFont( self:GetFont() )
	--print( txt )
	local txtsize_w, txtsize_h = surface.GetTextSize( txt )
	
	local offset = 4 * w/7
	local offset2 = offset - txtsize_w / 2
	
	
	draw.SimpleTextOutlined( txt, self:GetFont(), w - txtsize_w , h / 2 - txtsize_h / 2, Color( 244, 244, 244, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.4, Color( 218, 218, 218, 255 ) )]]
	
	local txtz = self:GetSwitched() and self.onName or self.offName
	
	surface.SetFont( self:GetFont() )
	
	local txtzsize_w, txtzsize_h = surface.GetTextSize( "ON"  )
	
	--print( self:GetFont(), txtz,  w / 2, txtzsize_w / 2 )

	if self:GetSwitched() then
		draw.SimpleText( txtz, self:GetFont(), txtzsize_w, h / 2 - txtzsize_h / 2, Color( 244, 244, 244, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
end 

derma.DefineControl( "DSwitch", "Simple Switch", PANEL, "DButton" )