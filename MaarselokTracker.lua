MaarselokTracker = {}

MaarselokTracker.name = "MaarselokTracker"

function MaarselokTracker:Initialize()

end

function MaarselokTracker.OnAddOnLoaded(event, addonName)
  if addonName == MaarselokTracker.name then
    MaarselokTracker:Initialize()
  end
end

EVENT_MANAGER:RegisterForEvent(FooAddon.name, EVENT_ADD_ON_LOADED, MaarselokTracker.OnAddOnLoaded)
