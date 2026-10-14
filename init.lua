local d3gl = {}
local sys = require("sys")

d3gl.Colors = {
    BLACK = 0xff000000,
    WHITE = 0xffffffff,
    RED   = 0xff0000ff,
    BLUE  = 0xffff0000,
    GREEN = 0xff00ff00,
}

local surface
local width
local height
local pitch

function d3gl.init(w, h)
    local addr, p, ret = sys.surface_create(w, h)

    assert(ret == 0 and addr ~= nil, "surface creation failed")

    surface = addr
    width = w
    height = h
    pitch = p
end

function d3gl.putpixel(x, y, color)
    assert(surface, "d3gl.init() must be called first")
    assert(x >= 0 and x < width, "x out of bounds")
    assert(y >= 0 and y < height, "y out of bounds")

    sys.c_buffer_uint32_set(surface, (y * width + x), color)
end

function d3gl.update()
    assert(surface, "d3gl.init() must be called first")
    return sys.surface_update(surface)
end

return d3gl