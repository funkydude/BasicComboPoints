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

local BasicComboPoints = LibStub("AceAddon-3.0"):NewAddon("BasicComboPoints", "AceEvent-3.0")
local media = LibStub("LibSharedMedia-3.0")

------------------------------
--           Config         --
------------------------------

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

local bcpOptions
local function getOptions()
	if not bcpOptions then
		bcpOptions = {
			type = "group",
			name = "BasicComboPoints",
			args = {
				intro = {
					type = "description",
					name = "BasicComboPoints is a numerical display of your current combo points, with extras such as a font and color chooser.",
					order = 1,
				},
				spacer = {
					type = "header",
					name = "",
					order = 2,
				},
				lock = {
					name = "Lock",
					desc = "Lock the points frame in its current location.",
					type = "toggle",
					get = function() return db.lock end,
					set = setLock,
					order = 3,
				},
				font = {
					desc = "Apply the font you wish to use for your Combo Points.",
					type = "select", 
					name = "Font",
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
					order = 4,
				},
			},
		}
	end
	return bcpOptions
end

local bcpOptionsColor
local function getBcpColor()
	if not bcpOptionsColor then
		bcpOptionsColor = {
			name = "Color",
			type = "group",
			args = {
				desc = {
					type = "description",
					name = "Apply the color you wish to use for your Combo Points.",
					order = 1,
				},
				spacer = {
					type = "header",
					name = "",
					order = 2,
				},
				colorone = {
					desc = "Apply the color you wish to use for Combo Point 1.",
					order = 3,
					name = "Combo Point 1",
					type = "color",
					get = function() return db.size.one, db.colorone.g, db.colorone.b end,
					set = function(_, v) db.size.one = v db.colorone.g = g db.colorone.b = b end,
					width = "full",
				},
				colortwo = {
					desc = "Apply the color you wish to use for Combo Point 2.",
					order = 4,
					name = "Combo Point 2",
					type = "color",
					get = function() return db.colortwo.r, db.colortwo.g, db.colortwo.b end,
					set = function(_, r, g, b) db.colortwo.r = r db.colortwo.g = g db.colortwo.b = b end,
					width = "full",
				},
				colorthree = {
					desc = "Apply the color you wish to use for Combo Point 3.",
					order = 5,
					name = "Combo Point 3",
					type = "color",
					get = function() return db.colorthree.r, db.colorthree.g, db.colorthree.b end,
					set = function(_, r, g, b) db.colorthree.r = r db.colorthree.g = g db.colorthree.b = b end,
					width = "full",
				},
				colorfour = {
					desc = "Apply the color you wish to use for Combo Point 4.",
					order = 6,
					name = "Combo Point 4",
					type = "color",
					get = function() return db.colorfour.r, db.colorfour.g, db.colorfour.b end,
					set = function(_, r, g, b) db.colortwo.r = r db.colortwo.g = g db.colortwo.b = b end,
					width = "full",
				},
				colorfive = {
					desc = "Apply the color you wish to use for Combo Point 5.",
					order = 7,
					name = "Combo Point 5",
					type = "color",
					get = function() return db.colorfive.r, db.colorfive.g, db.colorfive.b end,
					set = function(_, r, g, b) db.colorfive.r = r db.colorfive.g = g db.colorfive.b = b end,
					width = "full",
				},
			},
		}
	end
	return bcpOptionsColor
end

local bcpOptionsSize
local function getBcpSize()
	if not bcpOptionsSize then
		bcpOptionsSize = {
			name = "Size",
			type = "group",
			args = {
				desc = {
					type = "description",
					name = "Apply the size you wish to use for your Combo Points.",
					order = 1,
				},
				spacer = {
					type = "header",
					name = "",
					order = 2,
				},
				sizeone = {
					desc = "Apply the size you wish to use for Combo Point 1.",
					order = 3,
					name = "Combo Point 1",
					type = "range",
					min = 1, max = 48, step = 1,
					get = function() return db.size.one end,
					set = function(_, v) db.size.one = v end,
					width = "full",
				},
				sizetwo = {
					desc = "Apply the size you wish to use for Combo Point 2.",
					order = 4,
					name = "Combo Point 2",
					type = "range",
					min = 1, max = 48, step = 1,
					get = function() return db.size.two end,
					set = function(_, v) db.size.two = v end,
					width = "full",
				},
				sizethree = {
					desc = "Apply the size you wish to use for Combo Point 3.",
					order = 5,
					name = "Combo Point 3",
					type = "range",
					min = 1, max = 48, step = 1,
					get = function() return db.size.three end,
					set = function(_, v) db.size.three = v end,
					width = "full",
				},
				sizefour = {
					desc = "Apply the size you wish to use for Combo Point 4.",
					order = 6,
					name = "Combo Point 4",
					type = "range",
					min = 1, max = 48, step = 1,
					get = function() return db.size.four end,
					set = function(_, v) db.size.four = v end,
					width = "full",
				},
				sizefive = {
					desc = "Apply the size you wish to use for Combo Point 5.",
					order = 7,
					name = "Combo Point 5",
					type = "range",
					min = 1, max = 48, step = 1,
					get = function() return db.size.five end,
					set = function(_, v) db.size.five = v end,
					width = "full",
				},
			},
		}
	end
	return bcpOptionsSize
end

------------------------------
--      Initialization      --
------------------------------

function BasicComboPoints:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("BasicComboPointsDB", defaults)
	db = self.db.profile

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("BasicComboPoints", getOptions)
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("BasicComboPointsColor", getBcpColor)
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("BasicComboPointsSize", getBcpSize)

	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BasicComboPoints", "BasicComboPoints")
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BasicComboPointsColor", "Color", "BasicComboPoints")
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BasicComboPointsSize", "Size", "BasicComboPoints")
end

------------------------------
--       Frame Setup        --
------------------------------

local function move() this:StartMoving() end
local function stop()
	this:StopMovingOrSizing()
	local s = display:GetEffectiveScale()
	db.x = display:GetLeft() * s
	db.y = display:GetTop() * s
end

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
	font = media:Fetch("font", db.font)
	text:SetShadowColor(0, 0, 0, 1)
	text:SetShadowOffset(1, -1)
	text:SetFont(font, 15)

	self:RegisterEvent("PLAYER_COMBO_POINTS", "Update")
	self:RegisterEvent("PLAYER_TARGET_CHANGED", "Update")

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

