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

local points = GetComboPoints
local _G = _G
local display = nil
local text = nil
local font = nil

local db
local defaults = {
	profile = {
		x = nil,
		y = nil,
		lock = nil,
	}
}

local BasicComboPoints = LibStub("AceAddon-3.0"):NewAddon("BasicComboPoints", "AceEvent-3.0")

------------------------------
--      Initialization      --
------------------------------

function BasicComboPoints:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("BasicComboPointsDB", defaults)
	db = self.db.profile
end

------------------------------
--       Frame Setup        --
------------------------------

function BasicComboPoints:OnEnable()
	if not display then
		display = CreateFrame("Frame", "BCPFrame", UIParent)
		display:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",})
		display:SetFrameStrata("BACKGROUND")
		display:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
		display:SetBackdropColor(1,1,1,1)
		display:SetWidth(50)
		display:SetHeight(50)
		display:Show()
		display:EnableMouse(true)
		display:RegisterForDrag("LeftButton")
		display:SetMovable(true)
		display:SetScript("OnDragStart", function() this:StartMoving() end)
		display:SetScript("OnDragStop", function()
			this:StopMovingOrSizing()
			self:SavePosition()
		end)

	local x = db.x
	local y = db.y
	if x and y then
		local s = display:GetEffectiveScale()
		display:ClearAllPoints()
		display:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
	end

	if db.lock then
		display:SetBackdropColor(1,1,1,0)
		display:EnableMouse(false)
		display:SetMovable(false)
	end

		text = display:CreateFontString(nil,"OVERLAY")
		text:SetPoint("CENTER", display, "CENTER")
		font = "Fonts\\FRIZQT__.TTF"
		text:SetFont(font, 15)
	end

	self:RegisterEvent("PLAYER_COMBO_POINTS", "Update")
	self:RegisterEvent("PLAYER_TARGET_CHANGED", "Update")
end

function BasicComboPoints:SavePosition()
	if not display then return end

	local s = display:GetEffectiveScale()
	db.x = display:GetLeft() * s
	db.y = display:GetTop() * s
end

------------------------------
--       Point Update       --
------------------------------

function BasicComboPoints:Update()
	local pts = points()

	if pts == 0 then
		pts = ""
	elseif pts == 1 then
		text:SetFont(font, 15)
		text:SetTextColor(1, 1, 1)
	elseif pts == 2 then
		text:SetFont(font, 25)
		text:SetTextColor(0, 1, 0)
	elseif pts == 3 then
		text:SetFont(font, 35)
		text:SetTextColor(1, 1, 0)
	elseif pts == 4 then
		text:SetFont(font, 45)
		text:SetTextColor(0, 0, 1)
	else
		text:SetFont(font, 55)
		text:SetTextColor(1, 0, 0)
	end

	text:SetText(pts)
end

------------------------------
--     Slash Commands       --
------------------------------

_G["SlashCmdList"]["BASICCOMBOPOINTS"] = function(msg)
	if string.lower(msg) == "lock" then
		if not db.lock then
			display:SetBackdropColor(1,1,1,0)
			display:EnableMouse(false)
			display:SetMovable(false)
			db.lock = true
			ChatFrame1:AddMessage("BasicComboPoints: Locked")
		else
			display:SetBackdropColor(1,1,1,1)
			display:EnableMouse(true)
			display:SetMovable(true)
			db.lock = nil
			ChatFrame1:AddMessage("BasicComboPoints: Unlocked")
		end
	elseif msg == "" then
		ChatFrame1:AddMessage("BasicComboPoints: Commands:")
		ChatFrame1:AddMessage("/bcp lock")
	end
end
_G["SLASH_BASICCOMBOPOINTS1"] = "/bcp"
