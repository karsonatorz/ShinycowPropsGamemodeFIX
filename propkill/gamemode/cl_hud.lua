--[[
				  _________.__    .__                                  
				 /   _____/|  |__ |__| ____ ___.__. ____  ______  _  __
				 \_____  \ |  |  \|  |/    <   |  |/ ___\/  _ \ \/ \/ /
				 /        \|   Y  \  |   |  \___  \  \__(  <_> )     / 
				/_______  /|___|  /__|___|  / ____|\___  >____/ \/\_/  
						\/      \/        \/\/         \/              

		Everything HUD related
]]--

local _R = debug.getregistry()

	-- CREDITS: blackawps
local matBlurScreen = Material( "pp/blurscreen" )

function _R.Panel:DrawBackgroundBlur( blurAmnt )
	--[[blurAmnt = blurAmnt or 5
	surface.SetMaterial( matBlurScreen )    
	surface.SetDrawColor( 255, 255, 255, 255 )
	
	local x, y = self:LocalToScreen( 0, 0 )
		
	for i=0.33, 1, 0.33 do
		matBlurScreen:SetFloat( "$blur", blurAmnt * i )
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
	end]]
	
	
	
	-- do nothing cause FPS LOSS
end

-- i think i refigured out how to make universal huds even with siht like ScrH() - 35

-- for an example like ScrH() - 35,
-- lua_run_cl print( ScrH() / (ScrH() + 35) )
-- then the output is what you use,
--	ScrH() * 0.962


surface.CreateFont( "props_HUDTextULTRATiny",
	{
	font = "TargetID",
	size = 12, --ScreenScale( 5.6 ),
	weight = 550,
	}
)
surface.CreateFont( "props_HUDTextVeryTiny",
	{
	font = "TargetID",
	size = 14, --ScreenScale( 6.2 ),
	weight = 600,
	}
)	
surface.CreateFont("props_HUDTextTiny",
				{
				font = "TargetID",
				size = 16,--ScreenScale( 7.1 ), --16,
				weight = 600,
				})
surface.CreateFont("props_HUDTextSmall",
				{
				font = "TargetID",
				size = 20, --ScreenScale( 8.9 ), --20,
				--size = 20,
				weight = 600,
				})
surface.CreateFont("props_HUDTextMedium",
				{
				font = "TargetID",
				--size = 30,
				size = 30,--ScreenScale( 13.3 ),
				weight = 700,
				})
surface.CreateFont( "props_HUDTextLarge",
	{
	font = "TargetID",
	size = 36, --ScreenScale( 16 ),--36,
	weight = 700,
	}
)
surface.CreateFont("props_HUDTextHuge",
				{
				font = "TargetID",
				size = 46,--ScreenScale( 20.45 ), --46,
				weight = 700,
				})
surface.CreateFont( "props_HUDTextMASSIVE",
				{
				font = "TargetID",
				size = 128,
				weight = 900,
				}
				)
				
hook.Add( "HUDShouldDraw", "props_OverrideDefaultHUD", function( name )
	if name == "CHudHealth" then return false end
end )

local function CreateHUD( b_noMotd )
	if not _G.LocalPlayer or not IsValid( LocalPlayer() ) then
		timer.Simple( 0.5, function() CreateHUD() end )
		return
	end
	
	if IsValid( VGUI_BASECONTENT ) then
		VGUI_BASECONTENT:Remove()
		VGUI_BASECONTENT = nil
	end
	
	if IsValid( VGUI_introBackground ) then
		VGUI_introBackground:Remove()
		VGUI_introBackground = nil
	end
	
		-- saved for now.
	if not b_noMotd and ULib and ULib.ucl.query( LocalPlayer(), "ulx who" ) and GetConVarString( "ulx_showMotd" ) == "1" then
		if not PROPKILL.Config[ "ulx_showmotd" ] or PROPKILL.Config[ "ulx_showmotd" ].default then
			RunConsoleCommand( "ulx", "motd" )
		else
			RunConsoleCommand( "props_menu" )
		end 
	end
	
	local propsPlayer = LocalPlayer():GetObserverTarget() != NULL and LocalPlayer():GetObserverTarget() or LocalPlayer() --LocalPlayer():GetViewEntity()
	
	VGUI_BASECONTENT = vgui.Create( "DPanel" )
		-- for if there's 3 bars
	-------------VGUI_BASECONTENT:SetPos( 15, ScrH() - 135 )
	-------------VGUI_BASECONTENT:SetSize( 350, 120 )
	--VGUI_BASECONTENT:SetPos( 15, ScrH() - 110 ) 
	VGUI_BASECONTENT:SetPos( 15, math.ceil( ScrH() * GetUniversalSize( 110, 900 ) ))
	--VGUI_BASECONTENT:SetSize( 350, 95 )
		-- 350 / 1440 = 0.243
	VGUI_BASECONTENT:SetSize( ScrW() * 0.243, ScrH() * 0.1055 )
	VGUI_BASECONTENT:ParentToHUD()
	VGUI_BASECONTENT.Paint = function( self, w, h )
		--draw.RoundedBox( 0, 0, 0, w, h, Color( 31, 31, 31, 235  ) )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 27, 26, 26, 235 ) )
		self:DrawBackgroundBlur( 4 )
	end
	
	local basesizew, basesizeh = VGUI_BASECONTENT:GetSize()
	
	surface.SetFont( "props_HUDTextSmall" )
	local leader = props_GetLeader()
	local textsizew, textsizeh = surface.GetTextSize( "Leader: Shinycow ( 0 )" )
	VGUI_LEADER = vgui.Create( "DLabel" )
	VGUI_LEADER:SetParent( VGUI_BASECONTENT )
	--VGUI_LEADER:SetPos( 40, 3 )
	VGUI_LEADER:SetPos( 40, 3 )
	VGUI_LEADER:SetSize( basesizew, textsizeh )
	if IsValid( leader ) then
		VGUI_LEADER:SetText( "Leader: " .. leader:Nick() .. " ( " .. leader:GetKillstreak() .. " )" )
	else
		VGUI_LEADER:SetText( "Leader: ( 0 ) " )
	end
	VGUI_LEADER:SetFont( "props_HUDTextSmall" )
	--VGUI_LEADER:SetTextColor( Color( 200, 200, 200, 255 ) )
	--VGUI_LEADER:SetTextColor( Color( 127, 125, 125, 255 ) )
	VGUI_LEADER:SetTextColor( Color( 230, 230, 230, 255 ) )
	VGUI_LEADER.Think = function( self )
		local leader = props_GetLeader()
		local textsizew, textsizeh = nil, nil
		local sizew, sizeh = self:GetSize()
		
		local leader = props_GetLeader()
		if IsValid( leader ) then
			textsizew, textsizeh = surface.GetTextSize( "Leader: " .. FixLongName( leader:Nick(), 17 ) .. " ( " .. leader:GetKillstreak() .. " )" )
			VGUI_LEADER:SetText( "Leader: " .. FixLongName( leader:Nick(), 17 ) .. " ( " .. leader:GetKillstreak() .. " )" )
		else
			textsizew, textsizeh = surface.GetTextSize( "Leader: ( 0 )" )
			VGUI_LEADER:SetText( "Leader: ( 0 )" )
		end
		self:SetPos( sizew/2 - textsizew/2, 3 )
	end
	
	local previoussizew, previoussizeh = VGUI_LEADER:GetSize()
	local previousposx, previousposy = VGUI_LEADER:GetPos()
	
		-- i should automate these.

	VGUI_KILLSTREAK = vgui.Create( "props_horizontalbar" )
	VGUI_KILLSTREAK:SetParent( VGUI_BASECONTENT )
	VGUI_KILLSTREAK:SetPos( 5, 5 + previousposy + previoussizeh )
		-- ( (panel height - the previous dlabels + gap) - the gap amount times the amount of boxes) / amount of boxes
	VGUI_KILLSTREAK:SetSize( basesizew - 10, (basesizeh - (previousposy + previoussizeh + 5) - 15) / 2 )
	VGUI_KILLSTREAK:SetBackColor( Color( 25, 25, 25, 255 ) )
		-- when theres 3 of them use this
	---------VGUI_KILLSTREAK:SetFillColor( Color( 76, 84, 255, 255 ) )
	VGUI_KILLSTREAK:SetFillColor( Color( 206, 61, 38, 255 ) )
	VGUI_KILLSTREAK:SetBarValue( propsPlayer:GetKillstreak() / propsPlayer:GetBestKillstreak() )
	VGUI_KILLSTREAK.PaintOver = function( self, w, h )
		surface.SetFont( "props_HUDTextSmall" )
		local size_w, size_h = surface.GetTextSize( "Speed: " .. math.Round( propsPlayer:GetVelocity():Length(), 0 ) )

		draw.SimpleText( "Speed: " .. math.Round( propsPlayer:GetVelocity():Length(), 0 ), "props_HUDTextSmall", w / 10, h/2 - size_h/2, Color( 230, 230, 230, 255 ) )
		self:SetBarValue( propsPlayer:GetVelocity():Length() / 3500 )
	end
	
	local firstbarsizew, firstbarsizeh = VGUI_KILLSTREAK:GetSize()
	
	previoussizew, previoussizeh = VGUI_KILLSTREAK:GetSize()
	previousposx, previousposy = VGUI_KILLSTREAK:GetPos()
	
	VGUI_KD = vgui.Create( "props_horizontalbar" )
	VGUI_KD:SetParent( VGUI_BASECONTENT )
	VGUI_KD:SetPos( 5, previoussizeh + previousposy + 5 )
	VGUI_KD:SetSize( basesizew - 10, firstbarsizeh )
	VGUI_KD:SetBackColor( Color( 25, 25, 25, 255 ) )
		-- when there's 3 of them use this
	-----------------VGUI_KD:SetFillColor( Color( 60, 166, 255, 255 ) )
	VGUI_KD:SetFillColor( Color( 59, 59, 167, 255 ) )
	VGUI_KD:SetBarValue( propsPlayer:GetKD() )
	VGUI_KD.PaintOver = function( self, w, h )
		surface.SetFont( "props_HUDTextSmall" )
		local size_w, size_h = surface.GetTextSize( "KD Ratio: " .. propsPlayer:GetKD() )

		draw.SimpleText( "KD Ratio: " .. propsPlayer:GetKD(), "props_HUDTextSmall", w / 10, h/2 - size_h/2, Color( 230, 230, 230, 255 ) )
		self:SetBarValue( propsPlayer:GetKD() )
	end
	
	
	if IsValid( VGUI_PROPPANEL ) then
		VGUI_PROPPANEL:Remove()
		VGUI_PROPPANEL = nil
	end
	
	VGUI_PROPPANEL = vgui.Create( "DPanel" )
	VGUI_PROPPANEL:SetWide( VGUI_BASECONTENT:GetWide() - 80 )
	VGUI_PROPPANEL:SetTall( 25 )
	local basecontentpos_x, basecontentpos_y = VGUI_BASECONTENT:GetPos()
	VGUI_PROPPANEL:SetPos( basecontentpos_x + 40, basecontentpos_y - VGUI_PROPPANEL:GetTall() + 1 )
	VGUI_PROPPANEL:SetKeyboardInputEnabled( true )
	VGUI_PROPPANEL:ParentToHUD()
	VGUI_PROPPANEL.Paint = function( self, w, h )
		--draw.RoundedBox( 0, 0, 0, w, h, Color( 31, 31, 31, 235  ) )
		if not propsPlayer.LookingAtProp or not IsValid( propsPlayer.LookingAtProp ) then
			return
		end
		draw.RoundedBox( 0, 0, 0, w, h, Color( 47, 46, 46, 235 ) )
	end
	
	VGUI_PROPOWNER = vgui.Create( "DLabel" )
	VGUI_PROPOWNER:SetParent( VGUI_PROPPANEL )
	VGUI_PROPOWNER:SetText( "Owner: Shinycow" )
	VGUI_PROPOWNER:SetTextColor( Color( 230, 230, 230, 255 ) )
	VGUI_PROPOWNER:SetFont( "props_HUDTextSmall" )
	surface.SetFont( "props_HUDTextSmall" )
	local ownersize_w, ownersize_h = surface.GetTextSize( "Owner: Shinycow" )
	VGUI_PROPOWNER:SetPos( VGUI_PROPPANEL:GetWide() / 2 - ownersize_w / 2, VGUI_PROPPANEL:GetTall() / 2 - ownersize_h / 2 )
	VGUI_PROPOWNER:SetSize( ownersize_w, ownersize_h )
	VGUI_PROPOWNER.Think = function( self )
		if not propsPlayer.LookingAtProp or not IsValid( propsPlayer.LookingAtProp ) then
			self:SetText( "" )
			return
		end

		surface.SetFont( "props_HUDTextSmall" )
		
		local owner_text = "Owner:"

		local owner = propsPlayer.LookingAtProp:GetNetVar( "Owner" )
		if owner then
			owner_text = FixLongName( "Owner: " .. owner:Nick(), 22 )
		end
		
		local ownersize_w, ownersize_h = surface.GetTextSize( owner_text )
		
		self:SetText( owner_text )
		self:SetPos( VGUI_PROPPANEL:GetWide() / 2 - ownersize_w / 2, VGUI_PROPPANEL:GetTall() / 2 - ownersize_h / 2 ) 
		self:SetSize( ownersize_w, ownersize_h )
	end

end

local fullyLoaded = false
local function CreateIntroHUD()
	local timeToFade = 2
	local alphaCalc = 245
	local startFading = false
	local startFadeTime = 3.5
	
	local timetaken = 0
	local timetaken2 = 0
	timer.Create( "propsIntroHUDFade", startFadeTime, 1, function()
		startFading = true
		timetaken = SysTime()
	end )
	
	if IsValid( VGUI_BASECONTENT ) then
		VGUI_BASECONTENT:Remove()
		VGUI_BASECONTENT = nil
	end
	
	if IsValid( VGUI_introBackground ) then
		VGUI_introBackground:Remove()
		VGUI_introBackground = nil
	end

	VGUI_introBackground = vgui.Create( "DPanel" )
	VGUI_introBackground:SetPos( 0, 0 )
	VGUI_introBackground:SetSize( ScrW(), ScrH() )
	VGUI_introBackground:SetKeyboardInputEnabled( true )
	VGUI_introBackground:ParentToHUD()
	VGUI_introBackground.Paint = function( self, w, h )
		if startFading then 
			alphaCalc = math.Approach( alphaCalc, 0, (245 / timeToFade) * FrameTime())
				-- i cant do maths
			--alphaCalc = math.Approach( alphaCalc, 0, Lerp( (240 / timeToFade ) * FrameTime(), 1, 0 ) )
			--print( alphaCalc )
		end
		
		draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, alphaCalc ) )

		--[[if alphaCalc == 0 and timetaken2 == 0 then
			timetaken2 = SysTime()
			
			LocalPlayer():ChatPrint( "took " .. timetaken2 - timetaken .. " seconds" )
		end	]]
	end
	
	surface.SetFont( "props_HUDTextHuge" )
	local gmName_w, gmName_h = surface.GetTextSize( ( GM and GM.Name ) or GAMEMODE.Name )
	surface.SetFont( "props_HUDTextMedium" )
	local authorName_w, authorName_h = surface.GetTextSize( "Created by Shinycow" )
	
	VGUI_introGM = vgui.Create( "DLabel" )
	VGUI_introGM:SetParent( VGUI_introBackground )
	VGUI_introGM:SetPos( VGUI_introBackground:GetWide() / 2 - gmName_w / 2, ( VGUI_introBackground:GetTall() / 2 - (gmName_h - authorName_h) / 2 ) - (authorName_h + 20) )
	VGUI_introGM:SetFont( "props_HUDTextHuge" )
	VGUI_introGM:SetText( ( GM and GM.Name ) or GAMEMODE.Name )
	VGUI_introGM:SetTextColor( Color( 230, 230, 230, 255 ) )
	VGUI_introGM:SizeToContents()
	
	VGUI_introAuthor = vgui.Create( "DLabel" )
	VGUI_introAuthor:SetParent( VGUI_introBackground )
	VGUI_introAuthor:SetPos( VGUI_introBackground:GetWide() / 2 - authorName_w / 2, ( VGUI_introBackground:GetTall() / 2 - (gmName_h - authorName_h) / 2 ) + 10 )
	VGUI_introAuthor:SetFont( "props_HUDTextMedium" )
	VGUI_introAuthor:SetText( "Created by Shinycow" )
	VGUI_introAuthor:SetTextColor( Color( 230, 230, 230, 255 ) )
	VGUI_introAuthor:SizeToContents()
	
	local function CreatePropkillHUD()
		if alphaCalc == 0 and IsValid( VGUI_introBackground ) then
			CreateHUD()
			timer.Destroy( "CreatePropkillHUD" )
		end
	end
	timer.Create( "CreatePropkillHUD", 1, 0, function()
		CreatePropkillHUD()
	end )
	--[[timer.Create( "CreatePropkillHUD", timeToFade + startFadeTime + 0.2 , 3, function()
		if alphaCalc == 0 and IsValid( VGUI_introBackground ) then
			CreateHUD()
			timer.Destroy( "CreatePropkillHUD" )
		end
	end )]]
end

function props_ShowBattlingHUD()

	VGUI_BattleBack = vgui.Create( "DPanel" )
	--VGUI_BattleBack:SetSize( 680, 90 )
	VGUI_BattleBack:SetSize( math.ceil( ScrW() * GetUniversalSize( 680, 1440 ) ), 60 )
	VGUI_BattleBack:SetPos( ScrW() / 2 - VGUI_BattleBack:GetWide() / 2, 0 )
	VGUI_BattleBack:SetKeyboardInputEnabled( true )
	VGUI_BattleBack:ParentToHUD()
	VGUI_BattleBack.Paint = function( self, w, h )
		--draw.RoundedBox( 0, 0, 0, w, h, Color( 31, 31, 31, 235  ) )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 27, 26, 26, 235 ) )
		self:DrawBackgroundBlur( 4 )
	end
	
	local function createNameLabels( type )
		surface.SetFont( "props_HUDTextSmall" )
		_G[ "VGUI_" .. type .. "Name" ] = vgui.Create( "DLabel" )
		_G[ "VGUI_" .. type .. "Name" ].Sizew, _G[ "VGUI_" .. type .. "Name" ].Sizeh = surface.GetTextSize( PROPKILL.Battlers[ string.lower( type ) ] and PROPKILL.Battlers[ string.lower( type ) ]:Nick() or "N/A" )
		_G[ "VGUI_" .. type .. "Name" ]:SetFont( "props_HUDTextSmall" )
		if _G[ "VGUI_" .. type .. "Name" ].Sizew >= 240 then
			surface.SetFont( "props_HUDTextTiny" )
			_G[ "VGUI_" .. type .. "Name" ].Sizew, _G[ "VGUI_" .. type .. "Name" ].Sizeh = surface.GetTextSize( PROPKILL.Battlers[ string.lower( type ) ] and PROPKILL.Battlers[ string.lower( type ) ]:Nick() or "N/A" )
			_G[ "VGUI_" .. type .. "Name" ]:SetFont( "props_HUDTextTiny" )
		end
		_G[ "VGUI_" .. type .. "Name" ]:SetParent( _G[ "VGUI_" .. type .. "Panel" ] )
		_G[ "VGUI_" .. type .. "Name" ]:SetTextColor( color_white )
		_G[ "VGUI_" .. type .. "Name" ]:SetText( PROPKILL.Battlers[ string.lower( type ) ] and PROPKILL.Battlers[ string.lower( type ) ]:Nick() or "N/A" )
		_G[ "VGUI_" .. type .. "Name" ]:SetSize( _G[ "VGUI_" .. type .. "Name" ].Sizew, _G[ "VGUI_" .. type .. "Name" ].Sizeh )
		_G[ "VGUI_" .. type .. "Name" ]:SetPos( _G[ "VGUI_" .. type .. "Panel" ]:GetWide() / 2 - _G[ "VGUI_" .. type .. "Name" ].Sizew / 2, 5 )
	end
	
		-- todo: merge into one function
	local function createScoreLabels( type )
		surface.SetFont( "props_HUDTextHuge" )
		_G[ "VGUI_" .. type .. "Score" ] = vgui.Create( "DLabel" )
		local zeroks = "00" 
		if PROPKILL.Battlers[ string.lower( type ) ] then
			zeroks = PROPKILL.Battlers[ string.lower( type ) ]:GetKillstreak() < 10 and "0" .. PROPKILL.Battlers[ string.lower( type ) ]:GetKillstreak() or PROPKILL.Battlers[ string.lower( type ) ]:GetKillstreak()
		end
		_G[ "VGUI_" .. type .. "Score" ].Sizew, _G[ "VGUI_" .. type .. "Score" ].Sizeh = surface.GetTextSize( zeroks )
		_G[ "VGUI_" .. type .. "Score" ]:SetParent( _G[ "VGUI_" .. type .. "Panel" ] )
		_G[ "VGUI_" .. type .. "Score" ]:SetTextColor( color_white )
		_G[ "VGUI_" .. type .. "Score" ]:SetFont( "props_HUDTextHuge" )
		_G[ "VGUI_" .. type .. "Score" ]:SetSize( _G[ "VGUI_" .. type .. "Score" ].Sizew, _G[ "VGUI_" .. type .. "Score" ].Sizeh )
		_G[ "VGUI_" .. type .. "Score" ]:SetPos( _G[ "VGUI_" .. type .. "Panel" ]:GetWide() / 2 - _G[ "VGUI_" .. type .. "Score" ].Sizew / 2, _G[ "VGUI_" .. type .. "Panel" ]:GetTall() - (_G[ "VGUI_" .. type .. "Score" ].Sizeh + 1) + 3 )
		_G[ "VGUI_" .. type .. "Score" ].Think = function()
			if not zeroks then return end
			
			if PROPKILL.Battlers[ string.lower( type ) ] then
				zeroks = PROPKILL.Battlers[ string.lower( type ) ]:GetKillstreak() < 10 and "0" .. PROPKILL.Battlers[ string.lower( type ) ]:GetKillstreak() or PROPKILL.Battlers[ string.lower( type ) ]:GetKillstreak()
			end
			surface.SetFont( "props_HUDTextHuge" )
			_G[ "VGUI_" .. type .. "Score" ].Sizew, _G[ "VGUI_" .. type .. "Score" ].Sizeh = surface.GetTextSize( zeroks )
			_G[ "VGUI_" .. type .. "Score" ]:SetText( zeroks )
			_G[ "VGUI_" .. type .. "Score" ]:SetSize( _G[ "VGUI_" .. type .. "Score" ].Sizew, _G[ "VGUI_" .. type .. "Score" ].Sizeh )
			_G[ "VGUI_" .. type .. "Score" ]:SetPos( _G[ "VGUI_" .. type .. "Panel" ]:GetWide() / 2 - _G[ "VGUI_" .. type .. "Score" ].Sizew / 2, _G[ "VGUI_" .. type .. "Panel" ]:GetTall() - (_G[ "VGUI_" .. type .. "Score" ].Sizeh + 1) + 3 )
		end
	end
	
	
	VGUI_InviterPanel = vgui.Create( "DPanel" )
	VGUI_InviterPanel:SetParent( VGUI_BattleBack )
	VGUI_InviterPanel:SetSize( (VGUI_BattleBack:GetWide() / 3) - 15, VGUI_BattleBack:GetTall() )
	--VGUI_InviterPanel:SetPos( 0, 0 )
	VGUI_InviterPanel:Dock( LEFT )
	VGUI_InviterPanel.Paint = function() end

	createNameLabels( "Inviter" )
	createScoreLabels( "Inviter" )
	
	VGUI_InviteePanel = vgui.Create( "DPanel" )
	VGUI_InviteePanel:SetParent( VGUI_BattleBack )
	VGUI_InviteePanel:SetSize( (VGUI_BattleBack:GetWide() / 3) - 15, VGUI_BattleBack:GetTall() )
	--VGUI_InviteePanel:SetPos( VGUI_BattleBack:GetWide() - VGUI_InviteePanel:GetWide(), 0 )
	VGUI_InviteePanel:Dock( RIGHT )
	VGUI_InviteePanel.Paint = function() end

	createNameLabels( "Invitee" )
	createScoreLabels( "Invitee" )
	
	
	VGUI_CountdownPanel = vgui.Create( "DPanel" )
	VGUI_CountdownPanel:SetParent( VGUI_BattleBack )
	VGUI_CountdownPanel:SetSize( (VGUI_BattleBack:GetWide() / 3) + 15, VGUI_BattleBack:GetTall() )
	VGUI_CountdownPanel:Dock( FILL )
	
	surface.SetFont( "props_HUDTextLarge" )
	VGUI_CountdownText = vgui.Create( "DLabel" )
	VGUI_CountdownText.Sizew, VGUI_CountdownText.Sizeh = surface.GetTextSize( "Time Remaining" )
	VGUI_CountdownText:SetFont( "props_HUDTextLarge" )
	VGUI_CountdownText:SetParent( VGUI_CountdownPanel )
	VGUI_CountdownText:SetTextColor( Color( 90, 90, 90, 255 ) )
	VGUI_CountdownText:SetText( "Time Remaining" )
	VGUI_CountdownText:SetSize( VGUI_CountdownText.Sizew, VGUI_CountdownText.Sizeh )
	VGUI_CountdownText:SetPos( VGUI_CountdownPanel:GetWide() / 2 - VGUI_CountdownText.Sizew / 2 + 5, -2 )
	--[[VGUI_CountdownText.Think = function()
		if VGUI_Countdowntext:GetText() != "Time Remaining" and not PROPKILL.BattlePaused then
			surface.SetFont( "props_HUDTextLarge" )
			VGUI_CountdownText.Sizew, VGUI_CountdownText.Sizeh = surface.GetTextSize( "Time Remaining" )
			VGUI_CountdownText:SetFont( "props_HUDTextLarge" )
			
			VGUI_CountdownText:SetSize( VGUI_CountdownText.Sizew, VGUI_CountdownText.Sizeh )
			VGUI_CountdownText:SetPos( VGUI_CountdownPanel:GetWide() / 2 - VGUI_CountdownText.Sizew / 2 + 5, -2 )
		else]]
			
	
	VGUI_CountdownTimer = vgui.Create( "DLabel" )
	VGUI_CountdownTimer.Sizew, VGUI_CountdownTimer.Sizeh = surface.GetTextSize( string.ToMinutesSeconds( PROPKILL.BattleTime ) )
	VGUI_CountdownTimer:SetFont( "props_HUDTextLarge" )
	VGUI_CountdownTimer:SetParent( VGUI_CountdownPanel )
	VGUI_CountdownTimer:SetTextColor( Color( 90, 90, 90, 255 ) )
	VGUI_CountdownTimer:SetText( string.ToMinutesSeconds( PROPKILL.Config[ "battle_time" ].default * 60 ) )
	VGUI_CountdownTimer:SetSize( VGUI_CountdownTimer.Sizew, VGUI_CountdownTimer.Sizeh )
	VGUI_CountdownTimer:SetPos( VGUI_CountdownPanel:GetWide() / 2- VGUI_CountdownTimer.Sizew / 2 + 5, VGUI_CountdownPanel:GetTall() - VGUI_CountdownTimer.Sizeh )
	VGUI_CountdownTimer.Think = function()
		surface.SetFont( "props_HUDTextLarge" )
		VGUI_CountdownTimer.Sizew, VGUI_CountdownTimer.Sizeh = surface.GetTextSize( string.ToMinutesSeconds( PROPKILL.BattleTime ) )
		VGUI_CountdownTimer:SetText( string.ToMinutesSeconds( PROPKILL.BattleTime ) )
		VGUI_CountdownTimer:SetSize( VGUI_CountdownTimer.Sizew, VGUI_CountdownTimer.Sizeh )
		VGUI_CountdownTimer:SetPos( VGUI_CountdownPanel:GetWide() / 2 - VGUI_CountdownTimer.Sizew / 2 + 5, VGUI_CountdownPanel:GetTall() - VGUI_CountdownTimer.Sizeh)
	end
	
end

function props_HideBattlingHUD()
	if not IsValid( VGUI_BattleBack ) then return end
	VGUI_BattleBack:Remove()
	VGUI_BattleBack = nil
end

hook.Add( "OnReloaded", "props_RedrawHUD", function()
	--CreateIntroHUD()
	CreateHUD( true )
end )

hook.Add( "Initialize", "props_DrawHUD", function()
	timer.Simple( 1, function()
		CreateIntroHUD()
	
		--CreateHUD()
	end )
end )