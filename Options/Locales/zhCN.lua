
if GetLocale() ~= "zhCN" then return end
local _, tbl = ...
local L = tbl.L
L["Apply a outline to your text."] = "设置文本轮廓"
L["Apply a shadow to your text."] = "添加阴影效果。"
L["Apply the color you wish to use for your Combo Points."] = "设置连击点颜色。"
L["Apply the font you wish to use for your Combo Points."] = "设置连击点字体。"
L["Apply the size you wish to use for your Combo Points."] = "设置连击点的大小。"
L["Apply the %s you wish to use for Combo Point %d."] = "设置%s连击点数%d。"
L["BasicComboPoints is a numerical display of your current combo points, with extras such as a font and color chooser."] = "BasicComboPoints是一个显示你目前的连击点的数值的插件,可以改变字体和颜色."
L["Font"] = "字体"
L["Lock the points frame in its current location."] = "锁定框架在当前位置。"
L["Outline"] = "轮廓"
L["Thick Outline"] = "粗轮廓"

L.COMBAT_TEXT_COMBO_POINTS = "%d连击"
