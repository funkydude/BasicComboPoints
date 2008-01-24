------------------------------
--      Are you local?      --
------------------------------

local _, class = UnitClass("player")
if class == "ROGUE" or class == "DRUID" then
	class = nil
else
	DisableAddOn("BasicComboPoints")
	return
end

local GetComboPoints = GetComboPoints
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

local BasicComboPoints = LibStub("AceAddon-3.0"):NewAddon("BasicComboPoints", "AceEvent-3.0", "AceConsole-3.0")

local function setLock()
	if not db.lock then
		display:SetBackdropColor(1,1,1,0)
		display:EnableMouse(false)
		display:SetMovable(false)
		db.lock = true
	else
		display:SetBackdropColor(1,1,1,1)
		display:EnableMouse(true)
		display:SetMovable(true)
		db.lock = nil
	end
end

local bcpOptions = {
	type = "group",
	name = "BasicComboPoints",
	args = {
		intro = {
			type = "description",
			name = "BasicComboPoints is a numerical display of your current combo points, with extras such as a font and color chooser.",
			order = 1,
		},
		font = {
			order = 2,
			name = "Font",
			type = "group",
			args = {
				fontdesc = {
					order = 1,
					type = "description",
					name = "Change the numerical font of the displayed points.",
				},
			},
		},
		color = {
			order = 3,
			name = "Color",
			type = "group",
			args = {
				colordesc = {
					order = 1,
					type = "description",
					name = "Choose the colors for the different points.",
				},
			},
		},
		size = {
			order = 4,
			name = "Size",
			type = "group",
			args = {
				sizedesc = {
					order = 1,
					type = "description",
					name = "Choose the size of the font for the different points.",
				},
			},
		},
		lock = {
			order = 5,
			name = "Lock",
			type = "group",
			args = {
				lockdesc = {
					order = 1,
					type = "description",
					name = "Lock the points frame in its current location.",
				},
				lockset = {
					name = "Lock",
					type = "toggle",
					get = function() return db.lock end,
					set = setLock,
					order = 2,
				},
			},
		},
	}
}

------------------------------
--      Initialization      --
------------------------------

function BasicComboPoints:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("BasicComboPointsDB", defaults)
	db = self.db.profile

	LibStub("AceConfig-3.0"):RegisterOptionsTable("BasicComboPoints", bcpOptions)
	self:RegisterChatCommand("bcp", function() LibStub("AceConfigDialog-3.0"):Open("BasicComboPoints") end)
end

------------------------------
--       Frame Setup        --
------------------------------

local function move() this:StartMoving() end
local function stop()
	this:StopMovingOrSizing()
	BasicComboPoints:SavePosition()
end

function BasicComboPoints:OnEnable()
	if not display then
		display = CreateFrame("Frame", "BCPFrame", UIParent)
		display:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",})
		display:SetFrameStrata("BACKGROUND")
		display:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
		display:SetBackdropColor(1,1,1,0)
		display:SetWidth(50)
		display:SetHeight(50)
		display:Show()
		display:RegisterForDrag("LeftButton")
		display:SetScript("OnDragStart", move)
		display:SetScript("OnDragStop", stop)
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
	local points = GetComboPoints()

	if points == 0 then
		points = ""
	elseif points == 1 then
		text:SetFont(font, 15)
		text:SetTextColor(1, 1, 1)
		--text:SetFont(db.font, db.sizeone)
		--text:SetTextColor(db.colorone)
	elseif points == 2 then
		text:SetFont(font, 25)
		text:SetTextColor(0, 1, 0)
		--text:SetFont(db.font, db.sizetwo)
		--text:SetTextColor(db.colortwo)
	elseif points == 3 then
		text:SetFont(font, 35)
		text:SetTextColor(1, 1, 0)
		--text:SetFont(db.font, db.sizethree
		--text:SetTextColor(db.colorthree)
	elseif points == 4 then
		text:SetFont(font, 45)
		text:SetTextColor(0, 0, 1)
		--text:SetFont(db.font, db.sizefour)
		--text:SetTextColor(db.colorfour)
	else
		text:SetFont(font, 55)
		text:SetTextColor(1, 0, 0)
		--text:SetFont(db.font, db.sizefive)
		--text:SetTextColor(db.colorfive)
	end

	text:SetText(points)
end

