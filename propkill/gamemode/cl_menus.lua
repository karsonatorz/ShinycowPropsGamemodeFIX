--[[
				  _________.__    .__                                  
				 /   _____/|  |__ |__| ____ ___.__. ____  ______  _  __
				 \_____  \ |  |  \|  |/    <   |  |/ ___\/  _ \ \/ \/ /
				 /        \|   Y  \  |   |  \___  \  \__(  <_> )     / 
				/_______  /|___|  /__|___|  / ____|\___  >____/ \/\_/  
						\/      \/        \/\/         \/              

		clientside menu related things
]]--

concommand.Add( "props_menu", function()
	if IsValid( props_Menu ) then
		props_Menu:Remove()
		props_Menu = nil
		--gui.EnableScreenClicker( false )
	else
		props_Menu = vgui.Create( "props_MainMenu" )
	end
end )

hook.Add( "Move", "props_MenuDetectKeys", function()
	if IsValid( props_Menu ) then
		if input.WasKeyPressed( KEY_F2 ) or input.WasKeyPressed( KEY_F4 ) then	
			RunConsoleCommand( "props_menu" )
		end
	elseif input.WasKeyPressed( KEY_F3 ) then
		if not LocalPlayer().fightInvites or not LocalPlayer().fightInvites[ 1 ] then
			LocalPlayer().propClicker = false
			gui.EnableScreenClicker( false )
		else
			LocalPlayer().propClicker = not (LocalPlayer().propClicker or false)
			gui.EnableScreenClicker( LocalPlayer().propClicker )
		end
	end
end )

net.Receive( "props_FightInvite", function()
	local userid = net.ReadUInt( 10 )
	local name = net.ReadString()
	local killamt = net.ReadUInt( 4 )
	local propamt = net.ReadUInt( 4 )
	local funfight = net.ReadBit()
	
	LocalPlayer().fightInvites = LocalPlayer().fightInvites or {}
	
	local invite = vgui.Create( "props_BattleInvitation" )
	invite:SetInformation( userid, name, killamt, propamt, funfight, 15 )
	
	LocalPlayer().fightInvites[ #LocalPlayer().fightInvites + 1 ] = invite
	
	local oldinvite = LocalPlayer().fightInvites[ #LocalPlayer().fightInvites - 1 ]
	if not oldinvite then  return end
	
	local oldpos_x, oldpos_y = oldinvite:GetPos()
	
	invite:SetPos( 3, invite:GetTall() + oldpos_y + 3 )
end )

net.Receive( "props_FightResults", function()
	local battler1 = net.ReadTable()
	local battler2 = net.ReadTable()
	local winner = net.ReadString()
	local score = net.ReadString()
	local time = net.ReadString()
	
	local results = vgui.Create( "props_BattleResults" )
	results:SetInformation( battler1, battler2, winner, score, time )
end )
	

concommand.Add( "props_fightinvite", function()
	LocalPlayer().fightInvites = LocalPlayer().fightInvites or {}
	
	local invite = vgui.Create( "props_BattleInvitation" )
	
	LocalPlayer().fightInvites[ #LocalPlayer().fightInvites + 1 ] = invite
	
	local oldinvite = LocalPlayer().fightInvites[ #LocalPlayer().fightInvites - 1 ]
	if not oldinvite then /*print("aw")*/ return end
	
	local oldpos_x, oldpos_y = oldinvite:GetPos()
	
	invite:SetPos( 3, invite:GetTall() + oldpos_y + 3 )
	
	
	--props_fightinvite = vgui.Create( "props_BattleInvitation" )
end )

concommand.Add("props_showfight", function()
	if PROPKILL.Battling then return end

	props_ShowBattlingHUD()
end)
concommand.Add("props_endfight", function()
	PROPKILL.Battling = false
	PROPKILL.BattlePaused = false
	PROPKILL.BattleTime = 0
	timer.Destroy( "props_Battlecountdown" )
	timer.Destroy( "destroypausetimer" )
	props_HideBattlingHUD()
end)

concommand.Add( "props_fightresults", function()
	if SHOWRESULTS then
		SHOWRESULTS:Remove()
		SHOWRESULTS = nil
	else
		SHOWRESULTS = vgui.Create( "props_BattleResults" )
	end
end )