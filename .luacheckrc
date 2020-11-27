std = "lua51"
max_line_length = false
codes = true
exclude_files = {
	"**/Libs",
}
ignore = {
	"11/SLASH_BASICCOMBOPOINTS[12]", -- slash handlers
}
globals = {
	-- Lua
	"string",

	-- Addon
	"BasicComboPoints",
	"LibStub",

	-- WoW
	"CreateFrame",
	"EnableAddOn",
	"GetLocale",
	"LoadAddOn",
	"SlashCmdList",
	"UIParent",
	"UnitClass",
	"UnitPower",
}
