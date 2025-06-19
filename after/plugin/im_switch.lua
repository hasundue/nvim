---Workaround to suppress error messages from im-switch during setup about missing .git directory.
---@diagnostic disable-next-line: duplicate-set-field
vim.notify = function(msg, level, opts)
  if opts and opts.title == "im-switch.nvim" then
    return
  end
  vim.notify(msg, level, opts)
end

require("im-switch").setup {
  windows = {
    enabled = false,
  },
  linux = {
    enabled = true,
    default_im = "keyboard-us",
    get_im_command = { "fcitx5-remote", "-n" },
    set_im_command = { "fcitx5-remote", "-s" },
  },
}
