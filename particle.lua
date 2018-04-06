-- Particle factory function
-- Returns a Particle table
-- @param<number> x
-- @param<number> y
-- @param<number> speed     : the particle velocity's magnitude
-- @param<number> direction : the particle velocity's angle
-- @param<number> grav      : the global gravity magnitude applied to the particle, default to 0
-- @return<Particle>
local function getParticle(x, y, speed, direction, grav)
   
    -- @class Particle
    -- A particle is an entity submitted to forces
    -- It can be initially represented by its position {x, y} and its velocity {vx, vy}
    -- The particle moves when its velocity is added to its position
    -- The particle accelerate when one or multiple forces are added to its velocity 
    -- @field<number> x
    -- @field<number> y
    -- @field<number> vx
    -- @field<number> vy
    -- @field<number> mass       -- very high values to set an attraction field, a particle at a speed of 400 seems to gravitate smoothly to a particle of 30_000_000 mass 
    -- @field<number> radius
    -- @field<number> bounce
    -- @field<number> friction
    -- @field<number> gravity
    -- @field<table> springs      -- springs on which this particle is attached to, empty by default
    -- @field<table> gravitations -- particles to wich this particle gravitate to, empty by default
    local particle = {}
    
    particle.x = x
    particle.y = y
    particle.vx = speed * math.cos(direction)
    particle.vy = speed * math.sin(direction)
    particle.mass = 1             -- particles could gravitate to particles with very high mass
    particle.radius = 0
    particle.bounce = -1          -- -1 means perfect bounce, -0.9 speed is reduced by 10% each bounce
    particle.friction = 0        
    particle.gravity = grav or 0  -- 0 means no gravity is applied
    particle.springs = {}
    particle.gravitations = {}

    -- Get the particle's velocity magnitude
    -- @return<number>
    particle.getSpeed = function()
        return math.sqrt(particle.vx * particle.vx + particle.vy * particle.vy)
    end

    -- Set the particle's velocity magnitude
    -- @param<number> speed
    particle.setSpeed = function(speed)
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
        local speed = math.sqrt(particle.vx * particle.vx + particle.vy * particle.vy)
        particle.vx = math.cos(angle) * speed
        particle.vy = math.sin(angle) * speed
    end

    -- Add an acceleration vector ax, ay to the particle's velocity vx, vy
    -- @param<number> ax
    -- @param<number> ay
    -- @param<number> dt: delta time 
    particle.accelerate = function(ax, ay, dt)
        particle.vx = particle.vx + ax * dt
        particle.vy = particle.vy + ay * dt
    end
    
    -- Update the particle position by applying the velocity, friction and gravity
    -- @param<number> dt: delta time
    particle.update = function(dt)
        -- apply friction
        particle.vx = particle.vx * (1 - particle.friction * dt)
        particle.vy = particle.vy * (1 - particle.friction * dt)
        -- spring to if any
        particle.handleSprings(dt)
        -- gravitate to if any
        particle.handleGravitations(dt)
        -- apply gravity
        particle.vy = particle.vy + particle.gravity * dt
        -- apply velocity
        particle.x = particle.x + particle.vx * dt 
        particle.y = particle.y + particle.vy * dt
    end
   
    -- Get the angle between this particle and another particle
    -- @param<table{x<number}, y<number>}> p
    -- @return<number> 
    particle.angleTo = function(p)
        return math.atan2(p.y - particle.y, p.x - particle.x)
    end

    -- Get the distance between this particle and another particle
    -- @param<table{x<number>, y<number>}> p
    -- @return<number>
    particle.distanceTo = function(p)
        local dx = p.x - particle.x
        local dy = p.y - particle.y
        local dist = math.sqrt(dx * dx + dy * dy)
        return dist
    end

    -- Add a particle to which this particle will gravitate to
    -- @param<table{x<number>, y<number>}> p
    particle.addGravitation = function(p)
        particle.removeGravitation(p)
        particle.gravitations[#particle.gravitations + 1] = p
    end

    -- Remove one element from the gravitations list
    -- @param<table{x<number>, y<number>}>
    particle.removeGravitation = function(p)
        for i,el in ipairs(particle.gravitations) do
            if el == p then
                table.remove(particle.gravitations, i)
                break
            end
        end
    end

    -- If this particle is within the attraction field of another particle then this particle can gravitate to that particle
    -- by accelerating this particle velocity by the attraction vector of the other particle
    -- the attraction magnitude is equal to (the attracting particle mass) / (distance between the two particles) ^ 2
    -- the attraction vector is defined by the attraction magnitude and the angle between the two particles
    -- @param<table{x<number>, y<number>}>
    -- @param<number> dt: delta time
    particle.gravitateTo = function(p, dt)
        local dx = p.x - particle.x
        local dy = p.y - particle.y 
        local distSQ = dx * dx + dy * dy
        local dist = math.sqrt(distSQ)
        local force = p.mass / distSQ
        local ax = force * (dx / dist)
        local ay = force * (dy / dist)
        particle.vx = particle.vx + ax * dt
        particle.vy = particle.vy + ay * dt
    end

    -- Gravitate to the each particle in the gravitations list
    -- @param<number> dt: delta time
    particle.handleGravitations = function(dt)
        for i,p in ipairs(particle.gravitations) do
            particle.gravitateTo(p, dt)
        end
    end

    -- Attach a pring to the particle
    -- @param<table{x<number>, y<number>}> point
    -- @param<number> k: spring stiffness
    -- @param<number> length: spring rest distance
    particle.addSpring = function(point, k, length)
        particle.removeSpring(point)
        particle.springs[#particle.springs + 1] = {point = point, k = k, length = length or 0}
    end

    -- Remove an attached spring
    -- @param<table{x<number>, y<number>}> point
    particle.removeSpring = function(point)
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
    -- @param<number> dt: delta time
    particle.springTo = function(point, k, length, dt)
        local dx = (point.x - particle.x)
        local dy = (point.y - particle.y)
        local distance = math.sqrt(dx * dx + dy * dy)
        local force = k * (distance - length or 0)
        particle.vx = particle.vx + (dx / distance) * force * dt
        particle.vy = particle.vy + (dy / distance) * force * dt
    end

    -- Spring to the attached springs
    -- @param<dt> delta time
    particle.handleSprings = function(dt)
        for i,spring in ipairs(particle.springs) do
            particle.springTo(spring.point, spring.k, spring.length or 0, dt)
        end
    end
    
    return particle
end

return getParticle