return {
  {
    "tpope/vim-dadbod",
    lazy = true,
  },

  {
    "kristijanhusak/vim-dadbod-ui",
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    dependencies = { "tpope/vim-dadbod" },
    config = function()
      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_execute_on_save = 0
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_use_nvim_notify = 1
    end,
  },

  {
    "kristijanhusak/vim-dadbod-completion",
    ft = { "sql", "mysql", "plsql" },
    dependencies = { "tpope/vim-dadbod" },
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          require("cmp").setup.buffer {
            sources = {
              { name = "vim-dadbod-completion" },
              { name = "buffer" },
            },
          }
        end,
      })
    end,
  },
}
