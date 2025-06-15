---@diagnostic disable-next-line: missing-fields
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
