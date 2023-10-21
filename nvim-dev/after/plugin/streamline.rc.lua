local status, streamline = pcall(require, "streamline")
if not status then
    return
end

streamline.setup({
    opt = "your mom"
})
streamline.hello()
