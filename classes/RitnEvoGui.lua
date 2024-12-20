-- RitnEvoGui
----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
RitnEvoGui = ritnlib.classFactory.newclass(RitnLibGui, function(self, event)
    RitnLibGui.init(self, event, ritnlib.defines.enemy.name, "evogui_root")
    self.object_name = "RitnEvoGui"
    --------------------------------------------------
    self.gui_name = "evo"
    self.gui_evo = nil
    --------------------------------------------------
    self.gui = { self.player.gui.top }
    --------------------------------------------------
end)
----------------------------------------------------------------


function RitnEvoGui:getRootGui()
    if self.main_gui == nil then log('not main_gui !') return end
    if self.main_gui == "" then log('not main_gui !') return end
    if self.gui[1] == nil then log('not gui !') return end
    ----------------------------------------------------------
    return self.gui[1][self.main_gui]
end


function RitnEvoGui:getEvoEnemy()
    if self.main_gui == nil then log('not main_gui !') return end
    if self.main_gui == "" then log('not main_gui !') return end
    if self.gui[1] == nil then log('not gui !') return end
    ----------------------------------------------------------
    --log('> '..self.object_name..':getEvoEnemy() -> ' .. self.name)
    
    if self.gui[1][self.main_gui] == nil then log('not EVOGUI !') return end
    if self.gui[1][self.main_gui]["sensor_flow"] == nil then log('not sensor_flow !') return end
    if self.gui[1][self.main_gui]["sensor_flow"]["always_visible"] == nil then log('not always_visible !') return end
    if self.gui[1][self.main_gui]["sensor_flow"]["always_visible"]["remote_sensor_evolution_factor_ritnenemy"] == nil then --[[ log('not sensor RitnEnemy !') ]] return end

    pcall(function()
        self.gui_evo = self.gui[1][self.main_gui]["sensor_flow"]["always_visible"]["remote_sensor_evolution_factor_ritnenemy"]
    end)

    return self.gui_evo
end


function RitnEvoGui:isEvoEnemyPresent()
    local present = false
    if self:getEvoEnemy() ~= nil then 
        present = true
    end
    --log('> gui_evo present : ' .. tostring(present))
    return present
end


function RitnEvoGui:setCaption(caption)
    if type(caption) ~= "table" then log('caption not compatible -> type : ' .. type(caption)) return end
    if self:isEvoEnemyPresent() then 
        self.gui_evo.caption = caption
    end
end


----------------------------------------------------------------
--return RitnEvoGui