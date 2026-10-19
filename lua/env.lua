local import = ...

local env = {}

local function readFile(path)
    if not io then return nil end
    local file = io.open(path, "r")
    if not file then return nil end
    local content = file:read("*a")
    file:close()
    return content
end

function env:Load(path)
    local Logger = import("logger")
    path = path or ".env"
    local content = readFile(path)
    if not content then
        Logger:warn("env", path .. " not found")
        return env
    end

    for line in content:gmatch("[^\r\n]+") do
        if not line:match("^%s*#") and line:match("%S") then
            local key, value = line:match("^%s*([%w_]+)%s*=%s*(.-)%s*$")
            if key then
                value = value:gsub('^["\'](.*)["\']$', "%1")
                env[key] = tonumber(value) or value
            end
        end
    end
    Logger:info("env", "variables loaded successfully")
    return env
end

function env:Get(variable, default_value)
    if env[variable] == nil then
        env[variable] = default_value
    end
    return env[variable]
end

return env
