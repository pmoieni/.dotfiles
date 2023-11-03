require("pmoieni.core")
require("pmoieni.lazy")

-- temporary
for _, k in ipairs({
	"Up",
	"Down",
	"Right",
	"Left",
	"Insert",
	"Home",
	"End",
	"PageUp",
	"PageDown",
	"kUp",
	"kDown",
	"kLeft",
	"kRight",
	"kHome",
	"kOrigin",
	"kPageUp",
	"kPageDown",
	"kDel",
}) do
	vim.keymap.set("n", string.format("<%s>", k), "<Nop>")
end
