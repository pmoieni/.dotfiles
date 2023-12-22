return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "TSUpdateSync" },
    config = function()
        require("nvim-treesitter.configs").setup({
            highlight = {
                enable = true,
                disable = { "help" },
            },
            indent = {
                enable = true,
            },
            auto_install = true,
            autotag = {
                enable = true,
            },
            ensure_installed = {
                "bash",
                "html",
                "javascript",
                "json",
                "lua",
                "luadoc",
                "markdown",
                "markdown_inline",
                "tsx",
                "typescript",
                "go",
                "svelte",
            },
        })

        local parsers = require("nvim-treesitter.parsers").get_parser_configs()

        parsers.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
        parsers.gotmpl = {
            install_info = {
                url = "https://github.com/ngalaiko/tree-sitter-go-template",
                files = { "src/parser.c" }
            },
            filetype = "gotmpl",
            used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl", "yaml" }
        }
    end,
}

