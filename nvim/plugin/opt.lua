local g = vim.g
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
g.mapleader = ' '
opt.splitright = true
opt.updatetime = 1000

--
-- editing --------------------------------------
--
opt.smartindent = true
