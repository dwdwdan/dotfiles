package.loaded["awful.hotkeys_popup.keys.tmux"]={}
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({ preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function (err)
		-- Make sure we don't go into an endless error loop
		if in_error then return end
		in_error = true

		naughty.notify({ preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err) })
		in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/mytheme.lua")
-- Multiple monitor helper
local xrandr=require("xrandr")
local default_layout=2

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	awful.layout.suit.floating,
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	awful.layout.suit.fair,
	awful.layout.suit.fair.horizontal,
	awful.layout.suit.spiral,
	awful.layout.suit.spiral.dwindle,
	awful.layout.suit.max,
	awful.layout.suit.max.fullscreen,
	awful.layout.suit.magnifier,
	awful.layout.suit.corner.nw,
	-- awful.layout.suit.corner.ne,
	-- awful.layout.suit.corner.sw,
	-- awful.layout.suit.corner.se,
}
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Set up monitors
awful.spawn.with_shell("xrandr --output HDMI-1-1 --primary --right-of eDP-1-1")

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({ }, 1, function(t) t:view_only() end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({ }, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
	awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
	awful.button({ }, 1, function (c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal(
				"request::activate",
				"tasklist",
				{raise = true}
			)
		end
	end),
	awful.button({ }, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({ }, 4, function ()
		awful.client.focus.byidx(1)
	end),
	awful.button({ }, 5, function ()
		awful.client.focus.byidx(-1)
	end))

local logout_popup = require('awesome-wm-widgets.logout-popup-widget.logout-popup')
local my_volume = require('my-widgets.volume')
local my_battery = require('my-widgets.battery')
local my_date = require('my-widgets.date')
local my_pack = require('my-widgets.pack')

function makeMainScreenWiBar()
	local thisscreen=screen[1]
	awful.tag({"1","2","3","4","5","6","7","8","9"}, thisscreen, awful.layout.layouts[default_layout])
	local mytasklist = awful.widget.tasklist {
		screen  = thisscreen,
		filter  = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons
	}

	local bar=awful.wibar({
		position="top",
		screen=thisscreen,
		width=thisscreen.geometry.width,
		})

	local tray = wibox.widget.systray()
	tray:set_screen(thisscreen)
	local mytaglist = awful.widget.taglist {
		screen  = thisscreen,
		filter  = awful.widget.taglist.filter.all,
		buttons = taglist_buttons
	}
	bar:setup{
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			tray,
			mytaglist,
			mypromptbox,
		},
		nil,
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			my_pack,
			my_date,
			my_volume,
			my_battery,
		},
	}
end

local function makeSecondScreenWibar()
	local thisscreen=screen[screen.count()]
	awful.tag({"1","2","3","4","5","6","7","8","9"}, thisscreen, awful.layout.layouts[default_layout])
	local bar=awful.wibar({
		position="top",
		screen=thisscreen,
		width=thisscreen.geometry.width,
		})

	local mytaglist = awful.widget.taglist {
		screen  = thisscreen,
		filter  = awful.widget.taglist.filter.all,
		buttons = taglist_buttons
	}
	bar:setup{
		layout=wibox.layout.stack,
		{
			layout=wibox.layout.fixed.horizontal,
			mytaglist
		},
		{
			mytextclock,
			valign="center",
			halign="center",
			layout=wibox.container.place
		}
	}
end

makeMainScreenWiBar()
makeSecondScreenWibar()

-- {{{ Mouse bindings
root.buttons(gears.table.join(
	awful.button({ }, 4, awful.tag.viewnext),
	awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
	awful.key({ modkey, }, "s",      hotkeys_popup.show_help,
		{description="show help", group="awesome"}),

	awful.key({ modkey, }, "Left",   awful.tag.viewprev,
		{description = "view previous", group = "tag"}),

	awful.key({ modkey, }, "Right",  awful.tag.viewnext,
		{description = "view next", group = "tag"}),

	awful.key({ modkey, }, "Escape", awful.tag.history.restore,
		{description = "go back", group = "tag"}),

	awful.key({ modkey, }, "j",
		function ()
			awful.client.focus.byidx( 1)
		end,
		{description = "focus next by index", group = "client"}
	),

	awful.key({ modkey, }, "k",
		function ()
			awful.client.focus.byidx(-1)
		end,
		{description = "focus previous by index", group = "client"}
	),

	awful.key({ modkey, }, "w", function () mymainmenu:show() end,
		{description = "show main menu", group = "awesome"}),

	-- Layout manipulation
	awful.key({ modkey, "Shift" }, "j", function () awful.client.swap.byidx(  1)    end,
		{description = "swap with next client by index", group = "client"}),

	awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.byidx( -1)    end,
		{description = "swap with previous client by index", group = "client"}),

	awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
		{description = "focus the next screen", group = "screen"}),

	awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
		{description = "focus the previous screen", group = "screen"}),

	awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
		{description = "jump to urgent client", group = "client"}),

	awful.key({ modkey, }, "Tab",
		function ()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end,
		{description = "go back", group = "client"}),

	-- Standard program
	awful.key({ modkey, }, "Return", function () awful.spawn(terminal) end,
		{description = "open a terminal", group = "launcher"}),

	awful.key({ modkey, "Control" }, "r", awesome.restart,
		{description = "reload awesome", group = "awesome"}),

	awful.key({ modkey, "Shift" }, "q", awesome.quit,
		{description = "quit awesome", group = "awesome"}),

	awful.key({ modkey, }, "l",     function () awful.tag.incmwfact( 0.05)          end,
		{description = "increase master width factor", group = "layout"}),

	awful.key({ modkey, }, "h",     function () awful.tag.incmwfact(-0.05)          end,
		{description = "decrease master width factor", group = "layout"}),

	awful.key({ modkey, "Shift" }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
		{description = "increase the number of master clients", group = "layout"}),

	awful.key({ modkey, "Shift" }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
		{description = "decrease the number of master clients", group = "layout"}),

	awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
		{description = "increase the number of columns", group = "layout"}),

	awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
		{description = "decrease the number of columns", group = "layout"}),

	awful.key({ modkey, }, "space", function () awful.layout.inc( 1)                end,
		{description = "select next", group = "layout"}),

	awful.key({ modkey, "Shift" }, "space", function () awful.layout.inc(-1)                end,
		{description = "select previous", group = "layout"}),

	awful.key({ modkey, "Control" }, "n",
		function ()
			local c = awful.client.restore()
			-- Focus restored client
			if c then
				c:emit_signal(
					"request::activate", "key.unminimize", {raise = true}
				)
			end
		end,
		{description = "restore minimized", group = "client"}),

	-- Dmenu
	awful.key({ modkey }, "r",     function ()
		awful.util.spawn("dmenu_run -fn 'Lato, Light-14' -sb '#282828' -sf '#ffffff' -nb '#141414' -nf '#aaaaaa'") end,
		{description = "run dmenu", group = "launcher"}),

	awful.key({ modkey, "Control", "Shift" }, "m", function() xrandr.xrandr() end,
		{description = "cycle through multimonitor", group = "utility"}),

	awful.key({ modkey }, "b",     function ()
		awful.util.spawn("firefox")
		end,
		{description = "Firefox", group = "software"}),

	awful.key({ modkey }, "d",     function ()
		awful.util.spawn("ferdi")
		end,
		{description = "Ferdi - Messaging", group = "software"}),

	awful.key({ modkey, "Control" }, "f",     function ()
		awful.spawn("alacritty -e ranger") end,
		{description = "Ranger", group = "software"}),

	awful.key({ modkey, }, "f",     function ()
		awful.spawn("pcmanfm") end,
		{description = "PCMan File Manager", group = "software"}),

	awful.key({ modkey }, "a",     function ()
		awful.spawn("pavucontrol") end,
		{description = "Audio Controls", group = "software"}),

	awful.key({ modkey , "Control" }, "b",     function ()
		awful.spawn.with_shell("feh --recursive --randomize --bg-fill ~/wallpapers") end,
		{description = "Change Background", group = "utility"}),

	awful.key({ modkey }, "p",     function ()
		logout_popup.launch{bg_color='#141414',text_color='#aaaaaa',accent_color='#91231c'} end,
		{description = "Show Shutdown Menu", group = "awesome"}),

	awful.key({ modkey }, "x",
		function ()
			awful.prompt.run {
				prompt       = "Run Lua code: ",
				textbox      = awful.screen.focused().mypromptbox.widget,
				exe_callback = awful.util.eval,
				history_path = awful.util.get_cache_dir() .. "/history_eval"
			}
		end,
		{description = "lua execute prompt", group = "awesome"}),

	awful.key({ }, "XF86AudioRaiseVolume" ,     function ()
	awful.spawn.with_shell("amixer -D pulse sset Master 2%+", false) end,
		{description = "Increase Volume", group = "Audio"}),

	awful.key({ }, "XF86AudioLowerVolume" ,     function ()
	awful.spawn.with_shell("amixer -D pulse sset Master 2%-", false) end,
		{description = "Decrease Volume", group = "Audio"}),

	awful.key({ }, "XF86AudioMute" ,     function ()
	awful.spawn.with_shell("amixer -D pulse sset Master toggle", false) end,
		{description = "Mute Volume", group = "Audio"})
)

clientkeys = gears.table.join(

	awful.key({ modkey, "Shift" }, "f",
		function (c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end,
		{description = "toggle fullscreen", group = "client"}),

	awful.key({ modkey }, "q",      function (c) c:kill()                         end,
		{description = "close", group = "client"}),

	awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
		{description = "toggle floating", group = "client"}),

	awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
		{description = "move to master", group = "client"}),

	awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
		{description = "move to screen", group = "client"}),

	awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
		{description = "toggle keep on top", group = "client"}),

	awful.key({ modkey,           }, "n",
		function (c)
			-- The client currently has the input focus, so it cannot be
			-- minimized, since minimized clients can't have the focus.
			c.minimized = true
		end ,
		{description = "minimize", group = "client"}),

	awful.key({ modkey,           }, "m",
		function (c)
			c.maximized = not c.maximized
			c:raise()
		end ,
		{description = "(un)maximize", group = "client"}),

	awful.key({ modkey, "Control" }, "m",
		function (c)
			c.maximized_vertical = not c.maximized_vertical
			c:raise()
		end ,
		{description = "(un)maximize vertically", group = "client"}),

	awful.key({ modkey, "Shift"   }, "m",
		function (c)
			c.maximized_horizontal = not c.maximized_horizontal
			c:raise()
		end ,
		{description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = gears.table.join(globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9,
			function ()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					tag:view_only()
				end
			end,
			{description = "view tag #"..i, group = "tag"}),
		-- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9,
			function ()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end,
			{description = "toggle tag #" .. i, group = "tag"}),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9,
			function ()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:move_to_tag(tag)
					end
				end
			end,
			{description = "move focused client to tag #"..i, group = "tag"}),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
			function ()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:toggle_tag(tag)
					end
				end
			end,
			{description = "toggle focused client on tag #" .. i, group = "tag"})
	)
end

clientbuttons = gears.table.join(
	awful.button({ }, 1, function (c)
		c:emit_signal("request::activate", "mouse_click", {raise = true})
	end),
	awful.button({ modkey }, 1, function (c)
		c:emit_signal("request::activate", "mouse_click", {raise = true})
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function (c)
		c:emit_signal("request::activate", "mouse_click", {raise = true})
		awful.mouse.client.resize(c)
	end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{ rule = { },
		properties = { border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap+awful.placement.no_offscreen
		}
	},

	-- Floating clients.
	{ rule_any = {
		instance = {
			"DTA",  -- Firefox addon DownThemAll.
			"copyq",  -- Includes session name in class.
			"pinentry",
		},
		class = {
			"Arandr",
			"Blueman-manager",
			"Gpick",
			"Kruler",
			"MessageWin",  -- kalarm.
			"Sxiv",
			"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
			"Wpa_gui",
			"veromix",
			"xtightvncviewer"},

		-- Note that the name property shown in xprop might be set slightly after creation of the client
		-- and the name shown there might not match defined rules here.
		name = {
			"Event Tester",  -- xev.
		},
		role = {
			"AlarmWindow",  -- Thunderbird's calendar.
			"ConfigManager",  -- Thunderbird's about:config.
			"pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
		}
	}, properties = { floating = true }},

	-- Add titlebars to normal clients and dialogs
	{ rule_any = {type = { "normal", "dialog" }
	}, properties = { titlebars_enabled = false }
	},

	-- Set Firefox to always map on the tag named "2" on screen 1.
	-- { rule = { class = "Firefox" },
	--   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup
		and not c.size_hints.user_position
		and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)



client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)


beautiful.notification_max_width=300
beautiful.notification_max_height=100

-- Autostart Applications
awful.spawn.with_shell("compton -b -f")
awful.spawn.with_shell("feh --recursive --randomize --bg-fill ~/wallpapers")
awful.spawn.with_shell("numlockx on")
--awful.spawn("thunderbird",{tag="<Email>"})
