import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "player.lua"
import "library.lua"
import "mine.lua"
import "worldDraw.lua"

local gfx <const> = playdate.graphics
local mineImage = gfx.image.new("images/mine")
local playerImage = gfx.image.new("images/player")

local function createBlockSprite(x, y)
    rand = math.random(0,3)
    resistRand = -0.2 + (0.2 - -0.2) * math.random()
    table.insert(tiles, {block = rand, x = x, y = y, dex = 20, resist = resistRand})
end

local function makeWorld()
    local drawX, drawY = 0, 0

    local stepsRemaining = amt.x * amt.y
    while stepsRemaining > 0 do
        createBlockSprite(drawX, drawY)
        drawX += blockSpacing
        if drawX >= worldWidth then
            drawX = 0
            drawY += blockSpacing
        end
        stepsRemaining -= 1
    end
end

local function initialize()
    makeWorld()
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

local rectX, rectY  = 30, 5

function playdate.update()
    gfx.clear()
    if buttonJustPressed(playdate.kButtonB) then
        style = (style + 1) % 2
    end

    if style == 0 then
        if buttonJustPressed(playdate.kButtonDown) then
            blockEquip = math.min(#items, blockEquip + 1)
        end
        if buttonJustPressed(playdate.kButtonUp) then
            blockEquip = math.max(1, blockEquip - 1)
        end
    end

    movement()
    mine(items[blockEquip])
    updateCamera()
    updateBlockData()
    playdate.timer.updateTimers()
    drawWorld()
    drawPlayer_Mine(playerImage, mineImage)

    gfx.setColor(gfx.kColorWhite)
    gfx.drawTextAligned(items[blockEquip], rectX, rectY, kTextAlignment.center)
    playdate.drawFPS(200,5)
end

initialize()