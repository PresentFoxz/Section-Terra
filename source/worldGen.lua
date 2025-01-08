local blockTypes = {
    air = 0,
    grass = 1,
    stone = 2,
    water = 3,
    sand = 4
}

local noiseScale = 0.1
local caveThreshold = 0.6
local gfx <const> = playdate.graphics
local chunkHeight = 50 

local seed = math.random(1000, 9999)
local function randomNoise(x, y)
    return gfx.perlin(x * noiseScale + seed, y * noiseScale + seed)
end

function generateWorld()
    for y = 1, amt.y do
        for x = 1, amt.x do
            local baseHeight = math.floor(randomNoise(x, y) * chunkHeight)
            
            local terrainNoise = gfx.perlin(x * noiseScale, y * noiseScale)
            local blockType = "air"
            
            if y < baseHeight - 10 then
                local caveNoise = gfx.perlin(x * noiseScale, y * noiseScale)
                if caveNoise > caveThreshold then
                    blockType = "air"
                else
                    blockType = "stone"
                end
            elseif y == baseHeight then
                blockType = "grass"
            elseif y > baseHeight then
                if terrainNoise > 0.5 then
                    blockType = "water"
                else
                    blockType = "air"
                end
            end

            local resist = math.random() * 0.4 - 0.2
            local dex = 20

            table.insert(tiles, {
                block = blockTypes[blockType],
                x = (x - 1) * blockSpacing,
                y = (y - 1) * blockSpacing,
                resist = resist,
                dex = dex
            })
        end
    end
end