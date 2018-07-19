------------------------------
--      Are you local?      --
------------------------------

local name, tbl = ...
local POWER, EVENT
do
	local _, class = UnitClass("player")
	if class == "ROGUE" or class == "DRUID" then
		EVENT = "COMBO_POINTS"
		POWER = 4 -- Global Enum.PowerType.ComboPoints
	elseif class == "PALADIN" then
		EVENT = "HOLY_POWER"
		POWER = 9 -- Global Enum.PowerType.HolyPower
	elseif class == "MAGE" then
		EVENT = "ARCANE_CHARGES"
		POWER = 16 -- Global Enum.PowerType.ArcaneCharges
	elseif class == "WARLOCK" then
		EVENT = "SOUL_SHARDS"
		POWER = 7 -- Global Enum.PowerType.SoulShards
	elseif class == "MONK" then
		EVENT = "CHI"
		POWER = 12 -- Global Enum.PowerType.Chi
	else
		DisableAddOn(name)
		ChatFrame1:AddMessage("BasicComboPoints: ".. _G["ADDON_DISABLED"])
		return
	end
end

local media = LibStub("LibSharedMedia-3.0")
local UnitPower = UnitPower
local db, font = nil, nil

local BCP = CreateFrame("Frame", name, UIParent)
BCP:SetClampedToScreen(true)
BCP:SetPoint("CENTER", UIParent, "CENTER")
BCP:SetWidth(50)
BCP:SetHeight(50)
BCP:Show()
BCP:RegisterForDrag("LeftButton")
BCP:SetScript("OnDragStart", function(frame) frame:StartMoving() end)
BCP:SetScript("OnDragStop", function(frame) frame:StopMovingOrSizing()
	local s = frame:GetEffectiveScale()
	db.x = frame:GetLeft() * s
	db.y = frame:GetTop() * s
end)

local bg = BCP:CreateTexture()
bg:SetAllPoints(BCP)
bg:SetColorTexture(0, 1, 0, 0.3)
bg:Hide()
local text = BCP:CreateFontString()
text:SetAllPoints(BCP)

BCP:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
BCP:RegisterEvent("PLAYER_LOGIN")
BCP:RegisterEvent("ADDON_LOADED")

------------------------------
--           Config         --
------------------------------

do
	local comboPointsString = COMBAT_TEXT_COMBO_POINTS:gsub("[<>]", "")
	local bcpOptions
	local function getOptions()
		if not bcpOptions then
			local L = tbl.L
			bcpOptions = {
				name = name,
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
								get = function()
									for k, v in pairs(media:List("font")) do
										if db.font == v then
											return k
										end
									end
								end,
								set = function(_, newfont)
									db.font = media:List("font")[newfont]
									font = media:Fetch("font", db.font)
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
		end
		return bcpOptions
	end
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(name, getOptions, true)
	SlashCmdList["BASICCOMBOPOINTS_MAIN"] = function()
		LibStub("AceConfigDialog-3.0"):Open(name)
	end
	SLASH_BASICCOMBOPOINTS_MAIN1 = "/bcp"
	SLASH_BASICCOMBOPOINTS_MAIN2 = "/basiccombopoints"
end

------------------------------
--      Initialization      --
------------------------------

function BCP:ADDON_LOADED(msg)
	if msg == name then
		self:UnregisterEvent("ADDON_LOADED")
		local defaults = {
			profile = {
				shadow = true,
				outline = "NONE",
				font = "Friz Quadrata TT",
				size = { one = 15, two = 25, three = 35, four = 45, five = 55, six = 55, seven = 55, eight = 55 },
				colorone = { r = 1, g = 1, b = 1 },
				colortwo = { r = 0, g = 1, b = 0 },
				colorthree = { r = 1, g = 1, b = 0 },
				colorfour = { r = 0, g = 0, b = 1 },
				colorfive = { r = 1, g = 0, b = 0 },
				colorsix = { r = 1, g = 0, b = 0 },
				colorseven = { r = 1, g = 0, b = 0 },
				coloreight = { r = 1, g = 0, b = 0 },
			}
		}
		self.db = LibStub("AceDB-3.0"):New("BasicComboPointsDB", defaults)
		db = self.db.profile

		self.ADDON_LOADED = nil
	end
end

------------------------------
--       Frame Setup        --
------------------------------

function BCP:PLAYER_LOGIN()
	self:UnregisterEvent("PLAYER_LOGIN")

	if not db.lock then
		bg:Show()
		self:EnableMouse(true)
		self:SetMovable(true)
	end

	if db.x then
		local s = self:GetEffectiveScale()
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", db.x / s, db.y / s)
	end

	font = media:Fetch("font", db.font)
	if db.shadow then
		text:SetShadowColor(0, 0, 0, 1)
		text:SetShadowOffset(1, -1)
	end
	text:SetFont(font, 15, db.outline)

	self:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
	self:UNIT_POWER_UPDATE("player", EVENT)

	self.PLAYER_LOGIN = nil
end

------------------------------
--       Point Update       --
------------------------------

function BCP:UNIT_POWER_UPDATE(unit, pType)
	if pType == EVENT then
		local points = UnitPower(unit, POWER)

		-- Set colors and sizes according to point count
		if points < 1 then
			text:SetText("")
			return
		elseif points == 1 then
			text:SetFont(font, db.size.one, db.outline)
			local color = db.colorone
			text:SetTextColor(color.r,color.g,color.b)
		elseif points == 2 then
			text:SetFont(font, db.size.two, db.outline)
			local color = db.colortwo
			text:SetTextColor(color.r,color.g,color.b)
		elseif points == 3 then
			text:SetFont(font, db.size.three, db.outline)
			local color = db.colorthree
			text:SetTextColor(color.r,color.g,color.b)
		elseif points == 4 then
			text:SetFont(font, db.size.four, db.outline)
			local color = db.colorfour
			text:SetTextColor(color.r,color.g,color.b)
		elseif points == 5 then
			text:SetFont(font, db.size.five, db.outline)
			local color = db.colorfive
			text:SetTextColor(color.r,color.g,color.b)
		elseif points == 6 then
			text:SetFont(font, db.size.six, db.outline)
			local color = db.colorsix
			text:SetTextColor(color.r,color.g,color.b)
		elseif points == 7 then
			text:SetFont(font, db.size.seven, db.outline)
			local color = db.colorseven
			text:SetTextColor(color.r,color.g,color.b)
		elseif points == 8 then
			text:SetFont(font, db.size.eight, db.outline)
			local color = db.coloreight
			text:SetTextColor(color.r,color.g,color.b)
		end

		-- Display points
		text:SetText(points)
	end
end

