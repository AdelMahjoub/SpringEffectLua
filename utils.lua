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
    assert(type(value) == "number", "utils.norm(v, min, max) type of argument 'v' should be a number")
    assert(type(min) == "number", "utils.norm(v, min, max) type of argument 'min' should be a number")
    assert(type(max) == "number", "utils.norm(v, min, max) type of argument 'max' should be a number")
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
    assert(type(norm) == "number", "utils.lerp(norm, min, max) type of argument 'norm' should be a number")
    assert(type(min) == "number", "utils.lerp(norm, min, max) type of argument 'min' should be a number")
    assert(type(max) == "number", "utils.lerp(norm, min, max) type of argument 'max' should be a number")
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
    assert(type(value) == "number", "utils.map(value, srcMin, srcMax, dstMin, dstMax) type of argument 'value' should be a number")
    assert(type(srcMin) == "number", "utils.map(value, srcMin, srcMax, dstMin, dstMax) type of argument 'srcMin' should be a number")
    assert(type(srcMax) == "number", "utils.map(value, srcMin, srcMax, dstMin, dstMax) type of argument 'srcMax' should be a number")
    assert(type(dstMin) == "number", "utils.map(value, srcMin, srcMax, dstMin, dstMax) type of argument 'dstMin' should be a number")
    assert(type(dstMax) == "number", "utils.map(value, srcMin, srcMax, dstMin, dstMax) type of argument 'dstMax' should be a number")
    return utils.lerp(utils.norm(value, srcMin, srcMax), dstMin, dstMax)
end

-- Ensure that a value stays within a range 
-- @param<number> value
-- @param<number> min
-- @param<number> max
-- @return<number> 
utils.clamp = function(value, min, max)
    assert(type(value) == "number", "utils.clamp(value, min, max) type of argument 'value' should be a number")
    assert(type(min) == "number", "utils.clamp(value, min, max) type of argument 'min' should be a number")
    assert(type(max) == "number", "utils.clamp(value, min, max) type of argument 'max' should be a number")
    return math.max(math.min(min, max), math.min(value, math.max(min, max)))
end

-- Check if a value is within a (min -> max) range
-- @param<number> v
-- @param<number> min
-- @param<number> max
-- @return<boolean>
utils.inRange = function(v, min, max)
    assert(type(v) == "number", "utils.inRange(v, min, max) typeof argument 'v' should be a number")
    assert(type(min) == "number", "utils.inRange(v, min, max) typeof argument 'min' should be a number")
    assert(type(max) == "number", "utils.inRange(v, min, max) typeof argument 'max' should be a number")
    local result = v >= math.min(min, max) and v <= math.max(min, max)
    return result
end

-- Check intersection of two ranges
-- @param<table{min<number>, max<number>}>
-- @param<table{min<number>, max<number>}>
-- @return<boolean>
utils.rangeIntersect = function(rng0, rng1)
    assert(type(rng0) == "table", "utils.rangeIntersect(rng0, rng1) typeof argument 'rng0' should be a table with at least min and max fields")
    assert(type(rng1) == "table", "utils.rangeIntersect(rng0, rng1) typeof argument 'rng1' should be a table with at least min and max fields")
    assert(type(rng0.min) == "number", "utils.rangeIntersect(rng0, rng1) rng0.min should be a number")
    assert(type(rng0.max) == "number", "utils.rangeIntersect(rng0, rng1) rng0.max should be a number")
    assert(type(rng1.min) == "number", "utils.rangeIntersect(rng0, rng1) rng1.min should be a number")
    assert(type(rng1.max) == "number", "utils.rangeIntersect(rng0, rng1) rng1.max should be a number")
    return math.max(rng0.max, rng0.min) >= math.min(rng1.min, rng1.max) and math.min(rng0.min, rng0.max) <= math.max(rng1.max, rng1.min)  
end

-- Get the distance between two points
-- @param<{x<number>, y<number>}> p0 
-- @param<{x<number>, y<number>}> p1
-- @return<number>
utils.distance = function(p0, p1)
    assert(type(p0) == "table", "utils.distance(p0, p1) type of argument 'p0' should be a number")
    assert(type(p1) == "table", "utils.distance(p0, p1) type of argument 'p1' should be a number")
    assert(type(p0.x) == "number", "utils.distance(p0, p1) type of 'p0.x' should be a number")
    assert(type(p0.y) == "number", "utils.distance(p0, p1) type of 'p0.y' should be a number")
    assert(type(p1.x) == "number", "utils.distance(p0, p1) type of 'p1.x' should be a number")
    assert(type(p1.y) == "number", "utils.distance(p0, p1) type of 'p1.y' should be a number")
    return math.sqrt(math.pow(p0.x - p1.x, 2) + math.pow(p0.y - p1.y, 2))
end

-- Round a decimal number
-- @param<number> value
-- @return<number>
utils.round = function(value)
    assert(type(value) == "number", "utils.round(v, decimalPlaces) type of 'v' should be a number")
    return math.floor(value + 0.5)
end

-- Round a number to the given number of decimal places
-- @param<number> value
-- @param<number> places
-- @return<number>
utils.roundToPlaces = function(value, places)
    if places ~= nil then
        assert(type(places) == "number", "utils.roundToPlaces(v, places) type of argument 'places' should be a number")
    end
    assert(type(value) == "number", "utils.roundToPlaces(v, decimalPlaces) type of 'v' should be a number")
    local mult = math.pow(10, places or 0)
    return utils.round(value * mult) / mult
end

-- Round a value to a multiple of 'nearest' (Used for a snap to grid function for example)
-- @param<number> value
-- @param<number> nearest
-- @return<number>
utils.roundNearest = function(value, nearest)
    assert(type(value) == "number", "utils.roundNearest(value, nearest) type of argument 'value' should be a number")
    assert(type(nearest) == "number", "utils.roundNearest(value, nearest) type of argument 'nearest' should be a number")
    return utils.round(value / nearest) * nearest
end

-- Get a random number(float) between min(inclusive) and max(exclusive)
-- @param<number> min
-- @param<number> max
-- @return<number>
utils.randomRange = function(min, max)
    assert(type(min) == "number", "utils.randomRange(min, max) type of argument 'min' should be a number")
    assert(type(max) == "number", "utils.randomRange(min, max) type of argument 'max' should be a number")
    return min + math.random() * (max - min)
end

-- Get a random number(integer) between min(inclusive) and max(inclusive)
-- @param<number> min
-- @param<number> max
-- @return<number>
utils.randomInt = function(min, max)
    assert(type(min) == "number", "utils.randomInt(min, max) type of argument 'min' should be a number")
    assert(type(max) == "number", "utils.randomInt(min, max) type of argument 'max' should be a number")
    return math.floor(min + math.random() * (max - min + 1))
end

-- Random distribution (alsoo known as Normal distribution)
-- Given a range and a number of iterations, get the average of the random generated numbers
-- The average is most likely be closer to the mid range than the edges
-- @param<number> min
-- @param<number> max
-- @param<number> iterations
utils.randomDist = function(min, max, iterations)
    assert(type(min) == "number", "utils.randomDist(min, max, iterations) type of argument 'min' should be a number")
    assert(type(max) == "number", "utils.randomDist(min, max, iterations) type of argument 'max' should be a number")
    assert(type(iterations) == "number", "utils.randomDist(min, max, iterations) type of argument 'iterations' should be a number")
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
    assert(type(degrees) == "number", "utils.degToRad(degrees) type of argument 'degrees' should be a number")
    return degrees / 180 * math.pi
end

-- Convert radians to degrees
-- @param<number> radians
-- @return<number
utils.radToDeg = function(radians)
    assert(type(radians) == "number", "utils.radToDeg(radians) type of argument 'radians' should be a number")
    return radians * 180 / math.pi
end

-- [Circle - Circle] collision detection
-- @param<table{x<number>, y<number>, radius<number>}> c0  
-- @param<table{x<number>, y<number>, radius<number>}> c1
-- @return<boolean>
utils.circleCollision = function(c0, c1)
    assert(type(c0) == "table", "utils.circleCollision(c0, c1) type of argument 'c0' should be a table with at least x, y and radius fields")
    assert(type(c1) == "table", "utils.circleCollision(c0, c1) type of argument 'c1' should be a table with at least x, y and radius fields")
    assert(type(c0.x) == "number", "utils.circleCollision(c0, c1) c0.x should be a number")
    assert(type(c0.y) == "number", "utils.circleCollision(c0, c1) c0.y should be a number")
    assert(type(c0.radius) == "number", "utils.circleCollision(c0, c1) c0.radius should be a number")
    assert(type(c1.x) == "number", "utils.circleCollision(c0, c1) c1.x should be a number")
    assert(type(c1.y) == "number", "utils.circleCollision(c0, c1) c1.y should be a number")
    assert(type(c1.radius) == "number", "utils.circleCollision(c0, c1) c1.radius should be a number")
    return utils.distance({x = c0.x, y = c0.y}, {x = c1.x, y = c1.y}) <= c0.radius + c1.radius
end

-- [Circle - Point] collision detection
-- @param<table{x<number>, y<number>, radius<number>}> c
-- @param<table{x,<number>, y<number>}> p
-- @return<boolean>
utils.circlePointCollision = function(c, p)
    assert(type(c) == "table", "utils.circlePointCollision(c, p) type of argument 'c' should be a table with at least x, y and radius fields")
    assert(type(p) == "table", "utils.circlePointCollision(c, p) type of argument 'p' should be a table with at least x, y fields")
    assert(type(c.x) == "number", "utils.circlePointCollision(c, p) c.x should be a number")
    assert(type(c.y) == "number", "utils.circlePointCollision(c, p) c.y should be a number")
    assert(type(c.radius) == "number", "utils.circlePointCollision(c, p) c.radius should be a number")
    assert(type(p.x) == "number", "utils.circlePointCollision(c, p) p.x should be a number")
    assert(type(p.y) == "number", "utils.circlePointCollision(c, p) p.y should be a number")
    return utils.distance({x = c.x, y = c.y}, {x = p.x, y = p.y}) <= c.radius
end

-- [Rectangle - Point] collision detection
-- @param<table{x<number>, y<number>, width<number>, height<number>}> r
-- @param<table{x<number>, y<number>}> p
-- @return<boolean>
utils.rectPointCollision = function(r, p)
    assert(type(r) == "table", "utils.rectPointCollision(r, p) typeof argument r should be a table with at least x, y, width, height fields")
    assert(type(p) == "table", "utils.rectPointCollision(r, p) typeof argument p should be a table with at least x, y")
    assert(type(r.x) == "number", "utils.rectPointCollision(r, p) r.x should be a number")
    assert(type(r.y) == "number", "utils.rectPointCollision(r, p) r.y should be a number")
    assert(type(r.width) == "number", "utils.rectPointCollision(r, p) r.width should be a number")
    assert(type(r.height) == "number", "utils.rectPointCollision(r, p) r.height should be a number")
    assert(type(p.x) == "number", "utils.rectPointCollision(r, p) p.x should be a number")
    assert(type(p.y) == "number", "utils.rectPointCollision(r, p) p.x should be a number")
    return utils.inRange(p.x, r.x, r.x + r.width) and utils.inRange(p.y, r.y, r.y + r.height)
end

-- [Rectangle - Rectangle] collision detection
-- @param<table{x<number>, y<number>, width<number>, height<number>}> r0
-- @param<table{x<number>, y<number>, width<number>, height<number>}> r1
-- @return<boolean>
utils.rectCollision = function(r0, r1)
    assert(type(r0) == "table", "utils.rectCollision(r0, r1) typeof r0 should be a table with at least x, y, width, height fields")
    assert(type(r1) == "table", "utils.rectCollision(r0, r1) typeof r1 should be a table with at least x, y, width, height fields")
    assert(type(r0.x) == "number", "utils.rectCollision(r0, r1) r0.x should be a number")
    assert(type(r0.y) == "number", "utils.rectCollision(r0, r1) r0.y should be a number")
    assert(type(r0.width) == "number", "utils.rectCollision(r0, r1) r0.width should be a number")
    assert(type(r0.height) == "number", "utils.rectCollision(r0, r1) r0.height should be a number")
    assert(type(r1.x) == "number", "utils.rectCollision(r0, r1) r1.x should be a number")
    assert(type(r1.y) == "number", "utils.rectCollision(r0, r1) r1.y should be a number")
    assert(type(r1.width) == "number", "utils.rectCollision(r0, r1) r1.width should be a number")
    assert(type(r1.height) == "number", "utils.rectCollision(r0, r1) r1.height should be a number")
    return utils.rangeIntersect({min = r0.x, max = r0.x + r0.width}, {min = r1.x, max = r1.x + r1.width}) and
        utils.rangeIntersect({min = r0.y, max = r0.y + r0.height}, {min = r1.y, max = r1.y + r1.height})
end

-- Get the min and max from a table
-- @param<table> t
-- @return<number>
utils.minmax = function(t)
    assert(type(t) == "table", "utils.minmax(t) type of argument 't' should be a table")
    local max = -math.huge
    local min = math.huge

    for k,v in pairs(t) do
        assert(type(v) == "number", "utils.minmax(t) 't' should contain numbers")
        max = math.max( max, v )
        min = math.min( min, v )
    end

    return min, max
end

return utils