import "library.lua"

minePos = {x = 0, y = 0}

local function posExist(blockSprites, x, y)
    for _, block in ipairs(blockSprites) do
        if block.x == x and block.y == y then
            return true
        end
    end
    return false
end

local function addBlock(x, y, blockSprites, camPos, blockImage, gfx)
    if not blockImage then
        print("Error: blockImage is nil!")
        return
    end
    
    local blockSprite = gfx.sprite.new(blockImage)
    blockSprite:setCollideRect(0, 0, blockSprite:getSize())
    blockSprite:moveTo(x - camPos.x, y - camPos.y)
    blockSprite:add()
    table.insert(blockSprites, {sprite = blockSprite, x = x, y = y})
    print("Added block at:", x, y)
end

local function fixUp(mineSprite, blockSprites, camPos, blockImage, amt, gfx)
    if not blockImage then
        print("Error: blockImage is nil!")
        return
    end

    local drawX, drawY = 14, 0
    for y = 0, (amt.y - 1) do
        for x = 0, (amt.x - 1) do
            local mx, my, mw, mh = mineSprite:getBounds()
            local mineMidX, mineMidY = mx + (mw / 2), my + (mh / 2)
            local dx = (drawX - camPos.x) - mineMidX
            local dy = (drawY - camPos.y) - mineMidY
            local distance = math.sqrt(dx * dx + dy * dy)

            if distance < 20 and not posExist(blockSprites, drawX, drawY) then
                addBlock(drawX, drawY, blockSprites, camPos, blockImage, gfx)
                return
            end
            
            drawX += 40
        end
        drawX = 14
        drawY += 40
    end

    print("No valid position to place block.")
end

local function findClosest(mineSprite, blockSprites, camPos)
    local mx, my, mw, mh = mineSprite:getBounds()
    local mineMidX, mineMidY = mx + (mw / 2), my + (mh / 2)

    local closestBlock = nil
    local closestDistance = 20

    for _, block in ipairs(blockSprites) do
        local bx, by = block.x - camPos.x, block.y - camPos.y
        
        local dx = bx - mineMidX
        local dy = by - mineMidY
        local distance = math.sqrt(dx * dx + dy * dy)

        if distance < closestDistance then
            closestDistance = distance
            closestBlock = block
        end
    end

    return closestBlock
end

local function distBetween(mineSprite, playerSprite, camPos)
    local px, py, pw, ph = playerSprite:getBounds()
    local mx, my, mw, mh = mineSprite:getBounds()
    local mineMidX, mineMidY = mx + (mw / 2), my + (mh / 2)
    local dx = (px - camPos.x) - mineMidX
    local dy = (py - camPos.y) - mineMidY
    local distance = math.sqrt(dx * dx + dy * dy)

    local maxDistance = 40

    if distance > maxDistance then
        local scale = maxDistance / distance
        local clampedX = (px - camPos.x) - dx * scale
        local clampedY = (py - camPos.y) - dy * scale

        mineSprite:moveTo(clampedX, clampedY)
    end
end


function mine(style, playerPos, mineSprite, blockSprites, camPos, blockType, blockImage, amt, gfx)
    if style == 0 then
        minePos.x, minePos.y = playerPos.x, playerPos.y
        mineSprite:moveTo(minePos.x, minePos.y)
        mineSprite:setVisible(false)
    elseif style == 1 then
        mineSprite:setVisible(true)

        -- print("MineLocation: ", mineSprite.x, mineSprite.y)
        if playdate.buttonIsPressed(playdate.kButtonRight) then
            minePos.x += 2
        end
        if playdate.buttonIsPressed(playdate.kButtonLeft) then
            minePos.x -= 2
        end
        if playdate.buttonIsPressed(playdate.kButtonUp) then
            minePos.y -= 2
        end
        if playdate.buttonIsPressed(playdate.kButtonDown) then
            minePos.y += 2
        end

        mineSprite:moveTo(minePos.x - camPos.x, minePos.y - camPos.y)

        distBetween(mineSprite, playerSprite, minePos, playerPos, camPos)
        closest = findClosest(mineSprite, blockSprites, camPos)

        if buttonJustPressed(playdate.kButtonA) then
            if closest and blockType == "Hand" then
                print("Closest block found at world coordinates:", closest.x, closest.y)
                closest.sprite:remove()
                for i, b in ipairs(blockSprites) do
                    if b == closest then
                        table.remove(blockSprites, i)
                        break
                    end
                end
            elseif blockType == "Block" then
                fixUp(mineSprite, blockSprites, camPos, blockImage, amt, gfx)
            end
        end
    end
end
