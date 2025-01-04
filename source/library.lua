blockSpacing = 40
tiles = {}
amt = {x = 40, y = 50}
screenWidth, screenHeight = 400, 240
worldWidth, worldHeight = 1600, 2000

playerPos = {x = 200, y = 20, w = 32, h = 32}
playerSpeed = {x = 0, y = 0}
camPos = {x = 0, y = 0}
vars = {accel = 1.5, frict = 1.2, fall = 1, fallMax = 20, ground = 0}
style = 0
minePos = {x = 0, y = 0, w = 10, h = 10}

lastX, lastY = playerPos.x, playerPos.y
blockEquip = 1

function int(funct)
    return math.ceil(funct)
end

local previousButtonStates = {}

function blockReturn(item)
    if item == "Block1" then
        return 1
    elseif item == "Block2" then
        return 2
    elseif item == "Block3" then
        return 3
    end
    return 0
end

function updateBlockData()
    for i=1, #tiles do
        local tile = tiles[i]
        if tile.dex < 20 then
            tile.dex += 0.2
        elseif tile.dex > 20.01 then
            tile.dex = 20
        end
    end
end

function buttonJustPressed(button)
    local isPressed = playdate.buttonIsPressed(button)
    local wasPressed = previousButtonStates[button] or false
    previousButtonStates[button] = isPressed
    return isPressed and not wasPressed
end

function collisionCheck(s)
    local collisions = {false, false, false}
    local tilesToCheck = {
        -blockSpacing, blockSpacing,
        0, blockSpacing,
        blockSpacing, blockSpacing,
        -blockSpacing, 0,
        0, 0,
        blockSpacing, 0,
        -blockSpacing, -blockSpacing,
        0, -blockSpacing,
        blockSpacing, -blockSpacing
    }
    for i = 1, #tilesToCheck, 2 do
        local tileX = playerPos.x + tilesToCheck[i] + (playerPos.w / 2)
        local tileY = playerPos.y + tilesToCheck[i + 1] + (playerPos.h / 2)
        local tile = tileCheck(tileX, tileY)
    
        if tile and tile.block > 0 then
            local box_left = playerPos.x
            local box_right = playerPos.x + playerPos.w
            local box_top = playerPos.y
            local box_bottom = playerPos.y + playerPos.h
    
            local collider_left = tile.x
            local collider_right = tile.x + blockSpacing
            local collider_top = tile.y
            local collider_bottom = tile.y + blockSpacing
    
            if box_bottom < collider_top or
               box_top > collider_bottom or
               box_right < collider_left or
               box_left > collider_right then
            else
                if not s then
                    if (box_bottom >= collider_top and 
                        box_top < collider_top and
                        box_right > collider_left and
                        box_left < collider_right) then
                        collisions[1] = true
                    end
                    if (box_top <= collider_bottom and
                        box_bottom > collider_bottom and
                        box_right > collider_left and
                        box_left < collider_right) then
                        collisions[2] = true
                    end
                elseif s then
                    if box_right >= collider_left and
                        box_left <= collider_right then
                        local midpoint = collider_left + (collider_right - collider_left) / 2
                        if box_right <= midpoint then
                            collisions[3] = true
                        elseif box_left >= midpoint then
                            collisions[3] = true
                        end
                    end
                end
            end
        end
    end
    return collisions
end

function tileCheck(x, y)
    local cellX = math.floor(x / blockSpacing)
    local cellY = math.floor(y / blockSpacing)
    local index = (cellY * amt.x + cellX)
    
    local tile = tiles[(index + 1)]
    if tile then
        return tile
    end
    
    return false
end