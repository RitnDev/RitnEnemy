-- MODULE : COMMANDS
---------------------------------------------------------------------------------

commands.add_command("evo", "", 
    function (e)
        local LuaPlayer = game.players[e.player_index]
        local LuaSurface = LuaPlayer.surface
        local rSurface = RitnEnemySurface(LuaPlayer.surface)
        rSurface.surface.print({"msg.evo", rSurface.name, rSurface:get_evo_factor("%d.%d%%")}, {r=0,g=1,b=0,a=1})
    end
)

commands.add_command("reactive_enemy","",
    function(e) 

        local enemy = remote.call("RitnCoreGame", "get_enemy")
        local LuaPlayer

        if enemy then 
            if enemy.active == false then 
                local autorize = false
                local is_player = false
                local ENEMY_NAME = "enemy"

                if e.player_index then 
                    LuaPlayer = game.players[e.player_index]
                    if LuaPlayer.admin or LuaPlayer.name == "Ritn" then
                        autorize = true
                        is_player = true
                    end
                else 
                    autorize = true -- server
                end

                local function log_cmd(text) 
                    pcall(function() 
                        if is_player then 
                            LuaPlayer.print(text)
                        else
                            log(text)
                        end
                    end)
                end

                if autorize then 

                    for _,force in pairs(game.forces) do
                        local execute = true 
                        if force.name == 'player' then  execute = false end
                        if force.name == 'neutral' then  execute = false end
                        if force.name == 'force~default' then  execute = false end
                        if string.sub(force.name, 1, 5) == ENEMY_NAME then execute = false end

                        local compute_enemy_name = ENEMY_NAME .. '~' .. force.name
                        if game.forces[compute_enemy_name] ~= nil then execute = false end
                                    
                        if execute then 
                            log_cmd('> Create force enemy : ' .. compute_enemy_name)
                            local LuaForce = game.create_force(compute_enemy_name)
                            LuaForce.reset()
                            LuaForce.reset_evolution()
                            LuaForce.ai_controllable = true
                            LuaForce.set_cease_fire(ENEMY_NAME, true)
                            game.forces[ENEMY_NAME].set_cease_fire(LuaForce, true)
                        end
                    end

                    enemy.active = true 
                    log_cmd('> enemy is activate !')
                    remote.call("RitnCoreGame", "set_enemy", enemy)
                end
            end
        end
    end
)

---------------------------------------------------------------------------------
return {}