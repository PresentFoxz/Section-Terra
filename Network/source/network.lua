import "CoreLibs/utilities/where"

local net <const> = playdate.network

tcp_done = false
http_done = false
tcp_result = ""
http_result = ""
http_waiting = false
http_data_received = false
http_conn = nil
local start_time <const> = playdate.getCurrentTimeMilliseconds()

local wait_time = 10

local RUN_TCP <const> = true
local RUN_HTTP <const> = true
local tcpRecieve = true

player = {math.random(00000,99999), math.random(0,390), math.random(0,230)}
other_players = {}

status_str = "Not Connected"

function networkStatus()
    local status = net.getStatus()

    if status == net.kStatusConnected then
        status_str = "Connected"
    elseif status == net.kStatusNotAvailable then
        status_str = "Not Available"
    end
end

function timeLog(text)
    now = playdate.getCurrentTimeMilliseconds()
    elapsed = now - start_time
    print(string.format("[%i] %s", elapsed, text))
end

function headersRead()
    timeLog("HTTP headersRead called")

    local response = http_conn:getResponseStatus()
    timeLog(string.format("\tHTTP GET getResponseStatus: %i", response))


end

function connectionClosed()
    timeLog("HTTP connectionClosed called")
end

function requestComplete()
    local err = http_conn:getError()
    timeLog("HTTP requestComplete called, error="..(err or "nil"))

    if err ~= nil then
        http_done = true
        http_result = err
    end
end

function requestCallback()
    timeLog("HTTP requestCallback called, "..http_conn:getBytesAvailable().." bytes are available for reading")

    -- Show initial progress
    local current, total = http_conn:getProgress()
    timeLog(string.format("\tHTTP GET getProgress: %i / %i", current, total))

    -- check the number of bytes available to read
    local bytes = http_conn:getBytesAvailable()
    timeLog(string.format("\tHTTP GET getBytesAvailable: %i", bytes))

    -- read that number of bytes
    http_result = http_conn:read(bytes)
    timeLog(string.format("\tHTTP data received: %s", http_result))

    -- Show final progress
    current, total = http_conn:getProgress()
    timeLog(string.format("\tHTTP GET getProgress: %i / %i", current, total))

    http_data_received = true

end

function httpCode()
    if RUN_HTTP then
        if not http_waiting then
            http_conn = net.http.new("localhost", 65433, false, "HTTP Demo")
            assert(http_conn, "The user needs to allows this")

            http_conn:setHeadersReadCallback(headersRead)
            http_conn:setConnectionClosedCallback(connectionClosed)
            http_conn:setRequestCompleteCallback(requestComplete)
            http_conn:setRequestCallback(requestCallback)

            http_conn:setConnectTimeout(2)
            http_conn:setKeepAlive(true)

            local get_request, get_error = http_conn:get("/player")
            assert(get_request, get_error)

            http_waiting = true

        else
            --timeLog(string.format("HTTP Waiting %i ms for data…: %s", wait_time, http_conn:getError() or "OK"))
            playdate.wait(wait_time)
        end
    end
end

function tcpCode()
    if RUN_TCP then
        local tcp_conn = net.tcp.new("localhost", 65431)
        assert(tcp_conn, "The user needs to allows this")
        tcp_conn:setConnectTimeout(2)

        tcp_conn:setConnectionClosedCallback(function ()
            timeLog("TCP connection was closed")
        end)

        local write_result
        local write_complete = false

        tcp_conn:open(function (connected, open_error)
            timeLog(string.format("TCP connected: %s Error: %s", tostring(connected), tostring(open_error)))

            if not connected then
                tcp_result = open_error
            else
                write_result, tcp_result = tcp_conn:write("player")
                timeLog(string.format("TCP write: %s Result: %s", tostring(write_result), tostring(tcp_result)))
            end

            write_complete = true
        end)

        while not write_complete do
            timeLog(string.format("TCP Waiting %i ms for TCP write to complete…", wait_time))
            playdate.wait(wait_time)
        end

        if write_result and tcpRecieve then
            tcp_result = ""
            local bytes = tcp_conn:getBytesAvailable()
            local timeout = 0
            while bytes == 0 and timeout < 5 do
                timeLog("TCP Waiting for data…")
                playdate.wait(wait_time)
                timeout += 1
                bytes = tcp_conn:getBytesAvailable()
            end

            while bytes > 0 do
                timeLog("TCP Bytes available from server: " .. bytes)
                local bytes_read, num_bytes_read = tcp_conn:read(bytes)
                tcp_result = tcp_result .. bytes_read
                timeLog(string.format("TCP Read %i from the server", num_bytes_read))
                bytes = tcp_conn:getBytesAvailable()
            end

            if tcp_result == "" then
                tcp_result = "TCP No Data received"
            end

        end

        tcp_done = true
    end
end