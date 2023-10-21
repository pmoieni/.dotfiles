require("pmoieni.core.base")
require("pmoieni.core.keymaps")
require("pmoieni.core.highlights")
require("pmoieni.core.globals")

local has = vim.fn.has
local is_linux = has "unix"
local is_win = has "win32"
local is_wsl = has "wsl"

if is_linux == 1 then
	require('pmoieni.core.linux')
end
if is_win == 1 then
	require('pmoieni.core.windows')
end
if is_wsl == 1 then
	require('pmoieni.core.wsl')
end
