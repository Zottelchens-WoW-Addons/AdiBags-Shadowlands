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

local setFilter = AdiBags:RegisterFilter("Shadowlands", 98, "ABEvent-1.0")
setFilter.uiName = "|cff008a57Shadowlands|r"
setFilter.uiDesc = "Items from the Shadowlands\n|cff50C878Filter version: @project-version@|r"

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
			if slotData['loc']  and slotData['loc']:IsValid() then
				if MatchIDs[i]['override_method'](slotData.loc) then
					return i
				end
			end

		-- Bonus Condition (triggers when bonus condition is not fulfilled)
		elseif MatchIDs[i]['bonus_condition'] then
			if name[slotData.itemId] then
				slotData['loc'] = ItemLocation:CreateFromBagAndSlot(slotData.bag, slotData.slot)
				if slotData['loc'] and slotData['loc']:IsValid() then
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
end

function setFilter:GetOptions()
	return {
--!!PH
	},
	AdiBags:GetOptionHandler(self, false, function ()
		return self:Update()
	end)
end
