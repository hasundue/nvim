local cmp = require('my.cmp')

cmp.config({
  completion = {
    menu = {
      auto_show = true,
    },
  },
})

if not pcall(require, 'lazydev') then
  cmp.setup()
end
