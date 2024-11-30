---------------------------------------------------------------------------------------------
-- EVENTS
---------------------------------------------------------------------------------------------
local table = require(ritnlib.defines.table)
---------------------------------------------------------------------------------------------

local function on_init_mod(event)
    log('RitnEnemy -> on_init')
    -----------------------------------------------------------
    local enemy = remote.call('RitnCoreGame', "get_enemy")
    enemy.active = true
    enemy.force_disable = false
    remote.call('RitnCoreGame', "set_enemy", enemy)
    -----------------------------------------------------------
    remote.call("RitnCoreGame", "add_param_data", "surface", "pollution", {
        last = 0,
        current = 0,
        count = 0,
    })
    remote.call("RitnCoreGame", "add_param_data", "surface", "time", {
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
    local map_gen_settings = remote.call('RitnCoreGame', 'get_map_gen_settings')
    local enemy = remote.call('RitnCoreGame', "get_enemy")
        enemy.force_disable = false
        -- si la création de base est à 0, cela veut dire que les ennemies sont désactivés
        if table.isNotEmpty(map_gen_settings) then
            if map_gen_settings["autoplace_controls"] then 
                if map_gen_settings["autoplace_controls"]["enemy-base"] then 
                    if map_gen_settings["autoplace_controls"]["enemy-base"].size == 0 then 
                        enemy.active = false
                    else
                        enemy.active = true
                    end
                end
            end
        end
    remote.call('RitnCoreGame', "set_enemy", enemy)
    -----------------------------------------------------------
end

-- Gestion de l'affichage dans EvoGUI
local function on_tick_evoGui(e)
    if game.tick % 60 ~= 0 then return end

    local enemy = remote.call("RitnCoreGame", "get_enemy")

    if enemy == nil then return end
    if enemy.active == nil then return end
    if enemy.active == false then return end

    if script.active_mods["EvoGUI"] then 

        local players = remote.call("RitnCoreGame", "get_players")

        for player_index, player in pairs(players) do 
            -- On créer un faux event pour charger le LuaPlayer
            local event = {player_index = player_index}
            -- On récupère l'EvoGUI du joueur
            local rEvoGui = RitnEvoGui(event)
            local not_log = true
            rEvoGui:setCaption(RitnEnemyForce(game.forces[player.force], not_log):evolutionCalculate(player.surface))
        end
    end
end






local function on_tick_evolution(e)
    -- récupère le modulo 60 en fonction de la valeur du tick en cours
    local value = e.tick % 60
    -- si le modulo = 0 on ne fais rien
    if value == 0 then return end

    -- on récupère le nombre de surfaces en cours
    local values_surfaces = remote.call("RitnCoreGame", "get_values", "surfaces")
    -- si value est supérieur au nombre de surfaces on arrete tout !
    if value > values_surfaces then return end
    -- On recupere la liste des surfaces
    local surfaces = remote.call("RitnCoreGame", "get_surfaces")
    local iterator = 0
    -- par defaut le surface_name = nauvis
    local surface_name = "nauvis"
    -- on boucle en incrementant l'iterator
    for _, surface in pairs(surfaces) do
        iterator = iterator + 1
        -- si l'iterator = valeur on est sur la surface à calculer
        if iterator == value then 
            -- on récupère le nom la surface
            surface_name = surface.name
        end
    end
    --log('> surface_name = ' .. surface_name)

    local map_settings = remote.call("RitnCoreGame", "get_map_settings")
    local enemy = remote.call("RitnCoreGame", "get_enemy")

    -- calcul de la pollution pour une surface
    if map_settings.enemy_evolution then 
        if map_settings.enemy_evolution.enabled then 
            if enemy.active then 
                local LuaSurface = game.surfaces[surface_name]
                if LuaSurface ~= nil then
                    local rSurface = RitnEnemySurface(LuaSurface)

                    -- calcul de la pollution de la surface
                    rSurface:calculate_pollution()

                    -- calcul du temps passé sur la surface
                    rSurface:calculate_time()

                    -- calcul de l'evolution des enemy de cette surface
                    rSurface:calculate_evolution()
                end
            end
        end
    end
end



-- event : on_tick
local function on_tick(e)
    --on_tick_local(e)
    on_tick_evoGui(e)
    on_tick_evolution(e)
end

---------------------------------------------------------------------------------------------
local module = {events = {}}
---------------------------------------------------------------------------------------------
-- Events
module.on_init = on_init_mod
module.on_configuration_changed = on_configuration_changed
module.events[defines.events.on_tick] = on_tick
---------------------------------------------------------------------------------------------
return module