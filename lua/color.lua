local import = ...
local bit = import("bit")

local band, bor, lshift, rshift = bit.band, bit.bor, bit.lshift, bit.rshift
local floor = math.floor

local color = {}

local function byte(v)
    v = floor(v + 0.5)
    if v < 0 then return 0 end
    if v > 255 then return 255 end
    return v
end

function color.rgba(r, g, b, a)
    return bor(bor(lshift(byte(a or 255), 24), lshift(byte(b), 16)), bor(lshift(byte(g), 8), byte(r)))
end

color.rgb = color.rgba

function color.unpack(c)
    return band(c, 0xff), band(rshift(c, 8), 0xff), band(rshift(c, 16), 0xff), band(rshift(c, 24), 0xff)
end

function color.rgbf(r, g, b, a)
    return color.rgba(r * 255, g * 255, b * 255, (a or 1) * 255)
end

function color.hex(hex)
    hex = hex:gsub("^#", "")
    if #hex == 3 then
        hex = hex:gsub(".", "%0%0")
    end
    assert(#hex == 6 or #hex == 8, "invalid hex color")
    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)
    local a = #hex == 8 and tonumber(hex:sub(7, 8), 16) or 255
    return color.rgba(r, g, b, a)
end

function color.hsv(h, s, v, a)
    h = (h % 360) / 60
    local i = floor(h)
    local f = h - i
    local p = v * (1 - s)
    local q = v * (1 - s * f)
    local t = v * (1 - s * (1 - f))
    local r, g, b
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    else r, g, b = v, p, q end
    return color.rgba(r * 255, g * 255, b * 255, a)
end

function color.lerp(c1, c2, t)
    local r1, g1, b1, a1 = color.unpack(c1)
    local r2, g2, b2, a2 = color.unpack(c2)
    return color.rgba(r1 + (r2 - r1) * t, g1 + (g2 - g1) * t, b1 + (b2 - b1) * t, a1 + (a2 - a1) * t)
end

function color.scale(c, k)
    local r, g, b, a = color.unpack(c)
    return color.rgba(r * k, g * k, b * k, a)
end

function color.with_alpha(c, a)
    local r, g, b = color.unpack(c)
    return color.rgba(r, g, b, a)
end

function color.tostring(c)
    return string.format("#%02x%02x%02x%02x", color.unpack(c))
end

color.Colors = {
    BLACK     = color.rgb(0, 0, 0),
    WHITE     = color.rgb(255, 255, 255),
    GREY      = color.rgb(128, 128, 128),
    DARK_GREY = color.rgb(48, 48, 48),
    RED       = color.rgb(255, 0, 0),
    GREEN     = color.rgb(0, 255, 0),
    BLUE      = color.rgb(0, 0, 255),
    YELLOW    = color.rgb(255, 255, 0),
    CYAN      = color.rgb(0, 255, 255),
    MAGENTA   = color.rgb(255, 0, 255),
    ORANGE    = color.rgb(255, 128, 0),
    PURPLE    = color.rgb(128, 0, 255),
    PINK      = color.rgb(255, 128, 255),
    TRANSPARENT = color.rgba(0, 0, 0, 0),
}

return color
