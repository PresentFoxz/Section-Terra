import "CoreLibs/graphics"
import "network.lua"
import "player.lua"

playdate.display.setRefreshRate(50)

local gfx <const> = playdate.graphics

function playdate.update()
    movement(player)
    networkStatus()

    --tcpCode()
    httpCode()

    gfx.clear()
    t = string.format("Status: %s\nTCP: %s\nHTTP: %s\nTCP Complete: %s\nHTTP Complete: %s", status_str, tcp_result, http_result, tcp_done, http_done)
    gfx.drawTextInRect(t, 10, 10, 380, 220)

    gfx.fillRect(player[2], player[3], 10, 10)
end
