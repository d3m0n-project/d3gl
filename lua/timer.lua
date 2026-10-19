local import = ...
local class = import("class")

local MAX_DT = 0.25

local Timer = class()

function Timer:init(backend, fixed_dt)
    self.clock = backend.clock
    self.resolution = backend.clock_resolution or 0
    self.fixed = fixed_dt ~= nil
    self.dt = fixed_dt or 1 / 30
    self.fps = 1 / self.dt
    self.frame = 0
    self.elapsed = 0

    local now = self.clock and self.clock()
    if not now then self.fixed = true end
    self.last = now
    self.window_start, self.window_frames = now, 0
end

function Timer:now()
    return self.clock and self.clock() or nil
end

function Timer:tick()
    self.frame = self.frame + 1

    if not self.fixed then
        local now = self.clock()
        if not now then
            self.fixed = true
        elseif self.resolution > 0 then
            self.window_frames = self.window_frames + 1
            local span = now - self.window_start
            if span >= self.resolution then
                self.fps = self.window_frames / span
                self.dt = math.min(1 / self.fps, MAX_DT)
                self.window_start, self.window_frames = now, 0
            end
        else
            local dt = now - self.last
            self.last = now
            if dt > 0 then
                self.dt = math.min(dt, MAX_DT)
                self.fps = self.fps * 0.9 + (1 / dt) * 0.1
            end
        end
    end

    self.elapsed = self.elapsed + self.dt
    return self.dt
end

return Timer
