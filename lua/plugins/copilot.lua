return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = false,
        debounce = 10,
        keymap = {
          accept = "<M-l>",
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        yaml = true,
        -- markdown = true,
        -- help = true,
        -- gitcommit = true,
        -- gitrebase = true,
        -- hgcommit = true,
        -- svn = true,
        -- cvs = false,
        ["."] = true,
      },
    }
  end,
}
