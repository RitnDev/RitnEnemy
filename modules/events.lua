---------------------------------------------------------------------------------------------
-- EVENTS
---------------------------------------------------------------------------------------------
local RitnSurface = require(ritnlib.defines.enemy.class.surface)
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
    log('on_init : RitnEnemy -> finish !')
end


local function on_tick_evoGui(e)
    if game.tick % 60 ~= 0 then return end
    if global.enemy.setting == false then return end
    if global.enemy.value == false then return end
  
    if game.active_mods["EvoGUI"] then 
  
      for i,LuaPlayer in pairs(game.players) do
  
        if LuaPlayer.valid then 
            if LuaPlayer.gui.top["evogui_root"] ~= nil then
              local LuaGui = LuaPlayer.gui.top["evogui_root"]["sensor_flow"]["always_visible"]["remote_sensor_evolution_factor_ritntp"]
  
              if LuaGui then
                  local LuaSurface = LuaPlayer.surface 
  
                  if LuaSurface.name == "nauvis" or string.sub(LuaSurface.name, 1, 6) == "lobby~" then
                    -- enemy (nauvis)
                    local LuaForceEnemy = game.forces["enemy"]
                    local percent_evo_factor = LuaForceEnemy.evolution_factor * 100
                    local whole_number = math.floor(percent_evo_factor)
                    local fractional_component = math.floor((percent_evo_factor - whole_number) * 100)
  
                    LuaGui.caption = {"sensor.evo_factor_format", LuaForceEnemy.name, string.format("%d.%02d%%", whole_number, fractional_component)}
                  else
                    -- enemy surface (ritnTP)
                    local LuaForceEnemy = game.forces["enemy~" .. LuaSurface.name]
                    local percent_evo_factor = LuaForceEnemy.evolution_factor * 100
                    local whole_number = math.floor(percent_evo_factor)
                    local fractional_component = math.floor((percent_evo_factor - whole_number) * 100)
  
                    LuaGui.caption = {"sensor.evo_factor_format", LuaForceEnemy.name, string.format("%d.%02d%%", whole_number, fractional_component)}
                  end
              else
                  local text = ""
              end
            else
              events.utils.pcallLog("no 'evogui_root'", "on_tick_evoGui")
            end
        else
          events.utils.pcallLog("no 'top'", "on_tick_evoGui")
        end
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

---------------------------------------------------------------------------------------------
-- event : on_init
script.on_init(on_init_mod)
---------------------------------------------------------------------------------------------
return {}