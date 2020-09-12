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

-- hack to skip loading naughty
local _dbus = dbus; dbus = nil
local naughty = require("naughty")
dbus = _dbus

local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- addons
local treetile = require("treetile")

-- modules --
require("modules.error-handling")

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "st"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"
shiftkey = "Shift"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    treetile,
    -- awful.layout.suit.floating,
    -- awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- setup odd even tags across monitors
local _screen_count = screen:count()
for i = 1, 6 do
  local _s

  if _screen_count > 1 then
    if i % 2 == 0 then
      _s = 2
    else
      _s = 1
    end
  else
    _s = 1
  end

  awful.tag.add(i, {
    layout = awful.layout.layouts[1],
    screen = _s,
    gap_single_client = false
  })
end

-- {{{ key-bindings
globalkeys = gears.table.join(

    -- help
    awful.key({ modkey }, "s", hotkeys_popup.show_help,
    {description="show help", group="awesome"}),

    -- focus clients {{{
    awful.key({ modkey, }, "j", function ()
      awful.client.focus.global_bydirection("down")
      if client.focus then client.focus:raise() end
    end, { description = "focus down", group = "client" }),

    awful.key({ modkey, }, "k", function ()
      awful.client.focus.global_bydirection("up")
      if client.focus then client.focus:raise() end
    end, { description = "focus up", group = "client" }),

    awful.key({ modkey, }, "h", function ()
      awful.client.focus.global_bydirection("left")
      if client.focus then client.focus:raise() end
    end, { description = "focus left", group = "client" }),

    awful.key({ modkey, }, "l", function ()
      awful.client.focus.global_bydirection("right")
      if client.focus then client.focus:raise() end
    end, { description = "focus right", group = "client" }),
    -- }}}

    -- move clients {{{
    awful.key({ modkey, "Shift" }, "j", function ()
      awful.client.swap.global_bydirection("down")
    end, { description = "swap down", group = "client" }),

    awful.key({ modkey, "Shift" }, "k", function ()
      awful.client.swap.global_bydirection("up")
    end, { description = "swap up", group = "client" }),

    awful.key({ modkey, "Shift" }, "h", function ()
      awful.client.swap.global_bydirection("left")
    end, { description = "swap left", group = "client" }),

    awful.key({ modkey, "Shift" }, "l", function ()
      awful.client.swap.global_bydirection("right")
    end, { description = "swap right", group = "client" }),
    -- }}}

    -- red-control {{{
    awful.key({ altkey }, "j", function ()
      awful.spawn("red-control -500 0")
    end, {description = "temperature down", group = "red-control"}),

    awful.key({ altkey }, "k", function ()
      awful.spawn("red-control 500 0")
    end, {description = "temperature up", group = "red-control"}),

    awful.key({ altkey, shiftkey }, "j", function ()
      awful.spawn("red-control 0 -1")
    end, {description = "brightness down", group = "red-control"}),

    awful.key({ altkey, shiftkey }, "k", function ()
      awful.spawn("red-control 0 1")
    end, {description = "brightness up", group = "red-control"}),
    -- }}}

    -- layout manipulation
    -- awful.key({ modkey }, "u", awful.client.urgent.jumpto,
    -- {description = "jump to urgent client", group = "client"}),

    -- launch
    awful.key({ modkey }, "Return", function ()
      awful.spawn(terminal)
    end, {description = "open a terminal", group = "launcher"}),

    awful.key({ modkey, "Control" }, "r", awesome.restart,
    {description = "reload awesome", group = "awesome"}),

    awful.key({ modkey }, "space", function ()
      awful.spawn("keyboardswitch")
    end, {description = "switch language", group = ""})
)

-- client keys --

clientkeys = gears.table.join(
    awful.key({ modkey }, "m", function (c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end, {description = "toggle fullscreen", group = "client"}),

    awful.key({ modkey }, "w", function (c)
      c:kill()
    end, {description = "close", group = "client"}),

    awful.key({ modkey }, "f", awful.client.floating.toggle,
    {description = "toggle floating", group = "client"})
)

-- tag keys --

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

for i = 1, 9 do
  globalkeys = gears.table.join(globalkeys,

    -- view tag
    awful.key({ modkey }, "#" .. i + 9, function ()
      local tag = root.tags()[i]
      if tag then
        awful.screen.focus(tag.screen)
        tag:view_only()
      end
    end, {description = "view tag #" .. i, group = "tag"}),

    -- move client to tag
    awful.key({ modkey, "Shift" }, "#" .. i + 9, function ()
      if client.focus then
        local tag = root.tags()[i]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end, {description = "move focused client to tag #"..i, group = "tag"})

    -- toggle tag display
    -- toggle tag on focused client
  )
end

root.keys(globalkeys)

-- }}}

root.tags()[2]:view_only()
root.tags()[1]:view_only()

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  { rule = { },
    properties = {
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap+awful.placement.no_offscreen,
      size_hints_honor = false,
      maximized_horizontal = false,
      maximized_vertical = false,
      maximized = false,
      floating = false
    }
  },

-- Floating clients.
-- { rule_any = {
--     instance = {
--       "DTA",  -- Firefox addon DownThemAll.
--       "copyq",  -- Includes session name in class.
--       "pinentry",
--     },
--     class = {
--       "Arandr",
--       "Blueman-manager",
--       "Gpick",
--       "Kruler",
--       "MessageWin",  -- kalarm.
--       "Sxiv",
--       "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
--       "Wpa_gui",
--       "veromix",
--       "xtightvncviewer"},

--     -- Note that the name property shown in xprop might be set slightly after creation of the client
--     -- and the name shown there might not match defined rules here.
--     name = {
--       "Event Tester",  -- xev.
--     },
--     role = {
--       "AlarmWindow",  -- Thunderbird's calendar.
--       "ConfigManager",  -- Thunderbird's about:config.
--       "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
--     }
--   }, properties = { floating = true }},

-- Add titlebars to normal clients and dialogs
  { rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = true } },

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
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
-- client.connect_signal("request::titlebars", function(c)
--     -- buttons for the titlebar
--     local buttons = gears.table.join(
--         awful.button({ }, 1, function()
--             c:emit_signal("request::activate", "titlebar", {raise = true})
--             awful.mouse.client.move(c)
--         end),
--         awful.button({ }, 3, function()
--             c:emit_signal("request::activate", "titlebar", {raise = true})
--             awful.mouse.client.resize(c)
--         end)
--     )
-- 
--     awful.titlebar(c) : setup {
--         { -- Left
--             awful.titlebar.widget.iconwidget(c),
--             buttons = buttons,
--             layout  = wibox.layout.fixed.horizontal
--         },
--         { -- Middle
--             { -- Title
--                 align  = "center",
--                 widget = awful.titlebar.widget.titlewidget(c)
--             },
--             buttons = buttons,
--             layout  = wibox.layout.flex.horizontal
--         },
--         { -- Right
--             awful.titlebar.widget.floatingbutton (c),
--             awful.titlebar.widget.maximizedbutton(c),
--             awful.titlebar.widget.stickybutton   (c),
--             awful.titlebar.widget.ontopbutton    (c),
--             awful.titlebar.widget.closebutton    (c),
--             layout = wibox.layout.fixed.horizontal()
--         },
--         layout = wibox.layout.align.horizontal
--     }
-- end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

--client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
--client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

beautiful.useless_gap = 5

-- }}}

