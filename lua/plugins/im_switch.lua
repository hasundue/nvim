require("im-switch").setup({
  windows = {
    enabled = true,
  },
  linux = {
    enabled = true,
    default_im = "keyboard-us",
    get_im_command = { "fcitx5-remote", "-n" },
    set_im_command = { "fcitx5-remote", "-s" },
  },
})
