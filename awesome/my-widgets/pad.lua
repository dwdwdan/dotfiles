local wibox = require("wibox")
local watch = require("awful.widget.watch")
local theme = require("mytheme")

local pad_text = wibox.widget{
	font = theme.mono_font,
	widget = wibox.widget.textbox,
}

local pad_widget = wibox.widget.background()
pad_widget:set_widget(pad_text)

pad_widget:set_bg(theme.bg_widget)
pad_widget:set_fg(theme.fg_widget)

pad_text:set_text(" ")

return pad_widget
