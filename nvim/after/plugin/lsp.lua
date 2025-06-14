vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("my.lsp", {}),

  callback = function(args)
    local bufnr = args.buf
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    local function map(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, { noremap = true, buffer = bufnr })
    end

    map('n', '<M-k>', vim.diagnostic.open_float)
    map('n', '<M-n>', vim.diagnostic.jump({ count = 1, float = true }))
    map('n', '<M-p>', vim.diagnostic.jump({ count = -1, float = true }))

    if client.name == "copilot" then
      return
    end

    if client:supports_method("hover", bufnr) then
      map('n', 'K', vim.lsp.buf.hover)
    end

    if client:supports_method("rename", bufnr) then
      map('n', '<M-r>', vim.lsp.buf.rename)
    end

    if client:supports_method("inlay_hint", bufnr) then
      map('n', "<M-i>", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
      end)
      vim.cmd('highlight link LspInlayHint NonText')
    end

    if client:supports_method("format", bufnr) then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        group = vim.api.nvim_create_augroup("LspFormat", { clear = true }),
        callback = function()
          vim.lsp.buf.format({ async = false, bufnr = bufnr })
        end,
      })
    end
  end
})
