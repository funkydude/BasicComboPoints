
local acr = LibStub("AceConfigRegistry-3.0")
local acd = LibStub("AceConfigDialog-3.0")
local media = LibStub("LibSharedMedia-3.0")
local adbo = LibStub("AceDBOptions-3.0")
local BCP = BasicComboPoints
local L
do
	local _, mod = ...
	L = mod.L
end

local comboPointsString = COMBAT_TEXT_COMBO_POINTS:gsub("[<>]", "")
acOptions = {
	name = "BasicComboPoints",
	childGroups = "tab", type = "group",
	args = {
		main = {
			name = _G["MISCELLANEOUS"],
			order = 1, type = "group",
			args = {
				intro = {
					name = L["BasicComboPoints is a numerical display of your current combo points, with extras such as a font and color chooser."],
					order = 1, type = "description",
				},
				spacer = {
					name = "",
					order = 2, type = "header",
				},
				lock = {
					name = _G["LOCK"], desc = L["Lock the points frame in its current location."],
					order = 3, type = "toggle",
					get = function() return BCP.db.profile.lock end,
					set = function(_, state) BCP.db.profile.lock = state
						if not state then
							bg:Show()
							state = true
						else
							bg:Hide()
							state = false
						end
						BCP:EnableMouse(state)
						BCP:SetMovable(state)
					end,
				},
				font = {
					name = L["Font"], desc = L["Apply the font you wish to use for your Combo Points."],
					order = 4, type = "select", 
					values = media:List("font"),
					itemControl = "DDI-Font",
					get = function()
						for k, v in pairs(media:List("font")) do
							if BCP.db.profile.font == v then
								return k
							end
						end
					end,
					set = function(_, newfont)
						BCP.db.profile.font = media:List("font")[newfont]
						BCP:UNIT_POWER_UPDATE("player", EVENT)
					end,
				},
				shadow = {
					name = _G["DAMAGE_SCHOOL6"], desc = L["Apply a shadow to your text."],
					order = 5, type = "toggle",
					get = function() return BCP.db.profile.shadow end,
					set = function(_, state) BCP.db.profile.shadow = state
						if state then
							text:SetShadowColor(0, 0, 0, 1)
							text:SetShadowOffset(1, -1)
						else
							text:SetShadowColor(0, 0, 0, 0)
							text:SetShadowOffset(0, 0)
						end
						BCP:UNIT_POWER_UPDATE("player", EVENT)
					end,
				},
				outline = {
					name = L["Outline"], desc = L["Apply a outline to your text."],
					order = 5, type = "select",
					values = {NONE = _G["NONE"], OUTLINE = L["Outline"], THICKOUTLINE = L["Thick Outline"]},
					get = function() return BCP.db.profile.outline end,
					set = function(_, value) BCP.db.profile.outline = value BCP:UNIT_POWER_UPDATE("player", EVENT) end,
				},
			},
		},
		color = {
			name = _G["COLOR"],
			order = 2, type = "group",
			args = {
				desc = {
					name = L["Apply the color you wish to use for your Combo Points."],
					order = 1, type = "description",
				},
				spacer = {
					name = "",
					order = 2, type = "header",
				},
				--colorone = {
				--	name = format(comboPointsString, 1),
				--	desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 1),
				--	order = 3, type = "color", width = "full",
				--	get = function() return BCP.db.profile.colorone.r, BCP.db.profile.colorone.g, BCP.db.profile.colorone.b end,
				--	set = function(_, r, g, b) BCP.db.profile.colorone.r = r BCP.db.profile.colorone.g = g BCP.db.profile.colorone.b = b end,
				--},
				--colortwo = {
				--	name = format(comboPointsString, 2),
				--	desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 2),
				--	order = 4, type = "color", width = "full",
				--	get = function() return BCP.db.profile.colortwo.r, BCP.db.profile.colortwo.g, BCP.db.profile.colortwo.b end,
				--	set = function(_, r, g, b) BCP.db.profile.colortwo.r = r BCP.db.profile.colortwo.g = g BCP.db.profile.colortwo.b = b end,
				--},
				--colorthree = {
				--	name = format(comboPointsString, 3),
				--	desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 3),
				--	order = 5, type = "color", width = "full",
				--	get = function() return BCP.db.profile.colorthree.r, BCP.db.profile.colorthree.g, BCP.db.profile.colorthree.b end,
				--	set = function(_, r, g, b) BCP.db.profile.colorthree.r = r BCP.db.profile.colorthree.g = g BCP.db.profile.colorthree.b = b end,
				--},
				--colorfour = {
				--	name = format(comboPointsString, 4),
				--	desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 4),
				--	order = 6, type = "color", width = "full",
				--	get = function() return BCP.db.profile.colorfour.r, BCP.db.profile.colorfour.g, BCP.db.profile.colorfour.b end,
				--	set = function(_, r, g, b) BCP.db.profile.colorfour.r = r BCP.db.profile.colorfour.g = g BCP.db.profile.colorfour.b = b end,
				--},
				--colorfive = {
				--	name = format(comboPointsString, 5),
				--	desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 5),
				--	order = 7, type = "color", width = "full",
				--	get = function() return BCP.db.profile.colorfive.r, BCP.db.profile.colorfive.g, BCP.db.profile.colorfive.b end,
				--	set = function(_, r, g, b) BCP.db.profile.colorfive.r = r BCP.db.profile.colorfive.g = g BCP.db.profile.colorfive.b = b end,
				--},
				--colorsix = {
				--	name = format(comboPointsString, 6),
				--	desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 6),
				--	order = 8, type = "color", width = "full",
				--	get = function() return BCP.db.profile.colorsix.r, BCP.db.profile.colorsix.g, BCP.db.profile.colorsix.b end,
				--	set = function(_, r, g, b) BCP.db.profile.colorsix.r = r BCP.db.profile.colorsix.g = g BCP.db.profile.colorsix.b = b end,
				--},
				--colorseven = {
				--	name = format(comboPointsString, 7),
				--	desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 7),
				--	order = 9, type = "color", width = "full",
				--	get = function() return BCP.db.profile.colorseven.r, BCP.db.profile.colorseven.g, BCP.db.profile.colorseven.b end,
				--	set = function(_, r, g, b) BCP.db.profile.colorseven.r = r BCP.db.profile.colorseven.g = g BCP.db.profile.colorseven.b = b end,
				--},
				--coloreight = {
				--	name = format(comboPointsString, 8),
				--	desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 8),
				--	order = 10, type = "color", width = "full",
				--	get = function() return BCP.db.profile.coloreight.r, BCP.db.profile.coloreight.g, BCP.db.profile.coloreight.b end,
				--	set = function(_, r, g, b) BCP.db.profile.coloreight.r = r BCP.db.profile.coloreight.g = g BCP.db.profile.coloreight.b = b end,
				--},
			},
		},
		size = {
			name = _G["FONT_SIZE"],
			order = 3, type = "group",
			args = {
				desc = {
					name = L["Apply the size you wish to use for your Combo Points."],
					order = 1, type = "description",
				},
				spacer = {
					name = "",
					order = 2, type = "header",
				},
				--sizeone = {
				--	name = format(comboPointsString, 1),
				--	desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 1),
				--	order = 3, type = "range", width = "full",
				--	min = 1, max = 200, softMax = 72, step = 1,
				--	get = function() return BCP.db.profile.size.one end,
				--	set = function(_, v) BCP.db.profile.size.one = v end,
				--},
				--sizetwo = {
				--	name = format(comboPointsString, 2),
				--	desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 2),
				--	order = 4, type = "range", width = "full",
				--	min = 1, max = 200, softMax = 72, step = 1,
				--	get = function() return BCP.db.profile.size.two end,
				--	set = function(_, v) BCP.db.profile.size.two = v end,
				--},
				--sizethree = {
				--	name = format(comboPointsString, 3),
				--	desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 3),
				--	order = 5, type = "range", width = "full",
				--	min = 1, max = 200, softMax = 72, step = 1,
				--	get = function() return BCP.db.profile.size.three end,
				--	set = function(_, v) BCP.db.profile.size.three = v end,
				--},
				--sizefour = {
				--	name = format(comboPointsString, 4),
				--	desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 4),
				--	order = 6, type = "range", width = "full",
				--	min = 1, max = 200, softMax = 72, step = 1,
				--	get = function() return BCP.db.profile.size.four end,
				--	set = function(_, v) BCP.db.profile.size.four = v end,
				--},
				--sizefive = {
				--	name = format(comboPointsString, 5),
				--	desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 5),
				--	order = 7, type = "range", width = "full",
				--	min = 1, max = 200, softMax = 72, step = 1,
				--	get = function() return BCP.db.profile.size.five end,
				--	set = function(_, v) BCP.db.profile.size.five = v end,
				--},
				--sizesix = {
				--	name = format(comboPointsString, 6),
				--	desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 6),
				--	order = 8, type = "range", width = "full",
				--	min = 1, max = 200, softMax = 72, step = 1,
				--	get = function() return BCP.db.profile.size.six end,
				--	set = function(_, v) BCP.db.profile.size.six = v end,
				--},
				--sizeseven = {
				--	name = format(comboPointsString, 7),
				--	desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 7),
				--	order = 9, type = "range", width = "full",
				--	min = 1, max = 200, softMax = 72, step = 1,
				--	get = function() return BCP.db.profile.size.seven end,
				--	set = function(_, v) BCP.db.profile.size.seven = v end,
				--},
				--sizeeight = {
				--	name = format(comboPointsString, 8),
				--	desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 8),
				--	order = 10, type = "range", width = "full",
				--	min = 1, max = 200, softMax = 72, step = 1,
				--	get = function() return BCP.db.profile.size.eight end,
				--	set = function(_, v) BCP.db.profile.size.eight = v end,
				--},
			},
		},
		profiles = adbo:GetOptionsTable(BCP.db),
	},
}

acr:RegisterOptionsTable(acOptions.name, acOptions, true)
--acd:SetDefaultSize(acOptions.name, 420, 640)

