local ADDON, TC = ...

SLASH_TRACKCONSUMABLES1 = '/tc'
function SlashCmdList.TRACKCONSUMABLES(msg, editbox)
    -- TODO: Implement enable/disable functionality
    if msg == "" then TC.ShowHelp()
    elseif msg == 'run' then TC.RunCheck()
    end
end

function TC.GetDefaults()
    return {
    }
end

function TC.ShowHelp()
    TC.WriteDebugMessage("Usage: /tc <command>")
    TC.WriteDebugMessage("Available commands:")
    TC.WriteDebugMessage("/tc run - Performs consumable check on all raid/party members and prints the result to raid/party chat.")
end

function TC.GetSecondsRemaining(expireTime)
    -- The UnitBuff() function provides the expiration time of buffs.
    -- The value is relative to GetTime() of the local machine.
    -- Thus the length of time remaining is the difference between these values.
    local secondsRemaining = (expireTime - GetTime())
    return secondsRemaining
end

function TC.WriteDebugMessage(message, includeHeader)
    includeHeader = (includeHeader ~= false) -- Optional param; default to true
    if TC.DEBUG then
        if includeHeader then
            _G["ChatFrame1"]:AddMessage("[TrackConsumables] " .. message)
        else
            _G["ChatFrame1"]:AddMessage(message)
        end
    end
end

function TC.GetBuff(table, unitId)
    for k = 1, 40 do
        local actualBuff, _, _, _, _, expireTime, _, _, _, spellId = UnitBuff(unitId, k)
        if actualBuff == nil then break end

        for j = 1, #(table) do
            if spellId == table[j] then
                local secondsRemaining = TC.GetSecondsRemaining(expireTime)
                return true, spellId, secondsRemaining
            end
        end
    end
    return false, nil, nil
end

function TC.RunCheck()
    local isRaid = IsInRaid()
    local isParty = IsInGroup()

    local groupStatus = {}

    local includeOffline = false
    local includeFood = false
    local includeFlask = false
    local includeGuardian = false
    local includeBattle = false

    local playerMissing = "Offline/AFK:"
    local foodMissing = "Missing Food:"
    local flaskMissing = "Missing Flask:"
    local guardianMissing = "Missing Guardian Elixir:"
    local battleMissing = "Missing Battle Elixir:"

    for i = 1, GetNumGroupMembers() do
        local playerName, rank, subgroup, level, className, classSystemName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)

        -- TODO: Don't check low-level players

        local unitId
        if isRaid then
            unitId = string.format("raid%d", i)
        elseif isParty then
            unitId = string.format("party%d", i)
        end

        TC.WriteDebugMessage(playerName .. " " .. rank .. " " .. subgroup .. " " .. level .. " " .. className .. " " .. classSystemName .. " " .. zone .. " " .. tostring(online) .. " " .. tostring(isDead) .. " " .. tostring(role) .. " " .. tostring(isML))

        local isMainTank = role == "MAINTANK"
        local isMainAssist = role == "MAINASSIST"
        -- TODO: Determine utility of individual warnings for main-tank / off-tank

        local hasFood, _, foodRemaining = TC.GetBuff(TC.Data.Food, unitId)
        local hasFlask, _, flaskRemaining = TC.GetBuff(TC.Data.Flask, unitId)
        local hasBattle, _, battleRemaining = TC.GetBuff(TC.Data.Battle, unitId)
        local hasGuardian, _, guardianRemaining = TC.GetBuff(TC.Data.Guardian, unitId)

        groupStatus[i] = {
            name = playerName,
            food = { hasFood, foodRemaining },
            flask = { hasFlask, flaskRemaining },
            battle = { hasBattle, battleRemaining },
            guardian = { hasGuardian, guardianRemaining },
        }

        if online then
            if not hasFood then
                includeFood = true
                foodMissing = string.format("%s %s", foodMissing, playerName)
            end

            if not hasFlask then
                if hasBattle or hasGuardian then
                    if not hasBattle then
                        includeBattle = true
                        battleMissing = string.format("%s %s", battleMissing, playerName)
                    end

                    if not hasGuardian then
                        includeGuardian = true
                        guardianMissing = string.format("%s %s", guardianMissing, playerName)
                    end
                else
                    includeFlask = true
                    flaskMissing = string.format("%s %s", flaskMissing, playerName)
                end
            end
        else
            includeOffline = true
            playerMissing = string.format("%s %s", playerMissing, playerName)
        end

    end

    if includeOffline then TC.SendAnnouncement(playerMissing) end
    if includeFood then TC.SendAnnouncement(foodMissing) end
    if includeFlask then TC.SendAnnouncement(flaskMissing) end
    if includeGuardian then TC.SendAnnouncement(guardianMissing) end
    if includeBattle then TC.SendAnnouncement(battleMissing) end

    local result = {
        players = groupStatus
    }

    return result
end

function TC.SendAnnouncement(message)
    local reportChannel = nil
    -- Only announce to raid/party if we're the leader (or have assist)
    if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then
        if IsInRaid() then
            reportChannel = "RAID"
        elseif IsInGroup() then
            reportChannel = "PARTY"
        end
    end

    if reportChannel == nil then
        TC.WriteDebugMessage(message, false)
    else
        -- SendChatMessage is limited to 255 characters per message
        -- TODO: Split across multiple messages if needed
        SendChatMessage(message, reportChannel, nil)
    end
end
