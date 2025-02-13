-- All the character data
characterData = {
    Starter = {
        x = 0, y = 150, sprtX = 64, sprtY = 32, w = 150, h = 150, xSpeed = 0, ySpeed = 0,
        airTime = 0, frict = 1.2, accel = 1.5, fall = 0.8, fallMax = 20, ground = 1, maxSpeed = 8, dashing = 0, move = 5, dashDir = 0,
        state = 1, nextState = 1, otg = 2, lay = 0, stun = 0, hitbox = 1, hitboxAdd = 0, Char = 1, airDir = 0, hittable = 1, combo = 0, stagger = 2, staggerTime = 0, launchCount = 2,
        currentFrame = 1, lastAnim = 0, frameRate = 0, animationStart = 0, animationFinish = 0, flip = 0
    },
    Fox = {
        x = 0, y = 150, sprtX = 64, sprtY = 32, w = 150, h = 150, xSpeed = 0, ySpeed = 0,
        airTime = 0, frict = 1.2, accel = 1.5, fall = 0.8, fallMax = 20, ground = 1, maxSpeed = 8, dashing = 0, move = 5, dashDir = 0,
        state = 1, nextState = 1, otg = 2, lay = 0, stun = 0, hitbox = 1, hitboxAdd = 0, Char = 2, airDir = 0, hittable = 1, combo = 0, stagger = 2, staggerTime = 0, launchCount = 2,
        currentFrame = 1, lastAnim = 0, frameRate = 0, animationStart = 0, animationFinish = 0, flip = 0
    },
    Vulpix = {
        x = 0, y = 150, sprtX = 64, sprtY = 32, w = 150, h = 150, xSpeed = 0, ySpeed = 0,
        airTime = 0, frict = 1.2, accel = 1.5, fall = 1, fallMax = 20, ground = 1, maxSpeed = 8, dashing = 0, move = 2, dashDir = 0,
        state = 1, nextState = 1, otg = 2, lay = 0, stun = 0, hitbox = 1, hitboxAdd = 0, Char = 3, airDir = 0, hittable = 1, combo = 0, stagger = 2, staggerTime = 0, launchCount = 2,
        currentFrame = 1, lastAnim = 0, frameRate = 0, animationStart = 0, animationFinish = 0, flip = 0
    }
}
-- Animations per characters
animations = {
    {
        -- neutral
        {start = 1, finish = 4, frameAdd = 0.5, hitStart = 0, hitEnd = 0},
        {start = 5, finish = 8, frameAdd = 0.2, hitStart = 0, hitEnd = 0},
        {start = 9, finish = 9, frameAdd = 1, hitStart = 0, hitEnd = 0},
        {start = 10, finish = 10, frameAdd = 1, hitStart = 0, hitEnd = 0},
        {start = 38, finish = 38, frameAdd = 1, hitStart = 0, hitEnd = 0},

        -- attacks
        {start = 11, finish = 15, frameAdd = 1, hitStart = 3, hitEnd = 4},
        {start = 16, finish = 23, frameAdd = 1, hitStart = 4, hitEnd = 6},
        {start = 24, finish = 30, frameAdd = 0.5, hitStart = 5, hitEnd = 6},
        {start = 31, finish = 37, frameAdd = 1, hitStart = 4, hitEnd = 6},
        {start = 16, finish = 23, frameAdd = 1, hitStart = 4, hitEnd = 6}
    },{
        -- neutral
        {start = 1, finish = 4, frameAdd = 0.5, hitStart = 0, hitEnd = 0},
        {start = 5, finish = 8, frameAdd = 0.2, hitStart = 0, hitEnd = 0},
        {start = 9, finish = 9, frameAdd = 1, hitStart = 0, hitEnd = 0},
        {start = 10, finish = 10, frameAdd = 1, hitStart = 0, hitEnd = 0},
        {start = 38, finish = 38, frameAdd = 1, hitStart = 0, hitEnd = 0},

        -- attacks
        {start = 11, finish = 15, frameAdd = 1, hitStart = 3, hitEnd = 4},
        {start = 16, finish = 23, frameAdd = 1, hitStart = 4, hitEnd = 6},
        {start = 24, finish = 30, frameAdd = 0.5, hitStart = 5, hitEnd = 6},
        {start = 31, finish = 37, frameAdd = 1, hitStart = 4, hitEnd = 6},
        {start = 16, finish = 23, frameAdd = 1, hitStart = 4, hitEnd = 6}
    },{
        -- neutral
        {start = 1, finish = 4, frameAdd = 0.5, hitStart = 0, hitEnd = 0},
        {start = 5, finish = 8, frameAdd = 0.2, hitStart = 0, hitEnd = 0},
        {start = 9, finish = 9, frameAdd = 1, hitStart = 0, hitEnd = 0},
        {start = 10, finish = 10, frameAdd = 1, hitStart = 0, hitEnd = 0},
        {start = 38, finish = 38, frameAdd = 1, hitStart = 0, hitEnd = 0},

        -- attacks
        {start = 11, finish = 15, frameAdd = 1, hitStart = 3, hitEnd = 4},
        {start = 16, finish = 23, frameAdd = 1, hitStart = 4, hitEnd = 6},
        {start = 24, finish = 30, frameAdd = 0.5, hitStart = 5, hitEnd = 6},
        {start = 31, finish = 37, frameAdd = 1, hitStart = 4, hitEnd = 6},
        {start = 16, finish = 23, frameAdd = 1, hitStart = 4, hitEnd = 6}
    }
}
-- X/Y/W/H, Stun/KnockBack/ResetHit?/OTG?, PullBack/Launch?/Stagger/UpMomentum, lay?
hitboxes = {
    {
        {
            {10,10,40,20, 5,6,0,1, 3,0,0,5, 0},
            {10,10,40,20, 5,6,0,1, 3,0,0,5, 0}
        },
        {
            {15,10,50,25, 8,8,0,0, -16,0,0,3, 0},
            {15,10,50,25, 8,8,0,0, -16,0,0,3, 0},
            {15,10,50,25, 8,8,0,0, -16,0,0,3, 0}
        },
        {
            {10,6,60,20, 5,15,0,0, -16,0,1,2, 0},
            {10,6,60,20, 5,15,0,0, -16,0,1,2, 0}
        },
        {
            {10,6,60,40, 15,7,0,0, -16,1,0,10, 0},
            {10,6,60,40, 15,7,0,0, -16,1,0,10, 0},
            {10,6,60,40, 15,7,0,0, -16,1,0,10, 0}
        },
        {
            {15,10,50,25, 8,8,0,0, -16,0,0,-5, 1},
            {15,10,50,25, 8,8,0,0, -16,0,0,-5, 1},
            {15,10,50,25, 8,8,0,0, -16,0,0,-5, 1}
        }
    },{
        {
            {10,10,40,20, 5,6,0,0, 3,0,0,5},
            {10,10,40,20, 5,6,0,0, 3,0,0,5}
        },
        {
            {15,10,50,25, 8,8,0,0, -16,0,0,3},
            {15,10,50,25, 8,8,0,0, -16,0,0,3},
            {15,10,50,25, 8,8,0,0, -16,0,0,3}
        },
        {
            {10,6,60,20, 5,15,0,0, -16,0,1,10},
            {10,6,60,20, 5,15,0,0, -16,0,1,10}
        },
        {
            {10,6,60,40, 15,7,0,0, -16,1,0,1},
            {10,6,60,40, 15,7,0,0, -16,1,0,1},
            {10,6,60,40, 15,7,0,0, -16,1,0,1}
        },{
            {15,10,50,25, 8,8,0,0, -16,0,0,-5},
            {15,10,50,25, 8,8,0,0, -16,0,0,-5},
            {15,10,50,25, 8,8,0,0, -16,0,0,-5}
        }
    },{
        {
            {10,10,40,20, 5,6,0,0, 3,0,0,5},
            {10,10,40,20, 5,6,0,0, 3,0,0,5}
        },
        {
            {15,10,50,25, 8,8,0,0, -16,0,0,3},
            {15,10,50,25, 8,8,0,0, -16,0,0,3},
            {15,10,50,25, 8,8,0,0, -16,0,0,3}
        },
        {
            {10,6,60,20, 5,15,0,0, -16,0,1,10},
            {10,6,60,20, 5,15,0,0, -16,0,1,10}
        },
        {
            {10,6,60,40, 15,7,0,0, -16,1,0,1},
            {10,6,60,40, 15,7,0,0, -16,1,0,1},
            {10,6,60,40, 15,7,0,0, -16,1,0,1}
        },{
            {15,10,50,25, 8,8,0,0, -16,0,0,-5},
            {15,10,50,25, 8,8,0,0, -16,0,0,-5},
            {15,10,50,25, 8,8,0,0, -16,0,0,-5}
        }
    },
}
hurtBoxes = {
    {
        {0,0,32,56},
        {0,0,32,56},
        {0,0,32,56},
        {0,0,32,56},
        {0,20,32,36},
        {0,0,32,56},
        {0,0,32,56},
        {0,0,32,56},
        {0,0,32,56},
        {0,0,32,56}
    },
    {
        {0,0,32,56},
        {0,0,32,56},
        {0,0,32,56},
        {0,0,32,56},
        {0,20,32,36},
        {0,0,32,56},
        {0,0,32,56},
        {0,0,32,56},
        {0,0,32,56},
        {0,0,32,56}
    },
    {
        {0,0,32,56},
        {0,0,32,56},
        {0,0,32,56},
        {0,0,32,56},
        {0,20,32,36},
        {0,0,32,56},
        {0,0,32,56},
        {0,0,32,56},
        {0,0,32,56},
        {0,0,32,56}
    }
}