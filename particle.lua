-- Particle factory function
-- Returns a Particle table
-- @param<number> x
-- @param<number> y
-- @param<number> speed     : the particle velocity's magnitude
-- @param<number> direction : the particle velocity's angle
-- @param<number> grav      : the global gravity magnitude applied to the particle, default to 0
-- @return<Particle>
local function getParticle(x, y, speed, direction, grav)
    -- arguments type assertion
    assert(type(x) == "number", "getParticle(x, y, speed, direction, grav) typeof argument 'x' should be a number")
    assert(type(y) == "number", "getParticle(x, y, speed, direction, grav) typeof argument 'y' should be a number")
    assert(type(speed) == "number", "getParticle(x, y, speed, direction, grav) typeof argument 'speed' should be a number")
    assert(type(direction) == "number", "getParticle(x, y, speed, direction, grav) typeof argument 'direction' should be a number")
    if grav ~= nil then
        assert(type(grav) == "number", "getParticle(x, y, speed, direction, grav) typeof argument 'grav' should be a number")
    end
    
    -- @class Particle
    -- A particle is an entity submitted to forces
    -- It can be initially represented by its position {x, y} and its velocity {vx, vy}
    -- The particle moves when its velocity is added to its position
    -- The particle accelerate when one or multiple forces are added to its velocity 
    -- @field<number> x
    -- @field<number> y
    -- @field<number> vx
    -- @field<number> vy
    -- @field<number> mass
    -- @field<number> radius
    -- @field<number> bounce
    -- @field<number> friction
    -- @field<number> gravity
    -- @field<table> springs -- springs this particle is attached to, empty by default
    local particle = {}
    
    particle.x = x
    particle.y = y
    particle.vx = speed * math.cos(direction)
    particle.vy = speed * math.sin(direction)
    particle.mass = 1             -- particles could gravitate to particles with very high mass
    particle.radius = 0
    particle.bounce = -1          -- -1 means perfect bounce, -0.9 speed is reduced by 10% each bounce
    particle.friction = 1         -- 1 means no friction
    particle.gravity = grav or 0  -- 0 means no gravity is applied
    particle.springs = {}
    particle.previousDt = 1

    -- Get the particle's velocity magnitude
    -- @return<number>
    particle.getSpeed = function()
        return math.sqrt(particle.vx * particle.vx + particle.vy * particle.vy)
    end

    -- Set the particle's velocity magnitude
    -- @param<number> speed
    particle.setSpeed = function(speed)
        assert(type(speed) == "number", "particle.setSpeed(speed) typeof argument 'speed' should be a number")
        local angle = math.atan2(particle.vy, particle.vx)
        particle.vx = math.cos(angle) * speed
        particle.vy = math.sin(angle) * speed
    end

    -- Get the particle's velocity direction
    -- @return<number>
    particle.getHeading = function()
        return math.atan2(particle.vy, particle.vx)
    end

    -- Set the particle's velocity direction
    -- @param<number> angle
    particle.setHeading = function(angle)
        assert(type(angle) == "number", "particle.setHeading(angle) typeof argument 'angle' should be a number")
        local speed = math.sqrt(particle.vx * particle.vx + particle.vy * particle.vy)
        particle.vx = math.cos(angle) * speed
        particle.vy = math.sin(angle) * speed
    end

    -- Add an acceleration vector ax, ay to the particle's velocity vx, vy
    -- @param<number> ax
    -- @param<number> ay 
    particle.accelerate = function(ax, ay)
        assert(type(ax) == "number", "particle.accelerate(ax, ay) typeof argument 'ax' should be a number")
        assert(type(ay) == "number", "particle.accelerate(ax, ay) typeof argument 'ay' should be a number")
        particle.vx = particle.vx + ax
        particle.vy = particle.vy + ay
    end
    
    -- Update the particle position by applying the velocity, friction and gravity
    particle.update = function()
        particle.handleSprings()
        -- apply friction to velocity
        particle.vx = particle.vx * particle.friction
        particle.vy = particle.vy * particle.friction
        -- apply gravity to velocity
        particle.vy = particle.vy + particle.gravity
        -- apply velocity to position
        particle.x = particle.x + particle.vx
        particle.y = particle.y + particle.vy
    end
   
    -- Get the angle between this particle and another particle
    -- @param<table{x<number}, y<number>}> p
    -- @return<number> 
    particle.angleTo = function(p)
        assert(type(p) == "table", "particle.angleTo(p) typeof argument 'p' should be a table with at least x and y fields")
        assert(type(p.x) == "number", "particle.angleTo(p) p.x should be a number")
        assert(type(p.y) == "number", "particle.angleTo(p) p.y should be a number")
        return math.atan2(p.y - particle.y, p.x - particle.x)
    end

    -- Get the distance between this particle and another particle
    -- @param<table{x<number>, y<number>}> p
    -- @return<number>
    particle.distanceTo = function(p)
        assert(type(p) == "table", "particle.distanceTo(p) typeof argument 'p' should be a table with at least x and y fields")
        assert(type(p.x) == "number", "particle.distanceTo(p) p.x should be a number")
        assert(type(p.y) == "number", "particle.distanceTo(p) p.y should be a number")
        local dx = p.x - particle.x
        local dy = p.y - particle.y
        local dist = math.sqrt(dx * dx + dy * dy)
        return dist
    end

    -- If this particle is within the attraction field of another particle then this particle can gravitate to that particle
    -- by accelerating this particle velocity by the attraction vector of the other particle
    -- the attraction magnitude is equal to (the attracting particle mass) / (distance between the two particles) ^ 2
    -- the attraction vector is defined by the attraction magnitude and the angle between the two particles
    -- @param<table{x<number>, y<number>}>
    particle.gravitateTo = function(p)
        assert(type(p) == "table", "particle.gravitateTo(p) typeof argument 'p' should be a table with at least x and y fields")
        assert(type(p.x) == "number", "particle.gravitateTo(p) p.x should be a number")
        assert(type(p.y) == "number", "particle.gravitateTo(p) p.y should be a number")
        local dx = p.x - particle.x
        local dy = p.y - particle.y 
        local distSQ = dx * dx + dy * dy
        local dist = math.sqrt(distSQ)
        local force = p.mass / distSQ
        local ax = force * (dx / dist)
        local ay = force * (dy / dist)
        particle.vx = particle.vx + ax
        particle.vy = particle.vy + ay
    end

    -- Attach a pring to the particle
    -- @param<table{x<number>, y<number>}> point
    -- @param<number> k: spring stiffness
    -- @param<number> length: spring rest distance
    particle.addSpring = function(point, k, length)
        assert(type(point) == "table", "particle.addSpring(point, k, length) typeof argument 'point' should be a table with at least x and y field")
        assert(type(k) == "number", "particle.addSpring(point, k, length) typeof argument 'k' should be a number")
        if(length ~= nil) then
            assert(type(length) == "number", "particle.addSpring(point, k, length) typeof argument 'length' should be a number")
        end
        particle.removeSpring(point)
        particle.springs[#particle.springs + 1] = {point = point, k = k, length = length or 0}
    end

    -- Remove an attached spring
    -- @param<table{x<number>, y<number>}> point
    particle.removeSpring = function(point)
        assert(type(point) == "table", "particle.removeSpring(point) typeof argument 'point' should be a table with at least x and y field")
        for i,spring in ipairs(particle.springs) do
            if spring.point == point then
                table.remove(particle.springs, i)
                break
            end
        end
    end

    -- Attach the particle to a spring
    -- @param<table{x<number>, y<number>}> point
    -- @param<number> k: spring stiffness
    -- @param<number> length: spring rest distance
    particle.springTo = function(point, k, length)
        assert(type(point) == "table", "particle.springTo(point, k, length) typeof argument 'point' should be a table with at least x and y field")
        assert(type(k) == "number", "particle.springTo(point, k, length) typeof argument 'k' should be a number")
        if(length ~= nil) then
            assert(type(length) == "number", "particle.springTo(point, k, length) typeof argument 'length' should be a number")
        end
        local dx = point.x - particle.x
        local dy = point.y - particle.y
        local distance = math.sqrt(dx * dx + dy * dy)
        local force = k * (distance - length or 0)
        particle.vx = particle.vx + dx / distance * force
        particle.vy = particle.vy + dy / distance * force
    end

    -- Spring to the attached springs
    particle.handleSprings = function()
        for i,spring in ipairs(particle.springs) do
            particle.springTo(spring.point, spring.k, spring.length or 0)
        end
    end
    
    return particle
end

return getParticle