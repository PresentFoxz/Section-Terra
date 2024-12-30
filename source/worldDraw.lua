import "library.lua"

local gfx <const> = playdate.graphics
function drawWorld()
    for i=1, #tiles do
        local tile = tiles[i]
        if tile.block > 0 then
            local sprite = blockImages[tile.block]
            local xPos = tile.x - camPos.x
            local yPos = tile.y - camPos.y
            if (xPos < 400 and xPos > -40) and (yPos > -40 and yPos < 240) then
                sprite:draw(xPos, yPos)
            end
        end
    end
end

function drawPlayer_Mine(playerSprite, mineSprite)
    playerSprite:draw(playerPos.x - camPos.x, playerPos.y - camPos.y)

    if style == 1 then
        mineSprite:draw(minePos.x - camPos.x, minePos.y - camPos.y)
    end
end