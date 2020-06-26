--[[
				  _________.__    .__                                  
				 /   _____/|  |__ |__| ____ ___.__. ____  ______  _  __
				 \_____  \ |  |  \|  |/    <   |  |/ ___\/  _ \ \/ \/ /
				 /        \|   Y  \  |   |  \___  \  \__(  <_> )     / 
				/_______  /|___|  /__|___|  / ____|\___  >____/ \/\_/  
						\/      \/        \/\/         \/              

		Shared configuration file used throughout the gamemode.
]]--

	
--[[

*

* Configurables. These can all be modified in-game.

* Don't change unless you want to break something.

*

--]]

AddConfigItem( "dead_spawnprops",
	{
	Name = "Dead Spawning",
	Category = "Player Deaths",
	default = false,
	type = "boolean",
	desc = "Toggle dead players spawning props.",
	}
)

AddConfigItem( "dead_removeprops",
	{
	Name = "Dead Removing",
	Category = "Player Deaths",
	default = true,
	type = "boolean",
	desc = "Toggle removing dead player's props.",
	--[[func = function( pl, new )
		if not SERVER then return end
		
		if new == true then	
			for k,v in pairs( ents.GetAll() ) do
				
				if v:GetClass() == "prop_physics" then
					if v.Owner and IsValid(v.Owner) and not v.Owner:Alive() then
					
						v:Remove()
					
					end
				end
			
			end
		end
	end,]]
	}
)

AddConfigItem( "dead_removepropsdelay",
	{
	Name = "Dead Removing Delay",
	Category = "Player Deaths",
	default = 0,
	type = "integer",
	desc = "How long after a player's death until removal of their props.",
	}
)

AddConfigItem( "dead_respawndelay",
	{
	Name = "Respawn delay",
	Category = "Player Deaths",
	default = 0.1,
	min = 0,
	max = 60,
	decimals = 2,
	type = "integer",
	desc = "How long until dead players can respawn",
	}
)

AddConfigItem( "topplayers",
	{
	Name = "Top Players",
	Category = "Misc",
	default = 10,
	min = 0,
	max = 50,
	type = "integer",
	desc = "Limits the amount of top players there are.",
	}
)

AddConfigItem( "topprops",
	{
	Name = "Top Props",
	Category = "Misc",
	default = 15,
	min = 0,
	max = 50,
	type = "integer",
	desc = "Limits the amount of top props there are.",
	}
)

AddConfigItem( "blockedmodels",
	{
	Name = "Block Blacklisted Models",
	Category = "Misc",
	default = true,
	type = "boolean",
	desc = "Toggle spawning blocked models.",
	}
)

AddConfigItem( "battle_defaultkills",
	{
	Name = "Battle Default Kills",
	Category = "Battling",
	default = 10,
	min = 1,
	max = 100,
	type = "integer",
	desc = "Default kills to end the fight if player doesn't supply chosen amount.",
	}
)

AddConfigItem( "battle_minkills",
	{
	Name = "Battle Min Kills",
	Category = "Battling",
	default = 5,
	min = 3,
	max = 10,
	type = "integer",
	desc = "Minimum amount of kills a player can choose to fight.",
	}
)

AddConfigItem( "battle_maxkills",
	{
	Name = "Battle Max Kills",
	Category = "Battling",
	default = 15,
	min = 10,
	max = 30,
	type = "integer",
	desc = "Maximum amount of kills a player can choose to fight.",
	}
)

AddConfigItem( "battle_defaultprops",
	{
	Name = "Battle Default Prop Limit",
	Category = "Battling",
	default = 3,
	min = 1,
	max = 5,
	type = "integer",
	desc = "Default prop limit to use if player doesn't choose one.",
	}
)

AddConfigItem( "battle_minprops",
	{
	Name = "Battle Min Props",
	Category = "Battling",
	default = 1,
	min = 1, 
	max = 3,
	type = "integer",
	desc = "Minimum prop limit a player can choose to fight with.",
	}
)

AddConfigItem( "battle_maxprops",
	{
	Name = "Battle Max Props",
	Category = "Battling",
	default = 5,
	min = 3,
	max = 5,
	type = "integer",
	desc = "Maximum prop limit a player can choose to fight with.",
	}
)

AddConfigItem( "battle_time",
	{
	Name = "Battle Time",
	Category = "Battling",
	default = 7.5,
	min = 2,
	max = 15,
	type = "integer",
	desc = "How long the battle should last in minutes",
	}
)

AddConfigItem( "battle_pausetime",
	{
	Name = "Battle Pause Time",
	Category = "Battling",
	default = 20,
	min = 5,
	max = 120,
	type = "integer",
	desc = "How long a battle pause should last in seconds",
	}
)

AddConfigItem( "battle_maxpauses",
	{
	Name = "Battle Max Pauses",
	Category = "Battling",
	default = 2,
	min = 0,
	max = 100,
	type = "integer",
	desc = "How many times a player can pause the fight",
	}
)

--[[AddConfigItem( "battle_timespecified",
	{
	Name = "Battle Time Specifiable",
	Category = "Battling",
	default = true,
	type = "boolean",
	desc = "Allow players to select a time limit.",
	}
)

AddConfigItem( "battle_timespecifiedmin",
	{
	Name = "Battle Time Specifiable Max Time",
	Category = "Battling",
	default = 15,
	min = 5,
	max = 20,
	type = "integer",
	desc = "How long players can select the battle to last for at maximum",
	}
)]]

AddConfigItem( "battle_cooldown",
	{
	Name = "Battle Cooldown",
	Category = "Battling", 
	default = 2 * 60,
	min = 10,
	max = 15 * 60,
	type = "integer",
	desc = "How long after a battle until a player can start a new one",
	}
)

AddConfigItem( "battle_invitecooldown",
	{
	Name = "Battle Invite Cooldown",
	Category = "Battling",
	default = 30,
	min = 5,
	max = 5 * 60,
	type = "integer",
	desc = "How long after a player sent a battle request can he send another",
	}
)

AddConfigItem( "removedoors",
	{
	Name = "Remove Doors",
	Category = "Misc",
	default = nil,
	type = "button",
	desc = "Removes all doors on the map.",
	func = function( pl )
		if not SERVER then return end
		
		for k,v in pairs( ents.GetAll() ) do
		
			local class = v:GetClass()
			
			if class == "func_door"
			or class == "prop_door_rotating" 
			or class == "func_door_rotating" then
				
				v:Remove()
				
			end
			
		end
	end,
	}
)

AddConfigItem( "respawndoors",
	{
	Name = "Respawn Doors",
	Category = "Misc",
	default = nil,
	type = "button",
	desc = "Respawns all doors on the map.",
	func = function( pl )
		if not SERVER then return end
		
		for k,v in pairs( PROPKILL.StoredEntities or {} ) do
			--print( k )
			if v.Class == "func_door" or v.Class == "prop_door_rotating" 
			or v.Class == "func_door_rotating" and util.IsValidModel( v.Model ) then
				local ent = ents.Create( v.Class )
				ent:SetModel( v.Model )
				ent:SetPos( v.Pos )
				ent:SetAngles( v.Angles )
				ent:Spawn()
				ent:Activate()
			end
		end
		
		PROPKILL.StoredEntities = {}
	end,
	}
)