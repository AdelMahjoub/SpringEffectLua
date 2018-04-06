local getParticle = require("particle")
local utils = require("utils")

local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

-- Gravitation 
-----------------------------------------------------------------------------
-- local sun1 = getParticle(100, 200, 0, 0)
-- sun1.mass = 30000000
-- sun1.radius = 20

-- local sun2 = getParticle(600, 300, 0, 0)
-- sun2.mass = 78000000
-- sun2.radius = 20

-- local emitter = {
--     x = 10,
--     y = 10
-- }

-- local particles = {}
-- local particlesCount = 100
-- for i = 1, particlesCount do
--     local p = getParticle(emitter.x, emitter.y, utils.randomRange(400, 402), math.pi / 2 * utils.randomRange(-0.1, 0.1))
--     p.addGravitation(sun1)
--     p.addGravitation(sun2)
--     particles[#particles + 1] = p
--     p.radius = 2
-- end
------------------------------------------------------------------------------
-- Spring test
local springPoint = {
    x = width / 2,
    y = height / 2
}
local springPoint2 = {
    x = utils.randomRange(0, width),
    y = utils.randomRange(0, height)
}
local k = 160
local springLength = 100

local weight = getParticle(love.math.random() * width, love.math.random() * height, 100, love.math.random() * math.pi * 2, 20)
weight.radius = 20
weight.friction = 0.9
weight.addSpring(springPoint, k, springLength)
weight.addSpring(springPoint2, k, springLength)
-------------------------------------------------------------------------------

-- Mouse press events
function love.mousepressed(x, y, button, istouch)
    if not started then
        started = true
        return
    end
end

-- Mouse move events
function love.mousemoved(x, y, dx, dy, istouch)
    springPoint.x = x
    springPoint.y = y
end

-- Update loop
function love.update(dt)
    if not started then
        return
    end

    print(love.timer.getFPS())

    -- Gravitation 
    -- for i, p in ipairs(particles) do 
    --     p.update(dt)
    --     if p.x < 0 or p.x > width or p.y < 0 or p.y > height then
    --         p.x = emitter.x
    --         p.y = emitter.y
    --         p.setSpeed(utils.randomRange(400, 402))
    --         p.setHeading(math.pi / 2 * utils.randomRange(-0.1, 0.1))
    --     end
    -- end

    -- Spring
    weight.update(dt)
end

-- Render loop
function love.draw()
    if not started then
        local message = love.graphics.newText(love.graphics.newFont(40), "Click to start")
        love.graphics.print("Start Screen", 10, 10)
        love.graphics.draw(
            message,
            width * 0.5 - message:getWidth() * 0.5,
            height * 0.5 - message:getHeight() * 0.5
        )
        return
    end

    -- Gravitaion
    -----------------------------------------------------------
    -- for i, p in ipairs(particles) do 
    --     love.graphics.circle("fill", p.x, p.y, p.radius)
    -- end
    -- love.graphics.circle("fill", sun1.x, sun1.y, sun1.radius)
    -- love.graphics.circle("fill", sun2.x, sun2.y, sun2.radius)
    ------------------------------------------------------------

    -- Spring
    love.graphics.circle("fill", weight.x, weight.y, weight.radius)
    love.graphics.circle("fill", springPoint.x, springPoint.y, 5)
    love.graphics.circle("fill", springPoint2.x, springPoint2.y, 5)
    love.graphics.line(weight.x, weight.y, springPoint.x, springPoint.y)
    love.graphics.line(weight.x, weight.y, springPoint2.x, springPoint2.y)
end
