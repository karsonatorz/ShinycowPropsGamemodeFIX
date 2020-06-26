--[[
				  _________.__    .__                                  
				 /   _____/|  |__ |__| ____ ___.__. ____  ______  _  __
				 \_____  \ |  |  \|  |/    <   |  |/ ___\/  _ \ \/ \/ /
				 /        \|   Y  \  |   |  \___  \  \__(  <_> )     / 
				/_______  /|___|  /__|___|  / ____|\___  >____/ \/\_/  
						\/      \/        \/\/         \/              

		Hooks created for this gamemode
]]--

--[[

*

* Clientside player death

*

--]]

net.Receive( "props_NetworkPlayerKill", function()
	local dead = net.ReadEntity()
	local killer = net.ReadEntity()
		-- smash / longshot / flyby
	local kill_type = net.ReadString()
	
	hook.Call( "OnPlayerKilled", nil, dead, killer, kill_type )
end )

--[[
	EXAMPLE USES:
		Writing a clientside kill system to track how many people you have killed
		and by what type.
		
		The above is possible without this by using gameevent.Listen( "player_death" ),
		however it is a lot easier this way.
	

	EXAMPLE CODE:
	
		hook.Add( "OnPlayerKilled", "example", function( plDead, plKiller, sType )
			print( plDead:Nick() .. " was killed by " .. plKiller:Nick() .. " with type " .. sType )
		end )
]]--

function GM:OnPlayerKilled( dead, killer, kill_type )
	if dead != killer then
		killer:SetTotalFrags( killer:TotalFrags() + 1 )
	end
	dead:SetTotalDeaths( dead:TotalDeaths() + 1 )
end

--[[

*

* Configuration Settings

*

--]]
net.Receive( "props_UpdateConfig", function()
	local setting = net.ReadString()
		-- if nothing it is ""
	local new_value = net.ReadString()
	local setting_type = net.ReadString()
	
	if new_value == "" then return end
	
	if setting_type == "integer" then
		PROPKILL.Config[ setting ].default = tonumber( new_value )
	elseif setting_type == "boolean" then
		PROPKILL.Config[ setting ].default = tobool( new_value )
	end
end )

net.Receive( "props_UpdateFullConfig", function()
		-- done for when player first joins to ensure they get updated settings
	PROPKILL.Config = net.ReadTable()
end )

net.Receive( "props_SendRecentBattles", function()
	PROPKILL.RecentBattles = net.ReadTable()
end )

	-- all these timers are ugly. was done in a test. need to fix.
net.Receive( "props_BattleInit", function()
	local battler1 = net.ReadEntity()
	local battler2 = net.ReadEntity()
	local playsound = net.ReadUInt( 2 )
	local battletime = net.ReadFloat()
	local extension = net.ReadFloat()
	
	PROPKILL.Battling = true
	PROPKILL.Battlers[ "inviter" ] = battler1
	PROPKILL.Battlers[ "invitee" ] = battler2
	
	local counttostart = 0.8
	
	if playsound == 1 then
		for i=0,1 do
			timer.Simple( 0.008 * i, function()
				surface.PlaySound("vo/k_lab/kl_initializing.wav")
			end )
		end
		hook.Add("HUDPaint", "propkill_BattleInit", function()
			draw.SimpleText( "Prepare to Battle", "ScoreboardDefaultTitle", (ScrW() * 0.5) - ( surface.GetTextSize( "Preparing Battle...", "ScoreboardDefaultTitle" ) * 0.5), ScrH() * 0.3, color_white, 0, 0 )
		end)
		timer.Simple(4.8, function()
			hook.Remove("HUDPaint", "propkill_BattleInit")
		end)
		
		counttostart = 4.8
	end
	
	if not timer.Exists( "props_Battlecountdown" ) then
		PROPKILL.BattleTime = battletime > 0 and battletime or ( (PROPKILL.Config[ "battle_time" ].default * 60) + extension )
	end

	timer.Simple( counttostart, function()
		timer.Create( "props_Battlecountdown", 1, battletime > 0 and battletime or PROPKILL.BattleTime, function()
			PROPKILL.BattleTime = PROPKILL.BattleTime - 1
		end )
	end )
	props_ShowBattlingHUD()
end)

net.Receive( "props_EndBattle", function()
	PROPKILL.Battling = false
	PROPKILL.BattlePaused = false
	PROPKILL.BattleTime = 0
	timer.Destroy( "props_Battlecountdown" )
	timer.Destroy( "destroypausetimer" )
	
	props_HideBattlingHUD()
end )

net.Receive( "props_StopResumeBattle", function()
	local resume = net.ReadUInt( 2 )

	if not resume or resume == 0 then
		PROPKILL.BattlePaused = true
		PROPKILL.BattlePauseRemaining = PROPKILL.Config[ "battle_pausetime" ].default
		timer.Create( "destroypausetimer", 1, PROPKILL.BattlePauseRemaining, function()
			PROPKILL.BattlePauseRemaining = PROPKILL.BattlePauseRemaining - 1
		end )
		timer.Stop( "props_Battlecountdown" )
		hook.Call( "props_BattlePaused", GAMEMODE, nil )
	else
		PROPKILL.BattlePaused = false
		timer.Destroy( "destroypausetimer" )
		timer.Start( "props_Battlecountdown" )
		hook.Call( "props_BattleResumed", GAMEMODE, nil )
	end
end )

hook.Add( "props_BattlePaused", "changeshithere", function()
	if IsValid( VGUI_CountdownText ) then
		surface.SetFont( "props_HUDTextLarge" )
		VGUI_CountdownText.Sizew, VGUI_CountdownText.Sizeh = surface.GetTextSize( "Battle Paused" )
		VGUI_CountdownText:SetFont( "props_HUDTextLarge" )
		VGUI_CountdownText:SetText( "Battle Paused" )	
		VGUI_CountdownText:SetSize( VGUI_CountdownText.Sizew, VGUI_CountdownText.Sizeh )
		VGUI_CountdownText:SetPos( VGUI_CountdownPanel:GetWide() / 2 - VGUI_CountdownText.Sizew / 2 + 5, -2 )
		
		VGUI_CountdownTimer.Sizew, VGUI_CountdownTimer.Sizeh = surface.GetTextSize( string.ToMinutesSeconds( PROPKILL.BattlePauseRemaining ) )
		VGUI_CountdownTimer:SetFont( "props_HUDTextLarge" )
		VGUI_CountdownTimer:SetText( string.ToMinutesSeconds( PROPKILL.Config[ "battle_time" ].default ) )
		VGUI_CountdownTimer:SetSize( VGUI_CountdownTimer.Sizew, VGUI_CountdownTimer.Sizeh )
		VGUI_CountdownTimer:SetPos( VGUI_CountdownPanel:GetWide() / 2- VGUI_CountdownTimer.Sizew / 2 + 5, VGUI_CountdownPanel:GetTall() - VGUI_CountdownTimer.Sizeh )
		VGUI_CountdownTimer.Think = function()
			surface.SetFont( "props_HUDTextLarge" )
			VGUI_CountdownTimer.Sizew, VGUI_CountdownTimer.Sizeh = surface.GetTextSize( string.ToMinutesSeconds( PROPKILL.BattlePauseRemaining ) )
			VGUI_CountdownTimer:SetText( string.ToMinutesSeconds( PROPKILL.BattlePauseRemaining ) )
			VGUI_CountdownTimer:SetSize( VGUI_CountdownTimer.Sizew, VGUI_CountdownTimer.Sizeh )
			VGUI_CountdownTimer:SetPos( VGUI_CountdownPanel:GetWide() / 2 - VGUI_CountdownTimer.Sizew / 2 + 5, VGUI_CountdownPanel:GetTall() - VGUI_CountdownTimer.Sizeh)
		end
	end
end )

hook.Add( "props_BattleResumed", "changeshithere", function()
	if IsValid( VGUI_CountdownText ) then
		surface.SetFont( "props_HUDTextLarge" )
		VGUI_CountdownText.Sizew, VGUI_CountdownText.Sizeh = surface.GetTextSize( "Time Remaining" )
		VGUI_CountdownText:SetFont( "props_HUDTextLarge" )
		VGUI_CountdownText:SetText( "Time Remaining" )	
		VGUI_CountdownText:SetSize( VGUI_CountdownText.Sizew, VGUI_CountdownText.Sizeh )
		VGUI_CountdownText:SetPos( VGUI_CountdownPanel:GetWide() / 2 - VGUI_CountdownText.Sizew / 2 + 5, -2 )

		VGUI_CountdownTimer.Sizew, VGUI_CountdownTimer.Sizeh = surface.GetTextSize( string.ToMinutesSeconds( PROPKILL.BattleTime ) )
		VGUI_CountdownTimer:SetFont( "props_HUDTextLarge" )
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
end )

/*
		START STEAL FROM DeathZone (uh oh)
*/

local MessageCache = {}
local MessageFastRemove = false
local addmaterial = Material( "icon16/add.png", "nocull" )
local function DrawMessageCache()
	for i, v in next, MessageCache do

		if v.goingUp then
			local amount = 255 / 30
			if v.alpha + amount <= 255 then
				v.alpha = v.alpha + amount
			else
				v.alpha = 255
			end
		else
			local amount = 255 / ( MessageFastRemove and 120 or 100 )
			v.alpha = v.alpha - amount
			if v.alpha <= 0 then
				v.alpha = 0
			end
		end

		if CurTime() >= v.time + ( MessageFastRemove and 1.2 or 1.8 ) then
			v.goingUp = false
		end

		if not v.goingUp and v.alpha <= 0 then
			table.remove(MessageCache, i)
		end

		local targetY
		if v.goingUp then
			targetY = -(i * 20)
			v.y = v.y + ((targetY - v.y) / 20)

			targetX = 30
			v.x = v.x + ((targetX - v.x) / 40)
		else
			targetY = 200
			v.y = v.y + ((targetY - v.y) / 80)

			targetX = -100
			v.x = v.x + ((targetX - v.x) / 60)
		end

		surface.SetMaterial( addmaterial )
		surface.SetDrawColor(Color(255, 255, 255, v.alpha))
		surface.DrawTexturedRect(10 + v.x, (ScrH() / 2) + v.y - 8, 16, 16)
		draw.SimpleTextOutlined(v.data.text, "Trebuchet18", 30 + v.x, (ScrH() / 2) + v.y, Color(v.data.col.r, v.data.col.g, v.data.col.b, v.alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(v.data.col.r / 2, v.data.col.g / 2, v.data.col.b / 2, v.alpha / 2))
	end
	
	if #MessageCache > 60 then
		MessageCache = {}
	end
	
	if #MessageCache > 16 then
		--table.remove(MessageCache, 1)
		--for i=#MessageCache - 5,#MessageCache do
		for i=1,5 do
			if MessageCache[ i ] then
				MessageCache[ i ].goingup = false
			end
			--MessageCache[ i ].alpha = math.min( MessageCache[ i ].alpha, 40 )
		end
		MessageFastRemove = true
	else
		MessageFastRemove = false
	end
end

hook.Add("HUDPaint", "PK_DrawMessageCache", DrawMessageCache)
net.Receive("PK_HUDMessage", function()
	local data_string = net.ReadString()
	local data_int1 = net.ReadUInt( 8 )
	local data_int2 = net.ReadUInt( 8 )
	local data_int3 = net.ReadUInt( 8 )
	surface.PlaySound("buttons/lightswitch2.wav")

	for k, v in next, MessageCache do
		v.time = v.time + 0.8
	end

	MessageCache[ #MessageCache + 1 ] = {data = {text = data_string, col = Color(data_int1,data_int2,data_int3,255)}, x = 0, y = 0, goingUp = true, time = CurTime(), alpha = 0}
end)

/*
		END STEAL FROM DeathZone
*/

local savedURLs = {}
	-- url = length, obj
function props_GetSavedURLs()
	return savedURLs
end

function props_PlaySoundURL( url )
	if savedURLs[ url ] then
		savedURLs[ url ].obj:SetTime( 0 )
		savedURLs[ url ].obj:Play()
	else
		sound.PlayURL( url, "noblock", function( snd ) savedURLs[ url ] = { length = snd:GetLength(), obj = snd } end )
	end
end

net.Receive( "props_PlaySoundURL", function()
	local url = net.ReadString()
	
	props_PlaySoundURL( url )
end )