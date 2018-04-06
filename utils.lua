local utils = {}

-- Normalization
-- Taking a range of values and a value withinh that range
-- and converting that value to a number between 0 to 1
-- that indicate where the value lies within that range
-- @param<number> value
-- @param<number> min
-- @param<number> max
-- @return<number>
utils.norm = function(value, min, max) 
    return (value - min) / (max - min)
end

-- Liner interpolation, is the exact opposite of normalization
-- we start with a range and a normalized value
-- and it will return the value in that range that the normalized value points to
-- @param<number> norm: normalized value
-- @param<number> min
-- @param<number> max
-- @return<number>
utils.lerp = function(norm, min, max)
    return (max - min) * norm + min
end

-- Map is combining normalization and linear interpolation
-- to map a value from one range to a value in another Range
-- @param<number> value: a value within the source range
-- @param<number> srcMin: minimum value of the source range
-- @param<number> srcMax: maximum value of the source range
-- @param<number> dstMin: minimum value of the destination range
-- @param<number> dstMax: maximum value of the destination range
-- @return<number> 
utils.map = function(value, srcMin, srcMax, dstMin, dstMax)
    return utils.lerp(utils.norm(value, srcMin, srcMax), dstMin, dstMax)
end

-- Ensure that a value stays within a range 
-- @param<number> value
-- @param<number> min
-- @param<number> max
-- @return<number> 
utils.clamp = function(value, min, max)
    return math.max(math.min(min, max), math.min(value, math.max(min, max)))
end

-- Check if a value is within a (min -> max) range
-- @param<number> v
-- @param<number> min
-- @param<number> max
-- @return<boolean>
utils.inRange = function(v, min, max)
    local result = v >= math.min(min, max) and v <= math.max(min, max)
    return result
end

-- Check intersection of two ranges
-- @param<table{min<number>, max<number>}>
-- @param<table{min<number>, max<number>}>
-- @return<boolean>
utils.rangeIntersect = function(rng0, rng1)
    return math.max(rng0.max, rng0.min) >= math.min(rng1.min, rng1.max) and math.min(rng0.min, rng0.max) <= math.max(rng1.max, rng1.min)  
end

-- Get the distance between two points
-- @param<{x<number>, y<number>}> p0 
-- @param<{x<number>, y<number>}> p1
-- @return<number>
utils.distance = function(p0, p1)
    return math.sqrt(math.pow(p0.x - p1.x, 2) + math.pow(p0.y - p1.y, 2))
end

-- Round a decimal number
-- @param<number> value
-- @return<number>
utils.round = function(value)
    return math.floor(value + 0.5)
end

-- Round a number to the given number of decimal places
-- @param<number> value
-- @param<number> places
-- @return<number>
utils.roundToPlaces = function(value, places)
    local mult = math.pow(10, places or 0)
    return utils.round(value * mult) / mult
end

-- Round a value to a multiple of 'nearest' (Used for a snap to grid function for example)
-- @param<number> value
-- @param<number> nearest
-- @return<number>
utils.roundNearest = function(value, nearest)
    return utils.round(value / nearest) * nearest
end

-- Get a random number(float) between min(inclusive) and max(exclusive)
-- @param<number> min
-- @param<number> max
-- @return<number>
utils.randomRange = function(min, max)
    return min + math.random() * (max - min)
end

-- Get a random number(integer) between min(inclusive) and max(inclusive)
-- @param<number> min
-- @param<number> max
-- @return<number>
utils.randomInt = function(min, max)
    return math.floor(min + math.random() * (max - min + 1))
end

-- Random distribution (alsoo known as Normal distribution)
-- Given a range and a number of iterations, get the average of the random generated numbers
-- The average is most likely be closer to the mid range than the edges
-- @param<number> min
-- @param<number> max
-- @param<number> iterations
utils.randomDist = function(min, max, iterations)
    local total = 0
    for i = 1, iterations do
        total = total + utils.randomRange(min, max)
    end
    return total / iterations
end

-- Convert degrees to radians
-- @param<number> degrees
-- @return<number
utils.degToRad = function(degrees)
    return degrees / 180 * math.pi
end

-- Convert radians to degrees
-- @param<number> radians
-- @return<number
utils.radToDeg = function(radians)
    return radians * 180 / math.pi
end

-- [Circle - Circle] collision detection
-- @param<table{x<number>, y<number>, radius<number>}> c0  
-- @param<table{x<number>, y<number>, radius<number>}> c1
-- @return<boolean>
utils.circleCollision = function(c0, c1)
    return utils.distance({x = c0.x, y = c0.y}, {x = c1.x, y = c1.y}) <= c0.radius + c1.radius
end

-- [Circle - Point] collision detection
-- @param<table{x<number>, y<number>, radius<number>}> c
-- @param<table{x,<number>, y<number>}> p
-- @return<boolean>
utils.circlePointCollision = function(c, p)
    return utils.distance({x = c.x, y = c.y}, {x = p.x, y = p.y}) <= c.radius
end

-- [Rectangle - Point] collision detection
-- @param<table{x<number>, y<number>, width<number>, height<number>}> r
-- @param<table{x<number>, y<number>}> p
-- @return<boolean>
utils.rectPointCollision = function(r, p)
    return utils.inRange(p.x, r.x, r.x + r.width) and utils.inRange(p.y, r.y, r.y + r.height)
end

-- [Rectangle - Rectangle] collision detection
-- @param<table{x<number>, y<number>, width<number>, height<number>}> r0
-- @param<table{x<number>, y<number>, width<number>, height<number>}> r1
-- @return<boolean>
utils.rectCollision = function(r0, r1)
    return utils.rangeIntersect({min = r0.x, max = r0.x + r0.width}, {min = r1.x, max = r1.x + r1.width}) and
        utils.rangeIntersect({min = r0.y, max = r0.y + r0.height}, {min = r1.y, max = r1.y + r1.height})
end

-- Get the min and max from a table
-- @param<table> t
-- @return<number>
utils.minmax = function(t)
    local max = -math.huge
    local min = math.huge

    for k,v in pairs(t) do
        max = math.max( max, v )
        min = math.min( min, v )
    end

    return min, max
end

return utils