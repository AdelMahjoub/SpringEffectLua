local getParticle = require("particle")
local utils = require("utils")

local function test()

    local p0 = getParticle(0, 0, 0, 0)
    local p1 = getParticle(0, 0, 0, 0)

    -- Instance test
    assert(type(p0) == "table", "getParticle(x, y, speed, direction) should return a table")
    assert(p0 ~= p1, "multiple call to getParticle(x, y, speed, direction) should return multiple table references (new instances)")
   
    assert(type(p0.x) == "number", "type of particle.x should be a number")
    assert(type(p0.y) == "number", "type of particle.y should be a number")
    assert(type(p0.vx) == "number", "type of particle.vx should be a number")
    assert(type(p0.vy) == "number", "type of particle.vy should be a number")
    assert(type(p0.mass) == "number", "type of particle.mass should be a number")
    assert(type(p0.radius) == "number", "type of particle.radius should be a number")
    assert(type(p0.bounce) == "number", "type of particle.bounce should be a number")
    assert(type(p0.friction) == "number", "type of particle.friction should be a number")
    assert(type(p0.gravity) == "number", "type of particle.gravity should be a number")
    
    assert(p0.vx == 0, "if p = getParticle(0, 0, 0, 0) then p.vx should be equal to 0")
    assert(p0.vy == 0, "if p = getParticle(0, 0, 0, 0) then p.vy should be equal to 0")
    assert(p0.gravity == 0, "particle.gravity default value should be equal to 0")

    p0 = getParticle(0, 0, 20, math.pi / 3)
    assert(p0.vx == 20 * math.cos(math.pi / 3), "if p = getParticle(0, 0, 20, math.pi / 3) then p.vx should be equal to '20 * math.cos(math.pi / 3)'")
    assert(p0.vy == 20 * math.sin(math.pi / 3), "if p = getParticle(0, 0, 20, math.pi / 3) then p.vy should be equal to '20 * math.cos(math.pi / 3)'")

    -- particle.accelerate(ax, ay)
    local p = getParticle(0, 0, 0, 0)
    assert(type(p.accelerate) == "function", "particle.accelerate should be a function")
    p.accelerate(0.1, 0.2)
    assert(p.vx == 0.1 and p.vy == 0.2, "if p = getParticle(0, 0, 0, 0), particle.accelerate(0.1, 0.2) should mutate vx to 0.1 and vy to 0.2")

    -- particle.update
    -- particle.getSpeed
    -- particle.getHeading
    local p = getParticle(0, 0, 20, math.pi / 2)
    assert(type(p.update) == "function", "particle.update should be a function")
    assert(type(p.getSpeed) == "function", "particle.getSpeed should be a function")
    assert(type(p.getHeading) == "function", "particle.getHeading should be a function")
    local vx = 20 * math.cos(math.pi / 2)
    local vy = 20 * math.sin(math.pi / 2)
    p.update()
    assert(p.x == vx and p.y == vy, "if p = getParticle(0, 0, 20, math.pi / 2), calling p.update once should mutate p.x to equal p.vx and p.y to equal p.vy")
    -- starting values
    local x = 12
    local y = 238
    local speed = 32
    local direction = math.pi / 3
    local vx = speed * math.cos(direction)
    local vy = speed * math.sin(direction)
    local p = getParticle(x, y, speed, direction)
    p.gravity = 0.1
    p.friction = 0.9
    -- test multiple call to p.update
    for i = 0, 100000 do
        p.update()
        -- expected values
        vx = vx * p.friction 
        vy = vy * p.friction + p.gravity
        x = x + vx
        y = y + vy
        assert(p.x == x and p.y == y, "assertion for particle.update()")
        assert(p.getSpeed() == math.sqrt(vx * vx + vy * vy) , "assertion for particle.getSpeed()")
        assert(p.getHeading() == math.atan2(vy, vx), "assertion for particle.getHeading()")
    end
    
    -- particle.angleTo
    -- particle.distanceTo
    local p0 = getParticle(236, 569, 23, math.random() * math.pi)
    local p1 = getParticle(12, 56, 89, math.random() * math.pi)
    assert(type(p0.angleTo) == "function", "particle.angleTo should be a function")
    assert(type(p0.distanceTo) == "function", "particle.distanceTo should be a function")
    p0.gravity = 0.1
    p0.friction = 0.99
    p1.gravity = 0.08
    p1.friction = 0.98
    for i = 0, 100000 do
        -- expected angle
        p0.update()
        p1.update()
        local angleBetween = math.atan2(p1.y - p0.y, p1.x - p0.x)
        local distanceBetween = math.sqrt(math.pow(p1.x - p0.x, 2) + math.pow(p1.y - p0.y, 2))
        assert(p0.angleTo(p1) == angleBetween, "assertion for particle.angleTo(p)")
        assert(p0.distanceTo(p1) == distanceBetween, "assertion for particle.distanceTo(p)")
    end
    
    -- particle.setSpeed
    -- particle.setHeading
    local p = getParticle(236, 569, 23, math.random() * math.pi)
    assert(type(p.setSpeed) == "function", "particle.setSpeed should be a function")
    assert(type(p.setHeading) == "function", "particle.setHeading should be a function")
    for i = 0, 100000 do
        local speed = 32323 * math.random()
        p.setSpeed(speed)
        assert(utils.roundToPlaces(math.sqrt(p.vx * p.vx + p.vy * p.vy), 4) == utils.roundToPlaces(speed, 4), "particle.setSpeed(speed) should correctly mutate particle.vx and particle.vy")

        local angle = math.random() * math.pi * 2
        p.setHeading(angle)
        assert(
            utils.roundToPlaces(math.deg(math.atan2(p.vy, p.vx)), 4) == utils.roundToPlaces(math.deg(angle), 4) 
                or utils.roundToPlaces(math.deg(math.atan2(p.vy, p.vx) + math.pi * 2), 4)  == utils.roundToPlaces(math.deg(angle), 4), 
            "particle.setAngle(angle) should correctly mutate particle.vx and particle.vy")
    end

    print("All particle tests passed !")
end

return test