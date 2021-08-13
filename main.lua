local addon = LibStub("AceAddon-3.0"):NewAddon("SPTDB")
local icon = LibStub("LibDBIcon-1.0")

professions = {}

local frame = CreateFrame("FRAME", "myFrame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_UNGHOST")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:RegisterEvent("PLAYER_ALIVE")
local function eventHandler(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "SodaProfessionTracker" then
        if SPTProfessions == nil then
            SPTProfessions = {minerals = false, herbs = false}
        end
        herbsCheckButton:SetChecked(SPTProfessions.herbs)
        mineralsCheckButton:SetChecked(SPTProfessions.minerals)
        professions = SPTProfessions
    elseif event == "PLAYER_LOGOUT" then
        SPTProfessions = professions
    else
        if SPTProfessions.minerals == true then
            CastSpellByName("Find Minerals")
        end
        if SPTProfessions.herbs == true then
            CastSpellByName("Find Herbs")
        end
    end
end
frame:SetScript("OnEvent", eventHandler);

local parentFrame = CreateFrame("Frame", "ParentFrame", MinimapCluster)
parentFrame:SetFrameStrata("DIALOG")
parentFrame:SetWidth(120) -- Set these to whatever height/width is needed 
parentFrame:SetHeight(60) -- for your Texture
parentFrame:SetPoint("CENTER", -180, 0) -- for your Texture
parentFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
    tile = true, tileSize = 8, edgeSize = 8, 
    insets = { left = 4, right = 4, top = 4, bottom = 4 }});

parentFrame:SetBackdropColor(0,0,0,1);
parentFrame:Hide()


local uniquealyzer = 1;
function createCheckbutton(parent, x_loc, y_loc, displayname)
	uniquealyzer = uniquealyzer + 1;
	local checkbutton = CreateFrame("CheckButton", "my_addon_checkbutton_0" .. uniquealyzer, parent, "ChatConfigCheckButtonTemplate");
	checkbutton:SetPoint("TOPLEFT", x_loc, y_loc);
	getglobal(checkbutton:GetName() .. 'Text'):SetText(displayname);

	return checkbutton;
end

mineralsCheckButton = createCheckbutton(ParentFrame, 4, -4, "Track Minerals");
mineralsCheckButton.tooltip = "Find minerals?";

mineralsCheckButton:SetScript("OnClick", 
   function()
        professions.minerals = mineralsCheckButton:GetChecked()
        professions.herbs = not professions.minerals
        herbsCheckButton:SetChecked(professions.herbs)
   end
);

herbsCheckButton = createCheckbutton(ParentFrame, 4, -32, "Track Herbs");
herbsCheckButton.tooltip = "Find herbs?";

herbsCheckButton:SetScript("OnClick", 
   function()
        professions.herbs = herbsCheckButton:GetChecked()
        professions.minerals = not professions.herbs
        mineralsCheckButton:SetChecked(professions.minerals)
   end
);

local bunnyLDB = LibStub("LibDataBroker-1.1"):NewDataObject("SPT!", {
    type = "data source",
    text = "SPT!",
    icon = "Interface\\Icons\\inv_misc_flower_02",
    OnTooltipShow = function(tooltip)
      tooltip:AddLine("SPT")
      tooltip:AddLine("Select tracking spells")
    end
    })
    
function bunnyLDB:OnClick()
    if parentFrame:IsVisible() then parentFrame:Hide() else parentFrame:Show() end
end

function addon:OnInitialize() -- Obviously you'll need a ## SavedVariables: BunniesDB line in your TOC, duh! 
    self.db = LibStub("AceDB-3.0"):New("SPTDB", { profile = { minimap = { hide = false, }, }, }) icon:Register("SPT!", bunnyLDB, self.db.profile.minimap)
    bunnyLDB.icon = "Interface\\Icons\\inv_misc_flower_02"
end



