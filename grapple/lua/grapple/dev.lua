-- Don't include this file, we should manually include it via
-- require("grapple.dev").reload();
--
-- A quick mapping can be setup using something like:
-- :nmap <leader>rr :lua require("grapple.dev").reload()<CR>
local M = {}

function M.reload()
    require("plenary.reload").reload_module("grapple")
end

local log_levels = { "trace", "debug", "info", "warn", "error", "fatal" }
local function set_log_level()
    local log_level = vim.env.GRAPPLE_LOG or vim.g.grapple_log_level

    for _, level in pairs(log_levels) do
        if level == log_level then
            return log_level
        end
    end

    return "warn" -- default, if user hasn't set to one from log_levels
end

local log_level = set_log_level()
M.log = require("plenary.log").new({
    plugin = "grapple",
    level = log_level,
})

local log_key = os.time()

local function override(key)
    local fn = M.log[key]
    M.log[key] = function(...)
        fn(log_key, ...)
    end
end

for _, v in pairs(log_levels) do
    override(v)
end

function M.get_log_key()
    return log_key
end

return M
