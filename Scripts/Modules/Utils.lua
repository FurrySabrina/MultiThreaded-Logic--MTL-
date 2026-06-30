---@diagnostic disable: lowercase-global
local pack = function(...)
    return { n = select("#", ...), ... }
end

local function fixed_logger(func, ...)
    if not CONFIG.isDebug then return end -- Dont log if debug is off.
    local isServer = sm.isServerMode()
    local begining = "[" .. (isServer and "Server" or "Client") .. "] "
    func(begining, ...)
end

--- Fixes the logging to be more readable.
--- @param ... any
function fPrint(...)
    fixed_logger(print, ...)
end

--- Fixes the logging to be more readable.
--- @param ... any
function fInfo(...)
    fixed_logger(sm.log.info, ...)
end

--- Fixes the logging to be more readable.
--- @param ... any
function fWarn(...)
    fixed_logger(sm.log.warning, ...)
end

--- Fixes the logging to be more readable.
--- @param ... any
function fError(...)
    fixed_logger(sm.log.error, ...)
end
