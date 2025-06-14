require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "copilot",
    },
  },
  opts = {
    log_level = "DEBUG",
  },
})
