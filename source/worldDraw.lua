import "library.lua"
import "worldLoaded.lua"
import "CoreLibs/graphics"

local gfx <const> = playdate.graphics
function drawWorld()
    local grab = tileCheck(camPos.x, camPos.y)
    
    local x, y = 0, 0
    local tilesX = 11
    local tilesY = 9
    for i=1, tilesY do
        for l=1, tilesX do
            local tile = tileCheck((grab.x + x), (grab.y + y))
            if tile and type(tile) ~= "boolean" and tile.block > 0 then
                local sprite = blockImages[tile.block]
                local xPos = tile.x - camPos.x
                local yPos = tile.y - camPos.y
                if (xPos < 440 and xPos > -blockSpacing) and (yPos > -blockSpacing and yPos < 240) then
                    sprite:draw(xPos, yPos)
                end
            end
            x += blockSpacing
        end
        y += blockSpacing
        x = 0
        print("Looped: ", i)
    end
end

function drawPlayer_Mine(frame)
    local frameX = (frame - 1) * 32
    pIndex:draw(playerPos.x - camPos.x, playerPos.y - camPos.y, playdate.graphics.kImageUnflipped, frameX, 0, 32, 32)
    mineSprite:draw((minePos.x - (minePos.w / 2)) - camPos.x, (minePos.y - (minePos.h / 2)) - camPos.y)
end