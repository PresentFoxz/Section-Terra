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
local terrainFreq = 0.08
local caveFreq = 0.05
local hillFreq = 0.05
local hillHeightMultiplier = 4
local heightMultiplier = 8
local heightAddition = math.random(10,30)
local seed = math.random(-10000, 10000)
local resist = 0
local dex = 0
local height = {}

function generateWorld(image)
    for y = 1, image.height do
        for x = 1, image.width do
            if y == 1 then
                table.insert(height, gfx.perlin((x + seed) * terrainFreq, seed * terrainFreq) * heightMultiplier + heightAddition)
                local hillNoise = gfx.perlin((x + seed) * hillFreq, seed * hillFreq)
                local hillAdjustment = hillNoise * hillHeightMultiplier
                height[x] = math.min(math.floor(height[x] - hillAdjustment), image.height - 1)

                print("Base Height:", height[x] - hillAdjustment, "Hill Added:", hillAdjustment, "Final Height:", height[x])
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
    print("HeightAddition:", heightAddition)
end

function createNoiseImage()
    local image = gfx.image.new(amt.x, amt.y)
    assert(image, "Failed to create image.")

    gfx.pushContext(image)

    local chunkOffsetX = worldCoords.x * amt.x
    local chunkOffsetY = worldCoords.y * amt.y

    for x = 1, image.width do
        for y = 1, image.height do
            local worldX = chunkOffsetX + x
            local worldY = chunkOffsetY + y

            local noiseValue = gfx.perlin((worldX + seed) * caveFreq, (worldY + seed) * caveFreq)
            local color = noiseValue > 0.5 and gfx.kColorBlack or gfx.kColorWhite

            gfx.setColor(color)
            gfx.drawPixel(x, y)
        end
    end
    gfx.popContext()
    return image
end