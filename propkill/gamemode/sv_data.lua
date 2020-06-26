--[[
				  _________.__    .__                                  
				 /   _____/|  |__ |__| ____ ___.__. ____  ______  _  __
				 \_____  \ |  |  \|  |/    <   |  |/ ___\/  _ \ \/ \/ /
				 /        \|   Y  \  |   |  \___  \  \__(  <_> )     / 
				/_______  /|___|  /__|___|  / ____|\___  >____/ \/\_/  
						\/      \/        \/\/         \/              

		Saving and Loading of player data
]]--

local _R = debug.getregistry()

function _R.Player:SavePropkillData()
	local steamid = string.gsub( self:SteamID(), ":", "_" )
	
	local data = 
	{
	self:TotalFrags(),
	self:TotalDeaths(),
	
	self:GetFlybys(),
	self:GetLongshots(),
	self:GetHeadsmash(),
	
	self:GetBestKillstreak(),
	self:GetBestDeathstreak(),
	
	self:GetFightsWon(),
	self:GetFightsLost()
	}
	
	file.Write( "props/" .. steamid .. ".txt", pon.encode( data ) )
end


local dataset =
{
_R.Player.SetTotalFrags,
_R.Player.SetTotalDeaths,

_R.Player.SetFlyby,
_R.Player.SetLongshot,
_R.Player.SetHeadsmash,

_R.Player.SetBestKillstreak,
_R.Player.SetBestDeathstreak,

_R.Player.SetFightsWon,
_R.Player.SetFightsLost,
}

function _R.Player:LoadPropkillData()
	local steamid = string.gsub( self:SteamID(), ":", "_" )
	
	if file.Exists( "props/" .. steamid .. ".txt", "DATA" ) then
		
		local data = pon.decode( file.Read( "props/" .. steamid .. ".txt", "DATA" ) )
		
		for i=1,#dataset do
			if not data[ i ] then
				print( [[ERROR LOADING PLAYER DATA: ]] .. self:Nick() .. [[ (]] .. self:SteamID() .. [[ )
				            Couldn't load number ]] .. i )
				return
			end
			
			dataset[ i ]( self, data[ i ] )
		end

	end
end
