local M = {}

---Register callback function on LspAttach
---@param name string|nil If nil, global
---@param callback fun(client: vim.lsp.Client, bufnr: integer)
function M.on_attach(name, callback)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and (name == nil or client.name == name) then
        callback(client, bufnr)
      end
    end,
  })
end

-- ref: https://github.com/oxalica/nil/blob/main/dev/nvim-lsp.nix
M.capabilities = vim.tbl_deep_extend("force",
  vim.lsp.protocol.make_client_capabilities(),
  { workspace = { didChangeWatchedFiles = { dynamicRegistration = true } } }
)

---Register capabilities
---@param capabilities table
function M.register_capabilities(capabilities)
  M.capabilities = vim.tbl_deep_extend("force",
    M.capabilities,
    capabilities or {}
  )
end

---Setup a language server
---@param server string
---@param config table
function M.setup(server, config)
  vim.lsp.config(
    server,
    vim.tbl_deep_extend("keep", config, {
      autostart = true,
      capabilities = M.capabilities,
    })
  )
end

return M
