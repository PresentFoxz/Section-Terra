import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "player.lua"
import "library.lua"
import "hitAnim.lua"
spriteSystem = import("spriteInit.lua")

local gfx <const> = playdate.graphics
local p1, p2, pHit, side = 1, 1, 1, 1
local gameState = 0
local countDown, trueCount = 3, 14

local menu = playdate.getSystemMenu()

reset, error = menu:addMenuItem("Reset Training", function()
    initialize(charNames[p1][2], charNames[p2][2], false)
    print("Positions Reset")
end)

reset1, error1 = menu:addMenuItem("Menu Button", function()
    gameState = 0
    countDown = 3
    trueCount = 14
    print("Menu")
end)

audioToggle, audioError = menu:addMenuItem("Music Toggle", function()
    toggleAudio()
end)

function playdate.update()
    gfx.clear()
    
    if gameState == 0 then
        gfx.drawText("Menu", 170, 120)
        gfx.drawText("Press A", 162, 145)
        if playdate.buttonIsPressed(playdate.kButtonA) then
            PBS[1][5] = 1
            gameState = 1
        end
    elseif gameState == 1 then
        if playdate.buttonIsPressed(playdate.kButtonUp) then
            if PBS[1][1] == 0 then
                pHit -= 1
            end
            PBS[1][1] = 1
        else
            PBS[1][1] = 0
        end
        if playdate.buttonIsPressed(playdate.kButtonDown) then
            if PBS[1][2] == 0 then
                pHit += 1
            end
            PBS[1][2] = 1
        else
            PBS[1][2] = 0
        end

        if playdate.buttonIsPressed(playdate.kButtonLeft) then
            if PBS[1][4] == 0 then
                side = 1
                pHit = p1
            end
            PBS[1][4] = 1
        else
            PBS[1][4] = 0
        end
        if playdate.buttonIsPressed(playdate.kButtonRight) then
            if PBS[1][3] == 0 then
                side = 2
                pHit = p2
            end
            PBS[1][3] = 1
        else
            PBS[1][3] = 0
        end

        if pHit > 3 then
            pHit = 3
        elseif pHit < 1 then
            pHit = 1
        end

        if side == 1 then
            p1 = pHit
            gfx.drawLine(110, 110, 115, 115)
            gfx.drawLine(115, 115, 120, 100)
        elseif side == 2 then
            p2 = pHit
            gfx.drawLine(280, 110, 285, 115)
            gfx.drawLine(285, 115, 290, 100)
        end

        gfx.drawText("Character Select", 150, 50)
        gfx.drawText(charNames[p1][1], 100, 120)
        gfx.drawText(charNames[p2][1], 270, 120)
        
        if playdate.buttonIsPressed(playdate.kButtonA) then
            if PBS[1][5] == 0 then
                initialize(charNames[p1][2], charNames[p2][2], true)
                gameState = 2
            end
            PBS[1][5] = 1
        else
            PBS[1][5] = 0
        end
    elseif gameState == 2 then
        for i=1, 2 do
            if countDown <= -1 then
                if i == 1 then
                    movement(i, 2, playerCount)
                elseif i == 2 then
                    movement(i, 1, playerCount)
                end
                print("Player: " .. i .. " x| " .. CharactersUsed[i].x .. " y| " .. CharactersUsed[i].y)
            end
            checkAnimation(i, CharactersUsed[i].state)
            frame = animPlaying(i, CharactersUsed[i].state)
            drawSprites(frame, CharactersUsed[i].Char, i)
            --renderBox(i, CharactersUsed[i].state)

            gfx.drawText("State: " .. CharactersUsed[i].state, CharactersUsed[i].x, CharactersUsed[i].y - 15)
            local debug = 0
            if debug == 1 then
                gfx.drawText("State: " .. CharactersUsed[i].state, CharactersUsed[i].x, CharactersUsed[i].y - 15)
                gfx.drawText("Grounded: " .. CharactersUsed[i].ground, CharactersUsed[i].x, CharactersUsed[i].y - 30)
                gfx.drawText("Stun: " .. CharactersUsed[i].stun, CharactersUsed[i].x, CharactersUsed[i].y - 45)
                gfx.drawText("Char: " .. CharactersUsed[i].Char, CharactersUsed[i].x, CharactersUsed[i].y - 60)
                gfx.drawText("Air: " .. CharactersUsed[i].airTime, CharactersUsed[i].x, CharactersUsed[i].y - 75)
                gfx.drawText("Timer: " .. CharactersUsed[i].currentFrame, CharactersUsed[i].x, CharactersUsed[i].y - 90)
                gfx.drawText("Frame: " .. CharactersUsed[i].frameRate, CharactersUsed[i].x, CharactersUsed[i].y - 105)
                gfx.drawText("Test: " .. ((CharactersUsed[i].currentFrame - animations[CharactersUsed[i].Char][CharactersUsed[i].state].start) + 1), CharactersUsed[i].x, CharactersUsed[i].y - 120)
                gfx.drawText("Test: " .. CharactersUsed[i].hittable, CharactersUsed[i].x, CharactersUsed[i].y - 135)
                gfx.drawText("Stagger: " .. CharactersUsed[i].stagger, CharactersUsed[i].x, CharactersUsed[i].y - 150)
                gfx.drawText("STime: " .. CharactersUsed[i].staggerTime, CharactersUsed[i].x, CharactersUsed[i].y - 165)
                gfx.drawText("DashInit: " .. CharactersUsed[i].dashDir, CharactersUsed[i].x, CharactersUsed[i].y - 180)
                gfx.drawText("DashTime1: " .. dashFrames[1], 10, 80)
                gfx.drawText("DashTime2: " .. dashFrames[2], 10, 100)
            end

            if countDown >= 0 then
                if countDown > 0 then
                    gfx.drawText(countDown, 200, 120)
                else
                    gfx.drawText("GO!", 200, 120)
                end
                trueCount -= 1
                if trueCount <= 0 then
                    countDown -= 1
                    trueCount = 14
                end
            end

            if CharactersUsed[i].dashDir > 0 then
                dashFrames[i] += 1

                if dashFrames[i] > 10 then
                    CharactersUsed[i].dashDir = 0
                end
            else
                dashFrames[i] = 0
            end
        end

        gfx.drawText("P1: " .. CharactersUsed[1].combo, 10, 40)
        gfx.drawText("P2: " .. CharactersUsed[2].combo, 10, 60)
        playdate.drawFPS(200, 5)
    end
end