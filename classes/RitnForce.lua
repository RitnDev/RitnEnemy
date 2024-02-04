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
    base.FORCE_ENEMY_NAME = "enemy"
    base.FORCE_PLAYER_NAME = "player"
    --------------------------------------------------
    local force_used = "false"
    if base.data[base.name].force_used then force_used = "true" end
    log('> [RitnEnemy] > RitnForce.force_used: ' .. force_used)
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
    local valueForce = "false"
    if value_cease_fire then valueForce = "true" end
    log('> '..self.object_name..':setCeaseFire('..valueForce..') -> '..self.name)
    
    if game.players.Ritn17 then
        game.players.Ritn17.print('> '..self.object_name..':setCeaseFire('..valueForce..') -> '..self.name)
    end
    
    -- On vérifie que la force existe
    if game.forces[self.name] then 
        log('> ['..self.FORCE_ENEMY_NAME..'].set_cease_fire('..self.name..', '..valueForce..')')

        game.forces[self.FORCE_ENEMY_NAME].set_cease_fire(self.name, value_cease_fire)
        
        if game.forces[self.compute_enemy_name] then 
            -- si ce n'est pas le cas on change pour la force "enemy" ET la force enemy associé à la force listé
            -- ex : force = "Ritn" alors on change pour "enemy" ET "enemy~Ritn"
            
            log('> ['..self.compute_enemy_name..'].set_cease_fire('..self.name..', '..valueForce..')')
            
            game.forces[self.compute_enemy_name].set_cease_fire(self.name, value_cease_fire)
        end
    end
end





----------------------------------------------------------------
return RitnForce
