
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
					order = 1, type = "description", fontSize = "medium",
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
							BCP.bg:Show()
							BCP.header:Show()
							state = true
						else
							BCP.bg:Hide()
							BCP.header:Hide()
							state = false
						end
						BCP:EnableMouse(state)
						BCP:SetMovable(state)
					end,
				},
				font = {
					name = L["Font"], desc = L["Apply the font you wish to use for your Combo Points."],
					order = 4, type = "select", width = 2,
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
						BCP:UNIT_POWER_UPDATE("player", BCP.EVENT)
					end,
				},
				shadow = {
					name = _G["DAMAGE_SCHOOL6"], desc = L["Apply a shadow to your text."],
					order = 5, type = "toggle",
					get = function() return BCP.db.profile.shadow end,
					set = function(_, state) BCP.db.profile.shadow = state
						if state then
							BCP.text:SetShadowColor(0, 0, 0, 1)
							BCP.text:SetShadowOffset(1, -1)
						else
							BCP.text:SetShadowColor(0, 0, 0, 0)
							BCP.text:SetShadowOffset(0, 0)
						end
						BCP:UNIT_POWER_UPDATE("player", BCP.EVENT)
					end,
				},
				outline = {
					name = L["Outline"], desc = L["Apply a outline to your text."],
					order = 6, type = "select", width = 2,
					values = {NONE = _G["NONE"], OUTLINE = L["Outline"], THICKOUTLINE = L["Thick Outline"]},
					get = function() return BCP.db.profile.outline end,
					set = function(_, value) BCP.db.profile.outline = value BCP:UNIT_POWER_UPDATE("player", BCP.EVENT) end,
				},
			},
		},
		color = {
			name = _G["COLOR"],
			order = 2, type = "group",
			get = function(info) return BCP.db.profile.color[info[#info]].r, BCP.db.profile.color[info[#info]].g, BCP.db.profile.color[info[#info]].b end,
			set = function(info, r, g, b)
				BCP.db.profile.color[info[#info]].r = r
				BCP.db.profile.color[info[#info]].g = g
				BCP.db.profile.color[info[#info]].b = b
				BCP:UNIT_POWER_UPDATE("player", BCP.EVENT)
			end,
			args = {
				desc = {
					name = L["Apply the color you wish to use for your Combo Points."],
					order = 1, type = "description", fontSize = "medium",
				},
				spacer = {
					name = "",
					order = 2, type = "header",
				},
				[1] = {
					name = format(comboPointsString, 1),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 1),
					order = 3, type = "color", width = "full",
				},
				[2] = {
					name = format(comboPointsString, 2),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 2),
					order = 4, type = "color", width = "full",
				},
				[3] = {
					name = format(comboPointsString, 3),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 3),
					order = 5, type = "color", width = "full",
				},
				[4] = {
					name = format(comboPointsString, 4),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 4),
					order = 6, type = "color", width = "full",
				},
				[5] = {
					name = format(comboPointsString, 5),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 5),
					order = 7, type = "color", width = "full",
				},
				[6] = {
					name = format(comboPointsString, 6),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 6),
					order = 8, type = "color", width = "full",
				},
				[7] = {
					name = format(comboPointsString, 7),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 7),
					order = 9, type = "color", width = "full",
				},
				[8] = {
					name = format(comboPointsString, 8),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 8),
					order = 10, type = "color", width = "full",
				},
			},
		},
		size = {
			name = _G["FONT_SIZE"],
			order = 3, type = "group",
			get = function(info) return BCP.db.profile.size[info[#info]] end,
			set = function(info, v)
				BCP.db.profile.size[info[#info]] = v
				BCP:UNIT_POWER_UPDATE("player", BCP.EVENT)
			end,
			args = {
				desc = {
					name = L["Apply the size you wish to use for your Combo Points."],
					order = 1, type = "description", fontSize = "medium",
				},
				spacer = {
					name = "",
					order = 2, type = "header",
				},
				[1] = {
					name = format(comboPointsString, 1),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 1),
					order = 3, type = "range", width = "full",
					min = 1, max = 200, softMax = 100, step = 1,
				},
				[2] = {
					name = format(comboPointsString, 2),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 2),
					order = 4, type = "range", width = "full",
					min = 1, max = 200, softMax = 100, step = 1,
				},
				[3] = {
					name = format(comboPointsString, 3),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 3),
					order = 5, type = "range", width = "full",
					min = 1, max = 200, softMax = 100, step = 1,
				},
				[4] = {
					name = format(comboPointsString, 4),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 4),
					order = 6, type = "range", width = "full",
					min = 1, max = 200, softMax = 100, step = 1,
				},
				[5] = {
					name = format(comboPointsString, 5),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 5),
					order = 7, type = "range", width = "full",
					min = 1, max = 200, softMax = 100, step = 1,
				},
				[6] = {
					name = format(comboPointsString, 6),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 6),
					order = 8, type = "range", width = "full",
					min = 1, max = 200, softMax = 100, step = 1,
				},
				[7] = {
					name = format(comboPointsString, 7),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 7),
					order = 9, type = "range", width = "full",
					min = 1, max = 200, softMax = 100, step = 1,
				},
				[8] = {
					name = format(comboPointsString, 8),
					desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 8),
					order = 10, type = "range", width = "full",
					min = 1, max = 200, softMax = 100, step = 1,
				},
			},
		},
		profiles = adbo:GetOptionsTable(BCP.db),
	},
}

acr:RegisterOptionsTable(acOptions.name, acOptions, true)
acd:SetDefaultSize(acOptions.name, 600, 600)

