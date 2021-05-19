local wibox = require("wibox")
local watch = require("awful.widget.watch")
local theme = require("mytheme")

local vol_text = wibox.widget{
	font = theme.font,
	widget = wibox.widget.textbox,
}

local vol_widget = wibox.widget.background()
vol_widget:set_widget(vol_text)

vol_widget:set_bg(theme.bg_normal)
vol_widget:set_fg(theme.fg_normal)

watch("amixer -c 1 sget 'PCM'",1,function(widget, stdout, stderr, exitreason, exitcode)
	local vol_percent = string.match(stdout,"%[...%]")
	vol_percent = "🔉"..vol_percent:sub(2,-2)
	vol_text:set_text(vol_percent)
end, vol_widget)

return vol_widget
