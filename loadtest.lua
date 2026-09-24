-- Load the config exactly as init.lua does, capturing all errors/warnings.
local msgs = {}

-- Intercept vim.notify to catch warnings/errors during load
local orig_notify = vim.notify
vim.notify = function(msg, level, opts)
  msgs[#msgs + 1] = tostring(msg) .. " | level=" .. tostring(level)
  return orig_notify(msg, level, opts)
end

-- Enable strict error propagation by re-defining require to surface load issues
local ok1, e1 = pcall(function() require("core") end)
print("require('core') ok=" .. tostring(ok1) .. (not ok1 and (" err=" .. tostring(e1)) or ""))

local ok2, e2 = pcall(function() require("plugins") end)
print("require('plugins') ok=" .. tostring(ok2) .. (not ok2 and (" err=" .. tostring(e2)) or ""))

local ok3, e3 = pcall(function() require("lsp") end)
print("require('lsp') ok=" .. tostring(ok3) .. (not ok3 and (" err=" .. tostring(e3)) or ""))

local ok4, e4 = pcall(function() require("tools") end)
print("require('tools') ok=" .. tostring(ok4) .. (not ok4 and (" err=" .. tostring(e4)) or ""))

local ok5, e5 = pcall(function() require("ui") end)
print("require('ui') ok=" .. tostring(ok5) .. (not ok5 and (" err=" .. tostring(e5)) or ""))

print("---- notifications during load ----")
for _, m in ipairs(msgs) do
  print(m)
end
