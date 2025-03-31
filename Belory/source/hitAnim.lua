import "CoreLibs/graphics"
import "charData.lua"
local gfx <const> = playdate.graphics

-- names for menu
charNames = {{"Starter", characterData.Starter}, {"Fox", characterData.Fox}, {"Vulpix", characterData.Vulpix}}

-- Whos being used in match
CharactersUsed = {
    {},
    {}
}

function renderBox(p, state)
    local bx = hurtBoxes[CharactersUsed[p].Char][state][1] + CharactersUsed[p].x
    local by = hurtBoxes[CharactersUsed[p].Char][state][2] + CharactersUsed[p].y
    local bw = hurtBoxes[CharactersUsed[p].Char][state][3]
    local bh = hurtBoxes[CharactersUsed[p].Char][state][4]
    gfx.drawRect(bx, by, bw, bh)
    local frame = CharactersUsed[p].extraFrameIdx
    print()
    if hitboxes[CharactersUsed[p].Char][state - stateNormReset][frame] ~= null then
        local hitbox = hitboxes[CharactersUsed[p].Char][state - stateNormReset][frame]
        local x = hitbox[1] + CharactersUsed[p].x
        local y = hitbox[2] + CharactersUsed[p].y
        local w = hitbox[3]
        local h = hitbox[4]

        gfx.setColor(gfx.kColorBlack)
        gfx.drawPixel(x + (w / 2), y + (h / 2))
        if CharactersUsed[p].flip == 1 then
            x -= (bw - hitbox[9])
        end
        gfx.drawRect(x, y, w, h)
        gfx.drawPixel(x + (w / 2), y + (h / 2))
    end
end

pIndex = playdate.graphics.image.new("images/player")