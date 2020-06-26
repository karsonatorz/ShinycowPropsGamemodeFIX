--[[
				  _________.__    .__                                  
				 /   _____/|  |__ |__| ____ ___.__. ____  ______  _  __
				 \_____  \ |  |  \|  |/    <   |  |/ ___\/  _ \ \/ \/ /
				 /        \|   Y  \  |   |  \___  \  \__(  <_> )     / 
				/_______  /|___|  /__|___|  / ____|\___  >____/ \/\_/  
						\/      \/        \/\/         \/              

		Clientside utilities
]]--

	-- 900 in this example is what my ScrH was in developing
	--	ScrH() - 170
	
	-- example usage:
	--	GetUniversalSize( 900 - 170 )
	--
	--		Does this: (900 - 170) / 900
	--		returns a number: 0.8111
	--		then use that number in your final:
	--			ScrH() or ScrW() * sizereturned
function GetUniversalSize( difference, scrsize )
	return (scrsize - difference) / scrsize
end

function FixLongName( str, maxlength )
	if #tostring(str) > maxlength then
		str = string.sub( str, 1, maxlength ) .. "..."
	end

	return str
end