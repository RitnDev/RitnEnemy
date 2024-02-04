-- RitnSurface
----------------------------------------------------------------
local class = require(ritnlib.defines.class.core)
local RitnCoreSurface = require(ritnlib.defines.core.class.surface)
----------------------------------------------------------------


----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
local RitnSurface = class.newclass(RitnCoreSurface, function(base, LuaSurface)
    if LuaSurface == nil then return end
    if LuaSurface.valid == false then return end
    if LuaSurface.object_name ~= "LuaSurface" then return end
    RitnCoreSurface.init(base, LuaSurface)
    --log('> '..base.object_name..':init() -> RitnEnemy')
    --------------------------------------------------
    base.enemy = remote.call("RitnCoreGame", "get_enemy")
    --------------------------------------------------
    base.prefix = ritnlib.defines.core.names.prefix
    --------------------------------------------------
    base.compute_enemy_name = base.prefix.enemy .. base.name
    base.compute_lobby_name = base.prefix.lobby .. base.name
    --------------------------------------------------
    base.SURFACE_NAUVIS_NAME = "nauvis"
    base.FORCE_ENEMY_NAME = "enemy"
    base.FORCE_PLAYER_NAME = "player"
    --------------------------------------------------
    --log('> [RitnEnemy] > RitnSurface')
end)

----------------------------------------------------------------

-- Créé une équipe enemy associé pour la surface : "enemy~"..SURFACE_NAME
function RitnSurface:createForceEnemy()
    if self.name == self.SURFACE_NAUVIS_NAME then return self end
    if string.sub(self.name, 1, 6) == self.prefix.lobby then return self end
    if self.enemy.active == false then return self end
    log('> '..self.object_name..':createForceEnemy() -> '..self.name)

    if not game.forces[self.compute_enemy_name] then
        local LuaForce = game.create_force(self.compute_enemy_name)
        LuaForce.reset()
        LuaForce.reset_evolution()
        LuaForce.ai_controllable = true
        LuaForce.set_cease_fire(self.FORCE_ENEMY_NAME, true)
        game.forces[self.FORCE_ENEMY_NAME].set_cease_fire(LuaForce, true)
    end

    return self
end


-- change la force "enemy" par "enemy~"..SURFACE_NAME
function RitnSurface:changeForceEnemy(area)
    if self.name == self.SURFACE_NAUVIS_NAME then return self end
    if string.sub(self.name, 1, 6) == self.prefix.lobby then return self end
    if self.enemy.active == false then return self end

    local TabEntities = self.surface.find_entities_filtered{area=area, force=self.FORCE_ENEMY_NAME}
    for i,entity in pairs(TabEntities) do
        entity.force = self.compute_enemy_name
    end

    return self
end 



function RitnSurface:get_evo_factor(format)
    
    local enemy = prefix_enemy .. LuaSurface.name
    local percent_evo_factor = 0

    if game.forces[self.compute_enemy_name] ~= nil then
        percent_evo_factor = game.forces[self.compute_enemy_name].evolution_factor * 100
    else
        percent_evo_factor = game.forces.enemy.evolution_factor * 100  
    end
    local whole_number = math.floor(percent_evo_factor)
    local fractional_component = math.floor((percent_evo_factor - whole_number) * 10)

    return string.format(format, whole_number, fractional_component)
end


--
function RitnSurface:pollution_by_surface()
    if self.data[self.name] then 
        if self.data[self.name].pollution then                     
            local count = self.data[self.name].pollution.count
            local pollution_total = self.surface.get_total_pollution()
            self.data[self.name].pollution.last = self.data[self.name].pollution.current
            self.data[self.name].pollution.current = pollution_total
            local ecart = self.data[self.name].pollution.current - self.data[self.name].pollution.last
            if ecart > 0 then 
                self.data[self.name].pollution.count = count + ecart
            end
        end
    end

    self:update()

    return self
end


function RitnSurface:evolution_by_surface()
    if self.data[self.name] then  
        if self.data[self.name].pollution then                     
            local count = self.data[self.name].pollution.count
            -- recuperation du temps
            local time = self.data[self.name].time
            local time_factor = global.map_settings.enemy_evolution.time_factor

            local pollution_factor = global.map_settings.enemy_evolution.pollution_factor
            local enemy_name = self.FORCE_ENEMY_NAME
            if self.name ~= self.SURFACE_NAUVIS_NAME then 
                enemy_name = self.compute_enemy_name
            end

            if game.forces[enemy_name] then 
                -- calcul de l'evolution (by time & pollution)
                if self.data[self.name].map_used then 
                    game.forces[enemy_name].evolution_factor_by_time = time * time_factor
                end
                game.forces[enemy_name].evolution_factor_by_pollution = count * pollution_factor

                local evo_kill = game.forces[enemy_name].evolution_factor_by_killing_spawners
                local evo_pol = game.forces[enemy_name].evolution_factor_by_pollution
                local evo_time = game.forces[enemy_name].evolution_factor_by_time
                -- calcul de l'evolution total
                local evo = 1 - ((1-evo_kill) * (1-evo_pol) * (1-evo_time))
                -- renvoi du calcul sur la force enemy
                game.forces[enemy_name].evolution_factor = evo
            end
        end
    end
  self:update()

  return self
end



----------------------------------------------------------------
return RitnSurface