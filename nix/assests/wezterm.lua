-- Pull in the wezterm API
local wezterm = require 'wezterm'
-- local wezterm = require 'wezterm.color'
local config = wezterm.config_builder()
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
-- config.color_scheme = 'tokyonight'
config.color_scheme = 'Tokyo Night'
-- config.color_scheme = 'Material Palenight (base16)'
-- config.color_scheme = 'catppuccin-mocha'

config.front_end = "WebGpu"
config.animation_fps = 1
config.cursor_blink_rate = 0
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'
config.window_background_opacity = 0.95
config.font = wezterm.font 'JetBrains Mono NF'
config.enable_tab_bar = true
config.show_tab_index_in_tab_bar = false
-- This will hold the configuration.
-- colors, metadata = wezterm.color.load_terminal_sexy_scheme("/home/bones/.config/moonlightTheme.json")
-- This is where you actually apply your config choices
-- config.colors = colors
-- config.color_scheme = colours

-- and finally, return the configuration to wezterm
bar.apply_to_config(config)
local act = wezterm.action
config.keys = {
   -- turn off specific keybindings
  {
    key = 'Tab',
    mods = 'CTRL',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = 'Tab',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.DisableDefaultAssignment,
  },

  { key = 'LeftArrow', mods = 'SHIFT', action = act.ActivateTabRelativeNoWrap(-1) },
  { key = 'RightArrow', mods = 'SHIFT', action = act.ActivateTabRelativeNoWrap(1) },
  {
     key = 'LeftArrow',
     mods = 'CTRL|SHIFT',
     action = act.ActivatePaneDirection 'Left',
  },
  {
     key = 'RightArrow',
     mods = 'CTRL|SHIFT',
     action = act.ActivatePaneDirection 'Right',
  },
  {
     key = 'UpArrow',
     mods = 'CTRL|SHIFT',
     action = act.ActivatePaneDirection 'Up',
  },
  {
     key = 'DownArrow',
     mods = 'CTRL|SHIFT',
     action = act.ActivatePaneDirection 'Down',
  },

  {
     key = '{',
     mods = 'CTRL|SHIFT',
     action = wezterm.action.SplitPane {
        direction = 'Right',
        command = {},
        size = { Percent = 50 },
     },
  },
  {
     key = '}',
     mods = 'CTRL|SHIFT',
     action = wezterm.action.SplitPane {
        direction = 'Down',
        command = {},
        size = { Percent = 50 },
     },
  },
}

return config
