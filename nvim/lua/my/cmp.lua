local M = {}

---@type blink.cmp.Config
M.config = {}

---@param config blink.cmp.Config
M.setup = function(config)
  M.config = vim.tbl_deep_extend('force', M.config, config)
end

return M
