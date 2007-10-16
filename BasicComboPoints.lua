--------------------------------------------------
----------------BASIC COMBO POINTS----------------
--------------------------------------------------

local points = nil
local GetComboPoints = GetComboPoints

--------------------------------------------------
------------------FRAME CREATION------------------
--------------------------------------------------

local display = CreateFrame("Frame", "BCP", UIParent)
display:SetFrameStrata("BACKGROUND")
display:SetWidth(30)
display:SetHeight(30)
display:SetPoint("RIGHT", TargetFrame, "RIGHT")
display:SetParent(TargetFrame)
display:Show()

--------------------------------------------------
---------------------FONT SET---------------------
--------------------------------------------------

local text = display:CreateFontString(nil,"OVERLAY")
text:SetPoint("CENTER", display, "CENTER")
text:SetFont("Fonts\\FRIZQT__.TTF", 25)
text:SetText("0")
text:SetShadowOffset(.8, -.8)
text:SetShadowColor(0, 0, 0, 1)

--------------------------------------------------
-------------------EVENT REGISTER-----------------
--------------------POINT UPDATE------------------
--------------------------------------------------

local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function(frame, event)

points = GetComboPoints()
text:SetText(points)

--debug
--ChatFrame1:AddMessage(("-%d-"):format(points))

end)
frame:RegisterEvent("PLAYER_COMBO_POINTS")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")

