return {
    {
        "echasnovski/mini.cursorword",
        event = { "BufReadPre", "BufNewFile" },
        version = false,
        config = true,
    },
    {
        "echasnovski/mini.indentscope",
        event = { "BufReadPre", "BufNewFile" },
        version = false,
        opts = {
            symbol = "|",
        },
        config = true,
    },
    {
        "echasnovski/mini.pairs",
        event = "InsertEnter",
        version = false,
        config = true,
    },
}
