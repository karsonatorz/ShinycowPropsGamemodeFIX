--[[
				  _________.__    .__                                  
				 /   _____/|  |__ |__| ____ ___.__. ____  ______  _  __
				 \_____  \ |  |  \|  |/    <   |  |/ ___\/  _ \ \/ \/ /
				 /        \|   Y  \  |   |  \___  \  \__(  <_> )     / 
				/_______  /|___|  /__|___|  / ____|\___  >____/ \/\_/  
						\/      \/        \/\/         \/              

		Clientside utility for the creation of horizonal bars
]]--

local PANEL = {}

local colors =
{
 
	border = Color( 255, 255, 255, 255 ),
	background = Color( 20, 20, 20, 255 ),
	shade = Color( 225, 225, 225, 255 ),
	["hp"] =
	{
		fill = Color( 27, 161, 226, 255 )
	},
	["kd"] =
	{
		fill = Color( 51, 153, 51, 255 )
	},
	["killstreak"] =
	{
		fill = Color( 240, 150, 9, 255 )
	},
 
};

function PANEL:Init()
		-- we can walk around now.
	self:SetKeyBoardInputEnabled( true )
	
	
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	
	self:ParentToHUD()
end

function PANEL:SetBackColor( tblColor )
	self.backGroundColor = tblColor
end

function PANEL:SetFillColor( tblColor )
	self.fillColor = tblColor
end

function PANEL:SetBarValue( fl_Percent )
	self.barValue = fl_Percent
end

function PANEL:BarFunction( callback )
	hook.Add("Think", "props_editBarValues", function()
		callback()
	end)
end

local function clr( color ) return color.r, color.g, color.b, color.a; end
function PANEL:Paint( w, h )
	local x, y = 0, 0 --self:GetPos()
		
		-- WAR: no outlines
	--surface.SetDrawColor( clr( colors.border ) );		-- set border draw color
	--surface.DrawOutlinedRect( x, y, w, h );			-- draw the border
 
	x = x + 1;						-- fix our position and size
	y = y + 1;						-- the border is about 1 px
	w = w - 2;						-- thick
	h = h - 2;
 
	surface.SetDrawColor( clr( self.backGroundColor or colors.background ) );	-- set background color
	surface.DrawRect( x, y, w, h );				-- draw background
 
	local width = w * math.Clamp( self.barValue or 0.02, 0, 1 );		-- calc bar width
	local shade = 0;					-- set the shade size constant
 
	surface.SetDrawColor( clr( colors.shade ) );		-- set shade draw color( actually, instead of shade it should be fill )
	surface.DrawRect( x, y, width, shade );			-- draw shade
 
	surface.SetDrawColor( self.fillColor or Color(255, 0, 0, 255) )		-- set fill color( it should be shade instead of fill )
	surface.DrawRect( x, y + shade, width, h - shade );	-- draw fill
end
	
vgui.Register( "props_horizontalbar", PANEL )