M = {}

-- Enable by default
AUTOFORMAT_ACTIVE = true

-- Toggle null-ls's autoformatting
M.toggle_autoformat = function() AUTOFORMAT_ACTIVE = not AUTOFORMAT_ACTIVE end

return M
