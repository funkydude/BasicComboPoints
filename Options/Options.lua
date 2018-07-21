
local acr = LibStub("AceConfigRegistry-3.0")
local acd = LibStub("AceConfigDialog-3.0")
local media = LibStub("LibSharedMedia-3.0")
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
					get = function() return db.lock end,
					set = function(_, state) db.lock = state
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
							if db.font == v then
								return k
							end
						end
					end,
					set = function(_, newfont)
						db.font = media:List("font")[newfont]
						BCP:UNIT_POWER_UPDATE("player", EVENT)
					end,
				},
				shadow = {
					name = _G["DAMAGE_SCHOOL6"], desc = L["Apply a shadow to your text."],
					order = 5, type = "toggle",
					get = function() return db.shadow end,
					set = function(_, state) db.shadow = state
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
					get = function() return db.outline end,
					set = function(_, value) db.outline = value BCP:UNIT_POWER_UPDATE("player", EVENT) end,
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
				colorone = {
					name = format(comboPointsString, 1),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 1),
					order = 3, type = "color", width = "full",
					get = function() return db.colorone.r, db.colorone.g, db.colorone.b end,
					set = function(_, r, g, b) db.colorone.r = r db.colorone.g = g db.colorone.b = b end,
				},
				colortwo = {
					name = format(comboPointsString, 2),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 2),
					order = 4, type = "color", width = "full",
					get = function() return db.colortwo.r, db.colortwo.g, db.colortwo.b end,
					set = function(_, r, g, b) db.colortwo.r = r db.colortwo.g = g db.colortwo.b = b end,
				},
				colorthree = {
					name = format(comboPointsString, 3),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 3),
					order = 5, type = "color", width = "full",
					get = function() return db.colorthree.r, db.colorthree.g, db.colorthree.b end,
					set = function(_, r, g, b) db.colorthree.r = r db.colorthree.g = g db.colorthree.b = b end,
				},
				colorfour = {
					name = format(comboPointsString, 4),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 4),
					order = 6, type = "color", width = "full",
					get = function() return db.colorfour.r, db.colorfour.g, db.colorfour.b end,
					set = function(_, r, g, b) db.colorfour.r = r db.colorfour.g = g db.colorfour.b = b end,
				},
				colorfive = {
					name = format(comboPointsString, 5),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 5),
					order = 7, type = "color", width = "full",
					get = function() return db.colorfive.r, db.colorfive.g, db.colorfive.b end,
					set = function(_, r, g, b) db.colorfive.r = r db.colorfive.g = g db.colorfive.b = b end,
				},
				colorsix = {
					name = format(comboPointsString, 6),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 6),
					order = 8, type = "color", width = "full",
					get = function() return db.colorsix.r, db.colorsix.g, db.colorsix.b end,
					set = function(_, r, g, b) db.colorsix.r = r db.colorsix.g = g db.colorsix.b = b end,
				},
				colorseven = {
					name = format(comboPointsString, 7),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 7),
					order = 9, type = "color", width = "full",
					get = function() return db.colorseven.r, db.colorseven.g, db.colorseven.b end,
					set = function(_, r, g, b) db.colorseven.r = r db.colorseven.g = g db.colorseven.b = b end,
				},
				coloreight = {
					name = format(comboPointsString, 8),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 8),
					order = 10, type = "color", width = "full",
					get = function() return db.coloreight.r, db.coloreight.g, db.coloreight.b end,
					set = function(_, r, g, b) db.coloreight.r = r db.coloreight.g = g db.coloreight.b = b end,
				},
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
				sizeone = {
					name = format(comboPointsString, 1),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 1),
					order = 3, type = "range", width = "full",
					min = 1, max = 200, softMax = 72, step = 1,
					get = function() return db.size.one end,
					set = function(_, v) db.size.one = v end,
				},
				sizetwo = {
					name = format(comboPointsString, 2),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 2),
					order = 4, type = "range", width = "full",
					min = 1, max = 200, softMax = 72, step = 1,
					get = function() return db.size.two end,
					set = function(_, v) db.size.two = v end,
				},
				sizethree = {
					name = format(comboPointsString, 3),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 3),
					order = 5, type = "range", width = "full",
					min = 1, max = 200, softMax = 72, step = 1,
					get = function() return db.size.three end,
					set = function(_, v) db.size.three = v end,
				},
				sizefour = {
					name = format(comboPointsString, 4),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 4),
					order = 6, type = "range", width = "full",
					min = 1, max = 200, softMax = 72, step = 1,
					get = function() return db.size.four end,
					set = function(_, v) db.size.four = v end,
				},
				sizefive = {
					name = format(comboPointsString, 5),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 5),
					order = 7, type = "range", width = "full",
					min = 1, max = 200, softMax = 72, step = 1,
					get = function() return db.size.five end,
					set = function(_, v) db.size.five = v end,
				},
				sizesix = {
					name = format(comboPointsString, 6),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 6),
					order = 8, type = "range", width = "full",
					min = 1, max = 200, softMax = 72, step = 1,
					get = function() return db.size.six end,
					set = function(_, v) db.size.six = v end,
				},
				sizeseven = {
					name = format(comboPointsString, 7),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 7),
					order = 9, type = "range", width = "full",
					min = 1, max = 200, softMax = 72, step = 1,
					get = function() return db.size.seven end,
					set = function(_, v) db.size.seven = v end,
				},
				sizeeight = {
					name = format(comboPointsString, 8),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 8),
					order = 10, type = "range", width = "full",
					min = 1, max = 200, softMax = 72, step = 1,
					get = function() return db.size.eight end,
					set = function(_, v) db.size.eight = v end,
				},
			},
		},
	},
}

acr:RegisterOptionsTable(acOptions.name, acOptions, true)
--acd:SetDefaultSize(acOptions.name, 420, 640)

