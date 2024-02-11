---------------------------------------------------------------------------------------------
-- EVENTS
---------------------------------------------------------------------------------------------
local RitnEvoGui = require(ritnlib.defines.enemy.class.evoGui)
local RitnSurface = require(ritnlib.defines.enemy.class.surface)
local RitnForce = require(ritnlib.defines.enemy.class.force)
---------------------------------------------------------------------------------------------

local function on_init_mod(event)
    log('RitnEnemy -> on_init')
    -----------------------------------------------------------
    local enemy = remote.call('RitnCoreGame', "get_enemy")
    enemy.force_disable = false
    remote.call('RitnCoreGame', "set_enemy", enemy)
    -----------------------------------------------------------
    remote.call("RitnCoreGame", "add_param_data", "surface", "pollution", {
        last = 0,
        current = 0,
        count = 0,
    })
    remote.call("RitnCoreGame", "add_param_data", "force", "cease_fire_disable_forced", false)
    -----------------------------------------------------------
    -- gestion evoGUI
    local status = pcall(function() remote.call("EvoGUI", "create_remote_sensor", 
        { 
          mod_name = "RitnEnemy",
          name = "evolution_factor_ritnenemy", 
          text = "", 
          caption = {'sensor.evo_factor_name'}
        }
    ) end)
    if status then 
        log('evoGUI : remote sensor load !')
    else 
        log('evoGUI : remote sensor not load.')
    end
    -----------------------------------------------------------
    log('on_init : RitnEnemy -> finish !')
end


-- config du jeu à changé
local function on_configuration_changed(event)
    -----------------------------------------------------------
    -- gestion evoGUI
    pcall(function() remote.call("EvoGUI", "create_remote_sensor", 
        { 
          mod_name = "RitnEnemy",
          name = "evolution_factor_ritnenemy", 
          text = "", 
          caption = {'sensor.evo_factor_name'}
        }
    ) end)
    -----------------------------------------------------------
end


local function on_tick_evoGui(e)
    if game.tick % 60 ~= 0 then return end

    local enemy = remote.call("RitnCoreGame", "get_enemy")

    if enemy == nil then return end
    if enemy.active == nil then return end
    if enemy.active == false then return end
  
    if game.active_mods["EvoGUI"] then 

        local players = remote.call("RitnCoreGame", "get_players")

        for player_index, player in pairs(players) do 
            -- On créer un faux event pour charger le LuaPlayer
            local event = {player_index = player_index}
            -- On récupère l'EvoGUI du joueur
            local rEvoGui = RitnEvoGui(event)
            local not_log = true
            rEvoGui:setCaption(RitnForce(game.forces[player.force], not_log):evolutionCalculate())
        end
    end
end






local function on_tick_evolution(e)
    local value = e.tick % 60
  
    local map_settings = remote.call("RitnCoreGame", "get_map_settings")
    local enemy = remote.call("RitnCoreGame", "get_enemy")

    if map_settings.pollution then 
        if map_settings.pollution.enabled then 
            if map_settings.enemy_evolution then 
                if map_settings.enemy_evolution.enabled then 
                    if enemy.active then 
                        local LuaSurface = game.surfaces[value]
                        if LuaSurface ~= nil then
                            local surfaces = remote.call("RitnCoreGame", "get_surfaces")
                            if surfaces[LuaSurface.name] then 
                                local rSurface = RitnSurface(LuaSurface)
                                rSurface:pollution_by_surface()
                            end
                        end
                    end
                end
            end
        end
    end

----------------------------------------------------------------------------------
        if global.teleport.surfaces[LuaSurface.name] then
            events.enemy.pollution_by_surface(LuaSurface)
            if not global.teleport.surfaces[LuaSurface.name].current_time then 
                global.teleport.surfaces[LuaSurface.name].last_time = 0
                global.teleport.surfaces[LuaSurface.name].current_time = 0
                global.teleport.surfaces[LuaSurface.name].time = 0
            end
            -- si la map est utilisé par quelqu'un
            if global.teleport.surfaces[LuaSurface.name].map_used then 
                -- on recupère le curent time de la partie
                global.teleport.surfaces[LuaSurface.name].current_time = math.floor(game.tick / 60)
            end

            -- si le current time est surperieur au last time c'est que le temps s'ecoule (map_used = true)
            if global.teleport.surfaces[LuaSurface.name].current_time > global.teleport.surfaces[LuaSurface.name].last_time then
                global.teleport.surfaces[LuaSurface.name].time = global.teleport.surfaces[LuaSurface.name].time + 1
                global.teleport.surfaces[LuaSurface.name].last_time = global.teleport.surfaces[LuaSurface.name].current_time
            end
            events.enemy.evolution_by_surface(LuaSurface)
        end
end



-- event : on_tick
local function on_tick(e)
    --on_tick_local(e)
    --on_tick_loadGame(e) 
    on_tick_evoGui(e)
    --on_tick_evolution(e)
end

---------------------------------------------------------------------------------------------
local module = {events = {}}
---------------------------------------------------------------------------------------------
-- Events
script.on_init(on_init_mod)
script.on_configuration_changed(on_configuration_changed)
module.events[defines.events.on_tick] = on_tick
---------------------------------------------------------------------------------------------
return module