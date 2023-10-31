return {
    {
        "mfussenegger/nvim-dap",
        ft = {
            "go",
            "typescript",
            "javascript",
            "javascriptreact",
            "typescriptreact",
            "svelte",
        },
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "leoluz/nvim-dap-go",
        },
        config = function()
            local dap = require("dap")
            local go = require("dap-go")
            local ui = require("dapui")
            local vt = require("nvim-dap-virtual-text")

            ui.setup()
            vt.setup({})
            go.setup()

            dap.adapters["pwa-node"] = {
                type = "server",
                host = "localhost",
                port = "${port}",
                executable = {
                    command = "node",
                    args = {
                        vim.fn.stdpath('data') .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
                        "${port}",
                    },
                }
            }

            for _, language in ipairs({
                "typescript",
                "javascript",
                "javascriptreact",
                "typescriptreact",
                "svelte",
            }) do
                if not dap.configurations[language] then
                    dap.configurations[language] = {
                        {
                            type = 'pwa-node',
                            request = 'launch',
                            name = 'Launch file',
                            program = '${file}',
                            cwd = '${workspaceFolder}',
                        },
                        {
                            type = 'pwa-node',
                            request = 'attach',
                            name = 'Attach',
                            processId = require('dap.utils').pick_process,
                            cwd = '${workspaceFolder}',
                        },
                    }
                end
            end

            dap.listeners.after.event_initialized["dapui_config"] = function()
                ui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                ui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                ui.close()
            end

            local opts = { noremap = true, silent = true }

            local keymap = vim.keymap

            opts.desc = "Debugger toggle breakpoint"
            keymap.set("n", "<F9>", "<cmd>DapToggleBreakpoint<CR>", opts)

            opts.desc = "Continue debugging"
            keymap.set("n", "<F5>", "<cmd>DapContinue<CR>", opts)
        end,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        opts = {
            ensure_installed = {
                "js-debug-adapter",
                "delve",
            },
            automatic_setup = true,
        },
        config = true,
    },
}
