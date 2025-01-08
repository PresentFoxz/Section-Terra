import "library.lua"
import "items.lua"

local function raycast()
    local rayStep = 3
    local rayLength = 40
    local loopAmt = 0
    minePos.x, minePos.y = playerPos.x + (playerPos.w / 2), playerPos.y + (playerPos.h / 2)

    local crankAngle = playdate.getCrankPosition()
    local radians = math.rad(crankAngle)
    local dx = math.cos(radians)
    local dy = -math.sin(radians)
    
    while true do
        minePos.x += dx * rayStep
        minePos.y += dy * rayStep

        local touching = tileCheck(minePos.x, minePos.y)
        if touching and touching.block > 0 then
            print("touching")
            return touching
        end

        local distance = math.sqrt((minePos.x - (playerPos.x + (playerPos.w / 2))) + (minePos.y - (playerPos.y + (playerPos.h / 2))))
        if distance > rayLength or loopAmt > 13 then
            break
        end
        loopAmt += 1
    end

    return tileCheck(minePos.x, minePos.y)
end


function mine(item)
    closest = raycast()
        
    local validItems = {
        Hand = true,
        Pickaxe = true,
        Axe = true
    }
    local validBlocks = {
        Block1 = true,
        Block2 = true,
        Block3 = true,
        Block4 = true
    }
    local invalidStuff = {
        Sword = false
    }

    if playdate.buttonIsPressed(playdate.kButtonB) then
        if not closest == false and not invalidStuff[item] then
            if closest.block > 0 and validItems[item] then
                if closest.dex > 0 then
                    closest.dex -= objects[item].dex
                elseif closest.dex <= 0 then
                    closest.block = 0
                end
            elseif closest.block == 0 and validBlocks[item] then
                closest.block = blockReturn(item)
                closest.dex = 20
            end
        end
    end
end
