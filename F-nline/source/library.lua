import "CoreLibs/graphics"
import "charData.lua"
local gfx <const> = playdate.graphics
snd = playdate.sound

screenWidth, screenHeight = 400, 240

camPos = {x = 0, y = 0}
crankAngle = 0
PBS = {{0,0,0,0,0,0}, {0,0,0,0,0,0}}
lastPBS = {{0,0,0,0,0,0}, {0,0,0,0,0,0}}
dashCount = {0,0}
stateNormReset = 5
dashFrames = {0,0}

local audio = {
    "music/_.pda",
    "music/_1.pda",
    "music/_2.pda",
}

function int(funct)
    return math.ceil(funct)
end

local previousButtonStates = {}
function buttonJustPressed(button)
    local isPressed = playdate.buttonIsPressed(button)
    local wasPressed = previousButtonStates[button] or false
    previousButtonStates[button] = isPressed
    return isPressed and not wasPressed
end

function collisionCheck(p, o)
    local state1 = CharactersUsed[p].state
    local state2 = CharactersUsed[o].state
    local hurtbox = hurtBoxes[CharactersUsed[p].Char][state1]
    local hitbox = hitboxes[CharactersUsed[o].Char][state2 - stateNormReset][CharactersUsed[o].hitbox]
    local px = hurtbox[1] + CharactersUsed[p].x
    local py = hurtbox[2] + CharactersUsed[p].y
    local pw = hurtbox[3]
    local ph = hurtbox[4]

    local bx = hitbox[1] + CharactersUsed[o].x
    local by = hitbox[2] + CharactersUsed[o].y
    local bw = hitbox[3]
    local bh = hitbox[4]

    if CharactersUsed[o].flip == 1 then
        bx -= (hurtBoxes[CharactersUsed[o].Char][state2][3] - hitbox[9])
    end

    local box_left = px
    local box_right = px + pw
    local box_top = py
    local box_bottom = py + ph

    local collider_left = bx
    local collider_right = bx + bw
    local collider_top = by
    local collider_bottom = by + bh

    print("Hurtbox: ", box_top, box_bottom, box_left, box_right)
    print("Hitbox: ", collider_top, collider_bottom, collider_left, collider_right)
    
    if not (box_right < collider_left or
            box_left > collider_right or
            box_bottom < collider_top or
            box_top > collider_bottom) then
        return true
    end
    return false
end

function deepCopy(original)
    local copy = {}
    for key, value in pairs(original) do
        if type(value) == "table" then
            copy[key] = deepCopy(value)
        else
            copy[key] = value
        end
    end
    return copy
end

function initialize(c1, c2, reset)
    CharactersUsed[1].x = 100
    CharactersUsed[1].y = 150
    CharactersUsed[2].x = 200
    CharactersUsed[2].y = 150

    print(CharactersUsed[1].x, CharactersUsed[1].y, CharactersUsed[2].x, CharactersUsed[2].y)
end