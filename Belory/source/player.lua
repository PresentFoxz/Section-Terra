import "library.lua"
import "hitAnim.lua"
import "stateMachine.lua"
import "collCheck.lua"

local wait = 0

local function clampSpeed(maxSpeed, p)
    CharactersUsed[p].ySpeed += CharactersUsed[p].fall
    if CharactersUsed[p].ySpeed > CharactersUsed[p].fallMax then
        CharactersUsed[p].ySpeed = CharactersUsed[p].fallMax
    end
    
    if CharactersUsed[p].xSpeed > maxSpeed then
        CharactersUsed[p].xSpeed = maxSpeed
    end
    if CharactersUsed[p].xSpeed < -maxSpeed then
        CharactersUsed[p].xSpeed = -maxSpeed
    end


    if CharactersUsed[p].xSpeed > -0.1 and CharactersUsed[p].xSpeed < 0.1 then
        CharactersUsed[p].xSpeed = 0
    end

    CharactersUsed[p].xSpeed /= CharactersUsed[p].frict
end

local function buttonPresses(p)
    if playdate.buttonIsPressed(playdate.kButtonDown) then
        PBS[p][2] = 1
    else
        PBS[p][2] = 0
    end
    if playdate.buttonIsPressed(playdate.kButtonRight) then
        PBS[p][3] = 1
    else
        PBS[p][3] = 0
    end
    if playdate.buttonIsPressed(playdate.kButtonLeft) then
        PBS[p][4] = 1
    else
        PBS[p][4] = 0
    end
    if playdate.buttonIsPressed(playdate.kButtonUp) then
        PBS[p][1] = 1
    else
        PBS[p][1] = 0
    end

    if playdate.buttonIsPressed(playdate.kButtonA) then
        PBS[p][5] = 1
    else
        PBS[p][5] = 0
    end
    if playdate.buttonIsPressed(playdate.kButtonB) then
        PBS[p][6] = 1
    else
        PBS[p][6] = 0
    end
end

local function playerMove(p, count, iD)
    if p <= count and CharactersUsed[p].lay == 0 and CharactersUsed[p].state <= stateNormReset and CharactersUsed[p].staggerTime == 0 and CharactersUsed[p].stun == 0 and CharactersUsed[p].ground == iD then
        return true
    else
        return false
    end
end

function movement(p, o, count)
    buttonPresses(p)
    if playerMove(p, count, 1) then
        print("Movement: ", p)
        CharactersUsed[p].state = 1
        CharactersUsed[p].launchCount = 2

        if PBS[p][4] == 1 then
            if CharactersUsed[p].dashing < 3 then
                CharactersUsed[p].x -= CharactersUsed[p].move
                CharactersUsed[p].airDir = -CharactersUsed[p].move
                CharactersUsed[p].state = 2
            end
        end

        if PBS[p][3] == 1 then
            if CharactersUsed[p].dashing < 3 then
                CharactersUsed[p].x += CharactersUsed[p].move
                CharactersUsed[p].airDir = CharactersUsed[p].move
                CharactersUsed[p].state = 2
            end
        end

        if PBS[p][1] == 1 and CharactersUsed[p].airTime < 3 and CharactersUsed[p].ground == 1 then
            CharactersUsed[p].ySpeed = -10
            CharactersUsed[p].airTime = 8
            if CharactersUsed[p].dashing >= 3 then
                CharactersUsed[p].airDir = CharactersUsed[p].xSpeed
            end
        end

        if PBS[p][2] == 1 then
            CharactersUsed[p].state = 5
        end

        if  (PBS[p][3] == 1 or PBS[p][4] == 1) and PBSTXT ~= lastPBSTXT then
            CharactersUsed[p].dashDir += 1
        end

        stateMachine(p, o)
        
        if CharactersUsed[p].dashDir >= 2 then
            CharactersUsed[p].dashDir = 3
        end
    elseif p > count then
        if (CharactersUsed[p].stun <= 0 and CharactersUsed[p].staggerTime <= 0 and CharactersUsed[p].state <= stateNormReset) then
            CharactersUsed[p].state = 1
            CharactersUsed[p].lay = 0
            CharactersUsed[p].hittable = 1
            CharactersUsed[p].launchCount = 2
            -- wait += 1
        end

        if wait > 20 and (CharactersUsed[p].stun <= 0 and CharactersUsed[p].staggerTime <= 0 and CharactersUsed[p].state <= stateNormReset) then
            local jumpDecide = math.random(1,10)
            if jumpDecide >= 8 and CharactersUsed[p].ground == 1 then
                CharactersUsed[p].ySpeed = -10
            end
            
            if CharactersUsed[p].ground == 1 and jumpDecide < 8 then
                CharactersUsed[p].state = math.random(6,9)
            end
            wait = 0
        end
    end

    if CharactersUsed[p].dashing > 0 then
        CharactersUsed[p].dashing -= 1
    end
    if CharactersUsed[p].stun > 0 and CharactersUsed[p].staggerTime == 0 then
        CharactersUsed[p].stun -= 0.5
    end
    if CharactersUsed[p].staggerTime > 0 then
        CharactersUsed[p].staggerTime -= 0.5
    end
    if CharactersUsed[p].stun == 0 and CharactersUsed[p].staggerTime == 0 then
        CharactersUsed[p].hittable = 1
        CharactersUsed[p].stagger = 2
    end
    if CharactersUsed[o].stun == 0 then
        CharactersUsed[p].combo = 0
    end
    if CharactersUsed[p].ground == 1 then
        if CharactersUsed[p].x < CharactersUsed[o].x then
            CharactersUsed[p].flip = 0
        else
            CharactersUsed[p].flip = 1
        end
    end

    CharactersUsed[p].x += CharactersUsed[p].xSpeed
    clampSpeed(CharactersUsed[p].maxSpeed, p)

    CharactersUsed[p].airTime += 1
    CharactersUsed[p].y += CharactersUsed[p].ySpeed

    falling(p, CharactersUsed[p].state)

    if playerMove(p, count, 0) then
        stateMachine(p, o)
    end
    handleCollisions(p, o)
    lastPBS[p] = deepCopy(PBS[p])
end