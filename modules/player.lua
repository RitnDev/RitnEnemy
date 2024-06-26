---------------------------------------------------------------------------------------------
-- MODULE : PLAYER
---------------------------------------------------------------------------------------------


-- Remplace les entitées "spawner" de la force "enemy" par la force "enemy~[player_name]"
local function on_chunk_generated(e)
    local rEvent = RitnCoreEvent(e)
    local rSurface = RitnEnemySurface(rEvent.surface):changeForceEnemy(rEvent.area)
end

--Creation de la force enemy de la map joueur
local function on_player_changed_surface(e)
    ----------------------------------------------------------------
    local rEvent = RitnCoreEvent(e)
    local rPlayer = RitnCoreEvent(e):getPlayer()
    -- Récupération de la surface où le joueur viens d'arriver
    local rSurface = RitnEnemySurface(rPlayer.surface):createForceEnemy()
    RitnEnemyForce(rPlayer.force):updateCeaseFires()
    ----------------------------------------------------------------
    log('on_player_changed_surface')
end


local function update_cease_fire(e)
    ----------------------------------------------------------------
    local rEvent = RitnCoreEvent(e)
    local rForce = RitnEnemyForce(rEvent.player.force):updateCeaseFires()
    ----------------------------------------------------------------
    log(rEvent.name)
end


local function on_player_changed_force(e)
    ----------------------------------------------------------------
    local rEvent = RitnCoreEvent(e)
    local rForce = RitnEnemyForce(rEvent.player.force):updateCeaseFires()
    local rOldForce = RitnEnemyForce(rEvent.force):updateCeaseFires()
    ----------------------------------------------------------------
    log('on_player_changed_force')
end


---------------------------------------------------------------------------------------------
local module = {events = {}}
---------------------------------------------------------------------------------------------
-- Events Player
module.events[defines.events.on_chunk_generated] = on_chunk_generated
module.events[defines.events.on_player_changed_surface] = on_player_changed_surface
module.events[defines.events.on_player_changed_force] = on_player_changed_force
module.events[defines.events.on_player_left_game] = update_cease_fire
module.events[defines.events.on_player_joined_game] = update_cease_fire
---------------------------------------------------------------------------------------------
return module