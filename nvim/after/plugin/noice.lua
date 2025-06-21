---@diagnostic disable: missing-fields

require('noice').setup({
  lsp = {
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
    },
    hover = {
      enabled = true,
      silent = true,
    },
  },
  messages = {
    enabled = true,
    view = 'notify',
    view_error = 'mini',
    view_warn = 'mini',
    view_history = 'messages',
    view_search = 'virtualtext',
  },
  presets = {
    command_palette = true,
    long_message_to_split = true,
    lsp_doc_border = true,
  },
})
