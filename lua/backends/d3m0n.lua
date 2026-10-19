local ok, sys = pcall(require, "sys")
if not ok or type(sys) ~= "table" or not sys.surface_create then
    return nil
end

local bufset = sys.c_buffer_uint32_set

local backend = {
    name = "d3m0n",
    default_width = 320,
    default_height = 448,
}

local surface, width

function backend.init(w, h)
    local addr, pitch, ret = sys.surface_create(w, h)
    if ret ~= 0 or addr == nil then
        return false, "surface creation failed (d3m0n only accepts 320x448)"
    end
    surface, width = addr, w
    return true, pitch
end

function backend.set(x, y, c)
    bufset(surface, y * width + x, c)
end

function backend.hline(x0, x1, y, c)
    local base = y * width
    for i = base + x0, base + x1 do
        bufset(surface, i, c)
    end
end

function backend.present()
    return sys.surface_update(surface) == 0
end

backend.clock_resolution = 1
function backend.clock()
    local t = sys.clock and sys.clock()
    if type(t) ~= "number" or t < 0 then return nil end
    return t
end

function backend.random_seed()
    return sys.random_u32 and sys.random_u32() or nil
end

return backend
