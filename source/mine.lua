import "library.lua"
import "items.lua"

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
    
    resistRand = -0.2 + (0.2 - -0.2) * math.random()
    local blockSprite = gfx.sprite.new(blockImage)
    blockSprite:setCollideRect(0, 0, blockSprite:getSize())
    blockSprite:moveTo(x - camPos.x, y - camPos.y)
    blockSprite:add()
    table.insert(blockSprites, {sprite = blockSprite, x = x, y = y, dex = 20, resist = resistRand, block = rand})
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

local function distBetween(mineSprite, playerPos, minePos)
    local mineMidX, mineMidY = minePos.x + (mineSprite.width / 2), minePos.y + (mineSprite.height / 2)

    local dx = playerPos.x - mineMidX
    local dy = playerPos.y - mineMidY
    local distance = math.sqrt(dx * dx + dy * dy)

    local maxDistance = 40

    if distance > maxDistance then
        if (playerPos.x - mineMidX) > maxDistance then
            minePos.x = playerPos.x - maxDistance - 5
        elseif (playerPos.x - mineMidX) < -maxDistance then
            minePos.x = playerPos.x + maxDistance - 5
        end

        if (playerPos.y - mineMidY) > maxDistance then
            minePos.y = playerPos.y - maxDistance - 5
        elseif (playerPos.y - mineMidY) < -maxDistance then
            minePos.y = playerPos.y + maxDistance - 5
        end
    end
    print((playerPos.x - mineMidX), (playerPos.y - mineMidY))
end



function mine(style, playerPos, mineSprite, blockSprites, camPos, blockType, blockImage, amt, gfx, item)
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

        distBetween(mineSprite, playerPos, minePos)
        closest = findClosest(mineSprite, blockSprites, camPos)

        if playdate.buttonIsPressed(playdate.kButtonA) then
            if closest and (blockType == "Hand" or blockType == "Pickaxe" or blockType == "Axe") then

                if closest.dex > 0 then
                    closest.dex -= objects[blockType].dex
                else
                    print("Closest block found at world coordinates:", closest.x, closest.y)
                    closest.sprite:remove()
                    for i, b in ipairs(blockSprites) do
                        if b == closest then
                            table.remove(blockSprites, i)
                            break
                        end
                    end
                end
            elseif blockType == "Block" and buttonJustPressed(playdate.kButtonA) then
                fixUp(mineSprite, blockSprites, camPos, blockImage, amt, gfx)
            end
        end
    end
end
