import "library.lua"

local airtime = 0

local function movePlrRq(pos, spd, mult, cam, ps)
    if playdate.buttonIsPressed(playdate.kButtonRight) then
        pos.x -= spd * mult
    end
    if playdate.buttonIsPressed(playdate.kButtonLeft) then
        pos.x += spd * mult
    end
    ps:moveTo(pos.x - cam.x, pos.y - cam.y)
end

function handleCollisions(playerPos, playerSpeed, lastX, lastY, playerSprite, ground, slot, camPos, style)
    -- colliding with the floor
    if slot == 0 then
        movePlrRq(playerPos, 2, 1, camPos, playerSprite)
        local collisions = playerSprite:overlappingSprites()
        if #collisions > 0 then
            if playerPos.y ~= lastY then
                playerSpeed.y = -1
                playerPos.y -= 1
                ground = 1
                playerPos.y = lastY
                airtime = 0
            else
                ground = 0
            end
            playerSprite:moveTo(playerPos.x - camPos.x, playerPos.y - camPos.y)
        end

        if style == 0 and airtime < 8 and buttonJustPressed(playdate.kButtonA) then
            playerSpeed.y = -10
            ground = 0
        end
        movePlrRq(playerPos, 2, -1, camPos, playerSprite)
    end
    -- colliding with the sides
    if slot == 1 then
        local collisions = playerSprite:overlappingSprites()
        if #collisions > 0 then
            if playerPos.x ~= lastX then
                playerSpeed.x = -playerSpeed.x / 2
                playerPos.x = lastX
            end
            playerSprite:moveTo(playerPos.x - camPos.x, playerPos.y - camPos.y)
        end
    end
    -- colliding with roof
    if slot == 2 then
        movePlrRq(playerPos, 2, 1, camPos, playerSprite)
        local collisions = playerSprite:overlappingSprites()
        if #collisions > 0 then
            if playerPos.y ~= lastY then
                playerSpeed.y = 1
                playerPos.y += 1
                ground = 0
                playerPos.y = lastY
            end
        end
        movePlrRq(playerPos, 2, -1, camPos, playerSprite)
    end
end

function movement(lastX, lastY, playerSpeed, playerPos, playerSprite, vars, camPos, edgeX, edgeY, style)
    lastX, lastY = playerPos.x, playerPos.y
    if style == 0 then
        if playdate.buttonIsPressed(playdate.kButtonRight) then
            playerSpeed.x += vars.accel
        end
        if playdate.buttonIsPressed(playdate.kButtonLeft) then
            playerSpeed.x -= vars.accel
        end
    end

    playerPos.x += playerSpeed.x
    playerPos.y += playerSpeed.y

    clampSpeed(playerSpeed, 8, vars.frict, vars.fallMax, edgeX, edgeY, playerSprite, playerPos)

    playerSprite:moveTo(playerPos.x - camPos.x, playerPos.y - camPos.y)

    if playerSpeed.y <= 0 then
        handleCollisions(playerPos, playerSpeed, lastX, lastY, playerSprite, vars.ground, 2, camPos, style)
    elseif playerSpeed.y > 0 then
        handleCollisions(playerPos, playerSpeed, lastX, lastY, playerSprite, vars.ground, 0, camPos, style)
    end
    handleCollisions(playerPos, playerSpeed, lastX, lastY, playerSprite, vars.ground, 1, camPos, style)

    airtime += 1

    if vars.ground == 0 then
        playerSpeed.y += vars.fall
    end
end

function clampSpeed(playerSpeed, maxSpeed, frict, fallMax, edgeX, edgeY, playerSprite, playerPos)
    if playerSpeed.y > fallMax then
        playerSpeed.y = fallMax
    end
    if playerSpeed.x > maxSpeed then
        playerSpeed.x = maxSpeed
    end
    if playerSpeed.x < -maxSpeed then
        playerSpeed.x = -maxSpeed
    end

    if playerSpeed.x > -0.1 and playerSpeed.x < 0.1 then
        playerSpeed.x = 0
    end
    
    if playerSpeed.y > -0.1 and playerSpeed.y < 0.1 then
        playerSpeed.y = 0
    end

    playerSpeed.x /= frict
    x,y = playerSprite:getSize()
    if playerPos.x > (edgeX - (x / 2)) then
        playerPos.x = (edgeX - (x / 2))
        playerSpeed.x = 0
    end
    if playerPos.x < 0 then
        playerPos.x = 0
        playerSpeed.x = 0
    end

    if playerPos.y > (edgeY - y) then
        playerPos.y = edgeY - y
        playerSpeed.y = 0
    end
end