-- Keymaps for copying file location references to clipboard

vim.keymap.set('n', '<leader>cl', function()
  local filepath = vim.fn.expand('%:.')
  local line_num = vim.fn.line('.')
  local col_num = vim.fn.col('.')
  local reference = string.format('%s:%d:%d', filepath, line_num, col_num)
  vim.fn.setreg('+', reference)
  vim.notify('Copied: ' .. reference, vim.log.levels.INFO)
end, { desc = 'Copy current line reference' })

vim.keymap.set('v', '<leader>cs', function()
  local start_line = vim.fn.line('v')
  local end_line = vim.fn.line('.')
  local start_col = vim.fn.col('v')
  local end_col = vim.fn.col('.')
  local filepath = vim.fn.expand('%:.')

  -- Ensure start <= end
  if start_line > end_line or (start_line == end_line and start_col > end_col) then
    start_line, end_line = end_line, start_line
    start_col, end_col = end_col, start_col
  end

  local reference
  if start_line == end_line then
    reference = string.format('%s:%d:%d-%d', filepath, start_line, start_col, end_col)
  else
    reference = string.format('%s:%d:%d-%d:%d', filepath, start_line, start_col, end_line, end_col)
  end

  vim.fn.setreg('+', reference)
  vim.notify('Copied: ' .. reference, vim.log.levels.INFO)
end, { desc = 'Copy selection reference' })
