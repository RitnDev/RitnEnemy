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
    evoGui = directory .. "classes.RitnEvoGui",
    surface = directory .. "classes.RitnSurface",
    force = directory .. "classes.RitnForce",
}

-- setup classes
defines.setup = dir .. ".core.setup-classes"

-- Modules
defines.modules = {
    core = dir .. ".core.modules",
    storage = dir .. ".modules.storage",
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