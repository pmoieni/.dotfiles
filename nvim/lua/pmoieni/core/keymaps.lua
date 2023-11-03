-- move lines up and down
vim.keymap.set("n", "<A-j>", "<cmd>m +1<CR>==")
vim.keymap.set("n", "<A-k>", "<cmd>m -2<CR>==")
vim.keymap.set("v", "<A-j>", "<cmd>m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", "<cmd>m '<-2<CR>gv=gv")

-- remove search highlights
vim.keymap.set({ "n", "v" }, "<leader>/", "<cmd>noh<CR>")

-- reload module
vim.keymap.set("n", "<leader>mm", require("pmoieni.core.globals").require_module)
