import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "player.lua"
import "library.lua"
import "mine.lua"
import "worldDraw.lua"
import "worldGen.lua"
spriteSystem = import("spriteInit.lua")

local gfx <const> = playdate.graphics

local function initialize()
    playerPos.x = math.random(10, worldWidth - 10)
    local image = createNoiseImage()
    generateWorld(image)
end

local function updateCamera()
    camPos.x = math.max(0, math.min(worldWidth - screenWidth, playerPos.x - screenWidth / 2))
    camPos.y = math.max(0, math.min(worldHeight - screenHeight, playerPos.y - screenHeight / 2))
end

local previousButtonStates = {}

function buttonJustPressed(button)
    local isPressed = playdate.buttonIsPressed(button)
    local wasPressed = previousButtonStates[button] or false
    previousButtonStates[button] = isPressed
    return isPressed and not wasPressed
end

function playdate.update()
    gfx.clear()

    if buttonJustPressed(playdate.kButtonDown) then
        blockEquip = math.min(#items, blockEquip + 1)
    end
    if buttonJustPressed(playdate.kButtonUp) then
        blockEquip = math.max(1, blockEquip - 1)
    end

    movement()
    mine(items[blockEquip])
    updateCamera()
    updateBlockData()
    playdate.timer.updateTimers()
    drawWorld()
    checkAnimation(currentAnimation)
    frame = animPlaying()
    drawPlayer_Mine(frame)

    local xString = "X:" .. tostring(math.floor((playerPos.x + (playerPos.w / 2)) / blockSpacing))
    local yString = "Y:" .. tostring(math.floor((playerPos.y + (playerPos.h / 2)) / blockSpacing))

    gfx.setColor(gfx.kColorWhite)
    local xTextWidth = gfx.getTextSize(xString)
    local yTextWidth = gfx.getTextSize(yString)

    gfx.drawTextAligned(items[blockEquip], 30, 5, kTextAlignment.center)
    gfx.drawText(xString, 390 - xTextWidth, 5)
    gfx.drawText(yString, 390 - yTextWidth, 20)
    playdate.drawFPS(200, 5)

end

initialize()