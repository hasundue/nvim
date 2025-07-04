require('copilot').setup({
  filetypes = {
    gitcommit = true,
    markdown = true,
    yaml = true,
  },
  panel = {
    enabled = false,
  },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    keymap = {
      accept_line = '<C-f>',
      accept_word = '<M-f>',
      dismiss = '<C-e>',
    },
  },
})

-- Make copilot 'q'uiet
vim.keymap.set({ 'i', 'n' }, '<C-q>', require('copilot.suggestion').toggle_auto_trigger)
