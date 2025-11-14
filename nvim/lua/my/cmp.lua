---@module 'blink.cmp'

local M = {}
local default_sources = { 'lsp', 'buffer', 'snippets', 'path' }

---@type blink.cmp.Config
M.config = {}

---@param config blink.cmp.Config
M.setup = function(config)
  default_sources = vim.list_extend(default_sources, config.sources.default or {})
  M.config = vim.tbl_deep_extend('force', M.config, config)
  M.config.sources.default = default_sources
end

return M
