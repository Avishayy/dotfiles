-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.font = wezterm.font("FiraCode Nerd Font")
config.enable_tab_bar = false
-- Yabai doesn't recognize the window if decorations are NONE..
-- temporarily set to INTEGRATED_BUTTONS
config.window_decorations = "INTEGRATED_BUTTONS"
config.color_scheme = "AdventureTime"
config.window_padding = {
  -- temporarily set top padding so integrated buttons don't integere with content
  top = 48,
  bottom = 0,
}

-- and finally, return the configuration to wezterm
return config
