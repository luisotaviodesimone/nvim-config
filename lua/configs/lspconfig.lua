local servers = {
  "html",
  "cssls",
  "eslint", -- for this lsp, mason doesn't have a server, so we need to install it globally with npm with `npm install -g vscode-langservers-extracted`
  "vtsls",
  "rust_analyzer",
  "prismals",
  "gopls",
  "pyright",
  "marksman",
  "tailwindcss",
  "helm_ls",
  "tofu_ls",
  "vue_ls",
  "yamlls",
}

vim.diagnostic.config {
  virtual_text = {
    spacing = 4,
    prefix = "●",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "if_many",
  },
}

local vue_language_server_path = vim.fn.stdpath "data"
  .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

local vue_plugin = {
  name = "@vue/typescript-plugin",
  location = vue_language_server_path,
  languages = { "vue" },
  configNamespace = "typescript",
}

vim.lsp.config("vtsls", {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
  },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
})

vim.lsp.config("tofu_ls", {
  filetypes = { "opentofu", "opentofu-vars", "terraform", "terraform-vars" },
})

vim.lsp.enable(servers)

--- @class LspKeymap
--- @field mode string
--- @field lhs string
--- @field rhs function
--- @field opts? vim.keymap.set.Opts

--- @type table<string, LspKeymap>
local methods_n_keymaps = {
  ["textDocument/definition"] = {
    mode = "n",
    lhs = "gd",
    rhs = function()
      vim.g["textDocument/definition"] = true
      vim.lsp.buf.definition()
    end,
    opts = { desc = "LSP Go to definition" },
  },
  ["textDocument/declaration"] = {
    mode = "n",
    lhs = "gD",
    rhs = function()
      vim.g["textDocument/declaration"] = true
      vim.lsp.buf.declaration()
    end,
    opts = { desc = "LSP Go to declaration" },
  },
  ["textDocument/implementation"] = {
    mode = "n",
    lhs = "gi",
    rhs = function()
      vim.g["textDocument/implementation"] = true
      vim.lsp.buf.implementation()
    end,
    opts = { desc = "LSP Go to implementation" },
  },
  ["textDocument/references"] = {
    mode = "n",
    lhs = "gr",
    rhs = function()
      vim.g["textDocument/references"] = true
      vim.lsp.buf.references()
    end,
    opts = { desc = "LSP Go to references" },
  },
}

local function on_lsp_attach(callback)
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      callback(client, args.buf, methods_n_keymaps)
    end,
  })
end

vim.api.nvim_create_autocmd("CursorMoved", {
  callback = function()
    for method, _ in pairs(methods_n_keymaps) do
      if vim.g[method] then
        vim.cmd "normal! zz"
        vim.g[method] = false
      end
    end
  end,
})

return {
  on_lsp_attach = on_lsp_attach,
}
