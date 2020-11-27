
if GetLocale() ~= "frFR" then return end
local _, tbl = ...
local L = tbl.L

L["Apply the color you wish to use for your Combo Points."] = "Détermine la couleur à utiliser pour vos points de combo."
L["Apply the font you wish to use for your Combo Points."] = "Détermine la police d'écriture à utiliser pour vos points de combo."
L["Apply the size you wish to use for your Combo Points."] = "Détermine la taille de police à utiliser pour vos points de combo."
L["Apply the %s you wish to use for Combo Point %d."] = "Détermine la %s à utiliser quand vous avez %d |4point:points; de combo."
L["BasicComboPoints is a numerical display of your current combo points, with extras such as a font and color chooser."] = "BasicComboPoints est un affichage numérique de vos points de combo actuels, avec quelques extras comme la sélection de la police et de la couleur."
L["Font"] = "Police d'écriture"
L["Lock the points frame in its current location."] = "Verrouille le cadre des points à sa position actuelle."

L.COMBAT_TEXT_COMBO_POINTS = "%d |4point:points; de combo"
