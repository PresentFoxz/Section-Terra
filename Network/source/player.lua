function movement(player)
    if playdate.buttonIsPressed(playdate.kButtonUp) then
        player[3] -= 3
    end
    if playdate.buttonIsPressed(playdate.kButtonDown) then
        player[3] += 3
    end
    if playdate.buttonIsPressed(playdate.kButtonLeft) then
        player[2] -= 3
    end
    if playdate.buttonIsPressed(playdate.kButtonRight) then
        player[2] += 3
    end

    if player[2] > 390 then
        player[2] = 390
    elseif player[2] < 0 then
        player[2] = 0
    end
    if player[3] > 230 then
        player[3] = 230
    elseif player[3] < 0 then
        player[3] = 0
    end
end