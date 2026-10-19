local import = ...
local color = import("color")

local backend = {
    name = "headless",
    default_width = 320,
    default_height = 448,
    clock_resolution = 0,
}

local buffer, width, height

function backend.init(w, h)
    buffer, width, height = {}, w, h
    local black = color.Colors.BLACK
    for i = 0, w * h - 1 do
        buffer[i] = black
    end
    return true, w * 4
end

function backend.set(x, y, c)
    buffer[y * width + x] = c
end

function backend.hline(x0, x1, y, c)
    local base = y * width
    for i = base + x0, base + x1 do
        buffer[i] = c
    end
end

function backend.present()
    return true
end

function backend.get(x, y)
    return buffer[y * width + x]
end

function backend.clock()
    return os.clock()
end

function backend.random_seed()
    return os.time()
end

function backend.screenshot(path)
    local file = assert(io.open(path, "wb"))
    file:write(("P6\n%d %d\n255\n"):format(width, height))
    local row, char, unpack = {}, string.char, color.unpack
    for y = 0, height - 1 do
        for x = 0, width - 1 do
            local r, g, b = unpack(buffer[y * width + x])
            row[x + 1] = char(r, g, b)
        end
        file:write(table.concat(row))
    end
    file:close()
    return path
end

return backend
