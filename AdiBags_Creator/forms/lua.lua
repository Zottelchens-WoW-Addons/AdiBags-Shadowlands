--[[
AdiBags - Shadowlands
by Zottelchen
version: @project-version@
Add various Shadowlands items to AdiBags filter groups
]]

local addonName, addon = ...
local AdiBags = LibStub("AceAddon-3.0"):GetAddon("AdiBags")

local L = addon.L
local MatchIDs
local Tooltip
local Result = {}

local function AddToSet(List)
    local Set = {}
	for _, v in ipairs(List) do
		Set[v] = true
	end
	return Set
end

local function unescape(String)
    local unescaped = tostring(String)
    unescaped = gsub(unescaped, "|c........", "") -- Remove color start.
    unescaped = gsub(unescaped, "|r", "") -- Remove color end.
    -- Result = gsub(Result, "|H.-|h(.-)|h", "%1") -- Remove links.
    -- Result = gsub(Result, "|T.-|t", "") -- Remove textures.
    -- Result = gsub(Result, "{.-}", "") -- Remove raid target icons.
    return unescaped
end

--!!PH


local function MatchIDs_Init(self)
	wipe(Result)
    
--!!PH

	return Result
end

local function Tooltip_Init()
	local tip, leftside = CreateFrame("GameTooltip"), {}
	for i = 1, 6 do
		local Left, Right = tip:CreateFontString(), tip:CreateFontString()
		Left:SetFontObject(GameFontNormal)
		Right:SetFontObject(GameFontNormal)
		tip:AddFontStrings(Left, Right)
		leftside[i] = Left
	end
	tip.leftside = leftside
	return tip
end

local setFilter = AdiBags:RegisterFilter("Shadowlands", 98, "ABEvent-1.0")
setFilter.uiName = "|cff008a57Shadowlands|r"
setFilter.uiDesc = "Items from the Shadowlands"

function setFilter:OnInitialize()
    self.db = AdiBags.db:RegisterNamespace("Shadowlands", {
        profile = {
            --!!PH
		}
	})
end

function setFilter:Update()
	MatchIDs = nil
	self:SendMessage("AdiBags_FiltersChanged")
end

function setFilter:OnEnable()
	AdiBags:UpdateFilters()
end

function setFilter:OnDisable()
	AdiBags:UpdateFilters()
end

function setFilter:Filter(slotData)
	MatchIDs = MatchIDs or MatchIDs_Init(self)
	for i, name in pairs(MatchIDs) do
		-- Override Method
		if MatchIDs[i]['override'] then
			slotData['loc'] = ItemLocation:CreateFromBagAndSlot(slotData.bag, slotData.slot)
			if slotData['loc']:IsValid() then
				if MatchIDs[i]['override_method'](slotData.loc) then
					return i
				end
			end

		-- Bonus Condition (triggers when bonus condition is not fulfilled)
		elseif MatchIDs[i]['bonus_condition'] then
			if name[slotData.itemId] then
				slotData['loc'] = ItemLocation:CreateFromBagAndSlot(slotData.bag, slotData.slot)
				if slotData['loc']:IsValid() then
					if not MatchIDs[i]['bonus_condition_method'](slotData.loc) then -- THERE IS A NOT HERE!
						return i
					end
				end
			end

		-- Standard ID Matching
		elseif name[slotData.itemId] then
			return i
		end
	end
	
	Tooltip = Tooltip or Tooltip_Init()
	Tooltip:SetOwner(UIParent,"ANCHOR_NONE")
	Tooltip:ClearLines()
	
	if slotData.bag == BANK_CONTAINER then
		Tooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(slotData.slot, nil))
	else
		Tooltip:SetBagItem(slotData.bag, slotData.slot)
	end
	
	Tooltip:Hide()
end

function setFilter:GetOptions()
	return {
--!!PH
	},
	AdiBags:GetOptionHandler(self, false, function ()
		return self:Update()
	end)
end
