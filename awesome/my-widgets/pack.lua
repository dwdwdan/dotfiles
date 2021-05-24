local wibox = require("wibox")
local watch = require("awful.widget.watch")
local awful = require("awful")
local theme = require("mytheme")

local pack_text = wibox.widget{
	font = theme.mono_font,
	widget = wibox.widget.textbox,
}

local pack_widget = wibox.widget.background()
pack_widget:set_widget(pack_text)

pack_widget:set_bg(theme.bg_widget)
pack_widget:set_fg(theme.fg_widget)

watch("apt list --upgradable",60,function(widget, stdout, stderr, exitreason, exitcode)
	local _,number_to_upgrade = string.gsub(stdout, "\n", "\n")
	pack_text:set_text(" 📦 "..number_to_upgrade-1) --the -1 is to account for the listing output of apt list
end, pack_widget)

local upgrade_all = function(lx, ly, button, mods, find_widgets_result)
	awful.spawn.with_shell("alacritty -e ~/.scripts/upgrade.sh")
end

pack_widget:connect_signal("button::press",upgrade_all)

return pack_widget
