local import = ...
local env = import("env")
local table = import("table")
local json = import("json")

local Logger = {}
Logger.Enabled = tonumber(env:Get("DEV", 1)) == 1

Logger.LogLevel = tonumber(env:Get("LOG_LEVELS", Logger.Enabled and 3 or 0))

local LOG_LEVELS = {
    ERROR = 0,
    WARN = 1,
    INFO = 2,
    TRACE = 3
}

local ANSI = {
    RED = "\27[31m",
    GREEN = "\27[32m",
    YELLOW = "\27[33m",
    CYAN = "\27[36m",
    MAGENTA = "\27[35m",
    GREY = "\27[90m",
    RESET = "\27[0m"
}

local function parseArguments(...)
    local arguments = {...}
    local parsedArguments = {}

    for _,v in pairs(arguments) do
        if type(v) == "table" then
            parsedArguments[#parsedArguments + 1] = table.ToString(v)
        else
            parsedArguments[#parsedArguments + 1] = tostring(v)
        end
    end

    return parsedArguments
end

function Logger:error(module, ...)
    if self.LogLevel < LOG_LEVELS.ERROR then return end

    print(ANSI.RED .. "[ERROR] " .. ANSI.CYAN .. "[" .. string.upper(module) .. "] > " .. ANSI.RESET .. table.concat(parseArguments(...), " ") .. ANSI.RESET)
end

function Logger:warn(module, ...)
    if not self.Enabled then return end
    if self.LogLevel < LOG_LEVELS.WARN then return end

    print(ANSI.YELLOW .. "[WARN] " .. ANSI.CYAN .. "[" .. string.upper(module) .. "] > " .. ANSI.RESET .. table.concat(parseArguments(...), " ") .. ANSI.RESET)
end

function Logger:info(module, ...)
    if not self.Enabled then return end
    if self.LogLevel < LOG_LEVELS.INFO then return end

    print(ANSI.GREEN .. "[INFO] " .. ANSI.CYAN .. "[" .. string.upper(module) .. "] > " .. ANSI.RESET .. table.concat(parseArguments(...), " ") .. ANSI.RESET)
end

function Logger:trace(module, ...)
    if not self.Enabled then return end
    if self.LogLevel < LOG_LEVELS.TRACE then return end

    print(ANSI.GREY .. "[TRACE] " .. ANSI.CYAN .. "[" .. string.upper(module) .. "] > " .. ANSI.RESET .. table.concat(parseArguments(...), " ") .. ANSI.RESET)
end

function Logger:debug(data)
    local function cpy(t)
        local seen = {}
        local function _cpy(t)
            if type(t) ~= "table" then
                return tostring(t)
            elseif seen[t] then
                return seen[t]
            end
            local s = {}
            seen[t] = s
            for k, v in pairs(t) do
                s[_cpy(k)] = _cpy(v)
            end
            return setmetatable(s, getmetatable(t))
        end
        return _cpy(t)
    end
    print(json.encode(cpy(data), { indent = true }))
end

return Logger
