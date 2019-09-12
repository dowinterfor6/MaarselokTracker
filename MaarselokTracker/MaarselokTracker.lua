-- Create namespace with top level table
MaarselokTracker = {}

-- Namespace varaiables
MaarselokTracker.NAME = "MaarselokTracker"
MaarselokTracker.PROC_COOLDOWN = 7
MaarselokTracker.timer = 0
MaarselokTracker.UPDATE_INTERVAL = 0.1 
MaarselokTracker.MAARSELOK_ID = 126941

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
    MaarselokTracker.NAME, 
    EVENT_PLAYER_COMBAT_STATE, 
    self.OnPlayerCombatState
  )

  EVENT_MANAGER:RegisterForEvent(MaarselokTracker.NAME, EVENT_COMBAT_EVENT, MaarselokTracker.OnCombatEvent)
  EVENT_MANAGER:AddFilterForEvent(
    MaarselokTracker.NAME, 
    EVENT_COMBAT_EVENT, 
    REGISTER_FILTER_ABILITY_ID, 
    MaarselokTracker.MAARSELOK_ID
  )
  EVENT_MANAGER:AddFilterForEvent(
    MaarselokTracker.NAME,
    EVENT_COMBAT_EVENT,
    REGISTER_FILTER_UNIT_TAG,
    "player"
  )

  -- Initialize saved variables
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
  if addonName ~= MaarselokTracker.NAME then return end

  -- Unregister addon load listener
<<<<<<< HEAD:MaarselokTracker/MaarselokTracker.lua
  EVENT_MANAGER:UnregisterForEvent(MaarselokTracker.NAME, EVENT_ADD_ON_LOADED)
=======
  EventManager:UnregisterForEvent(MaarselokTracker.NAME, EVENT_ADD_ON_LOADED)
>>>>>>> master:MaarselokTracker/MaarselokTracker.lua
  MaarselokTracker:Initialize()
end

-- Callback for player state change
function MaarselokTracker.OnPlayerCombatState(event, inCombat)
  if inCombat ~= MaarselokTracker.inCombat then
    -- Combat state has changed, change store
    MaarselokTracker.inCombat = inCombat

    if inCombat == false then
      MaarselokTrackerIndicator:SetHidden(not inCombat)
    end
  end
end

-- Callback to handle movement stop
function MaarselokTracker.OnIndicatorMoveStop()
  MaarselokTracker.savedVariables.left = MaarselokTrackerIndicator:GetLeft()
  MaarselokTracker.savedVariables.top = MaarselokTrackerIndicator:GetTop()
end

-- Callback for starting cooldown
function MaarselokTracker.OnCombatEvent(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _)
  MaarselokTrackerIndicator:SetHidden(false)
<<<<<<< HEAD:MaarselokTracker/MaarselokTracker.lua
  if MaarselokTracker.timer == 0 then 
    MaarselokTracker.timer = MaarselokTracker.PROC_COOLDOWN

    MaarselokTrackerIndicatorTimer:SetColor(1,0,0)
    MaarselokTrackerIndicatorTimer:SetText(MaarselokTracker.timer)
    MaarselokTrackerIndicatorNotification:SetHidden(true)

    EVENT_MANAGER:UnregisterForUpdate(MaarselokTracker.NAME)
    EVENT_MANAGER:RegisterForUpdate(
      MaarselokTracker.NAME,
      MaarselokTracker.UPDATE_INTERVAL,
      MaarselokTracker.countDown
    )
  end
=======
  MaarselokTracker.timer = MaarselokTracker.PROC_COOLDOWN

  MaarselokTrackerIndicatorTimer:SetColor(1,0,0)
  MaarselokTrackerIndicatorTimer:SetText(MaarselokTracker.timer)
  MaarselokTrackerIndicatorNotification:SetHidden(true)

  EVENT_MANAGER:UnregisterForUpdate(MaarselokTracker.NAME)
  EVENT_MANAGER:RegisterForUpdate(
    MaarselokTracker.NAME,
    MaarselokTracker.UPDATE_INTERVAL,
    MaarselokTracker.countDown
  )
>>>>>>> master:MaarselokTracker/MaarselokTracker.lua
end

-- Count down the timer
function MaarselokTracker.countDown()
  MaarselokTrackerIndicatorTimer:SetText(string.format("%.1f", MaarselokTracker.timer))
  if MaarselokTracker.timer > 0 then
    MaarselokTracker.timer = 
      MaarselokTracker.timer - (MaarselokTracker.UPDATE_INTERVAL / 3)
  else
    EVENT_MANAGER:UnregisterForUpdate(
      MaarselokTracker.NAME
    )
    MaarselokTracker.timer = 0
    MaarselokTrackerIndicatorTimer:SetColor(0,1,0)
    MaarselokTrackerIndicatorTimer:SetText(
      string.format("%.1f", MaarselokTracker.timer)
    )
    MaarselokTrackerIndicatorNotification:SetHidden(false)
  end
end

-- Register event listener with namespace, event, and callback
EVENT_MANAGER:RegisterForEvent(
  MaarselokTracker.NAME, 
  EVENT_ADD_ON_LOADED, 
  MaarselokTracker.OnAddOnLoaded
)