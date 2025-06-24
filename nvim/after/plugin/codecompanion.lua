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
