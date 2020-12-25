std = "lua51"
max_line_length = false
codes = true
exclude_files = {
	"**/Libs",
}
ignore = {
	"111/SLASH_BASICCOMBOPOINTS[12]", -- slash handlers
}
globals = {
	-- Addon
	"BasicComboPoints",
	"LibStub",

	-- WoW
	"CreateFrame",
	"EnableAddOn",
	"GetLocale",
	"LoadAddOn",
	"ReloadUI",
	"SlashCmdList",
	"UIParent",
	"UnitClass",
	"UnitPower",
}
