local import = ...
local font = import("font")

local floor = math.floor

local draw = {}

local set, hline
local W, H = 0, 0

function draw.bind(backend, w, h)
    set, hline, W, H = backend.set, backend.hline, w, h
end

local function span(x0, x1, y, c)
    if y < 0 or y >= H then return end
    if x0 > x1 then x0, x1 = x1, x0 end
    if x0 < 0 then x0 = 0 end
    if x1 >= W then x1 = W - 1 end
    if x0 <= x1 then hline(x0, x1, y, c) end
end

local function plot(x, y, c)
    if x >= 0 and x < W and y >= 0 and y < H then set(x, y, c) end
end

function draw.putpixel(x, y, color)
    plot(floor(x), floor(y), color)
end

function draw.set_background(color)
    local x1 = W - 1
    for y = 0, H - 1 do
        hline(0, x1, y, color)
    end
end

draw.clear = draw.set_background

function draw.draw_hline(x1, x2, y, color)
    span(floor(x1), floor(x2), floor(y), color)
end

function draw.draw_vline(x, y1, y2, color)
    x, y1, y2 = floor(x), floor(y1), floor(y2)
    if x < 0 or x >= W then return end
    if y1 > y2 then y1, y2 = y2, y1 end
    if y1 < 0 then y1 = 0 end
    if y2 >= H then y2 = H - 1 end
    for y = y1, y2 do
        set(x, y, color)
    end
end

function draw.draw_line(x1, y1, x2, y2, color)
    x1, y1, x2, y2 = floor(x1), floor(y1), floor(x2), floor(y2)
    if y1 == y2 then return span(x1, x2, y1, color) end

    local dx = x2 > x1 and x2 - x1 or x1 - x2
    local dy = y2 > y1 and y2 - y1 or y1 - y2
    local sx = x1 < x2 and 1 or -1
    local sy = y1 < y2 and 1 or -1
    local err = dx - dy

    while true do
        plot(x1, y1, color)
        if x1 == x2 and y1 == y2 then break end
        local e2 = 2 * err
        if e2 > -dy then
            err = err - dy
            x1 = x1 + sx
        end
        if e2 < dx then
            err = err + dx
            y1 = y1 + sy
        end
    end
end

function draw.draw_rectangle(x, y, width, height, color, fill)
    x, y, width, height = floor(x), floor(y), floor(width), floor(height)
    if width < 0 then x, width = x + width, -width end
    if height < 0 then y, height = y + height, -height end
    if width == 0 or height == 0 then return end

    local x2, y2 = x + width - 1, y + height - 1

    if fill then
        local top, bottom = y < 0 and 0 or y, y2 >= H and H - 1 or y2
        for row = top, bottom do
            span(x, x2, row, fill)
        end
    end

    if color then
        span(x, x2, y, color)
        span(x, x2, y2, color)
        draw.draw_vline(x, y, y2, color)
        draw.draw_vline(x2, y, y2, color)
    end
end

function draw.fill_rect(x, y, width, height, color)
    draw.draw_rectangle(x, y, width, height, nil, color)
end

function draw.draw_circle(xc, yc, r, color, fill)
    xc, yc, r = floor(xc), floor(yc), floor(r)
    if r <= 0 then return plot(xc, yc, color or fill) end

    local x, y, d = 0, r, 3 - 2 * r
    while y >= x do
        if fill then
            span(xc - x, xc + x, yc + y, fill)
            span(xc - x, xc + x, yc - y, fill)
            span(xc - y, xc + y, yc + x, fill)
            span(xc - y, xc + y, yc - x, fill)
        end
        if color then
            plot(xc + x, yc + y, color)
            plot(xc - x, yc + y, color)
            plot(xc + x, yc - y, color)
            plot(xc - x, yc - y, color)
            plot(xc + y, yc + x, color)
            plot(xc - y, yc + x, color)
            plot(xc + y, yc - x, color)
            plot(xc - y, yc - x, color)
        end
        if d > 0 then
            y = y - 1
            d = d + 4 * (x - y) + 10
        else
            d = d + 4 * x + 6
        end
        x = x + 1
    end
end

local function edge_x(xa, ya, xb, yb, y)
    if ya == yb then return xa end
    return xa + (xb - xa) * (y - ya) / (yb - ya)
end

function draw.draw_triangle(x1, y1, x2, y2, x3, y3, color, fill)
    if fill then
        local ax, ay, bx, by, cx, cy = floor(x1), floor(y1), floor(x2), floor(y2), floor(x3), floor(y3)
        if ay > by then ax, ay, bx, by = bx, by, ax, ay end
        if by > cy then bx, by, cx, cy = cx, cy, bx, by end
        if ay > by then ax, ay, bx, by = bx, by, ax, ay end

        local top, bottom = ay < 0 and 0 or ay, cy >= H and H - 1 or cy
        for y = top, bottom do
            local xl = edge_x(ax, ay, cx, cy, y)
            local xr
            if y < by then
                xr = edge_x(ax, ay, bx, by, y)
            else
                xr = edge_x(bx, by, cx, cy, y)
            end
            span(floor(xl + 0.5), floor(xr + 0.5), y, fill)
        end
    end

    if color then
        draw.draw_line(x1, y1, x2, y2, color)
        draw.draw_line(x2, y2, x3, y3, color)
        draw.draw_line(x3, y3, x1, y1, color)
    end
end

function draw.draw_polygon(points, color, fill)
    local n = #points
    if n < 6 then return end

    if fill then
        local ymin, ymax = math.huge, -math.huge
        for i = 2, n, 2 do
            local y = points[i]
            if y < ymin then ymin = y end
            if y > ymax then ymax = y end
        end
        ymin = math.max(floor(ymin), 0)
        ymax = math.min(floor(ymax), H - 1)

        local xs = {}
        for y = ymin, ymax do
            local yc, count = y + 0.5, 0
            local xa, ya = points[n - 1], points[n]
            for i = 1, n, 2 do
                local xb, yb = points[i], points[i + 1]
                if (ya <= yc) ~= (yb <= yc) then
                    count = count + 1
                    xs[count] = xa + (yc - ya) * (xb - xa) / (yb - ya)
                end
                xa, ya = xb, yb
            end
            for i = count + 1, #xs do xs[i] = nil end
            table.sort(xs)
            for i = 1, count - 1, 2 do
                span(floor(xs[i] + 0.5), floor(xs[i + 1] - 0.5), y, fill)
            end
        end
    end

    if color then
        local xa, ya = points[n - 1], points[n]
        for i = 1, n, 2 do
            draw.draw_line(xa, ya, points[i], points[i + 1], color)
            xa, ya = points[i], points[i + 1]
        end
    end
end

function draw.draw_char(x, y, char, color, scale)
    scale = scale or 1
    x, y = floor(x), floor(y)
    local pixels = font.glyph(char)
    if scale == 1 then
        for i = 1, #pixels, 2 do
            plot(x + pixels[i], y + pixels[i + 1], color)
        end
    else
        for i = 1, #pixels, 2 do
            draw.draw_rectangle(x + pixels[i] * scale, y + pixels[i + 1] * scale, scale, scale, nil, color)
        end
    end
end

function draw.draw_text(x, y, text, color, scale)
    scale = scale or 1
    text = tostring(text)
    local cx = x
    for i = 1, #text do
        local char = text:sub(i, i)
        if char == "\n" then
            cx = x
            y = y + font.LINE_HEIGHT * scale
        else
            if char ~= " " then draw.draw_char(cx, y, char, color, scale) end
            cx = cx + font.ADVANCE * scale
        end
    end
end

function draw.text_size(text, scale)
    return font.measure(tostring(text), scale)
end

return draw
