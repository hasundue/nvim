local show_diagnostic_float = function()
  local opts = {
    focusable = false,
    close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
    border = 'rounded',
    source = 'always',
    prefix = ' ',
    scope = 'line',
  }
  vim.diagnostic.open_float(nil, opts)
end

vim.lsp.config('*', {
  root_markers = { '.git' },
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if not client then
      return
    end

    vim.keymap.set(
      'n',
      '<leader>d',
      show_diagnostic_float,
      { buffer = bufnr, desc = 'Show line diagnostics' }
    )

    vim.api.nvim_create_autocmd('CursorHold', {
      buffer = bufnr,
      callback = show_diagnostic_float,
    })

    -- Only setup LSP formatting if conform is not available
    if
      not pcall(require, 'conform')
      and not client:supports_method('textDocument/willSaveWaitUntil')
      and client:supports_method('textDocument/formatting')
    then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})
