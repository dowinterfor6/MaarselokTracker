-- Create namespace with top level table
MaarselokTracker = {}

-- Constant for use later
MaarselokTracker.name = "MaarselokTracker"

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

    if inCombat then
      d("Entering combat.")
    else
      d("Exiting combat.")
    end

  end
end

-- Register event listener with namespace, event, and callback
EVENT_MANAGER:RegisterForEvent(FooAddon.name, EVENT_ADD_ON_LOADED, MaarselokTracker.OnAddOnLoaded)
