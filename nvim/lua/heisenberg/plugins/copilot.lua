return {
  'github/copilot.vim',
  event = { 'InsertEnter' },
  config = function()
    -- Optional: Additional Copilot configuration
    vim.g.copilot_no_tab_map = true
    vim.api.nvim_set_keymap('i', '<C-J>', 'copilot#Accept("<CR>")', { silent = true, expr = true })
  end
}

