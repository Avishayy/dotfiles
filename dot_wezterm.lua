-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.max_fps = 240

-- This is where you actually apply your config choices
config.font = wezterm.font("FiraCode Nerd Font")
config.enable_tab_bar = false
-- Yabai doesn't recognize the window if decorations are NONE..
-- RESIZE does work instead
config.window_decorations = "RESIZE"
config.color_scheme = "AdventureTime"

config.keys = {
  { key = "t", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
}

-- and finally, return the configuration to wezterm
return config
