local PANEL = {}

function PANEL:Init()
	self:SetPos( 20, 20 )
	--print( self:GetParent() )
	self:SetSize( self:GetParent():GetWide() - 40, self:GetParent():GetTall() - 40 )
end

vgui.Register( "props_StatsMenu", PANEL )