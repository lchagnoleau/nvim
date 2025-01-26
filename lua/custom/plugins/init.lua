-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'stevearc/dressing.nvim',
    opts = {},
  },
  {
    'tpope/vim-fugitive',
  },
  {
    keys = {
      { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
      { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
      { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
      { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
      { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
    },

    'christoomey/vim-tmux-navigator',

    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
    },
  },
  {
    'sindrets/diffview.nvim',
  },
  {
    'akinsho/git-conflict.nvim',
    config = true,
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
      'ibhagwan/fzf-lua',
      'rbong/vim-flog',
      'echasnovski/mini.pick',
    },
    config = true,
    opts = { graph_style = 'unicode' },
  },
  {
    'mbbill/undotree',

    config = function()
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.keymap.set('n', '<leader>tu', vim.cmd.UndotreeToggle, { desc = '[T]oggle [U]ndoTree' })
    end,
  },
  {
    'nvim-lualine/lualine.nvim',

    config = function()
      require('lualine').setup {
        options = {
          theme = 'auto',
        },
      }
    end,
  },
}
