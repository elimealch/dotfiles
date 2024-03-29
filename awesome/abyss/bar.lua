local screen = require("awful.screen").primary

local wibar = require("awful").wibar({
    position = "top",
    border_width = 1,
    border_color = "#ffffff",
    visible = true,
    opacity = 0.9,
    --x = 10,
    --y = 0,
    width = screen.geometry["width"] - 20,
    heigth = 10,
})


