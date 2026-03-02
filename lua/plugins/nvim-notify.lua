return {
  "rcarriga/nvim-notify",
  lazy = false,
  config = function()
    local nvim_notify = require("notify")
    nvim_notify.setup {
      stages = "static",
      fps = 0,
    }
    vim.notify = nvim_notify
  end,
}
