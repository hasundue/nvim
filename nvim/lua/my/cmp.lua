---@module 'blink.cmp'

local M = {}

local config = {
  sources = {
    default = { 'lsp', 'buffer', 'snippets', 'path' },
  },
}

---@param params table<string, any>
M.config = function(params)
  config = vim.tbl_deep_extend('keep', config, params)
  if params.sources and params.sources.default then
    config.sources.default = vim.list_extend(config.sources.default, params.sources.default)
  end
end

---@param params table<string, any> | nil
M.setup = function(params)
  M.config(params or {})
  require('blink.cmp').setup(config)
end

return M
