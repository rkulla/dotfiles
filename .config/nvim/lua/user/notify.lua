require("notify").setup({
  background_colour = "NotifyBackground",
  fps = 30,
  icons = {
    DEBUG = "",
    ERROR = "",
    INFO = "",
    TRACE = "✎",
    WARN = "",
  },
  -- Levels by name: "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "OFF". Level numbers begin with "TRACE" at 0
  level = 2, -- minimum log level to display (default is 2 "INFO")
  minimum_width = 50,
  render = "default",
  stages = "fade_in_slide_out",
  timeout = 1000, -- how long to display the message in ms (default is 5000) `:Telescope notify` to see again
  top_down = true,
})
