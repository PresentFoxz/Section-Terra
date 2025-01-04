import "library.lua"

local gfx <const> = playdate.graphics
function drawWorld()
    local grab = tileCheck(camPos.x, camPos.y)
    
    print(grab.x, grab.y, grab.block)
    
    local x, y = 0, 0
    local tilesX = screenWidth / blockSpacing
    local tilesY = screenHeight / blockSpacing
    for i=grab.y, grab.y + tilesY do
        for l=grab.x, grab.x + tilesX do
            local tile = tileCheck((grab.x + x), (grab.y + y))
            if type(tile) ~= "boolean" and tile.block > 0 then
                local sprite = blockImages[tile.block]
                local xPos = tile.x - camPos.x
                local yPos = tile.y - camPos.y
                if (xPos < 400 and xPos > -blockSpacing) and (yPos > -blockSpacing and yPos < 240) then
                    sprite:draw(xPos, yPos)
                end
            end
            x += blockSpacing
        end
        y += blockSpacing
        x = 0
    end
end

function drawPlayer_Mine(playerSprite, mineSprite)
    playerSprite:draw(playerPos.x - camPos.x, playerPos.y - camPos.y)

    if style == 1 then
        mineSprite:draw(minePos.x - camPos.x, minePos.y - camPos.y)
    end
end