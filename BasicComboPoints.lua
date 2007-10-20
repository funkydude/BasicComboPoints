--------------------------------------------------
----------------BASIC COMBO POINTS----------------
--------------------------------------------------

if select(2, UnitClass('player')) ~= "ROGUE" then
	DisableAddOn("BasicComboPoints")
	return
end

local points = nil
local GetComboPoints = GetComboPoints
local IsAddOnLoaded = IsAddOnLoaded
local start = nil

--------------------------------------------------
------------------FRAME CREATION------------------
--------------------------------------------------

local display = CreateFrame("Frame", "BCP", UIParent)
display:SetFrameStrata("BACKGROUND")
display:SetWidth(30)
display:SetHeight(30)
display:Show()

--------------------------------------------------
---------------------FONT SET---------------------
--------------------------------------------------

local text = display:CreateFontString(nil,"OVERLAY")
text:SetPoint("CENTER", display, "CENTER")
local font = "Fonts\\FRIZQT__.TTF"

--------------------------------------------------
-------------------EVENT REGISTER-----------------
--------------------------------------------------

local event = CreateFrame("Frame")
event:SetScript("OnEvent", function()

points = GetComboPoints()

--addon check, change position according to UF addon
if not start then
	start = true
	if IsAddOnLoaded("ag_UnitFrames") then
		display:SetParent(aUFtarget)
		display:SetPoint("RIGHT", aUFtarget, "RIGHT", 25, 0)
	elseif IsAddOnLoaded("PitBull") then
		display:SetParent(PitBullUnitFrame4)
		display:SetPoint("RIGHT", PitBullUnitFrame4, "RIGHT", 50, 0)
	elseif IsAddOnLoaded("XPerl_Target") then
		display:SetParent(XPerl_Target)
		display:SetPoint("RIGHT", XPerl_Target, "RIGHT", 60, 0)
	elseif IsAddOnLoaded("Perl_Target") then
		display:SetParent(Perl_Target_StatsFrame_CastClickOverlay)
		display:SetPoint("RIGHT", Perl_Target_StatsFrame_CastClickOverlay, "RIGHT", 40, 0)
	else
		display:SetParent(TargetFrame)
		display:SetPoint("RIGHT", TargetFrame, "RIGHT", 4, 5)
	end
	IsAddOnLoaded = nil
end

--Update point colour and size
if points == 0 then
	text:SetFont(font, 18) 
	text:SetText("") --remove this line below when testing new frame locations for ease, we don't want to display if we have 0 points
	return --remove when frame testing
elseif points == 1 then
	text:SetFont(font, 18)
	text:SetTextColor(1, 1, 1)
elseif points == 2 then
	text:SetFont(font, 22)
	text:SetTextColor(0, 1, 0)
elseif points == 3 then
	text:SetFont(font, 25)
	text:SetTextColor(1, 1, 0)
elseif points == 4 then
	text:SetFont(font, 29)
	text:SetTextColor(0, 0, 1)
else
	text:SetFont(font, 35)
	text:SetTextColor(1, 0, 0)
end

text:SetText(points) --Update point text
end)
event:RegisterEvent("PLAYER_COMBO_POINTS")
event:RegisterEvent("PLAYER_TARGET_CHANGED")

