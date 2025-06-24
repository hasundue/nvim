require('codecompanion').setup({
  adapters = {
    copilot = function()
      return require('codecompanion.adapters').extend('copilot', {
        schema = {
          model = {
            default = 'claude-3.7-sonnet',
          },
        },
      })
    end,
  },
  strategies = {
    chat = {
      adapter = 'copilot',
    },
    inline = {
      adapter = 'copilot',
    },
  },
  opts = {
    log_level = 'DEBUG',
  },
})

vim.keymap.set(
  { 'n', 'v' },
  '<C-a>',
  '<cmd>CodeCompanionActions<cr>',
  { noremap = true, silent = true }
)
vim.keymap.set(
  { 'n', 'v' },
  '<LocalLeader>a',
  '<cmd>CodeCompanionChat Toggle<cr>',
  { noremap = true, silent = true }
)
vim.keymap.set('v', 'ga', '<cmd>CodeCompanionChat Add<cr>', { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
