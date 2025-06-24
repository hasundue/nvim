local function get_dynamic_config()
  local width = vim.o.columns
  local height = vim.o.lines

  -- Use vertical split if window is wide enough, otherwise horizontal
  local position = width > 120 and 'vertical' or 'botright'

  return {
    window = {
      split_ratio = 0.5,
      position = position,
    },
  }
end

local function update_claude_config()
  require('claude-code').setup(get_dynamic_config())
end

-- Update configuration when vim is resized
vim.api.nvim_create_autocmd({ 'VimEnter', 'VimResized' }, {
  callback = update_claude_config,
  desc = 'Update claude-code window position based on vim size',
})
