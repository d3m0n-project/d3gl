local import = ...
local class = import("class")

local sqrt, cos, sin, atan2, random = math.sqrt, math.cos, math.sin, math.atan2 or math.atan, math.random

local vec2 = class()

function vec2:init(x, y)
    self.x = x or 0
    self.y = y or 0
end

local function new(x, y)
    return setmetatable({ x = x, y = y }, vec2)
end

vec2.new = new

function vec2.from_angle(angle, length)
    length = length or 1
    return new(cos(angle) * length, sin(angle) * length)
end

function vec2.random(length)
    return vec2.from_angle(random() * 2 * math.pi, length)
end

function vec2.is(v)
    return getmetatable(v) == vec2
end

function vec2.__add(a, b) return new(a.x + b.x, a.y + b.y) end
function vec2.__sub(a, b) return new(a.x - b.x, a.y - b.y) end
function vec2.__unm(a) return new(-a.x, -a.y) end
function vec2.__eq(a, b) return a.x == b.x and a.y == b.y end
function vec2.__tostring(a) return ("vec2(%.3f, %.3f)"):format(a.x, a.y) end

function vec2.__mul(a, b)
    if type(a) == "number" then return new(a * b.x, a * b.y) end
    if type(b) == "number" then return new(a.x * b, a.y * b) end
    return new(a.x * b.x, a.y * b.y)
end

function vec2.__div(a, b)
    if type(b) == "number" then return new(a.x / b, a.y / b) end
    return new(a.x / b.x, a.y / b.y)
end

function vec2:copy() return new(self.x, self.y) end

function vec2:unpack() return self.x, self.y end

function vec2:len2() return self.x * self.x + self.y * self.y end
function vec2:len() return sqrt(self.x * self.x + self.y * self.y) end

function vec2:dist2(o)
    local dx, dy = o.x - self.x, o.y - self.y
    return dx * dx + dy * dy
end

function vec2:dist(o)
    return sqrt(self:dist2(o))
end

function vec2:dot(o) return self.x * o.x + self.y * o.y end

function vec2:cross(o) return self.x * o.y - self.y * o.x end

function vec2:angle() return atan2(self.y, self.x) end

function vec2:normalized() return self:copy():normalize_() end

function vec2:rotated(angle) return self:copy():rotate_(angle) end

function vec2:perp() return new(-self.y, self.x) end

function vec2:set_(x, y)
    self.x, self.y = x, y
    return self
end

function vec2:add_(o)
    self.x, self.y = self.x + o.x, self.y + o.y
    return self
end

function vec2:sub_(o)
    self.x, self.y = self.x - o.x, self.y - o.y
    return self
end

function vec2:add_scaled_(o, k)
    self.x, self.y = self.x + o.x * k, self.y + o.y * k
    return self
end

function vec2:scale_(k)
    self.x, self.y = self.x * k, self.y * k
    return self
end

function vec2:normalize_()
    local l = self:len()
    if l > 0 then
        self.x, self.y = self.x / l, self.y / l
    end
    return self
end

function vec2:set_len_(length)
    return self:normalize_():scale_(length)
end

function vec2:limit_(max)
    local l2 = self:len2()
    if l2 > max * max then
        local k = max / sqrt(l2)
        self.x, self.y = self.x * k, self.y * k
    end
    return self
end

function vec2:rotate_(angle)
    local c, s = cos(angle), sin(angle)
    self.x, self.y = self.x * c - self.y * s, self.x * s + self.y * c
    return self
end

return vec2
