--[[
	-- title, options, callback, time
	ulx.doVote( "AIDS", {"yes", "no"}, function( res ) PrintTable( res ) end, 10 )
]]
if not ulx then return end
	--ulx.doVote( "AIDS", {"yes", "no"}, function( res ) PrintTable( res ) end, 10 )
	--ulx.doVote( "Remove Prop Dormancy for 10 minutes?", {"yes", "no"}, function( res ) PrintTable( res ) end, 15 )

	--res:
	
	--	args:
	--	callback = functionxfdsf
	--	options:
	--		1: yes
	--		2: no
	--	results:
	--		1: 0		( 1 is yes, value is how many votes )
	--		2: 1		( 2 is no, value is how many votes )
	--	title: Remove Prop Dormancy for 10 minutes?
	--	voters: 1
	--	votes: 1

local CATEGORY_NAME = "Voting"

pkLastVoteDormancy = pkLastVoteDormancy or nil

function ulx.pkVoteDormancy( calling_ply )
	if #player.GetAll() < 2 then return end
	if PROPKILL.Battling then return end
	if PROPKILL.BattlePropsDormant != nil and not PROPKILL.BattlePropsDormant then
		calling_ply:Notify( 1, 4, "Prop dormancy is already turned off!" )
		return
	end
	if ulx.voteInProgress then
		calling_ply:Notify( 1, 4, "There is already a vote!" )
		return 
	end
	if pkLastVoteDormancy and pkLastVoteDormancy > CurTime() then
		calling_ply:Notify( 1, 4, "A vote was recently had. Wait " .. math.Round( pkLastVoteDormancy - CurTime() ) .. " seconds" )
		return
	end
	
	local function TurnOnDormancy()
		PROPKILL.BattlePropsDormant = true
		timer.Create( "props_turnoffpropdormancy", 60 * 10, 1, function()
			PROPKILL.BattlePropsDormant = false
		end )
	end
	
	ulx.doVote( "Prop Dormancy for 10 minutes?", {"yes", "no"}, function( res ) 
		if res.results[ 1 ] and not res.results[ 2 ] then
			ChatPrint( "yes won (1)" )
			TurnOnDormancy()
		elseif res.results[ 1 ] and res.results[ 2 ] then
			if res.results[ 1 ] / (res.results[ 1 ] + res.results[ 2 ]) >= 0.70 then
				ChatPrint( "yes won (2)" )
				TurnOnDormancy()
			else
				ChatPrint( "no won" )
			end
		else
			ChatPrint( "no won (2)" )
		end
	end, 15 )
	
	pkLastVoteDormancy = CurTime() + 180
	ulx.fancyLogAdmin( calling_ply, "#A started a vote for prop dormancy" )
end
local pkVoteDormancy = ulx.command( CATEGORY_NAME, "ulx votedormancy", ulx.pkVoteDormancy, "!votedormancy" )
pkVoteDormancy:defaultAccess( ULib.ACCESS_ALL )
pkVoteDormancy:help( "Starts a vote to turn on prop dormancy for 10 minutes." )