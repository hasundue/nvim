local opt = vim.opt

--
-- UI -------------------------------------------
--
opt.number = true

opt.cursorline = true
opt.ruler = true

opt.wrap = false
opt.breakindent = true

opt.pumheight = 10
opt.pumblend = 15

opt.laststatus = 3

--
-- commands -------------------------------------
--
opt.splitright = true
opt.updatetime = 1000

--
-- editing --------------------------------------
--
opt.autoindent = true
opt.smartindent = false

opt.expandtab = true
opt.tabstop = 2
-- Make shiftwidth follow tabstop
opt.shiftwidth = 0
-- Make softtabstop follow shiftwidth
opt.softtabstop = -1
