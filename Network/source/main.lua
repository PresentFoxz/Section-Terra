import "CoreLibs/graphics"
import "network.lua"
import "player.lua"

playdate.display.setRefreshRate(50)

local gfx <const> = playdate.graphics
local start = false
local timer = 0

function playdate.update()
    movement(player)

    if start then
        networkStatus()
    else
        networkStatus()
        tcpCode()
        start = true
    end

    gfx.clear()
    t = string.format("Status: %s\nTCP: %s\nHTTP: %s\nTCP Complete: %s\nHTTP Complete: %s", status_str, tcp_result, http_result, tcp_done, http_done)
    gfx.drawTextInRect(t, 10, 10, 380, 220)
    gfx.fillRect(player[2], player[3], 10, 10)

    if tcp_result ~= "" then
        if timer > 50 then
            other_players = tcp_result
            print("1", other_players, tcp_result)
            http_result = ""
            tcp_result = ""
            http_waiting = false
            print("2", other_players, tcp_result)
            --networkStatus()
            tcpCode()
            --httpCode()
            timer = 0
        else
            timer += 1
        end
    end
end
