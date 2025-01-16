local addonName = ...
if select(2, UnitClass("player")) ~= "ROGUE" then return end

local tooltip = CreateFrame("GameTooltip", addonName .. "TempEnchantScanner", UIParent, "GameTooltipTemplate")
tooltip:Show()

local tempEnchants = {}

if GetLocale() == "ruRU" then
    tempEnchants = {
        ["Калечащий"] = "Interface\\Icons\\ability_poisonsting",
        ["Быстродействующий"] = "Interface\\Icons\\ability_poisons",
        ["Смертельный"] = "Interface\\Icons\\ability_rogue_dualweild",
        ["Нейтрализующий"] = "Interface\\Icons\\inv_misc_herb_16",
        ["Анестезирующий"] = "Interface\\Icons\\spell_nature_slowpoison",
        ["Дурманящий"] = "Interface\\Icons\\spell_nature_nullifydisease",
    }
elseif GetLocale() == "deDE" then
    tempEnchants = {
        ["Verkrüppel"] = "Interface\\Icons\\ability_poisonsting",
        ["Sofort"] = "Interface\\Icons\\ability_poisons",
        ["Tödliches"] = "Interface\\Icons\\ability_rogue_dualweild",
        ["Wundgift"] = "Interface\\Icons\\inv_misc_herb_16",
        ["Beruhigendes"] = "Interface\\Icons\\spell_nature_slowpoison",
        ["Gedankenbenebelndes"] = "Interface\\Icons\\spell_nature_nullifydisease",
    }
elseif GetLocale() == "frFR" then
    tempEnchants = {
        ["affaiblissant"] = "Interface\\Icons\\ability_poisonsting",
        ["instantané"] = "Interface\\Icons\\ability_poisons",
        ["mortel"] = "Interface\\Icons\\ability_rogue_dualweild",
        ["douloureux"] = "Interface\\Icons\\inv_misc_herb_16",
        ["anesthésiant"] = "Interface\\Icons\\spell_nature_slowpoison",
        ["distraction"] = "Interface\\Icons\\spell_nature_nullifydisease",
    }
elseif GetLocale() == "esES" then
    tempEnchants = {
        ["entorpecedor"] = "Interface\\Icons\\ability_poisonsting",
        ["instantáneo"] = "Interface\\Icons\\ability_poisons",
        ["mortal"] = "Interface\\Icons\\ability_rogue_dualweild",
        ["hiriente"] = "Interface\\Icons\\inv_misc_herb_16",
        ["anestésico"] = "Interface\\Icons\\spell_nature_slowpoison",
        ["mental"] = "Interface\\Icons\\spell_nature_nullifydisease",
    }
elseif GetLocale() == "zhTW" then
    tempEnchants = {
        ["致殘"] = "Interface\\Icons\\ability_poisonsting",
        ["速效"] = "Interface\\Icons\\ability_poisons",
        ["致命"] = "Interface\\Icons\\ability_rogue_dualweild",
        ["致傷"] = "Interface\\Icons\\inv_misc_herb_16",
        ["麻醉"] = "Interface\\Icons\\spell_nature_slowpoison",
        ["麻痹"] = "Interface\\Icons\\spell_nature_nullifydisease",
    }
else
    tempEnchants = {
        ["Crippling"] = "Interface\\Icons\\ability_poisonsting",
        ["Instant"] = "Interface\\Icons\\ability_poisons",
        ["Deadly"] = "Interface\\Icons\\ability_rogue_dualweild",
        ["Wound"] = "Interface\\Icons\\inv_misc_herb_16",
        ["Anesthetic"] = "Interface\\Icons\\spell_nature_slowpoison",
        ["Mind"] = "Interface\\Icons\\spell_nature_nullifydisease",
    }
end

local textures = {}

local function createTexture(name)
    local frame = _G[name]
    local icon = _G[name .. "Icon"]
    local texture = frame:CreateTexture(nil, "ARTWORK")
    texture:SetAllPoints(icon)

    return texture
end

for i = 1, 2 do
    textures[i] = createTexture("TempEnchant" .. i)
end

local tooltipText = setmetatable({}, {
    __index = function(self, index)
        self[index] = _G[addonName .. "TempEnchantScannerTextLeft" .. index]
        return self[index]
    end
})

tooltip:SetScript("OnTooltipSetItem", function(self)
    for index = 1, self:NumLines() do
        local line = tooltipText[index]
        if line and line:GetText() then
            local text = line:GetText()

            for enchantName, texture in pairs(tempEnchants) do
                if text and string.match(text, enchantName) then
                    self.texture = texture
                    return
                end
            end
        end
    end
    self.texture = nil
end)

local function UpdateEnchantIcons()
    local mainHandEnchanted, _, _, offHandEnchanted = GetWeaponEnchantInfo()

    if mainHandEnchanted and offHandEnchanted then
        tooltip:SetInventoryItem("player", 17)
        if tooltip.texture then
            textures[1]:SetTexture(tooltip.texture)
        else
            textures[1]:SetTexture(nil)
        end

        tooltip:SetInventoryItem("player", 16)
        if tooltip.texture then
            textures[2]:SetTexture(tooltip.texture)
        else
            textures[2]:SetTexture(nil)
        end
    elseif mainHandEnchanted then
        tooltip:SetInventoryItem("player", 16)
        if tooltip.texture then
            textures[1]:SetTexture(tooltip.texture)
        else
            textures[1]:SetTexture(nil)
        end
    elseif offHandEnchanted then
        tooltip:SetInventoryItem("player", 17)
        if tooltip.texture then
            textures[1]:SetTexture(tooltip.texture)
        else
            textures[1]:SetTexture(nil)
        end
    else
        textures[1]:SetTexture(nil)
        textures[2]:SetTexture(nil)
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
frame:RegisterUnitEvent("UNIT_MODEL_CHANGED", "player")
frame:RegisterUnitEvent("UNIT_INVENTORY_CHANGED", "player")
frame:SetScript("OnEvent", UpdateEnchantIcons)