-- MODULE : COMMANDS
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------

commands.add_command("evo", "", 
  function (e)
    local LuaPlayer = game.players[e.player_index]
    local LuaSurface = LuaPlayer.surface
    LuaSurface.print({"msg.evo", LuaSurface.name, ritnlib.enemy.getEvoFactor(LuaSurface,"%d.%d%%")},{r=0,g=1,b=0,a=1})
  end
)





---------------------------------------------------------------------------------
return {}