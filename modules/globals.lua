---------------------------------------------------------------------------------------------
-- GLOBALS
---------------------------------------------------------------------------------------------
if global.enemy == nil then
    global.enemy = {
        map_setting_enemy_activated = false,
    }
end


---------------------------------------------------------------------------------------------
-- REMOTE FUNCTIONS INTERFACE
---------------------------------------------------------------------------------------------
-- RitnClasse à implémenter ici.
---------------------------------------------------------------------------------------------

local enemy_interface = {

}
remote.add_interface("RitnEnemy", enemy_interface)
---------------------------------------------------------------------------------------------
return {}