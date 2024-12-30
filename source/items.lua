local gfx <const> = playdate.graphics

objects = {
    Hand = { dex = 0.5, blockTypes = 1 },
    Pickaxe = { dex = 1.2, blockTypes = 2 },
    Axe = { dex = 1.2, blockTypes = 3 }
}

items = {
    "Hand", "Pickaxe", "Axe", 
    "Block1", "Block2", "Block3"
}

blockImages = {
    gfx.image.new("images/blocks/block1"), gfx.image.new("images/blocks/block2"),
    gfx.image.new("images/blocks/block3")
}