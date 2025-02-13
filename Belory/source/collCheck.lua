import "library.lua"
import "charData.lua"
import "hitAnim.lua"

function handleCollisions(p, o)
    local collision = false
    local Char = CharactersUsed[o].Char
    local state = CharactersUsed[o].state
    local frame = math.ceil((CharactersUsed[o].currentFrame - animations[Char][state].start) + 1)
    if state > stateNormReset and frame >= animations[Char][state].hitStart and frame <= animations[Char][state].hitEnd then
        collision = collisionCheck(p, o)
        print(p)
    end

    if collision and hitboxes[Char][state - stateNormReset][CharactersUsed[o].hitbox][8] == 1 then
        CharactersUsed[p].lay = 0
    end

    if collision and CharactersUsed[p].hittable == 1 and CharactersUsed[p].lay == 0 then
        if CharactersUsed[p].x < CharactersUsed[o].x then
            CharactersUsed[p].flip = 0
        else
            CharactersUsed[p].flip = 1
        end
        if CharactersUsed[o].dashing > 3 then
            CharactersUsed[p].stun = hitboxes[Char][state - stateNormReset][CharactersUsed[o].hitbox][5] + 5
        else
            CharactersUsed[p].stun = hitboxes[Char][state - stateNormReset][CharactersUsed[o].hitbox][5]
        end
        if CharactersUsed[p].flip == 1 then
            CharactersUsed[p].xSpeed += hitboxes[Char][state - stateNormReset][CharactersUsed[o].hitbox][6]
        else
            CharactersUsed[p].xSpeed += -hitboxes[Char][state - stateNormReset][CharactersUsed[o].hitbox][6]
        end

        if CharactersUsed[p].ground == 0 then
            CharactersUsed[p].ySpeed = -hitboxes[Char][state - stateNormReset][CharactersUsed[o].hitbox][12]
        end
        if hitboxes[Char][state - stateNormReset][CharactersUsed[o].hitbox][10] == 1 and CharactersUsed[p].launchCount > 0 then
            CharactersUsed[p].ySpeed = -hitboxes[Char][state - stateNormReset][CharactersUsed[o].hitbox][12]
            CharactersUsed[p].launchCount -= 1
        elseif CharactersUsed[p].launchCount == 0 and hitboxes[Char][state - stateNormReset][CharactersUsed[o].hitbox][10] == 1 then
            CharactersUsed[p].stun = 3
        end
        if CharactersUsed[p].stagger == 0 then
            CharactersUsed[p].staggerTime = 0
        end
        if CharactersUsed[p].stagger >= 1 and hitboxes[Char][state - stateNormReset][CharactersUsed[o].hitbox][11] == 1 then
            CharactersUsed[p].stagger -= 1
            CharactersUsed[p].staggerTime = 20
        end

        CharactersUsed[p].lay = hitboxes[Char][state - stateNormReset][CharactersUsed[o].hitbox][13]

        resetState(p)
        CharactersUsed[p].hittable = 0
        CharactersUsed[o].combo += 1
    end
end