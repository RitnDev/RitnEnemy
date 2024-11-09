local modules = {}
------------------------------------------------------------------------------

-- Inclus les events onInit et onLoad + les ajouts de commandes
modules.storage =                   require(ritnlib.defines.enemy.modules.storage)
modules.events =                    require(ritnlib.defines.enemy.modules.events)
modules.commands =                  require(ritnlib.defines.enemy.modules.commands)

---- Modules désactivable
modules.player =                    require(ritnlib.defines.enemy.modules.player)
------------------------------------------------------------------------------
return modules