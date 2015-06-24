------------------------------
--      Are you local?      --
------------------------------

local name, tbl = ...
do
	local _, class = UnitClass("player")
	if class ~= "ROGUE" and class ~= "DRUID" then
		DisableAddOn(name)
		ChatFrame1:AddMessage("BasicComboPoints: ".. _G["ADDON_DISABLED"])
		return
	end
end

local BCP = CreateFrame("Frame", name, UIParent)
local media = LibStub("LibSharedMedia-3.0")
local font = nil
local Update
local db

BCP:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
BCP:RegisterEvent("PLAYER_LOGIN")
BCP:RegisterEvent("ADDON_LOADED")

------------------------------
--           Config         --
------------------------------

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
									BCP:SetBackdropColor(1,1,1,1)
									state = true
								else
									BCP:SetBackdropColor(1,1,1,0)
									state = nil
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
								BCP:Update()
							end,
						},
						shadow = {
							name = _G["DAMAGE_SCHOOL6"], desc = L["Apply a shadow to your text."],
							order = 5, type = "toggle",
							get = function() return db.shadow end,
							set = function(_, state) db.shadow = state
								if state then
									BCP.text:SetShadowColor(0, 0, 0, 1)
									BCP.text:SetShadowOffset(1, -1)
								else
									BCP.text:SetShadowColor(0, 0, 0, 0)
									BCP.text:SetShadowOffset(0, 0)
								end
								BCP:Update()
							end,
						},
						outline = {
							name = L["Outline"], desc = L["Apply a outline to your text."],
							order = 5, type = "select",
							values = {NONE = _G["NONE"], OUTLINE = L["Outline"], THICKOUTLINE = L["Thick Outline"]},
							get = function() return db.outline end,
							set = function(_, value) db.outline = value BCP:Update() end,
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
							name = format(_G["COMBAT_TEXT_COMBO_POINTS"], 1),
							desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 1),
							order = 3, type = "color", width = "full",
							get = function() return db.colorone.r, db.colorone.g, db.colorone.b end,
							set = function(_, r, g, b) db.colorone.r = r db.colorone.g = g db.colorone.b = b end,
						},
						colortwo = {
							name = format(_G["COMBAT_TEXT_COMBO_POINTS"], 2),
							desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 2),
							order = 4, type = "color", width = "full",
							get = function() return db.colortwo.r, db.colortwo.g, db.colortwo.b end,
							set = function(_, r, g, b) db.colortwo.r = r db.colortwo.g = g db.colortwo.b = b end,
						},
						colorthree = {
							name = format(_G["COMBAT_TEXT_COMBO_POINTS"], 3),
							desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 3),
							order = 5, type = "color", width = "full",
							get = function() return db.colorthree.r, db.colorthree.g, db.colorthree.b end,
							set = function(_, r, g, b) db.colorthree.r = r db.colorthree.g = g db.colorthree.b = b end,
						},
						colorfour = {
							name = format(_G["COMBAT_TEXT_COMBO_POINTS"], 4),
							desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 4),
							order = 6, type = "color", width = "full",
							get = function() return db.colorfour.r, db.colorfour.g, db.colorfour.b end,
							set = function(_, r, g, b) db.colorfour.r = r db.colorfour.g = g db.colorfour.b = b end,
						},
						colorfive = {
							name = format(_G["COMBAT_TEXT_COMBO_POINTS"], 5),
							desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["COLOR"], 5),
							order = 7, type = "color", width = "full",
							get = function() return db.colorfive.r, db.colorfive.g, db.colorfive.b end,
							set = function(_, r, g, b) db.colorfive.r = r db.colorfive.g = g db.colorfive.b = b end,
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
							name = format(_G["COMBAT_TEXT_COMBO_POINTS"], 1),
							desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 1),
							order = 3, type = "range", width = "full",
							min = 1, max = 48, step = 1,
							get = function() return db.size.one end,
							set = function(_, v) db.size.one = v end,
						},
						sizetwo = {
							name = format(_G["COMBAT_TEXT_COMBO_POINTS"], 2),
							desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 2),
							order = 4, type = "range", width = "full",
							min = 1, max = 48, step = 1,
							get = function() return db.size.two end,
							set = function(_, v) db.size.two = v end,
						},
						sizethree = {
							name = format(_G["COMBAT_TEXT_COMBO_POINTS"], 3),
							desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 3),
							order = 5, type = "range", width = "full",
							min = 1, max = 48, step = 1,
							get = function() return db.size.three end,
							set = function(_, v) db.size.three = v end,
						},
						sizefour = {
							name = format(_G["COMBAT_TEXT_COMBO_POINTS"], 4),
							desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 4),
							order = 6, type = "range", width = "full",
							min = 1, max = 48, step = 1,
							get = function() return db.size.four end,
							set = function(_, v) db.size.four = v end,
						},
						sizefive = {
							name = format(_G["COMBAT_TEXT_COMBO_POINTS"], 5),
							desc = format(L["Apply the %s you wish to use for Combo Point %d."], _G["FONT_SIZE"], 5),
							order = 7, type = "range", width = "full",
							min = 1, max = 48, step = 1,
							get = function() return db.size.five end,
							set = function(_, v) db.size.five = v end,
						},
					},
				},
			},
		}
	end
	return bcpOptions
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
				size = { one = 15, two = 25, three = 35, four = 45, five = 55 },
				colorone = { r = 1, g = 1, b = 1 },
				colortwo = { r = 0, g = 1, b = 0 },
				colorthree = { r = 1, g = 1, b = 0 },
				colorfour = { r = 0, g = 0, b = 1 },
				colorfive = { r = 1, g = 0, b = 0 },
			}
		}
		self.db = LibStub("AceDB-3.0"):New("BasicComboPointsDB", defaults)
		db = self.db.profile

		LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(name, getOptions, true)
		LibStub("AceConfigDialog-3.0"):AddToBlizOptions(name, name)

		SlashCmdList["BASICCOMBOPOINTS_MAIN"] = function()
			InterfaceOptionsFrame_OpenToCategory(name)
		end
		SLASH_BASICCOMBOPOINTS_MAIN1 = "/bcp"
		SLASH_BASICCOMBOPOINTS_MAIN2 = "/basiccombopoints"
		self.ADDON_LOADED = nil
	end
end

------------------------------
--       Frame Setup        --
------------------------------

function BCP:PLAYER_LOGIN()
	self:UnregisterEvent("PLAYER_LOGIN")
	self:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",})
	self:SetFrameStrata("BACKGROUND")
	self:SetClampedToScreen(true)
	self:SetPoint("CENTER", UIParent, "CENTER")
	self:SetBackdropColor(1,1,1,0)
	self:SetWidth(50)
	self:SetHeight(50)
	self:Show()
	self:RegisterForDrag("LeftButton")
	self:SetScript("OnDragStart", function(frame) frame:StartMoving() end)
	self:SetScript("OnDragStop", function(frame) frame:StopMovingOrSizing()
		local s = self:GetEffectiveScale()
		db.x = self:GetLeft() * s
		db.y = self:GetTop() * s
	end)
	self:SetScript("OnEvent", Update)
	if not db.lock then
		self:SetBackdropColor(1,1,1,1)
		self:EnableMouse(true)
		self:SetMovable(true)
	end

	if db.x then
		local s = self:GetEffectiveScale()
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", db.x / s, db.y / s)
	end

	self.text = self:CreateFontString("BasicComboPointsText", "OVERLAY")
	self.text:SetPoint("CENTER", self, "CENTER")
	font = media:Fetch("font", db.font)
	if db.shadow then
		self.text:SetShadowColor(0, 0, 0, 1)
		self.text:SetShadowOffset(1, -1)
	end
	self.text:SetFont(font, 15, db.outline)

	self:RegisterUnitEvent("UNIT_COMBO_POINTS", "player")

	self.PLAYER_LOGIN = nil
end

------------------------------
--       Point Update       --
------------------------------

do
	local GetComboPoints = GetComboPoints
	local UnitGUID = UnitGUID
	local points = 0
	function Update(self, event, unit)
		local target = UnitGUID("target")
		if target then
			points = GetComboPoints(unit) -- Only get points if we have a target, it reports 0 with no target even if we have points
		else
			if points > 0 then
				points = points - 1 -- We don't have a target but we want to display the combo point decay over time, calculate it based on our last known points
			end
		end

		-- Set colors and sizes according to point count
		if points == 0 then
			points = ""
		elseif points == 1 then
			self.text:SetFont(font, db.size.one, db.outline)
			local color = db.colorone
			self.text:SetTextColor(color.r,color.g,color.b)
		elseif points == 2 then
			self.text:SetFont(font, db.size.two, db.outline)
			local color = db.colortwo
			self.text:SetTextColor(color.r,color.g,color.b)
		elseif points == 3 then
			self.text:SetFont(font, db.size.three, db.outline)
			local color = db.colorthree
			self.text:SetTextColor(color.r,color.g,color.b)
		elseif points == 4 then
			self.text:SetFont(font, db.size.four, db.outline)
			local color = db.colorfour
			self.text:SetTextColor(color.r,color.g,color.b)
		else
			self.text:SetFont(font, db.size.five, db.outline)
			local color = db.colorfive
			self.text:SetTextColor(color.r,color.g,color.b)
		end

		-- Display points
		self.text:SetText(points)
	end
end

