import "library.lua"
import "items.lua"

local function distBetween()
    local mineMidX, mineMidY = minePos.x + (minePos.w / 2), minePos.y + (minePos.h / 2)
    local px, py = (playerPos.x + (playerPos.w / 2)), (playerPos.y + (playerPos.h / 2))
    local dx = px - mineMidX
    local dy = py - mineMidY
    local distance = math.sqrt(dx * dx + dy * dy)

    local maxDistance = 40

    if distance > maxDistance then
        if (px - mineMidX) > maxDistance then
            minePos.x = px - maxDistance - 5
        elseif (px - mineMidX) < -maxDistance then
            minePos.x = px + maxDistance - 5
        end

        if (py - mineMidY) > maxDistance then
            minePos.y = py - maxDistance - 5
        elseif (py - mineMidY) < -maxDistance then
            minePos.y = py + maxDistance - 5
        end
    end
end

function mine(item)
    if style == 0 then
        minePos.x, minePos.y = playerPos.x + (playerPos.w / 2), playerPos.y + (playerPos.h / 2)
    elseif style == 1 then
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

        distBetween()
        closest = tileCheck(minePos.x, minePos.y)
        
        local validItems = {
            Hand = true,
            Pickaxe = true,
            Axe = true
        }
        local validBlocks = {
            Block1 = true,
            Block2 = true,
            Block3 = true
        }

        if playdate.buttonIsPressed(playdate.kButtonA) then
            if not closest == false then
                print("Closest Block:", closest and closest.block)
                print(validBlocks[item])
                print(buttonJustPressed(playdate.kButtonA))
                if closest.block > 0 and validItems[item] then
                    if closest.dex > 0 then
                        closest.dex -= objects[item].dex
                    elseif closest.dex <= 0 then
                        closest.block = 0
                    end
                elseif closest.block == 0 and validBlocks[item] then
                    closest.block = blockReturn(item)
                    closest.dex = 20
                    print("Change Block: ", closest.block, closest.dex)
                end
            end
        end
    end
end
