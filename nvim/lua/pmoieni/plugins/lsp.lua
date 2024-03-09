return {
    {
        "neovim/nvim-lspconfig",
        cmd = { "LspInfo", "LspInstall", "LspStart" },
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "folke/neodev.nvim",
        },
        config = function()
            require("neodev").setup({})

            local lspconfig = require("lspconfig")

            local lsp_defaults = lspconfig.util.default_config
            lsp_defaults.capabilities =
                vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

            vim.api.nvim_create_autocmd("LspAttach", {
                desc = "LSP actions",
                callback = function(event)
                    local keymap = vim.keymap -- for conciseness

                    local opts = { noremap = true, silent = false, buffer = event.bufnr }

                    -- set keybinds
                    opts.desc = "Show LSP references"
                    keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

                    opts.desc = "Go to declaration"
                    keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

                    opts.desc = "Show LSP definitions"
                    keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- show lsp definitions

                    opts.desc = "Show LSP implementations"
                    keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

                    opts.desc = "Show LSP type definitions"
                    keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

                    opts.desc = "See available code actions"
                    keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

                    opts.desc = "Smart rename"
                    keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

                    opts.desc = "Show diagnostics"
                    keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics<CR>", opts) -- show  diagnostics for file

                    opts.desc = "Show line diagnostics"
                    keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

                    opts.desc = "Go to previous diagnostic"
                    keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

                    opts.desc = "Go to next diagnostic"
                    keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

                    opts.desc = "Show documentation for what is under cursor"
                    keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

                    opts.desc = "Restart LSP"
                    keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>", opts) -- mapping to restart lsp if necessary
                end,
            })

            -- setup servers
            lspconfig.lua_ls.setup({})
            lspconfig.gopls.setup({})
            lspconfig.rust_analyzer.setup({
                settings = {
                    ["rust-analyzer"] = {
                        check = {
                            command = "clippy",
                            extraArgs = { "--tests" },
                            features = "all",
                        },
                    },
                },
            })
            lspconfig.clangd.setup({})
            lspconfig.jdtls.setup({
                cmd = {
                    "jdt-language-server",
                    "-configuration",
                    "/home/pmoieni/.cache/jdtls/config",
                    "-data",
                    "/home/pmoieni/.cache/jdtls/workspace"
                }
            })
            lspconfig.rnix.setup({})
            lspconfig.tsserver.setup({})
            lspconfig.svelte.setup({})
            lspconfig.bashls.setup({})
            lspconfig.cssls.setup({})
            lspconfig.jsonls.setup({})
            lspconfig.html.setup({})
            lspconfig.tailwindcss.setup({})
            lspconfig.elixirls.setup({
                cmd = { "/home/pmoieni/.nix-profile/bin/elixir-ls" }
            })

            vim.diagnostic.config({
                underline = true,
                virtual_text = false,
                update_in_insert = true,
                severity_sort = true,

                float = {
                    severity_sort = true,
                    header = "Diagnostics",
                    source = "if_many",
                    prefix = "• ",
                    -- border = "single",
                },
            })
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            { "L3MON4D3/LuaSnip" },
        },
        config = function()
            local cmp = require("cmp")

            cmp.setup({
                sources = {
                    { name = "nvim_lsp" },
                },
                mapping = cmp.mapping.preset.insert({
                    -- `Enter` key to confirm completion
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),

                    -- Ctrl+Space to trigger completion menu
                    ["<C-Space>"] = cmp.mapping.complete(),

                    -- Scroll up and down in the completion documentation
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                }),
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
            })
        end,
    },
}
