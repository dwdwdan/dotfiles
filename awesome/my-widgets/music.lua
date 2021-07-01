local wibox = require("wibox")
local watch = require("awful.widget.watch")
local theme = require("mytheme")
local awful = require("awful")

local music_text = wibox.widget{
	font = theme.mono_font,
	widget = wibox.widget.textbox,
}

local music_widget = wibox.widget {
  {
    {
      widget = music_text
    },
    left = 10,
    right = 10,
    widget = wibox.container.margin,
  },
  bg =theme.bg_widget,
  fg = theme.fg_widget,
  shape = theme.widget_shape,
  widget=wibox.container.background,
}

watch("mpc -f \"[%artist% - ][%album%][ - %title%]\"", 3, function(widget, stdout, stderr, exitreason, exitcode)
	if (stderr == "MPD error: Connection refused\n") then
		text = "MPD not running"
	elseif (stdout == "volume: n/a   repeat: off   random: off   single: off   consume: off\n") then
		text = "Playlist Empty"
	else
		text = stdout
	music_text:set_text("🎵 "..text)
	end
end, music_widget)

return music_widget
