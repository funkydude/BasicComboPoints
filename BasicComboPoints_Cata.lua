------------------------------
--      Are you local?      --
------------------------------

local POWER, EVENT
do
	local _, class = UnitClass("player")
	if class == "ROGUE" or class == "DRUID" then
		EVENT = "COMBO_POINTS"
		POWER = 4 -- Global Enum.PowerType.ComboPoints // 4 on retail, 14 on BCC/Classic
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
	elseif class == "EVOKER" then
		EVENT = "ESSENCE"
		POWER = 19 -- Global Enum.PowerType.Essence
	else
		return
	end
end

local name = ...
local media = LibStub("LibSharedMedia-3.0")

local BCP = CreateFrame("Frame", name, UIParent)
BCP.EVENT = EVENT
BCP:SetClampedToScreen(true)
BCP:SetPoint("CENTER", UIParent, "CENTER")
BCP:SetWidth(50)
BCP:SetHeight(50)
BCP:SetMovable(true)
BCP:EnableMouse(true)
BCP:Show()
BCP:RegisterForDrag("LeftButton")
BCP:SetScript("OnDragStart", function(f) f:StartMoving() end)
BCP:SetScript("OnDragStop", function(f)
	f:StopMovingOrSizing()
	local a, _, b, c, d = f:GetPoint()
	f.db.profile.position[1] = a
	f.db.profile.position[2] = b
	f.db.profile.position[3] = c
	f.db.profile.position[4] = d
end)

local bg = BCP:CreateTexture()
BCP.bg = bg
bg:SetAllPoints(BCP)
bg:SetColorTexture(0, 1, 0, 0.3)
local text = BCP:CreateFontString()
BCP.text = text
text:SetAllPoints(BCP)
local header = BCP:CreateFontString(nil, "OVERLAY", "TextStatusBarText")
BCP.header = header
header:SetPoint("BOTTOM", BCP, "TOP")
header:SetText(name)

BCP:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
BCP:RegisterEvent("PLAYER_LOGIN")
BCP:RegisterEvent("ADDON_LOADED")

------------------------------
--           Config         --
------------------------------

do
	local function openOpts()
		local EnableAddOn = C_AddOns.EnableAddOn or EnableAddOn
		local LoadAddOn = C_AddOns.LoadAddOn or LoadAddOn
		EnableAddOn("BasicComboPoints_Options") -- Make sure it wasn't left disabled for whatever reason
		LoadAddOn("BasicComboPoints_Options")
		LibStub("AceConfigDialog-3.0"):Open(name)
	end
	BCP:SetScript("OnMouseUp", function(_, btn)
		if btn == "RightButton" then
			openOpts()
		end
	end)
	SlashCmdList.BASICCOMBOPOINTS = openOpts
	SLASH_BASICCOMBOPOINTS1 = "/bcp"
	SLASH_BASICCOMBOPOINTS2 = "/basiccombopoints"
end

------------------------------
--      Initialization      --
------------------------------

function BCP:ADDON_LOADED(msg)
	if msg == name then
		self:UnregisterEvent("ADDON_LOADED")
		local defaults = {
			profile = {
				lock = false,
				position = {"CENTER", "CENTER", 0, 0},
				shadow = true,
				outline = "NONE",
				font = media:GetDefault("font"),
				size = {15, 25, 35, 45, 55, 55, 55, 55},
				color = {
					{ r = 1, g = 1, b = 1 },
					{ r = 0, g = 1, b = 0 },
					{ r = 1, g = 1, b = 0 },
					{ r = 0, g = 0, b = 1 },
					{ r = 1, g = 0, b = 0 },
					{ r = 1, g = 0, b = 0 },
					{ r = 1, g = 0, b = 0 },
					{ r = 1, g = 0, b = 0 },
				}
			}
		}
		self.db = LibStub("AceDB-3.0"):New("BCPSettings", defaults, true)
		do
			local rl = function() ReloadUI() end
			self.db.RegisterCallback(self, "OnProfileChanged", rl)
			self.db.RegisterCallback(self, "OnProfileCopied", rl)
			self.db.RegisterCallback(self, "OnProfileReset", rl)
		end

		self.ADDON_LOADED = nil
	end
end

------------------------------
--       Frame Setup        --
------------------------------

function BCP:PLAYER_LOGIN()
	self:UnregisterEvent("PLAYER_LOGIN")

	if self.db.profile.lock then
		self:EnableMouse(false)
		self:SetMovable(false)
		bg:Hide()
		header:Hide()
	end

	self:ClearAllPoints()
	self:SetPoint(self.db.profile.position[1], UIParent, self.db.profile.position[2], self.db.profile.position[3], self.db.profile.position[4])

	if self.db.profile.shadow then
		text:SetShadowColor(0, 0, 0, 1)
		text:SetShadowOffset(1, -1)
	end
	text:SetFont(media:Fetch("font", self.db.profile.font), 15, self.db.profile.outline)

	self:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
	self:RegisterEvent("LOADING_SCREEN_DISABLED")
	self:UNIT_POWER_UPDATE("player", EVENT)

	self.PLAYER_LOGIN = nil
end

------------------------------
--       Point Update       --
------------------------------

function BCP:LOADING_SCREEN_DISABLED()
	-- Compensate for decaying combo points during a loading screen not firing UNIT_POWER_UPDATE
	self:UNIT_POWER_UPDATE("player", EVENT)
end

if EVENT == "COMBO_POINTS" then
	local GetComboPoints = GetComboPoints
	function BCP:UNIT_POWER_UPDATE(unit, pType)
		if pType == EVENT then
			local points = GetComboPoints(unit, "target")
			-- Set colors and sizes according to point count
			if points < 1 then
				text:SetText("")
				return
			else
				local db = self.db.profile
				text:SetFont(media:Fetch("font", db.font), db.size[points], db.outline)
				local color = db.color[points]
				text:SetTextColor(color.r,color.g,color.b)
			end
			-- Display points
			text:SetText(points)
		end
	end
	BCP.PLAYER_TARGET_CHANGED = BCP.LOADING_SCREEN_DISABLED
	BCP:RegisterEvent("PLAYER_TARGET_CHANGED")
else
	local UnitPower = UnitPower
	function BCP:UNIT_POWER_UPDATE(unit, pType)
		if pType == EVENT then
			local points = UnitPower(unit, POWER)
			-- Set colors and sizes according to point count
			if points < 1 then
				text:SetText("")
				return
			else
				local db = self.db.profile
				text:SetFont(media:Fetch("font", db.font), db.size[points], db.outline)
				local color = db.color[points]
				text:SetTextColor(color.r,color.g,color.b)
			end
			-- Display points
			text:SetText(points)
		end
	end
end
