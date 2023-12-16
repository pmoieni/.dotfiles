return {
    "stevearc/oil.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local oil = require("oil")

        oil.setup({
            default_file_explorer = true,
            columns = {
                "icon",
                "permissions",
                "size",
                -- "mtime",
            },
            keymaps = {
                ["g?"] = "actions.show_help",
                ["<CR>"] = "actions.select",
                ["<C-v>"] = "actions.select_vsplit",
                ["<C-s>"] = "actions.select_split",
                ["<C-t>"] = "actions.select_tab",
                ["<C-p>"] = "actions.preview",
                ["<C-c>"] = "actions.close",
                ["<C-l>"] = "actions.refresh",
                ["-"] = "actions.parent",
                ["_"] = "actions.open_cwd",
                ["`"] = "actions.cd",
                ["~"] = "actions.tcd",
                ["gs"] = "actions.change_sort",
                ["gx"] = "actions.open_external",
                ["g."] = "actions.toggle_hidden",
                ["g\\"] = "actions.toggle_trash",
            },
            view_options = {
                show_hidden = true,
                is_hidden_file = function(name, _)
                    return vim.startswith(name, ".")
                end,
                sort = {
                    { "type", "asc" },
                    { "name", "asc" },
                },
            },
            delete_to_trash = true,
        })

        local opts = { noremap = true, silent = true }

        opts.desc = "File explorer"
        vim.keymap.set("n", "<leader>e", oil.open, opts)
    end,
}
