local PANEL = {}

function PANEL:Init()
	self:SetPos( 20, 20 )
	self:SetSize( self:GetParent():GetWide() - 40, self:GetParent():GetTall() - 40 )
	
	self.descriptionPanel = self:Add( "DPanel" )
	self.descriptionPanel:SetWide( self:GetWide() )
	self.descriptionPanel:SetTall( 150 )
	self.descriptionPanel:Dock( BOTTOM )
	self.descriptionPanel.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 121, 120, 125, 255 ) )
	end
	
	self.descriptionPanel.Description = self.descriptionPanel:Add( "DLabel" )
	self.descriptionPanel.Description:SetText( "Pick a player to battle with one-on-one.\n\nChoose how many kills to fight to, and a time limit.\n\nLaugh as others get pissed off waiting on you to finish." )
	self.descriptionPanel.Description:SetFont( "props_HUDTextMedium" )
	self.descriptionPanel.Description:SetTextColor( Color( 230, 230, 230, 255 ) )
	self.descriptionPanel.Description:SizeToContents()
	self.descriptionPanel.Description:SetPos( 15, 0 )
	
	self.fightPanel = self:Add( "DPanel" )
	self.fightPanel:SetWide( self:GetWide() )
	self.fightPanel:SetTall( 90 )
	self.fightPanel:Dock( BOTTOM )
	self.fightPanel.Paint = function( pnl, w, h )
	end
	
	self.fightPanel.StartButton = self.fightPanel:Add( "DButton" )
	self.fightPanel.StartButton:SetFont( "props_HUDTextSmall" )
	self.fightPanel.StartButton:SetText( "Start Battle" )
	self.fightPanel.StartButton:SetSize( 150, 40 )
	local fightsize_w, fightsize_h = self.fightPanel:GetSize()
	self.fightPanel.StartButton:SetPos( ( fightsize_w / 2 - self.fightPanel.StartButton:GetWide() / 2 ) - 25, fightsize_h / 2 - self.fightPanel.StartButton:GetTall() / 2 )

	
	self.selectionPanel = self:Add( "DPanel" )
	self.selectionPanel:SetWide( self:GetWide() * (4/9) )
	--self.selectionPanel:SetTall( self:GetTall() )
	self.selectionPanel:Dock( LEFT )
	self.selectionPanel.Paint = function( pnl, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 121, 120, 125, 255 ) )
	end
	
	self.selectionPanel.PlayerSelection = self.selectionPanel:Add( "DComboBox" )
	self.selectionPanel.PlayerSelection:SetPos( 15, 5 )
	self.selectionPanel.PlayerSelection:SetWide( self.selectionPanel:GetWide() - 30 )
	self.selectionPanel.PlayerSelection:SetTall( 25 )
	self.selectionPanel.PlayerSelection:SetValue( "Select a player" )
	for k,v in pairs( player.GetAll() ) do
		if v == LocalPlayer() then continue end
		
		self.selectionPanel.PlayerSelection:AddChoice( v:Nick() )
	end
	self.selectionPanel.PlayerSelection.OnSelect = function( pnl, index, value )
		--print( self.selectionPanel.PlayerAvatar and "found playeravatar" or "didnt find playeravatar" )
		self.selectionPanel.PlayerAvatar:SetModel( player.GetByID( index ):GetModel() )
		self.selectionPanel.PlayerAvatar.Entity:SetEyeTarget( player.GetByID( index ):EyePos() )
	end
	
	self.selectionPanel.PlayerAvatar = self.selectionPanel:Add( "DModelPanel" )
	self.selectionPanel.PlayerAvatar:SetAnimated( false )
	self.selectionPanel.PlayerAvatar:SetFOV( 60 )
	self.selectionPanel.PlayerAvatar:SetPos( 10, 5 + (5 + 25 ) )
	self.selectionPanel.PlayerAvatar:SetSize( 230, 230 )
	self.selectionPanel.PlayerAvatar:SetModel( LocalPlayer():GetModel() )
	local headpos = self.selectionPanel.PlayerAvatar.Entity:GetBonePosition( self.selectionPanel.PlayerAvatar.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )
	headpos:Add( Vector( 0, 0, 2 ) )
	self.selectionPanel.PlayerAvatar:SetLookAt( headpos )
	self.selectionPanel.PlayerAvatar:SetCamPos( headpos-Vector( -15, 0, 0 ) )	
	self.selectionPanel.PlayerAvatar.Entity:SetEyeTarget( LocalPlayer():EyePos() ) 
	self.selectionPanel.PlayerAvatar.LayoutEntity = function( pnl, ent )
		return
	end
	self.selectionPanel.PlayerAvatar.Entity.GetPlayerColor = function( self )
		local plColor = LocalPlayer():GetPlayerColor()
		return Vector( plColor.x, plColor.y, plColor.z )
	end
	--[[self.selectionPanel.PlayerAvatar = self.selectionPanel:Add( "ModelImage" )
	self.selectionPanel.PlayerAvatar:SetModel( LocalPlayer():GetModel() )
	self.selectionPanel.PlayerAvatar:SetSize( 50, 50 )
	self.selectionPanel.PlayerAvatar:SetPos( 10, 5 + (5 + 25 ) )]]
	
	self.settingsPanel = self:Add( "DPanel" )
	self.settingsPanel:SetWide( self:GetWide() - self.selectionPanel:GetWide() )
	--self.settingsPanel:SetTall( 50 )
	self.settingsPanel:Dock( RIGHT )
	self.settingsPanel.Paint = function( pnl, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 121, 120, 125, 255 ) )
	end
	
	self.settingsPanel.SettingsText = self.settingsPanel:Add( "DLabel" )
	self.settingsPanel.SettingsText:SetText( "BATTLE SETTINGS" )
	self.settingsPanel.SettingsText:SetFont( "props_HUDTextHuge" )
	self.settingsPanel.SettingsText:SetTextColor( Color( 230, 230, 230, 255 ) )
	self.settingsPanel.SettingsText:SizeToContents()
	surface.SetFont( "props_HUDTextHuge" )
	local textsize_w, textsize_h = surface.GetTextSize( "BATTLE SETTINGS" )
	self.settingsPanel.SettingsText:SetPos( self.settingsPanel:GetWide() / 2 - textsize_w / 2, 0 )
	
	self.settingsPanel.fragText = self.settingsPanel:Add( "DLabel" )
	self.settingsPanel.fragText:SetText( "How many kills it takes to win the fight" )
	self.settingsPanel.fragText:SetFont( "props_HUDTextSmall" )
	self.settingsPanel.fragText:SetTextColor( Color( 230, 230, 230, 255) ) 
	surface.SetFont( "props_HUDTextSmall" )
	local textsize2_w, textsize2_h = surface.GetTextSize( "How many kills it takes to win the fight" )
	self.settingsPanel.fragText:SizeToContents()
	self.settingsPanel.fragText:SetPos( self.settingsPanel:GetWide() / 2 - textsize2_w / 2, textsize_h + textsize2_h + 5 )
	
	self.settingsPanel.fragSlider = self.settingsPanel:Add( "DNumSlider" )
	self.settingsPanel.fragSlider:SetWide( 400 ) 
	self.settingsPanel.fragSlider:SetText( "" )
	self.settingsPanel.fragSlider:SetPos( (self.settingsPanel:GetWide() / 2 - self.settingsPanel.fragSlider:GetWide() / 2) - 18, self.settingsPanel.fragText.y + self.settingsPanel.fragText:GetTall() + 5 )
	self.settingsPanel.fragSlider:SetMin( 1 )
	self.settingsPanel.fragSlider:SetMax( PROPKILL.Config[ "battle_maxkills" ].default )
	self.settingsPanel.fragSlider:SetDecimals( 0 )
	self.settingsPanel.fragSlider.Scratch:SetDecimals( 0 )
	self.settingsPanel.fragSlider:SetValue( PROPKILL.Config[ "battle_defaultkills" ].default )
	self.settingsPanel.fragSlider.Slider:SetSlideX( PROPKILL.Config[ "battle_defaultkills" ].default / PROPKILL.Config[ "battle_maxkills" ].default )
	self.settingsPanel.fragSlider.Slider.OnMouseReleased = function( pnl )
		pnl:SetDragging( false )
		pnl:MouseCapture( false )
		
	end
	self.settingsPanel.fragSlider.Slider.Knob.OnMouseReleased = function( pnl, mousecode )
		return DLabel.OnMouseReleased( pnl, mousecode )
	end
	self.settingsPanel.fragSlider.TextArea.OnEnter = function( pnl )
	end
	self.settingsPanel.fragSlider.PerformLayout = function( pnl )
	end
	
	
end

vgui.Register( "props_BattleMenu", PANEL )
	