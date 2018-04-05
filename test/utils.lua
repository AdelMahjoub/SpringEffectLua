local utils = require("utils")

local function test()

    assert(type(utils.norm) == "function", "utils.norm should be a function")
    assert(type(utils.lerp) == "function", "utils.lerp should be a function")
    assert(type(utils.map) == "function", "utils.map should be a function")
    assert(type(utils.clamp) == "function", "utils.clamp should be a function")
    assert(type(utils.inRange) == "function", "utils.inRange should be a function")
    assert(type(utils.rangeIntersect) == "function", "utils.rangeIntersect should be a function")
    assert(type(utils.distance) == "function", "utils.distance should be a function")
    assert(type(utils.round) == "function", "utils.round should be a function")
    assert(type(utils.roundToPlaces) == "function", "utils.roundToPlaces should be a function")
    assert(type(utils.roundNearest) == "function", "utils.roundNearest should be a function")
    assert(type(utils.randomRange) == "function", "utils.randomRange should be a function")
    assert(type(utils.randomInt) == "function", "utils.randomInt should be a function")
    assert(type(utils.randomDist) == "function", "utils.randomDist should be a function")
    assert(type(utils.degToRad) == "function", "utils.degToRad should be a function")
    assert(type(utils.radToDeg) == "function", "utils.radToDeg should be a function")
    assert(type(utils.circleCollision), "function", "utils.circleCollision should be a function")
    assert(type(utils.circlePointCollision) == "function", "utils.circlePointCollision should be a function")
    assert(type(utils.rectPointCollision) == "function", "utils.rectPointCollision should be a function")
    assert(type(utils.rectCollision) == "function", "utils.rectCollision should be a function")
    assert(type(utils.minmax) == "function", "utils.minmax should be a function")

    -- utils.norm
    local min = 0
    local max = 33
    local value = 18
    assert(type(utils.norm(18, 0, 33)) == "number", "utils.norm(value, min, max) should return a number")
    assert(utils.norm(18, 0, 33) == (value - min) / (max - min), "utils.norm(value, min, max) should be equal to (value - min) / (max - min)")

    -- utils.lerp
    local norm = 0.37 
    local min = 100
    local max = 450
    assert(type(utils.lerp(norm, min, max)) == "number", "utils.lerp(norm, min, max) should return a number")
    assert(utils.lerp(norm, min, max) == (max - min) * norm + min, "utils.lerp(norm, min, max) should be equal to (max - min) * norm + min")

    -- utils.map
    local value = 320 
    local srcMin = 0
    local srcMax = 600 
    local dstMin = 100 
    local dstMax = 340
    assert(type(utils.map(value, srcMin, srcMax, dstMin, dstMax)) == "number", 
        "utils.map(value, srcMin, srcMax, dstMin, dstMax) should return a number")
    assert(utils.map(value, srcMin, srcMax, dstMin, dstMax) == utils.lerp(utils.norm(value, srcMin, srcMax), dstMin, dstMax), 
        "utils.map(value, srcMin, srcMax, dstMin, dstMax) should return utils.lerp(utils.norm(value, srcMin, srcMax), dstMin, dstMax)")

    -- utils.clamp
    local value = 20
    local min = -5
    local max = 16
    assert(type(utils.clamp(value, min, max)) == "number", "utils.clamp(value, min, max) should return a number")
    assert(utils.clamp(value, min, max) == max, "utils.clamp(20, -5, 16) should return 16")
    value = -60
    min = 0
    max = 10
    assert(utils.clamp(value, min, max) == min, "utils.clamp(-60, 0, 10) should return 0")
    value = 221
    min = -8
    max = 5697
    assert(utils.clamp(value, min, max) == value, "utils.clamp(221, -8, 5697) should return 221")
    value = 221
    min = -82
    max = -5697
    assert(utils.clamp(value, min, max) == min, "utils.clamp(221, -82, -5697) should return -82")

    -- utils.inRange
    value = 20
    min = -5
    max = 16
    assert(type(utils.inRange(value, min, max)) == "boolean", "utils.inRange(v, min, max) should return a boolean")
    assert(utils.inRange(value, min, max) == false, "utils.inRange(20, -5, 16) should return false")
    value = 12369
    min = 4598
    max = 135689
    assert(utils.inRange(value, min, max) == true, "utils.inRange(12369, 4598, 135689) should return true")
    value = -23.69
    min = -568.1258
    max = -2.6595
    assert(utils.inRange(value, min, max) == true, "utils.inRange(-23.69, -568.1258, -2.6595) should return true")

    -- utils.rangeIntersect
    local rng0 = {min = 0, max = 100}
    local rng1 = {min = 10, max = 110}
    assert(type(utils.rangeIntersect(rng0, rng1)) == "boolean", "utils.rangeIntersect(rng0, rng1) should return a boolean")
    assert(utils.rangeIntersect(rng0, rng1) == true, "utils.rangeIntersect({min = 0, max = 100}, {min = 10, max = 110}) should return true")
    rng0 = {min = 20, max = 30}
    rng1 = {min = 40, max = 60}
    assert(utils.rangeIntersect(rng0, rng1) == false, "utils.rangeIntersect({min = 20, max = 30}, {min = 40, max = 60}) should return false")
    rng0 = {min = -18, max = -68}
    rng1 = {min = -17, max = -40}
    assert(utils.rangeIntersect(rng0, rng1) == true, "utils.rangeIntersect({min = -18, max = -68}, {min = -17, max = -40}) should return true")

    -- utils.distance
    local p0 = {x = 1, y = 1}
    local p1 = {x = 2, y = 2}
    assert(type(utils.distance(p0, p1)) == "number", "utils.distance(p0, p1) should return a number")
    assert(utils.distance(p0, p1) == math.sqrt(2), "utils.distance({x = 1, y = 1}, {x = 2, y = 2}}) should return math.sqrt(2)")

    -- utils.round
    local value = 1.256317
    assert(type(utils.round(value)) == "number", "utils.round(value) should return a number")
    assert(utils.round(value) == 1, "utils.round(1.256317) should return 1")

    -- utils.roundToPlaces
    assert(type(utils.roundToPlaces(value)) == "number", "utils.roundToPlaces(value) should return a number")
    assert(utils.roundToPlaces(value) == 1, "utils.roundToPlaces(1.256317) should return 1")
    assert(utils.roundToPlaces(value, 1) == 1.3, "utils.roundToPlaces(1.256317, 1) should return 1.3")
    assert(utils.roundToPlaces(value, 2) == 1.26, "utils.roundToPlaces(1.256317, 2) should return 1.26")
    assert(utils.roundToPlaces(value, 3) == 1.256, "utils.roundToPlaces(1.256317, 3) should return 1.256")

    -- utils.roundNearest
    local nearest = 10
    value = 33.56598
    assert(type(utils.roundNearest(value, nearest)) == "number", "utils.roundNearest(value, nearest) should return a number")
    assert(utils.roundNearest(value, nearest) == 30, "utils.roundNearest(33.56598, 10) should return 30")
    value = 27.126846
    assert(utils.roundNearest(value, nearest) == 30, "utils.roundNearest(27.126846, 10) should return 30")
    value = 4.98729
    assert(utils.roundNearest(value, nearest) == 0, "utils.roundNearest(4.98729, 10) should return 0")
    nearest = 40
    value = 113
    assert(utils.roundNearest(value, nearest) == 120, "utils.roundNearest(113, 40) should return 120")

    -- utils.randomRange
    local min = 10
    local max = 20
    assert(type(utils.randomRange(min, max)) == "number", "utils.randomRange(min, max) should return a number")

    -- utils.randomInt
    local min = 10
    local max = 20
    assert(type(utils.randomInt(min, max)) == "number", "utils.randomInt(min, max) should return a number")

    -- utils.randomDist
    local iterations = 100
    assert(type(utils.randomDist(min, max, iterations)) == "number", "utils.randomDist(min, max, iterations) should return a number")

    -- utils.degToRad
    local angle = 180
    assert(type(utils.degToRad(angle)) == "number", "utils.degToRad(angle) should return a number")
    assert(utils.degToRad(angle) == math.pi, "utils.degToRad(180) should return math.pi")

    -- utils.radToDeg
    angle = math.pi
    assert(type(utils.radToDeg(angle)) == "number", "utils.radToDeg(angle) should return a number")
    assert(utils.radToDeg(angle) == 180, "utils.radToDeg(math.pi) should return 180")
    
    -- utils.circleCollision
    local c0 = {x = 23, y = 35, radius = 20}
    local c1 = {x = 38, y = 57, radius = 40}
    assert(type(utils.circleCollision(c0, c1)) == "boolean", "utils.circleCollision(c0, c1) should return a boolean")
    assert(utils.circleCollision(c0, c1) == true, "utils.circleCollision({x = 23, y = 35, radius = 20}, {x = 38, y = 57, radius = 40}) should return true")
    c1 = {x = 100, y = 200, radius = 40}
    assert(utils.circleCollision(c0, c1) == false, "utils.circleCollision({x = 23, y = 35, radius = 20}, {x = 100, y = 200, radius = 40}) should return false")

    -- utils.circlePointCollision
    local c = {x = 23, y = 35, radius = 20}
    local p = {x = 38, y = 57}
    assert(type(utils.circlePointCollision(c, p)) == "boolean", "utils.circlePointCollision(c, p) should return a boolean")
    assert(utils.circlePointCollision(c, p) == false, "utils.circlePointCollision({x = 23, y = 35, radius = 20}, {x = 38, y = 57}) should return false")

    -- utils.rectPointCollision
    local r = {x = 100, y = 100, width = 50, height = 30}
    local p = {x = 20, y = 20}
    assert(type(utils.rectPointCollision(r, p)) == "boolean", "utils.rectPointCollision(r, p) should return a boolean")
    assert(utils.rectPointCollision(r, p) == false, "utils.rectPointCollision({x = 100, y = 100, width = 50, height = 30}, {x = 20, y = 20}) should return false")
    r = {x = 100, y = 100, width = 50, height = 30}
    p = {x = 120, y = 129}
    assert(utils.rectPointCollision(r, p) == true, "utils.rectPointCollision({x = 100, y = 100, width = 50, height = 30}, {x = 120, y = 129}) should return true")
    r = {x = 100, y = 100, width = -50, height = -40}
    p = {x = 65, y = 60}
    assert(utils.rectPointCollision(r, p) == true, "utils.rectPointCollision({x = 100, y = 100, width = -50, height = -40}, {x = 65, y = 60}) should return true")
    r = {x = 100, y = 100, width = -50, height = -30}
    p = {x = 65, y = 60}
    assert(utils.rectPointCollision(r, p) == false, "utils.rectPointCollision({x = 100, y = 100, width = -50, height = -30}, {x = 65, y = 60}) should return true")

    -- utils.rectCollision
    local r0 = {x = 0, y = 0, width = 10, height = 10}
    local r1 = {x = 5, y = 5, width = 15, height = 15}
    assert(type(utils.rectCollision(r0, r1)) == "boolean", "utils.rectCollision(r0, r1) should return a boolean")
    assert(utils.rectCollision(r0, r1) == true, "utils.rectCollision({x = 0, y = 0, width = 10, height = 10}, {x = 5, y = 5, width = 15, height = 15}) should return true")
    r0 = {x = 0, y = 0, width = 10, height = 10}
    r1 = {x = 23, y = 5, width = 15, height = 15}
    assert(utils.rectCollision(r0, r1) == false, "utils.rectCollision({x = 0, y = 0, width = 10, height = 10}, {x = 23, y = 5, width = 15, height = 15}) should return false")
    r0 = {x = 0, y = 0, width = 10, height = 10}
    r1 = {x = 23, y = 5, width = -15, height = -5}
    assert(utils.rectCollision(r0, r1) == true, "utils.rectCollision({x = 0, y = 0, width = 10, height = 10}, {x = 23, y = 5, width = -15, height = -5}) should return true")

    -- utils.minmax
    local values = {7, 5, 21, 18, 33, 12, 27, 18, 9, 23, 14, 6, 31, 25, 17, 13, 29}
    local min, max = utils.minmax(values)
    assert(type(utils.minmax(values)) == "number", "utils.minmax(t) should return a number")
    assert(min == 5, "utils.minmax({7, 5, 21, 18, 33, 12, 27, 18, 9, 23, 14, 6, 31, 25, 17, 13, 29}), max should be 33")
    assert(max == 33, "utils.minmax({7, 5, 21, 18, 33, 12, 27, 18, 9, 23, 14, 6, 31, 25, 17, 13, 29}), min should be 5")

    print("All utils test passed !")
end

return test