-- Create namespace with top level table
MaarselokTracker = {}

-- Constants
MaarselokTracker.name = "MaarselokTracker"
MaarselokTracker.procCooldown = 7
MaarselokTracker.timer = 0
MaarselokTracker.UPDATE_INTERVAL = 100 

-- Restore saved position from savedVariables
function MaarselokTracker:RestorePosition()
  local left = self.savedVariables.left
  local top = self.savedVariables.top

  MaarselokTrackerIndicator:ClearAnchors()
  MaarselokTrackerIndicator:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
end

-- Initialize addon
function MaarselokTracker:Initialize()
  -- Equivalent to MaarselokTracker.inCombat when using : to assign self
  self.inCombat = IsUnitInCombat("player");

  -- Register combat change event
  EVENT_MANAGER:RegisterForEvent(
    self.name, 
    EVENT_PLAYER_COMBAT_STATE, 
    self.OnPlayerCombatState
  )

  EVENT_MANAGER:RegisterForEvent(MaarselokTracker.name, EVENT_COMBAT_EVENT, MaarselokTracker.OnCombatEvent)
  -- Filter for the right id eventually

  -- Initialie saved variables
  self.savedVariables = ZO_SavedVars:NewAccountWide(
    "MaarselokTrackerSavedVariables", 
    1, 
    nil, 
    {}
  )

  self:RestorePosition()
end

-- Event handler callback function, initialize addon after
-- resources are loaded
function MaarselokTracker.OnAddOnLoaded(event, addonName)
  -- EVENT_ADD_ON_LOADED fires for each addon, check for own
  if addonName == MaarselokTracker.name then
    MaarselokTracker:Initialize()
  end
end

-- Callback for player state change
function MaarselokTracker.OnPlayerCombatState(event, inCombat)
  if inCombat ~= MaarselokTracker.inCombat then
    -- Combat state has changed, change store
    MaarselokTracker.inCombat = inCombat

    -- if inCombat then
    --   d("Entering combat.")
    -- else
    --   d("Exiting combat.")
    -- end

    MaarselokTrackerIndicator:SetHidden(not inCombat)
  end
end

-- Callback to handle movement stop
function MaarselokTracker.OnIndicatorMoveStop()
  MaarselokTracker.savedVariables.left = MaarselokTrackerIndicator:GetLeft()
  MaarselokTracker.savedVariables.top = MaarselokTrackerIndicator:GetTop()
end

-- Callback for checking MaarselokAbilityId
function MaarselokTracker.OnCombatEvent(eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId)
-- Use this template when done debugging
-- function MaarselokTracker.OnCombatEvent(_, _, _) etc
  -- eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId
  
  d("result=" .. tostring(result) .. "; isError=" .. tostring(isError) .. "; abilityName=" .. tostring(abilityName)
          .. "; abilityGraphic=" .. tostring(abilityGraphic) .. "; abilityActionSlotType=" .. tostring(abilityActionSlotType)
          .. "; sourceName=" .. tostring(sourceName) .. "; sourceType=" .. tostring(sourceType) .. "; targetName=" .. tostring(targetName)
          .. "; targetType=" .. tostring(targetType) .. "; hitValue=" .. tostring(hitValue) .. "; powerType=" .. tostring(powerType)
          .. "; damageType=" .. tostring(damageType) .. "; log=" .. tostring(log) .. "; sourceUnitId=" .. tostring(sourceUnitId)
          .. "; targetUnitId=" .. tostring(targetUnitId) .. "; abilityId=" .. tostring(abilityId))
  d("------------")

  d("result=" .. tostring(result) .. "; abilityName=" .. tostring(abilityName)
              .. "; hitValue=" .. tostring(hitValue) .. "; powerType=" .. tostring(powerType)
              .. "; damageType=" .. tostring(damageType) .. "; abilityId=" .. tostring(abilityId))
  d("------------")

  MaarselokTrackerIndicatorLabel:SetText(abilityName)

  -- -- If it is maarselok
  -- MaarselokTracker.timer = MaarselokTracker.procCooldown
  -- MaarselokTrackerIndicatorTimer:SetText(MaarselokTracker.timer)
  -- EVENT_MANAGER:RegisterForUpdate(
  --   MaarselokTracker.name,
  --   MaarselokTracker.UPDATE_INTERVAL,
  --   MaarselokTracker.countDown
  -- )
end

-- Count down the timer
function MaarselokTracker.countDown()
  if MaarselokTracker.timer > 0 then
    MaarselokTracker.timer -= MaarselokTracker.UPDATE_INTERVAL
  else
    MaarselokTracker:UnregisterForUpdate(
      MaarselokTracker.name
    )
  end
  MaarselokTrackerIndicatorTimer:SetText(string.format("%.1f", MaarselokTracker.timer))
end

-- Register event listener with namespace, event, and callback
EVENT_MANAGER:RegisterForEvent(MaarselokTracker.name, EVENT_ADD_ON_LOADED, MaarselokTracker.OnAddOnLoaded)