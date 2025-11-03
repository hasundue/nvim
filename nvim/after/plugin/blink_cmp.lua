require('my.cmp').setup({
  completion = {
    menu = {
      auto_show = true,
    },
  },
})

require('blink.cmp').setup(require('my.cmp').config)
