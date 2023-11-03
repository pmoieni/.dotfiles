local reload_module = function(...)
	return require("plenary.reload").reload_module(...)
end

local require_module = function()
	local name = vim.fn.input("Module name: ")

	if not name or name == "" then
		vim.print("no name was provided")
		return
	end

	reload_module(name)
	return require(name)
end

return {
	reload_module = reload_module,
	require_module = require_module,
}
