return {
    "nvim-lua/plenary.nvim",
    -- local development
    {
        dir = "~/projects/pmoieni/streamline.nvim",
        "pmoieni/streamline.nvim",
        config = function()
            local streamline = require("streamline")

            streamline.setup({
                debug = true,
            })
        end,
    }
}
