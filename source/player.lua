import "library.lua"

local airtime = 0

function handleCollisions()
    -- Wall Collision
    playerPos.y -= 2
    slot = collisionCheck(3)
    if slot then
        if playerPos.x ~= lastX then
            playerSpeed.x = -playerSpeed.x / 2
            playerPos.x = lastX
        end
    end
    playerPos.y += 2

    -- Feet Collision
    slot = collisionCheck(1)
    if slot then
        if playerPos.y ~= lastY then
            playerSpeed.y = -0.1
            playerPos.y -= 1
            playerPos.y = lastY
            vars.ground = 1
            airtime = 0
        end
    else
        vars.ground = 0
    end

    -- Head Collision
    slot = collisionCheck(2)
    if slot then
        if playerPos.y ~= lastY then
            playerSpeed.y = 1
            playerPos.y += 1
            vars.ground = 0
            playerPos.y = lastY
        end
    end
end

function movement()
    vars.ground = 0
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

    clampSpeed(8)

    airtime += 1
    
    handleCollisions()

    if style == 0 and airtime < 8 and buttonJustPressed(playdate.kButtonA) then
        playerSpeed.y = -10
        airtime = 8
    end

    if vars.ground == 0 then
        playerSpeed.y += vars.fall
    end
    print(playerSpeed.y)
end

function clampSpeed(maxSpeed)
    if playerSpeed.y > vars.fallMax then
        playerSpeed.y = vars.fallMax
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

    playerSpeed.x /= vars.frict
    x,y = playerPos.w, playerPos.h
    if playerPos.x > (worldWidth - (x / 2)) then
        playerPos.x = (worldWidth - (x / 2))
        playerSpeed.x = 0
    end
    if playerPos.x < 0 then
        playerPos.x = 0
        playerSpeed.x = 0
    end

    if playerPos.y > worldHeight - 32 then
        playerPos.y = worldHeight - 32
        playerSpeed.y = 0
    end
end