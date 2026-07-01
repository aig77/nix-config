hl.config({
  animations = {
    enabled = true,
  },
})

-- Two curves only
hl.curve("settle", { type = "bezier", points = { { 0.0, 0.0 }, { 0.2, 1.0 } } })
hl.curve("leave", { type = "bezier", points = { { 0.4, 0.0 }, { 1.0, 1.0 } } })

-- Windows: barely-there scale confirm, not a bounce
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4, bezier = "settle", style = "popin 95%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "leave", style = "popin 95%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3, bezier = "settle" })

-- Layers (panels, popups)
hl.animation({ leaf = "layersIn", enabled = true, speed = 3, bezier = "settle", style = "slide" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 2, bezier = "leave", style = "slide" })

-- Fades: one unified fast setting
hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "settle" })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 4, bezier = "settle" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 4, bezier = "settle" })

-- Workspaces: directional slide, no bounce
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "settle", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, bezier = "settle", style = "slidevert" })

hl.animation({ leaf = "border", enabled = true, speed = 5, bezier = "settle" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 85, bezier = "linear", style = "loop" })
