import "library.lua"

local airtime = 0

function handleCollisions(slot)
    local collisions = collisionCheck(slot)
    
    if not slot then
        -- Handle Feet Collision
        if collisions[1] then
            playerSpeed.y = -0.1
            playerPos.y = lastY
            vars.ground = 1
            airtime = 0
        else
            vars.ground = 0
        end
        -- Handle Head Collision
        if collisions[2] then
            playerSpeed.y = 1
            playerPos.y = lastY
        end
    elseif slot then
        -- Handle Wall Collision
        if collisions[3] then
            playerSpeed.x = -playerSpeed.x / 2
            playerPos.x = lastX
        end
    end
end

local debug = 0
function movement()
    vars.ground = 0
    lastX, lastY = playerPos.x, playerPos.y
    if debug == 0 then
        if playdate.buttonIsPressed(playdate.kButtonRight) then
            playerSpeed.x += vars.accel
        end
        if playdate.buttonIsPressed(playdate.kButtonLeft) then
            playerSpeed.x -= vars.accel
        end

        playerPos.x += playerSpeed.x
        handleCollisions(true)
        clampSpeed(8, debug)

        airtime += 1
        playerPos.y += playerSpeed.y
        handleCollisions(false)

        if airtime < 8 and buttonJustPressed(playdate.kButtonA) then
            playerSpeed.y = -10
            airtime = 8
        end

        if vars.ground == 0 then
            playerSpeed.y += vars.fall
        end
    elseif debug == 1 then
        if playdate.buttonIsPressed(playdate.kButtonRight) then
            playerSpeed.x += vars.accel
        end
        if playdate.buttonIsPressed(playdate.kButtonLeft) then
            playerSpeed.x -= vars.accel
        end
        if playdate.buttonIsPressed(playdate.kButtonUp) then
            playerSpeed.y -= vars.accel
        end
        if playdate.buttonIsPressed(playdate.kButtonDown) then
            playerSpeed.y += vars.accel
        end
        playerPos.x += playerSpeed.x
        playerPos.y += playerSpeed.y
        clampSpeed(8, debug)
    end
end

function clampSpeed(maxSpeed, d)
    if d == 0 then
        if playerSpeed.y > vars.fallMax then
            playerSpeed.y = vars.fallMax
        end
    elseif d == 1 then
        if playerSpeed.y > maxSpeed then
            playerSpeed.y = maxSpeed
        end
        if playerSpeed.y < -maxSpeed then
            playerSpeed.y = -maxSpeed
        end    
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
    if d == 1 then playerSpeed.y /= vars.frict end
    x,y = playerPos.w, playerPos.h
    if playerPos.x > (worldWidth - (x / 2) - 16) then
        playerPos.x = (worldWidth - (x / 2) - 16)
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