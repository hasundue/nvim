require('my.cmp').config({
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
