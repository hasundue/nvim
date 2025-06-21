local M = {}

---Configures and enables a LSP server if it is available.
---@param name string
---@param opts { [string]: vim.lsp.Config }|nil
---@return nil
M.setup = function(name, opts)
  local cfg = vim.lsp.config[name] or {}
  local exe = cfg.cmd[1] or name
  if vim.fn.executable(exe) == 0 then
    return
  end
  vim.lsp.config(name, opts or {})
  vim.lsp.enable(name)
end

return M
