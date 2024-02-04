local modules = {}
------------------------------------------------------------------------------

-- Inclus les events onInit et onLoad + les ajouts de commandes
modules.globals =                   require(ritnlib.defines.enemy.modules.globals)
modules.events =                    require(ritnlib.defines.enemy.modules.events)
--modules.commands =                  require(ritnlib.defines.enemy.modules.commands)

---- Modules désactivable
modules.player =                    require(ritnlib.defines.enemy.modules.player)
------------------------------------------------------------------------------
return modules