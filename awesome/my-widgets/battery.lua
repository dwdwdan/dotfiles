local wibox = require("wibox")
local watch = require("awful.widget.watch")
local theme = require("mytheme")
local awful = require("awful")

local bat_text = wibox.widget{
	font = theme.mono_font,
	widget = wibox.widget.textbox,
}

local bat_widget = wibox.widget.background()
bat_widget:set_widget(bat_text)

bat_widget:set_bg(theme.bg_widget)
bat_widget:set_fg(theme.fg_widget)

watch("cat /sys/class/power_supply/BAT0/capacity",10,function(widget, stdout, stderr, exitreason, exitcode)
	local bat_percent = stdout
	if(tonumber(bat_percent) < 100) then
		bat_percent = " "..bat_percent
	end
	if(tonumber(bat_percent) < 10) then
		bat_percent = " "..bat_percent
	end
	bat_percent = bat_percent.."%"
	bat_text:set_text("🔋"..bat_percent)
end, bat_widget)

local open_info = function(lx, ly, button, mods, find_widgets_result)
	awful.spawn.with_shell("alacritty -e ~/.scripts/bat_status.sh")
end

bat_widget:connect_signal("button::press",open_info)

return bat_widget
