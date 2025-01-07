local biomeRules = {
    grassland = {
        air = {"air", "grass"},
        grass = {"grass", "stone", "water", "air"},
        stone = {"stone", "grass"},
        water = {"grass", "air"}
    },
    cave = {
        air = {"stone", "air"},
        stone = {"stone", "air"},
    }
}


local blockTypes = {
    air = 0,
    grass = 1,
    stone = 2,
    water = 3,
    sand = 4
}
local convertBlock = {
    "air",
    "grass",
    "stone",
    "water",
    "sand"
}

local blocks = {}

function WFC()
    local i = 1
    local x, y, step = 0, 0, 0
    local lastBlockX, lastBlockY = 0, 0

    if worldCoords.y >= 1 then
        blocks = biomeRules.cave
    elseif worldCoords.y < 1 then
        blocks = biomeRules.grassland
    end
    print(blocks)
    while i < (amt.x * amt.y) do
        local test = tileCheck(lastBlockX, lastBlockY) 
        local prevBlock = test and convertBlock[test.block + 1] or "air"
        local validPatterns = blocks[prevBlock]
        if #validPatterns == 0 then
            validPatterns = {"air"}
        end
        
        local rand = math.random(1, #validPatterns)
        local chosenBlock = validPatterns[rand]
        if blockTypes[chosenBlock] == nil then
            chosenBlock = "air"
        end
        local resistRand = math.random() * 0.4 - 0.2

        table.insert(tiles, {block = blockTypes[chosenBlock], x = x, y = y, dex = 20, resist = resistRand})
        lastBlockX, lastBlockY = x, y
        x += blockSpacing
        step += 1
        if step >= amt.x then
            y += blockSpacing
            x = 0
            step = 0
            lastBlockX, lastBlockY = 0, (y - blockSpacing)
        end
        i+=1
    end
end