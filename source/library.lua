function int(funct)
    return math.ceil(funct)
end

local previousButtonStates = {}

function updateBlockData(blockSprites)
    for _, block in ipairs(blockSprites) do
        if block.dex < 20 then
            block.dex += 0.2
            print(_, block.dex)
        elseif block.dex > 20.01 then
            block.dex = 20
        end
    end
end

function buttonJustPressed(button)
    local isPressed = playdate.buttonIsPressed(button)
    local wasPressed = previousButtonStates[button] or false
    previousButtonStates[button] = isPressed
    return isPressed and not wasPressed
end