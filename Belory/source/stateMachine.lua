import "library.lua"

local function buttonDetect(p)
    local buttonNumb = table.concat(PBS[p], "")
    return buttonNumb
end

function stateMachine(p, o)
    CharactersUsed[o].hittable = 1
    
    if CharactersUsed[p].Char == 1 then
        if CharactersUsed[p].dashDir == 2 and (CharactersUsed[p].state <= stateNormReset and CharactersUsed[p].ground == 1) then
            CharactersUsed[p].state = 2
            CharactersUsed[p].dashing = 20
            if buttonDetect(p) == "001000" then
                CharactersUsed[p].xSpeed = 10
            elseif buttonDetect(p) == "000100" then
                CharactersUsed[p].xSpeed = -10
            end
        elseif (CharactersUsed[p].state <= stateNormReset and CharactersUsed[p].ground == 1) and (buttonDetect(p) == "000010") then
            -- 5A
            CharactersUsed[p].state = 6
        elseif (CharactersUsed[p].state <= stateNormReset and CharactersUsed[p].ground == 1) and (buttonDetect(p) == "000001") then
            -- 5B
            CharactersUsed[p].state = 7
        elseif (CharactersUsed[p].state <= stateNormReset and CharactersUsed[p].ground == 1) and CharactersUsed[p].flip == 0 and (buttonDetect(p) == "001010") then
            -- 6A
            CharactersUsed[p].state = 8
        elseif (CharactersUsed[p].state <= stateNormReset and CharactersUsed[p].ground == 1) and CharactersUsed[p].flip == 1 and (buttonDetect(p) == "000110") then
            -- 4A
            CharactersUsed[p].state = 8
        elseif (CharactersUsed[p].state <= stateNormReset and CharactersUsed[p].ground == 1) and (buttonDetect(p) == "010001") then
            -- 2B
            CharactersUsed[p].state = 9
        elseif (CharactersUsed[p].state <= stateNormReset and CharactersUsed[p].ground == 0) and (buttonDetect(p) == "000010") then
            -- a.5A
            CharactersUsed[p].state = 6
        elseif (CharactersUsed[p].state <= stateNormReset and CharactersUsed[p].ground == 0) and (buttonDetect(p) == "000001") then
            -- a.5B
            CharactersUsed[p].state = 10
        end
        CharactersUsed[p].extraFrameIdx = 1
    end
end