std = "lua51"
max_line_length = false
codes = true
exclude_files = {
	"**/Libs",
}
ignore = {
	"111/SLASH_BASICCOMBOPOINTS[12]", -- slash handlers
	"112/SlashCmdList", -- SlashCmdList.BASICCOMBOPOINTS
}
read_globals = {
	-- Addon
	"BasicComboPoints",
	"LibStub",

	-- WoW
	"C_AddOns",
	"C_UnitAuras", -- MoP Mage
	"CreateFrame",
	"EnableAddOn",
	"GetLocale",
	"LoadAddOn",
	"ReloadUI",
	"UIParent",
	"UnitClass",
	"UnitPower",

	-- Classic
	"Enum",
	"GetComboPoints",
}
