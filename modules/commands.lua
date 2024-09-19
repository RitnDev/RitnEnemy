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

---------------------------------------------------------------------------------
return {}