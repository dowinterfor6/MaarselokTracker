-- Create namespace with top level table
MaarselokTracker = {}

-- Constant for use later
MaarselokTracker.name = "MaarselokTracker"

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

-- Register event listener with namespace, event, and callback
EVENT_MANAGER:RegisterForEvent(FooAddon.name, EVENT_ADD_ON_LOADED, MaarselokTracker.OnAddOnLoaded)
