local builtin = require('telescope.builtin')

local function map(key, picker)
  vim.keymap.set('n', '<leader>' .. key, builtin[picker], {})
end

for picker, key in pairs({
  git_files = 'f',
  buffers = 'b',
  help_tags = 'h',
  live_grep = 'l',
  resume = 'r',
  grep_string = 'g',
}) do
  map(key, picker)
end

require('telescope').setup({
  pickers = {
    git_files = {
      show_untracked = true,
    },
  },
})
