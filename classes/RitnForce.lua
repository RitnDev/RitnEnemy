-- RitnEnemyForce
----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
RitnEnemyForce = ritnlib.classFactory.newclass(RitnCoreForce, function(self, LuaForce, not_log)
    RitnCoreForce.init(self, LuaForce)
    if not not_log then
        log('> '..self.object_name..':init() -> RitnEnemy')
    end
    --------------------------------------------------
    self.compute_enemy_name = ritnlib.defines.core.names.prefix.enemy .. self.name
    if not not_log then
        log('> self.compute_enemy_name = ' .. self.compute_enemy_name)
    end
    --------------------------------------------------
    if not not_log then
        local force_used = self.data[self.name].force_used
        log('> [RitnEnemy] > RitnEnemyForce.force_used: ' .. tostring(force_used))
        log('> [RitnEnemy] > RitnEnemyForce')
    end
    self.not_log = not_log
end)
----------------------------------------------------------------


-- retourne true si la RitnEnemyForce est la force "player"
function RitnEnemyForce:isForcePlayer()
    return (self.name == self.FORCE_PLAYER_NAME)
end


-- Système de cessé le feu avec les ennemies lors d'un changement d'état d'un joueur.
function RitnEnemyForce:updateCeaseFires()

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
function RitnEnemyForce:setCeaseFire(value_cease_fire)
    log('> '..self.object_name..':setCeaseFire('.. tostring(value_cease_fire) ..') -> '..self.name)
    
    -- On vérifie que la force existe
    if game.forces[self.name] ~= nil then 
        log('> ['..self.FORCE_ENEMY_NAME..'].set_cease_fire('..self.name..', '.. tostring(value_cease_fire) ..')')

        game.forces[self.FORCE_ENEMY_NAME].set_cease_fire(self.name, value_cease_fire)

        if game.forces[self.compute_enemy_name] ~= nil then 
            -- si ce n'est pas le cas on change pour la force "enemy" ET la force enemy associé à la force listé
            -- ex : force = "Ritn" alors on change pour "enemy" ET "enemy~Ritn"
            
            log('> ['..self.compute_enemy_name..'].set_cease_fire('..self.name..', '.. tostring(value_cease_fire) ..')')
            
            game.forces[self.compute_enemy_name].set_cease_fire(self.name, value_cease_fire)
        end
    end
end


-- renvoie l'evolution au format texte à afficher dans EvoGUI
function RitnEnemyForce:evolutionCalculate()
    -- recupère la force enemy par defaut
    local LuaForceEnemy = game.forces[self.FORCE_ENEMY_NAME]
    -- si la force du joueur n'est pas player
    if self:isForcePlayer() == false then
        if game.forces[self.compute_enemy_name] ~= nil then 
            -- on récupère la force enemy associé à sa force actuelle
            LuaForceEnemy = game.forces[self.compute_enemy_name]
        end
    end
    -- prepare le texte de sortie en fonction de l'evolution de la force enemy
    local percent_evo_factor = LuaForceEnemy.evolution_factor * 100
    local whole_number = math.floor(percent_evo_factor)
    local fractional_component = math.floor((percent_evo_factor - whole_number) * 100)
    if not self.not_log then 
        log('> ' .. LuaForceEnemy.name .. ' (evo) = ' .. string.format("%d.%02d%%", whole_number, fractional_component))
    end

    return {"sensor.evo_factor_format", LuaForceEnemy.name, string.format("%d.%02d%%", whole_number, fractional_component)}
end


