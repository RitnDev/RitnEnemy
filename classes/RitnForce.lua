-- RitnForce
----------------------------------------------------------------
local class = require(ritnlib.defines.class.core)
local RitnCoreForce = require(ritnlib.defines.core.class.force)
----------------------------------------------------------------


----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
local RitnForce = class.newclass(RitnCoreForce, function(base, LuaForce)
    if LuaForce == nil then return end
    if LuaForce.valid == false then return end
    if LuaForce.object_name ~= "LuaForce" then return end
    RitnCoreForce.init(base, LuaForce)
    log('> '..base.object_name..':init() -> RitnEnemy')
    --------------------------------------------------
    base.compute_enemy_name = ritnlib.defines.core.names.prefix.enemy .. base.name
    log('> base.compute_enemy_name = ' .. base.compute_enemy_name)
    base.FORCE_ENEMY_NAME = "enemy"
    base.FORCE_PLAYER_NAME = "player"
    --------------------------------------------------
    local force_used = base.data[base.name].force_used
    log('> [RitnEnemy] > RitnForce.force_used: ' .. tostring(force_used))
    log('> [RitnEnemy] > RitnForce')
end)
----------------------------------------------------------------


-- Système de cessé le feu avec les ennemies lors d'un changement d'état d'un joueur.
function RitnForce:updateCeaseFires()

    if self.data[self.name] then 
        log('> '..self.object_name..':updateCeaseFires() -> '..self.name)

        local force_used = self.data[self.name].force_used

        if self.data[self.name].cease_fire_disable_forced then 
            -- Si la force doit garder le cessé le feu inactif
            self:setCeaseFire(true)
            log('>>> self:setCeaseFire(true)')
        else
            self:setCeaseFire(not force_used)
        end
    end

    return self
  
end


-- Changement de l'état du cessé le feu pour les forces listé (force enemy associé)
function RitnForce:setCeaseFire(value_cease_fire)
    log('> '..self.object_name..':setCeaseFire('.. tostring(value_cease_fire) ..') -> '..self.name)
    
    -- On vérifie que la force existe
    if game.forces[self.name] ~= nil then 
        log('> ['..self.FORCE_ENEMY_NAME..'].set_cease_fire('..self.name..', '.. tostring(value_cease_fire) ..')')

        game.forces[self.FORCE_ENEMY_NAME].set_cease_fire(self.name, value_cease_fire)
        
        log('liste des forces : ')
        for _,force in pairs(game.forces) do 
            log(force.name)
        end

        if game.forces[self.compute_enemy_name] ~= nil then 
            -- si ce n'est pas le cas on change pour la force "enemy" ET la force enemy associé à la force listé
            -- ex : force = "Ritn" alors on change pour "enemy" ET "enemy~Ritn"
            
            log('> ['..self.compute_enemy_name..'].set_cease_fire('..self.name..', '.. tostring(value_cease_fire) ..')')
            
            game.forces[self.compute_enemy_name].set_cease_fire(self.name, value_cease_fire)
        end
    end
end





----------------------------------------------------------------
return RitnForce
