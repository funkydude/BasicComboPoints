------------------------------
--      Are you local?      --
------------------------------

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
		return
	end
end

local name, tbl = ...
local media = LibStub("LibSharedMedia-3.0")

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
	frame.db.profile.x = frame:GetLeft() * s
	frame.db.profile.y = frame:GetTop() * s
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

SlashCmdList.BASICCOMBOPOINTS = function()
	LoadAddOn("BasicComboPoints_Options")
	LibStub("AceConfigDialog-3.0"):Open(name)
end
SLASH_BASICCOMBOPOINTS1 = "/bcp"
SLASH_BASICCOMBOPOINTS2 = "/basiccombopoints"

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

		self.ADDON_LOADED = nil
	end
end

------------------------------
--       Frame Setup        --
------------------------------

function BCP:PLAYER_LOGIN()
	self:UnregisterEvent("PLAYER_LOGIN")

	if not self.db.profile.lock then
		bg:Show()
		self:EnableMouse(true)
		self:SetMovable(true)
	end

	if self.db.profile.x then
		local s = self:GetEffectiveScale()
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", self.db.profile.x / s, self.db.profile.y / s)
	end

	if self.db.profile.shadow then
		text:SetShadowColor(0, 0, 0, 1)
		text:SetShadowOffset(1, -1)
	end
	text:SetFont(media:Fetch("font", self.db.profile.font), 15, self.db.profile.outline)

	self:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
	self:UNIT_POWER_UPDATE("player", EVENT)

	self.PLAYER_LOGIN = nil
end

------------------------------
--       Point Update       --
------------------------------

do
	local UnitPower = UnitPower
	function BCP:UNIT_POWER_UPDATE(unit, pType)
		if pType == EVENT then
			local points = UnitPower(unit, POWER)
			local db = self.db.profile

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
end
