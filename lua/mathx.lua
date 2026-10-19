local floor, random, pi = math.floor, math.random, math.pi

local mathx = {
    PI = pi,
    TAU = 2 * pi,
}

function mathx.clamp(v, min, max)
    if v < min then return min end
    if v > max then return max end
    return v
end

function mathx.lerp(a, b, t)
    return a + (b - a) * t
end

function mathx.inverse_lerp(a, b, v)
    if a == b then return 0 end
    return (v - a) / (b - a)
end

function mathx.map(v, in_min, in_max, out_min, out_max)
    return out_min + (out_max - out_min) * mathx.inverse_lerp(in_min, in_max, v)
end

function mathx.wrap(v, min, max)
    local range = max - min
    return min + (v - min) % range
end

function mathx.sign(v)
    if v > 0 then return 1 end
    if v < 0 then return -1 end
    return 0
end

function mathx.round(v)
    if v >= 0 then return floor(v + 0.5) end
    return -floor(-v + 0.5)
end

function mathx.angle_diff(a, b)
    return (b - a + pi) % (2 * pi) - pi
end

function mathx.lerp_angle(a, b, t)
    return a + mathx.angle_diff(a, b) * t
end

function mathx.random_range(min, max)
    return min + random() * (max - min)
end

function mathx.chance(p)
    return random() < p
end

function mathx.pick(list)
    return list[random(#list)]
end

function mathx.dist2(x1, y1, x2, y2)
    local dx, dy = x2 - x1, y2 - y1
    return dx * dx + dy * dy
end

function mathx.dist(x1, y1, x2, y2)
    return math.sqrt(mathx.dist2(x1, y1, x2, y2))
end

return mathx
