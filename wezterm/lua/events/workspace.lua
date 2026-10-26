-- Workspace-related event hooks (extensible).

local M = {}

function M.setup(_wezterm)
  -- Reserved for workspace rename / switch notifications.
  -- Active workspace is already shown in events.update-status.
end

return M
