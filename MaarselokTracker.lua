-- Create namespace with top level table
MaarselokTracker = {}

-- Constant for use later
MaarselokTracker.name = "MaarselokTracker"

-- Initialize addon
function MaarselokTracker:Initialize()

end

-- Event handler callback function, initialize addon after
-- resources are loaded
function MaarselokTracker.OnAddOnLoaded(event, addonName)
  -- EVENT_ADD_ON_LOADED fires for each addon, check for own
  if addonName == MaarselokTracker.name then
    MaarselokTracker:Initialize()
  end
end

-- Register event listener with namespace, event, and callback
EVENT_MANAGER:RegisterForEvent(FooAddon.name, EVENT_ADD_ON_LOADED, MaarselokTracker.OnAddOnLoaded)
