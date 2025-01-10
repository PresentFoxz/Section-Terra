import "library.lua"

local currentFrame = 1
local animationSpeed = 2
local frameRate = 0
local lastAnim = 0
local animationStart = 0
local animationFinish = 0

function checkAnimation(name)
    local anim = animations[name]
    if name == lastAnim then
        animationStart = anim.start
        animationFinish = anim.finish
        if currentFrame < animationStart or currentFrame > animationFinish then
            currentFrame = animationStart
        end
    end
    lastAnim = name
end

function animPlaying()
    frameRate += 0.2
    if frameRate >= animationSpeed then
        currentFrame += 1
        if currentFrame > animationFinish then
            currentFrame = animationStart
        end
        frameRate = 0
    end

    return currentFrame
end