local function setup_organize_imports_for_ts()
  local function organize_imports()
    local params = {
      command = "_typescript.organizeImports",
      arguments = { vim.api.nvim_buf_get_name(0) },
      title = "",
    }
    vim.lsp.buf.execute_command(params)
  end

  require("lspconfig").tsserver.setup({
    on_attach = function()
      vim.keymap.set("n", "<leader>oi", "<cmd>OrganizeImports<cr>", { noremap = true, silent = true })
    end,
    commands = {
      OrganizeImports = {
        organize_imports,
        description = "Organize Imports",
      },
    },
  })
end

local function setup_null_ls_format()
  local null_ls = require("null-ls")

  local async_formatting = function(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    vim.lsp.buf_request(
      bufnr,
      "textDocument/formatting",
      vim.lsp.util.make_formatting_params({}),
      function(err, res, ctx)
        if err then
          local err_msg = type(err) == "string" and err or err.message
          -- you can modify the log message / level (or ignore it completely)
          vim.notify("formatting: " .. err_msg, vim.log.levels.WARN)
          return
        end

        -- don't apply results if buffer is unloaded or has been modified
        if not vim.api.nvim_buf_is_loaded(bufnr) or vim.api.nvim_buf_get_option(bufnr, "modified") then
          return
        end

        if res then
          local client = vim.lsp.get_client_by_id(ctx.client_id)
          vim.lsp.util.apply_text_edits(res, bufnr, client and client.offset_encoding or "utf-16")
          vim.api.nvim_buf_call(bufnr, function()
            vim.cmd("silent noautocmd update")
          end)
        end
      end
    )
  end

  local augroup = vim.api.nvim_create_augroup("LspFormatting", {})


  null_ls.setup({
    on_attach = function(client, bufnr)
      -- if client.supports_method("textDocument/formatting") then
      --   vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      --   vim.api.nvim_create_autocmd("BufWritePost", {
      --     group = augroup,
      --     buffer = bufnr,
      --     callback = function()
      --       async_formatting(bufnr)
      --     end,
      --   })
      -- end
      local format_cmd = function(input)
        vim.lsp.buf.format({
          id = client.id,
          timeout_ms = 5000,
          async = input.bang,
        })
      end

      local bufcmd = vim.api.nvim_buf_create_user_command
      bufcmd(bufnr, "NullFormat", format_cmd, {
        bang = true,
        range = true,
        desc = "Format using null-ls",
      })

      vim.keymap.set("n", "<leader>fs", "<cmd>NullFormat!<cr>", { buffer = bufnr })
    end,
    sources = {
      -- You can add tools not supported by mason.nvim

      null_ls.builtins.diagnostics.fish,
      null_ls.builtins.code_actions.eslint,
      null_ls.builtins.formatting.prismaFmt,
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.rustfmt,
      null_ls.builtins.formatting.prettierd,
      null_ls.builtins.formatting.fish_indent,
    },
  })
end

local function setup_completions()
  local cmp = require('cmp')
  local cmp_action = require('lsp-zero').cmp_action()

  require('luasnip.loaders.from_vscode').lazy_load()

  cmp.setup({
    sources = {
      { name = 'path',     keyword_length = 0 },
      { name = 'nvim_lsp', keyword_length = 0 },
      { name = 'buffer',   keyword_length = 0 },
      { name = 'luasnip',  keyword_length = 0 },
    },
    mapping = {
      ['<C-f>'] = cmp_action.luasnip_jump_forward(),
      ['<C-b>'] = cmp_action.luasnip_jump_backward(),
      ['<CR>'] = cmp.mapping.confirm({ select = false }),
      ['<C-Space>'] = cmp.mapping.complete(),
    },
    preselect = 'item',
    completion = {
      completeopt = 'menu,menuone,noinsert'
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    }
  })
end

local function setup_lsp()
  local lsp = require('lsp-zero').preset({})

  lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
  end)

  -- (Optional) Configure lua language server for neovim
  require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

  lsp.ensure_installed({
    "graphql",
    "html",
    "eslint",
    "cssls",
    "cssmodules_ls",
    "prismals",
    "svelte",
    "tailwindcss",
    "tsserver",
    "jsonls",
    -- Others
    "dockerls",
    "docker_compose_language_service",
    "gopls",
    "lua_ls",
    "remark_ls",
    "pyright",
    "sqlls",
    "rust_analyzer",
    "yamlls",
  })

  setup_organize_imports_for_ts()
  lsp.setup()
end

return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v2.x',
  event = 'BufRead',
  dependencies = {
    -- LSP Support
    { 'neovim/nvim-lspconfig' }, -- Required
    {                            -- Optional
      'williamboman/mason.nvim',
      build = function()
        pcall(vim.cmd, 'MasonUpdate')
      end,
    },
    { 'williamboman/mason-lspconfig.nvim' }, -- Optional

    -- Autocompletion
    { 'hrsh7th/nvim-cmp' },     -- Required
    { 'hrsh7th/cmp-nvim-lsp' }, -- Required
    { 'L3MON4D3/LuaSnip' },     -- Required
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-buffer' },
    {
      "jose-elias-alvarez/null-ls.nvim",
      event = "VeryLazy",
      config = function()
        setup_null_ls_format()
      end,
    },
  },
  config = function()
    setup_completions()
    setup_lsp()
  end
}
