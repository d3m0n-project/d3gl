local _, MODPATH = ...

local DIR
do
    local path = type(MODPATH) == "string" and MODPATH or debug.getinfo(1, "S").source:gsub("^@", "")
    DIR = path:match("^(.*)[/\\]") or "."
end

local modules = {}

local function import(name)
    local mod = modules[name]
    if mod == nil then
        local path = DIR .. "/" .. (name:gsub("%.", "/")) .. ".lua"
        local chunk, err = loadfile(path)
        if not chunk then
            error("d3gl: cannot load module '" .. name .. "': " .. tostring(err), 2)
        end
        mod = chunk(import)
        if mod == nil then mod = false end
        modules[name] = mod
    end
    return mod
end

local color = import("color")
local draw = import("draw")

local d3gl = {
    _VERSION = "0.2.0",
    import = import,
    color = color,
    Colors = color.Colors,
    rgb = color.rgb,
    rgba = color.rgba,
    hsv = color.hsv,
    hex = color.hex,
    width = 0,
    height = 0,
}

local LAZY = {
    class = "class",
    vec2 = "vec2",
    mathx = "mathx",
    font = "font",
    bit = "bit",
    Timer = "timer",
    logger = "logger",
    json = "json",
    env = "env",
}

setmetatable(d3gl, {
    __index = function(t, key)
        local name = LAZY[key]
        if not name then return nil end
        local mod = import(name)
        rawset(t, key, mod)
        return mod
    end,
})

for name, fn in pairs(draw) do
    if name ~= "bind" then d3gl[name] = fn end
end

local BACKENDS = { "d3m0n", "headless" }

local function select_backend()
    local forced = os and os.getenv and os.getenv("D3GL_BACKEND")
    if forced then
        local backend = import("backends." .. forced)
        assert(backend, "d3gl: backend '" .. forced .. "' is not available here")
        return backend
    end
    for _, name in ipairs(BACKENDS) do
        local backend = import("backends." .. name)
        if backend then return backend end
    end
end

local backend = select_backend()
local initialized = false
local quit_requested = false

d3gl.backend = backend.name

function d3gl.init(w, h, opts)
    assert(not initialized, "d3gl.init() called twice")
    w = w or backend.default_width
    h = h or backend.default_height
    opts = type(opts) == "table" and opts or {}

    local ok, pitch = backend.init(w, h, opts)
    assert(ok, "d3gl: " .. tostring(pitch))

    initialized = true
    d3gl.width, d3gl.height, d3gl.pitch = w, h, pitch
    draw.bind(backend, w, h)

    local seed = backend.random_seed and backend.random_seed()
    if seed then math.randomseed(seed) end
    return d3gl
end

function d3gl.get_size()
    return d3gl.width, d3gl.height
end

function d3gl.update()
    assert(initialized, "d3gl.init() must be called first")
    return backend.present()
end

function d3gl.screenshot(path)
    if not backend.screenshot then
        return nil, "screenshots are not supported by the " .. backend.name .. " backend"
    end
    return backend.screenshot(path)
end

function d3gl.quit()
    quit_requested = true
end

function d3gl.fps()
    return d3gl.timer and d3gl.timer.fps or 0
end

function d3gl.time()
    return d3gl.timer and d3gl.timer.elapsed or 0
end

function d3gl.draw_fps(x, y, fg, bg)
    local text = ("FPS %d"):format(math.floor(d3gl.fps() + 0.5))
    local tw, th = draw.text_size(text)
    draw.draw_rectangle((x or 2) - 1, (y or 2) - 1, tw + 2, th + 2, nil, bg or d3gl.Colors.BLACK)
    draw.draw_text(x or 2, y or 2, text, fg or d3gl.Colors.WHITE)
end

function d3gl.run(app, opts)
    opts = opts or {}
    if not initialized then d3gl.init(opts.width, opts.height, opts) end

    local env_frames = os and os.getenv and tonumber(os.getenv("D3GL_FRAMES"))
    local frames = opts.frames or env_frames or (backend.name == "headless" and 120 or nil)

    local timer = d3gl.Timer(backend, opts.fixed_dt)
    d3gl.timer = timer
    quit_requested = false

    if app.load then app.load() end

    local function finish()
        if app.quit then app.quit() end
        local shot = os and os.getenv and os.getenv("D3GL_SCREENSHOT")
        if shot and shot ~= "" then
            print("d3gl: screenshot saved to " .. tostring(d3gl.screenshot(shot)))
        end
    end

    local function step()
        if quit_requested then return false end
        local dt = timer:tick()
        if app.update then app.update(dt) end
        if app.draw then app.draw() end
        backend.present()
        if frames and timer.frame >= frames then quit_requested = true end
        return true
    end

    while step() do end
    finish()
end

return d3gl
