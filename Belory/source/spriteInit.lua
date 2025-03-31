import "library.lua"
import "hitAnim.lua"
import "CoreLibs/graphics"

local animationSpeed = 2

function checkAnimation(p, iD)
    local anim = animations[CharactersUsed[p].Char][iD]
    if iD == CharactersUsed[p].lastAnim then
        CharactersUsed[p].animationStart = anim.start
        CharactersUsed[p].animationFinish = anim.finish
        if CharactersUsed[p].currentFrame < CharactersUsed[p].animationStart or CharactersUsed[p].currentFrame > CharactersUsed[p].animationFinish then
            CharactersUsed[p].currentFrame = CharactersUsed[p].animationStart
            CharactersUsed[p].extraFrameIdx = 1
        end
    else
        CharactersUsed[p].frameRate = 0
    end
    CharactersUsed[p].lastAnim = iD

    if CharactersUsed[p].currentFrame == CharactersUsed[p].animationStart then
        CharactersUsed[p].extraFrameIdx = 1
    end
end

function animPlaying(p, iD)
    if CharactersUsed[p].dashing > 3 then
        CharactersUsed[p].frameRate += animations[CharactersUsed[p].Char][iD].frameAdd - 0.25
    else
        CharactersUsed[p].frameRate += animations[CharactersUsed[p].Char][iD].frameAdd
    end
    if CharactersUsed[p].frameRate >= animationSpeed then
        CharactersUsed[p].currentFrame += 1
        CharactersUsed[p].extraFrameIdx += 1
        if CharactersUsed[p].currentFrame > CharactersUsed[p].animationFinish then
            CharactersUsed[p].currentFrame = CharactersUsed[p].animationStart
            if CharactersUsed[p].state > stateNormReset then
                CharactersUsed[p].state = 1
                CharactersUsed[p].currentFrame = 1
                CharactersUsed[p].extraFrameIdx = 1
            end
        end
        CharactersUsed[p].frameRate = 0
    end

    return CharactersUsed[p].currentFrame
end

function drawSprites(frame, iD, p)
    local frameX = (frame - 1) * CharactersUsed[p].w
    local flip = playdate.graphics.kImageUnflippedX
    local flipXAmt = 0
    if CharactersUsed[p].flip == 1 then
        flip = playdate.graphics.kImageFlippedX
        flipXAmt = 10
    end
    if iD == 1 then
        pIndex:draw(CharactersUsed[p].x - CharactersUsed[p].sprtX + flipXAmt, CharactersUsed[p].y - CharactersUsed[p].sprtY, flip, frameX, 0, CharactersUsed[p].w, CharactersUsed[p].h)
    elseif iD == 2 then
        pIndex:draw(CharactersUsed[p].x - CharactersUsed[p].sprtX + flipXAmt, CharactersUsed[p].y - CharactersUsed[p].sprtY, flip, frameX, 0, CharactersUsed[p].w, CharactersUsed[p].h)
    elseif iD == 3 then
        pIndex:draw(CharactersUsed[p].x - CharactersUsed[p].sprtX + flipXAmt, CharactersUsed[p].y - CharactersUsed[p].sprtY, flip, frameX, 0, CharactersUsed[p].w, CharactersUsed[p].h)
    end
end