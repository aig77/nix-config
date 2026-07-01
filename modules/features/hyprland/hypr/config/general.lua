LAYOUT = "scrolling"
local c = require("config.colors")

hl.config({ debug = { disable_logs = false } })

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
  general = {
    gaps_in = 0,
    gaps_out = 5,

    border_size = 1,

    col = {
      -- Colors sourced from ~/.cache/stylix/colors.json (mauve, lavender, blue gradient)
      active_border = {
        colors = { "rgb(" .. c.base0E .. ")", "rgb(" .. c.base01 .. ")", "rgb(" .. c.base0D .. ")" },
        angle = 45,
      },
      inactive_border = "rgb(" .. c.base02 .. ")",
    },

    -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
    resize_on_border = false,

    -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
    allow_tearing = false,

    layout = LAYOUT,
  },

  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "",
    kb_rules = "",

    follow_mouse = 1,

    sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
    accel_profile = "flat",
    -- force_no_accel = true,

    touchpad = {
      natural_scroll = true,
      clickfinger_behavior = true,
    },
  },

  cursor = {
    inactive_timeout = 3,
  },

  ecosystem = {
    no_update_news = true,
    no_donation_nag = true,
  },

  misc = {
    force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
    disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
    focus_on_activate = true,
  },

  decoration = {
    rounding = 0,
    rounding_power = 2,

    -- Change transparency of focused and unfocused windows
    active_opacity = 1.0,
    inactive_opacity = 1.0,

    shadow = {
      enabled = false,
      range = 8,
      render_power = 2,
      color = 0xee1a1a1a,
    },

    blur = {
      enabled = true,
      size = 6,
      passes = 3,
      noise = 0.02,
      contrast = 0.9,
      vibrancy = 0.1,
      new_optimizations = true,
      ignore_opacity = false,
    },
  },

  -- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
  dwindle = {
    force_split = 2,
    preserve_split = true,
  },

  -- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
  master = {
    new_status = "master",
  },

  -- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
  scrolling = {
    column_width = 0.5,
    explicit_column_widths = "0.33, 0.5, 0.66, 1.0",
    -- fullscreen_on_one_column = true,
  },
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
  name = "epic-mouse-v1",
  sensitivity = -0.5,
})
