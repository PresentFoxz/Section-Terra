import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "player.lua"
import "library.lua"
import "mine.lua"

local gfx <const> = playdate.graphics
local playerSprite = nil
local blockSprites = {}
local screenWidth, screenHeight = 400, 240
local blockSpacing = 40
local amt = {x = 12, y = 12}
local worldWidth, worldHeight = blockSpacing * amt.x, blockSpacing * amt.y

local playerPos = {x = 200, y = -80}
local playerSpeed = {x = 0, y = 0}
local camPos = {x = 0, y = 0}
local vars = {accel = 1.5, frict = 1.2, fall = 1, fallMax = 20, ground = 0}
local blockImage = gfx.image.new("images/block")
local mineImage = gfx.image.new("images/mine")
local style = 0

local lastX, lastY = playerPos.x, playerPos.y
local blockType = {"Hand", "Block"}
local blockEquip = 1

local function createBlockSprite(x, y)
    rand = math.random(0,1)

    if rand == 1 then
        local blockSprite = gfx.sprite.new(blockImage)
        blockSprite:setCollideRect(0, 0, blockSprite:getSize())
        blockSprite:moveTo(x - camPos.x, y - camPos.y)
        blockSprite:add()
        table.insert(blockSprites, {sprite = blockSprite, x = x, y = y})
    end
end

local function drawWorld()
    local drawX, drawY = 14, 0

    for y = 0, (amt.y - 1) do
        for x = 0, (amt.x - 1) do
            createBlockSprite(drawX, drawY)
            drawX += blockSpacing
        end
        drawX = 14
        drawY += blockSpacing
    end
end

local function initialize()
    local playerImage = gfx.image.new("images/player")
    playerSprite = gfx.sprite.new(playerImage)
    playerSprite:setCollideRect(0, 0, playerSprite:getSize())
    playerSprite:add()

    mineSprite = gfx.sprite.new(mineImage)
    mineSprite:setVisible(false)
    mineSprite:add()

    drawWorld()

    local backgroundImage = gfx.image.new("images/background")
    gfx.sprite.setBackgroundDrawingCallback(
        function(x, y, width, height)
            gfx.setClipRect(x, y, width, height)
            backgroundImage:draw(0, 0)
            gfx.clearClipRect()
        end
    )
end

local function updateCamera()
    camPos.x = math.max(-12, math.min(worldWidth - screenWidth, playerPos.x - screenWidth / 2))
    camPos.y = math.max(-100, math.min(worldHeight - screenHeight, playerPos.y - screenHeight / 2))

    playerSprite:moveTo(playerPos.x - camPos.x, playerPos.y - camPos.y)
    for _, block in ipairs(blockSprites) do
        block.sprite:moveTo(block.x - camPos.x, block.y - camPos.y)
    end
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
    if buttonJustPressed(playdate.kButtonB) then
        style = (style + 1) % 2
    end
    --print("Style: ", style)

    if style == 0 then
        if buttonJustPressed(playdate.kButtonDown) then
            blockEquip = math.min(#blockType, blockEquip + 1)
        end
        if buttonJustPressed(playdate.kButtonUp) then
            blockEquip = math.max(1, blockEquip - 1)
        end
    end

    movement(lastX, lastY, playerSpeed, playerPos, playerSprite, vars, camPos, worldWidth, worldHeight, style)
    mine(style, playerPos, mineSprite, blockSprites, camPos, blockType[blockEquip], blockImage, amt, gfx)
    --print("vars: ", vars.ground)
    --print("PlayerPos: ", playerSprite.position)
    --print("PlayerSpeed: ", playerSpeed.x, playerSpeed.y)
    updateCamera()
    playdate.timer.updateTimers()
    gfx.sprite.update()

    gfx.setColor(gfx.kColorWhite)
    gfx.drawTextAligned(blockType[blockEquip], rectX, rectY, kTextAlignment.center)
end

initialize()