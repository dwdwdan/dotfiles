local wibox = require("wibox")
local watch = require("awful.widget.watch")
local theme = require("mytheme")

local vol_text = wibox.widget{
	font = theme.mono_font,
	widget = wibox.widget.textbox,
}

local vol_widget = wibox.widget.background()
vol_widget:set_widget(vol_text)

vol_widget:set_bg(theme.bg_widget)
vol_widget:set_fg(theme.fg_widget)

watch("amixer -c 1 sget 'PCM'",1,function(widget, stdout, stderr, exitreason, exitcode)
	local vol_percent = string.match(stdout,"%[[^%s]*%]")
	vol_percent = vol_percent:sub(2,-3)
	if(tonumber(vol_percent) < 100) then
		vol_percent = " "..vol_percent
	end
	if(tonumber(vol_percent) < 10) then
		vol_percent = " "..vol_percent
	end
	if(vol_percent == "100") then
		vol_percent = " 🔊"..vol_percent
	elseif(vol_percent =="0") then
		vol_percent = " 🔈"..vol_percent
	else
		vol_percent = " 🔉"..vol_percent
	end
	vol_percent = vol_percent.."%"
	vol_text:set_text(vol_percent)
end, vol_widget)

return vol_widget
