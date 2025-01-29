import "worldLoaded.lua"
import "library.lua"

local blockTypes = {
    air = 0,
    grass = 1,
    stone = 2,
    water = 3,
    sand = 4
}

local gfx <const> = playdate.graphics
local terrainFreq = 0.04
local caveFreq = 0.045
local hillFreq = 0.02
local hillHeightMultiplier = 3
local heightMultiplier = 6
local heightAddition = math.random(15, 25)
local seed = math.random(-10000, 10000)
local minHeight = 10
local maxHeight = amt.y
local resist = 0
local dex = 0
local height = {}

function generateWorld(image)
    for y = 1, image.height do
        for x = 1, image.width do
            if y == 1 then
                -- Generate base height
                local baseHeight = gfx.perlin((x + seed) * terrainFreq, seed * terrainFreq) * heightMultiplier
                local hillNoise = gfx.perlin((x + seed) * hillFreq, seed * hillFreq) * hillHeightMultiplier
                height[x] = math.floor(baseHeight - hillNoise + heightAddition)
                height[x] = math.max(minHeight, math.min(maxHeight, height[x]))
                print("Base Height:", baseHeight, "Hill Added:", hillNoise, "Final Height:", height[x])
            end

            resist = 0
            dex = 0
            blockType = "air"
            local pixelValue = image:sample(x, y)

            if pixelValue == 1 and y >= height[x] then
                resist = math.random() * 0.4 - 0.2
                dex = 20
                blockType = "grass"
            end

            table.insert(tiles, {
                block = blockTypes[blockType],
                x = (x - 1) * blockSpacing,
                y = (y - 1) * blockSpacing,
                resist = resist,
                dex = dex
            })
        end
    end
    print("Height Addition:", heightAddition)
end

local function generateHeights(image)
    for x = 1, image.width do
        local baseHeight = gfx.perlin((x + seed) * terrainFreq, seed * terrainFreq) * heightMultiplier
        local hillNoise = gfx.perlin((x + seed) * hillFreq, seed * hillFreq) * hillHeightMultiplier
        local finalHeight = math.floor(baseHeight - hillNoise + heightAddition)

        height[x] = math.max(minHeight, math.min(maxHeight, finalHeight))
    end
end

function createNoiseImage()
    local image = gfx.image.new(amt.x, amt.y)
    assert(image, "Failed to create image.")

    gfx.pushContext(image)

    generateHeights(image)

    local chunkOffsetX = worldCoords.x * amt.x
    local chunkOffsetY = worldCoords.y * amt.y

    for x = 1, image.width do
        for y = 1, image.height do
            local worldX = chunkOffsetX + x
            local worldY = chunkOffsetY + y

            local noiseValue = gfx.perlin((worldX + seed) * caveFreq, (worldY + seed) * caveFreq)

            if height[x] and y > (height[x] - 4) and y < (height[x] + 8) and noiseValue > 0.7 then
                gfx.setColor(gfx.kColorBlack)
            else
                gfx.setColor(gfx.kColorWhite)
            end

            gfx.drawPixel(x, y)
        end
    end

    gfx.popContext()
    return image
end
