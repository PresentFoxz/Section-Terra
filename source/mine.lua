import "library.lua"
import "items.lua"

local mineLast = {x = 0, y = 0}
local validItems = {
    Hand = true,
    Pickaxe = true,
    Axe = true
}
local validBlocks = {
    Block1 = {true, 1},
    Block2 = {true, 2},
    Block3 = {true, 3},
    Block4 = {true, 4}
}
local invalidStuff = {
    Sword = false
}
local function raycast(p)
    local rayStep = 3
    local rayLength = 80
    local loopAmt = 0
    minePos.x, minePos.y = playerPos.x + (playerPos.w / 2), playerPos.y + (playerPos.h / 2)

    local crankAngle = playdate.getCrankPosition() - 90
    if crankAngle < 0 then
        crankAngle = crankAngle + 360
    end
    local radians = math.rad(crankAngle)
    local dx = math.cos(radians)
    local dy = math.sin(radians)
    
    while true do
        if p then
            mineLast.x = minePos.x
            mineLast.y = minePos.y
        end
        minePos.x += dx * rayStep
        minePos.y += dy * rayStep

        local touching = tileCheck(minePos.x, minePos.y)
        if touching and touching.block > 0 then
            if p then
                touching = tileCheck(mineLast.x, mineLast.y)
            end
            return touching
        end

        local distance = math.sqrt((minePos.x - (playerPos.x + (playerPos.w / 2)))^2 + (minePos.y - (playerPos.y + (playerPos.h / 2)))^2)
        if distance > rayLength or loopAmt > 26 then
            break
        end
        loopAmt += 1
    end

    return tileCheck(minePos.x, minePos.y)
end


function mine(item)
    local posChecks = {
        tileCheck(playerPos.x, playerPos.y + (playerPos.h / 2)),
        tileCheck(playerPos.x + playerPos.w, playerPos.y + (playerPos.h / 2)),
        tileCheck(playerPos.x + (playerPos.w / 2), playerPos.y),
        tileCheck(playerPos.x + (playerPos.w / 2), playerPos.y + playerPos.h),

        tileCheck(playerPos.x, playerPos.y),
        tileCheck(playerPos.x + playerPos.w, playerPos.y),
        tileCheck(playerPos.x + playerPos.w, playerPos.y + playerPos.h),
        tileCheck(playerPos.x, playerPos.y + playerPos.h)
    }

    if buttonJustPressed(playdate.kButtonB) and validBlocks[item] then
        closest = raycast(true)
    else
        closest = raycast(false)
    end

    if playdate.buttonIsPressed(playdate.kButtonB) then
        if not closest == false and not invalidStuff[item] then
            if closest.block > 0 and validItems[item] then
                if closest.dex > 0 then
                    closest.dex -= objects[item].dex
                elseif closest.dex <= 0 then
                    closest.block = 0
                end
            elseif closest.block == 0 and validBlocks[item] then
                for i=1, #posChecks do
                    if posChecks[i] == closest then
                        return
                    end
                end
                closest.block = validBlocks[item][2]
                closest.dex = 20
            end
        end
    end
end
