local getParticle = require("particle")
local utils = require("utils")

-- local utilsTest = require("test/utils")
local particleTest = require("test/particle")
-- utilsTest()
-- particleTest()

love.math.setRandomSeed(love.timer.getTime())
local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

local springPoint = {
    x = width / 2,
    y = height / 2
}
local springPoint2 = {
    x = utils.randomRange(0, width),
    y = utils.randomRange(0, height)
}
local k = 0.1
local springLength = 100

local weight = getParticle(love.math.random() * width, love.math.random() * height, 50, love.math.random() * math.pi * 2, 0.5)
weight.radius = 20
weight.friction = 0.95
weight.addSpring(springPoint, k, springLength)
weight.addSpring(springPoint2, k, springLength)


-- Load event
function love.load()
    
end

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

    weight.update()

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

    love.graphics.circle("fill", weight.x, weight.y, weight.radius)
    love.graphics.circle("fill", springPoint.x, springPoint.y, 5)
    love.graphics.circle("fill", springPoint2.x, springPoint2.y, 5)
    love.graphics.line(weight.x, weight.y, springPoint.x, springPoint.y)
    love.graphics.line(weight.x, weight.y, springPoint2.x, springPoint2.y)
end
