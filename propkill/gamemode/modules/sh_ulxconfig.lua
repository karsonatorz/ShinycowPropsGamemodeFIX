if not ulx then return end

AddConfigItem( "ulx_showmotd",
	{
	Name = "Show MOTD",
	Category = "ULX",
	default = false,
	type = "boolean",
	desc = "Show players the MOTD on join. (Disabled will show team selection)",
	}
)