return {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    dependencies = {
        "nvim-telescope/telescope-fzy-native.nvim",
    },
    config = function()
        local telescope = require("telescope")

        telescope.setup({})

        telescope.load_extension("fzy_native")
        -- telescope.load_extension("noice")

        local opts = { noremap = true, silent = true }

        local keymap = vim.keymap

        opts.desc = "Find files"
        keymap.set("n", "<leader>f", "<cmd>Telescope find_files<CR>", opts)

        opts.desc = "Live grep"
        keymap.set("n", "<leader>lg", "<cmd>Telescope live_grep<CR>", opts)

        opts.desc = "Git stash"
        keymap.set("n", "<leader>gs", "<cmd>Telescope git_stash<CR>", opts)

        opts.desc = "Git branches"
        keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", opts)

        opts.desc = "Git commits"
        keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", opts)

        opts.desc = "Help tags"
        keymap.set("n", "<leader>h", "<cmd>Telescope help_tags<CR>", opts)

        opts.desc = "Switch buffers"
        keymap.set("n", "<leader>\\", "<cmd>Telescope buffers<CR>", opts)

        opts.desc = "Resume"
        keymap.set("n", "<leader><leader>", "<cmd>Telescope resume<CR>", opts)
    end,
}

