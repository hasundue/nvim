require('my.cmp').setup({
  completion = {
    menu = {
      auto_show = true,
    },
  },
  sources = {
    default = { 'lazydev' },
    providers = {
      lazydev = {
        name = 'LazyDev',
        module = 'lazydev.integrations.blink',
        score_offset = 100,
      },
    },
  },
})

require('blink.cmp').setup(require('my.cmp').config)
