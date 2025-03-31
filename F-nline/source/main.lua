import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "player.lua"
import "library.lua"
spriteSystem = import("spriteInit.lua")

local gfx <const> = playdate.graphics

function playdate.update()
    gfx.clear()
    
    if gameState == 0 then
        movement(2,0.9,0.8,2)

        local debug = 0
        if debug == 1 then
            gfx.drawText("State: " .. CharactersUsed[i].state, CharactersUsed[i].x, CharactersUsed[i].y - 15)
        end

        gfx.drawText("P1: " .. CharactersUsed[1].combo, 10, 40)
        gfx.drawText("P2: " .. CharactersUsed[2].combo, 10, 60)
        playdate.drawFPS(200, 5)
    end
end