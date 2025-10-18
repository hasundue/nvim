vim.g.opencode_opts = {
  auto_reload = true,
}

vim.opt.autoread = true

vim.keymap.set({ 'n', 'x' }, '<leader>oa', function()
  require('opencode').ask('@this: ', { submit = true })
end, { desc = 'Ask about this' })

vim.keymap.set({ 'n', 'x' }, '<leader>os', function()
  require('opencode').select()
end, { desc = 'Select prompt' })

vim.keymap.set({ 'n', 'x' }, '<leader>o+', function()
  require('opencode').prompt('@this')
end, { desc = 'Add this' })

vim.keymap.set('n', '<leader>on', function()
  require('opencode').command('session_new')
end, { desc = 'New session' })
