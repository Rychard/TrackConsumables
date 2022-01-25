local ADDON, TC = ...
local TCEvents = {}

function TCEvents:ADDON_LOADED(addonName, ...)
    if ADDON ~= addonName then return end
    if not TrackConsumables then TrackConsumables = TC.GetDefaults() end
end

function TCEvents:READY_CHECK(self, arg1, arg2, ...)
    TC.RunCheck()
end

function TCEvents:READY_CHECK_FINISHED(...)
end

local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function(self, event, ...)
    if event ~= "ADDON_LOADED" then
        TC.WriteDebugMessage("EVENT: " .. event)
    end
    TCEvents[event](self, ...)
end)

for k, v in pairs(TCEvents) do frame:RegisterEvent(k) end