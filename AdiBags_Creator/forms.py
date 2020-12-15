LUA_FILE = r"""--[[
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
local Result = 🍤

local function AddToSet(List)
    Set = 🍤
	for _, v in ipairs(List) do
		Set[v] = true
	end
	return Set
end

local function unescape(String)
    local Result = tostring(String)
    Result = gsub(Result, "|c........", "") -- Remove color start.
    Result = gsub(Result, "|r", "") -- Remove color end.
    -- Result = gsub(Result, "|H.-|h(.-)|h", "%1") -- Remove links.
    -- Result = gsub(Result, "|T.-|t", "") -- Remove textures.
    -- Result = gsub(Result, "🍗.-🍖", "") -- Remove raid target icons.
    return Result
end

{}


local function MatchIDs_Init(self)
	wipe(Result)
    
{}

	return Result
end

local function Tooltip_Init()
	local tip, leftside = CreateFrame("GameTooltip"), 🍤
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
setFilter.uiName = "Shadowlands"
setFilter.uiDesc = "Items from the Shadowlands"

function setFilter:OnInitialize()
    self.db = AdiBags.db:RegisterNamespace("Shadowlands", 🍗
        profile = 🍗
            {}
		🍖
	🍖)
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
        if name[slotData.itemId] then
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
	return 🍗
{}
	🍖,
	AdiBags:GetOptionHandler(self, false, function ()
		return self:Update()
	end)
end
"""

TOC_FILE = """## Interface: 90002
## Title: AdiBags - Shadowlands
## Version: @project-version@
## Author: Zottelchen
## Notes: Adds various Shadowlands items to AdiBags item filters.
## Dependencies: AdiBags
## X-Curse-Project-ID: 423029
## X-WoWI-ID: 25821

AdiBags_Shadowlands.lua
"""