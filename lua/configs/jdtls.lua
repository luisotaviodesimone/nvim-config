local home = os.getenv "HOME"
local sdkman_java_path = home .. "/.sdkman/candidates/java"

local java_21_path = sdkman_java_path .. "/21.0.10-amzn"
local java_17_path = sdkman_java_path .. "/17.0.17-amzn"

local opts = {
  settings = {
    java = {
      signatureHelp = { enabled = true },
      completion = {
        favoriteStaticMembers = {},
        filteredTypes = {},
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        useBlocks = true,
      },
      configuration = {
        runtimes = {
          {
            name = "JavaSE-17",
            path = java_17_path,
          },
          {
            name = "JavaSE-21",
            path = java_21_path,
          },
        },
      },
    },
  },
}

local function setup()
  local pkg_status, jdtls = pcall(require, "jdtls")
  if not pkg_status then
    vim.notify("nvim-jdtls not installed", vim.log.levels.ERROR)
    return
  end

  local jdtls_install_path = vim.fn.stdpath "data" .. "/mason/packages/jdtls"

  local root_markers = { ".gradle", "gradlew", "mvnw", "pom.xml", "build.gradle", ".git" }
  local root_dir = jdtls.setup.find_root(root_markers)
  if not root_dir then
    root_dir = vim.fn.getcwd()
  end

  local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
  local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name

  -- Use Java 21 to RUN jdtls (required), but project uses Java 17
  local cmd = {
    java_21_path .. "/bin/java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", vim.fn.glob(jdtls_install_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration", jdtls_install_path .. "/config_linux",
    "-data", workspace_dir,
  }

  local config = vim.tbl_deep_extend("force", opts, {
    cmd = cmd,
    root_dir = root_dir,
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    on_attach = function(client, bufnr)
      jdtls.setup.add_commands()
      -- Add any additional on_attach logic here
    end,
  })

  jdtls.start_or_attach(config)
end

return { setup = setup }
