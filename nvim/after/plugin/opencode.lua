vim.g.opencode_opts = {
  auto_reload = true,
}

vim.opt.autoread = true

vim.keymap.set({ 'n', 'x' }, '<leader>aa', function()
  require('opencode').ask('@this: ', { submit = true })
end, { desc = 'Ask about this' })

vim.keymap.set({ 'n', 'x' }, '<leader>ap', function()
  require('opencode').select()
end, { desc = 'Select prompt' })

vim.keymap.set({ 'n', 'x' }, '<leader>as', function()
  require('opencode').prompt('@this')
end, { desc = 'Send this' })

vim.keymap.set('n', '<leader>an', function()
  require('opencode').command('session_new')
end, { desc = 'New session' })
