local PANEL = {}

include( "props_teams.lua" )
include( "props_config.lua" )
include( "props_battle.lua" )
include( "props_newbattle.lua" )
include( "props_topprops.lua" )
include( "props_stats.lua" )
include( "props_bots.lua" )
include( "props_topprops_new.lua" )

-- 1440 x 900


function PANEL:Init()
	
	self:SetSize( 750, 600 )
	--self:SetSize( ScrW() / (ScrW() / 750), ScrH() / (ScrH() / 600) )
	self:Center()
	
	self:SetKeyboardInputEnabled( true )
	self:MakePopup()
	--gui.EnableScreenClicker( true )
	
	self:SetTitle( "" )
	self.btnMaxim:Remove()
	self.btnMinim:Remove()
	
	local propSheets = vgui.Create( "DPropertySheet", self )
	propSheets:SetPos( 8, 28 )
	propSheets:SetSize( self:GetWide() - 16, self:GetTall() - 31 )
	
	local teamsPanel = vgui.Create( "props_TeamsMenu", propSheets )
	
	--local propsPanel = vgui.Create( "props_TopPropsMenu", propSheets )
	local propsnPanel = vgui.Create( "props_TopPropsNewMenu", propSheets )
	
	--[[local battlePanel = vgui.Create( "DPanelList", propSheets )
	battlePanel:SetAutoSize( true )
	battlePanel:SetSize( propSheets:GetWide() - 2, propSheets:GetTall() - 2 )
	battlePanel:SetSpacing( 25 )
	battlePanel:EnableHorizontal( false )
	battlePanel:EnableVerticalScrollbar( true )]]
	--local battlePanel = vgui.Create( "props_BattleMenu", propSheets )
	
	local battleNewPanel = vgui.Create( "props_BattleMenuNew", propSheets )
	
	--local statsPanel = vgui.Create( "props_StatsMenu", propSheets )
	local botsPanel = vgui.Create( "props_BotsMenu", propSheets )
	
	local configPanel = nil
	
	local canAccessConfig = hook.Call( "PlayerCanChangeSetting", GAMEMODE, LocalPlayer(), nil )
	if canAccessConfig then
		configPanel = vgui.Create( "props_ConfigMenu", propSheets )
	end
	
	local propSheetTeams = propSheets:AddSheet( "Team Selection", teamsPanel, "icon16/sport_football.png", false, false, "Join a team" )
	--local propSheetProps = propSheets:AddSheet( "Top Props", propsPanel, "icon16/car.png", false, false, "View top list of props spawned" )
	local propSheetPropsNew = propSheets:AddSheet( "Top Props", propsnPanel, "icon16/car.png", false, false, "View list of top props" )
	--local propSheetFight = propSheets:AddSheet( "Battle", battlePanel, "icon16/bomb.png", false, false, "Fight a player 1-on-1" )
	local propSheetFight2 = propSheets:AddSheet( "Battle", battleNewPanel, "icon16/bomb.png", false, false, "Fight a player 1-on-1" )
	--local propSheetStats = propSheets:AddSheet( "Statistics", statsPanel, "icon16/chart_bar.png", false, false, "View gamemode statistics!" )
	local propSheetBots = propSheets:AddSheet( "Bots", botsPanel, "icon16/user_gray.png", false, false, "Manage your bot" )
	
	if canAccessConfig then
		local propSheetConfig = propSheets:AddSheet( "Config", configPanel, "icon16/cog.png", false, false, "Change gamemode settings" )
	end
	
end

function PANEL:ShowCloseButton( bShow )

	self.btnClose:SetVisible( bShow )
	
end

function PANEL:OnClose()
	gui.EnableScreenClicker( false )
end

function PANEL:PerformLayout()

	local titlePush = 0

	if ( IsValid( self.imgIcon ) ) then

		self.imgIcon:SetPos( 5, 5 )
		self.imgIcon:SetSize( 16, 16 )
		titlePush = 16

	end

	self.btnClose:SetPos( self:GetWide() - 31 - 4, 0 )
	self.btnClose:SetSize( 31, 31 )

	self.lblTitle:SetPos( 8 + titlePush, 2 )
	self.lblTitle:SetSize( self:GetWide() - 25 - titlePush, 20 )

end

function PANEL:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 31, 31, 31, 255 ) )
	--derma.SkinHook( "Paint", "Frame", self, w, h )
	--return true
end

vgui.Register( "props_MainMenu", PANEL, "DFrame" )

