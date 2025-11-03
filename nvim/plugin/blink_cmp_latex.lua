require('my.cmp').setup({
  sources = {
    default = { 'latex' },
    providers = {
      latex = {
        name = 'Latex',
        module = 'blink-cmp-latex',
      },
    },
  },
})
