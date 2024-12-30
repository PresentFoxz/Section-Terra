blockSpacing = 40
tiles = {}
amt = {x = 11, y = 3}
screenWidth, screenHeight = 400, 240
worldWidth, worldHeight = 440, 120

playerPos = {x = 200, y = -80, w = 32, h = 32}
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

function collisionCheck()
    for i=1, #tiles do
        local tile = tiles[i]
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
                if box_bottom >= collider_top and
                    box_top < collider_top and
                    box_right > collider_left and
                    box_left < collider_right then
                    print("Collision detected: Feet")
                    return 1
                end
                if box_top <= collider_bottom and
                    box_bottom > collider_bottom and
                    box_right > collider_left and
                    box_left < collider_right then
                    print("Collision detected: Head")
                    return 2
                end
                if box_right >= collider_left and
                    box_left <= collider_right then
                    local midpoint = collider_left + (collider_right - collider_left) / 2
                    if box_right <= midpoint then
                        print("Collision detected: Left Side")
                        return 3
                    elseif box_left >= midpoint then
                        print("Collision detected: Right Side")
                        return 3
                    end
                end
            end
        end
    end

    return 0
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