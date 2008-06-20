------------------------------
--      Are you local?      --
------------------------------

local class = select(2, UnitClass("player"))
if class == "ROGUE" or class == "DRUID" then
	class = nil
else
	DisableAddOn("BasicComboPoints")
	return
end

local GetComboPoints = _G.GetComboPoints
local text = nil
local display = nil
local font = nil

local db
local defaults = {
	profile = {
		x = nil,
		y = nil,
		lock = nil,
		font = "Friz Quadrata TT",
		size = { one = 15, two = 25, three = 35, four = 45, five = 55 },
		colorone = { r = 1, g = 1, b = 1 },
		colortwo = { r = 0, g = 1, b = 0 },
		colorthree = { r = 1, g = 1, b = 0 },
		colorfour = { r = 0, g = 0, b = 1 },
		colorfive = { r = 1, g = 0, b = 0 },
	}
}

local BasicComboPoints = LibStub("AceAddon-3.0"):NewAddon("BasicComboPoints")
local media = LibStub("LibSharedMedia-3.0")

------------------------------
--           Config         --
------------------------------

local bcpOptions
local function getOptions()
	if not bcpOptions then
		local L = LibStub("AceLocale-3.0"):GetLocale("BasicComboPoints", true)
		bcpOptions = {
			name = "BasicComboPoints",
			childGroups = "tab", type = "group",
			args = {
				main = {
					name = _G["MISCELLANEOUS"],
					order = 1, type = "group",
					args = {
						intro = {
							name = L["desc"],
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
									display:SetBackdropColor(1,1,1,1)
									state = true
								else
									display:SetBackdropColor(1,1,1,0)
									state = nil
								end
								display:EnableMouse(state)
								display:SetMovable(state)
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
							set = function(_, font)
								db.font = media:List("font")[font]
								BasicComboPoints:SetFont()
							end,
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

function BasicComboPoints:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("BasicComboPointsDB", defaults)
	db = self.db.profile

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("BasicComboPoints", getOptions)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BasicComboPoints", "BasicComboPoints")

	_G["SlashCmdList"]["BASICCOMBOPOINTS_MAIN"] = function() InterfaceOptionsFrame_OpenToFrame("BasicComboPoints") end
	_G["SLASH_BASICCOMBOPOINTS_MAIN1"] = "/bcp"
	_G["SLASH_BASICCOMBOPOINTS_MAIN2"] = "/basiccombopoints"
end

------------------------------
--       Frame Setup        --
------------------------------

function BasicComboPoints:OnEnable()
	display = CreateFrame("Frame", "BCPFrame", UIParent)
	display:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",})
	display:SetFrameStrata("BACKGROUND")
	display:SetClampedToScreen(true)
	display:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	display:SetBackdropColor(1,1,1,0)
	display:SetWidth(50)
	display:SetHeight(50)
	display:Show()
	display:RegisterForDrag("LeftButton")
	display:SetScript("OnDragStart", function() this:StartMoving() end)
	display:SetScript("OnDragStop", function() this:StopMovingOrSizing()
		local s = display:GetEffectiveScale()
		db.x = display:GetLeft() * s
		db.y = display:GetTop() * s
	end)
	display:SetScript("OnEvent", function() BasicComboPoints:Update() end)
	if not db.lock then
		display:SetBackdropColor(1,1,1,1)
		display:EnableMouse(true)
		display:SetMovable(true)
	end

	if db.x then
		local s = display:GetEffectiveScale()
		display:ClearAllPoints()
		display:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", db.x / s, db.y / s)
	end

	text = display:CreateFontString("BCPText", "OVERLAY")
	text:SetPoint("CENTER", display, "CENTER")
	font = media:Fetch("font", db.font)
	text:SetShadowColor(0, 0, 0, 1)
	text:SetShadowOffset(1, -1)
	text:SetFont(font, 15)

	display:RegisterEvent("PLAYER_COMBO_POINTS")
	display:RegisterEvent("PLAYER_TARGET_CHANGED")

	media.RegisterCallback(self, "LibSharedMedia_Registered", "SetFont")
	media.RegisterCallback(self, "LibSharedMedia_SetGlobal", "SetFont")
end

------------------------------
--       Point Update       --
------------------------------

function BasicComboPoints:SetFont()
	font = media:Fetch("font", db.font)
	self:Update()
end

function BasicComboPoints:Update()
	local points = GetComboPoints()

	if points == 0 then
		points = ""
	elseif points == 1 then
		text:SetFont(font, db.size.one)
		local color = db.colorone
		text:SetTextColor(color.r,color.g,color.b)
	elseif points == 2 then
		text:SetFont(font, db.size.two)
		local color = db.colortwo
		text:SetTextColor(color.r,color.g,color.b)
	elseif points == 3 then
		text:SetFont(font, db.size.three)
		local color = db.colorthree
		text:SetTextColor(color.r,color.g,color.b)
	elseif points == 4 then
		text:SetFont(font, db.size.four)
		local color = db.colorfour
		text:SetTextColor(color.r,color.g,color.b)
	else
		text:SetFont(font, db.size.five)
		local color = db.colorfive
		text:SetTextColor(color.r,color.g,color.b)
	end

	text:SetText(points)
end

