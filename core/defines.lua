-----------------------------------------
--               DEFINES               --
-----------------------------------------
if not ritnlib then require("__RitnBaseGame__.core.defines") end
-----------------------------------------
local name = "RitnEnemy"
local dir = "__".. name .."__"
local directory = dir .. "."
-----------------------------------------
local defines = {}

-- Mod ID.
defines.name = name
-- Path to the mod's directory.
defines.directory = dir

-- classes
defines.class = {
    surface = directory .. "classes.RitnSurface",
    force = directory .. "classes.RitnForce",
}


-- Modules
defines.modules = {
    core = dir .. ".core.modules",
    globals = dir .. ".modules.globals",
    events = dir .. ".modules.events",
    commands = dir .. ".modules.commands",
    ----
    player = dir .. ".modules.player",
    ----
}

-- Prefix.
defines.prefix = {
    name = "ritnmods-",
}


----------------
ritnlib.defines.enemy = defines