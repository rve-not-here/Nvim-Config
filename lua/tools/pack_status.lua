-- Background vim.pack update check with on-disk cache.
-- vim.pack has no "outdated" API, so we compare each plugin's installed rev
-- against its upstream HEAD via `git ls-remote` (batched, async, deferred so
-- startup stays fast). Result is read by the dashboard section.
local M = {}

M.cache_path = vim.fn.stdpath("state") .. "/pack-updates.json"
M.max_age = 24 * 3600 -- recheck at most once a day
MChecked = false

---@return {count: integer, total: integer, names: string[], checked_at: integer}?
function M.read()
  local f = io.open(M.cache_path, "r")
  if not f then
    return nil
  end
  local ok, data = pcall(vim.json.decode, f:read("*a"))
  f:close()
  if not ok or type(data) ~= "table" then
    return nil
  end
  return data
end

local function write_cache(data)
  local f = io.open(M.cache_path, "w")
  if f then
    f:write(vim.json.encode(data))
    f:close()
  end
end

local function plugin_name(p)
  return (p.spec and p.spec.name) or vim.fn.fnamemodify(p.path, ":t")
end

function M.check(callback)
  local plugins = vim.pack.get()
  local pending = {}
  for _, p in ipairs(plugins) do
    if p.active ~= false and p.path and (p.spec and p.spec.src) then
      pending[#pending + 1] = p
    end
  end
  if #pending == 0 then
    return
  end

  local names, done, running, max_jobs = {}, 0, 0, 8
  local total = #pending
  local pump
  local function finish_one()
    done = done + 1
    running = running - 1
    if done >= total then
      local data = { count = #names, total = total, names = names, checked_at = os.time() }
      write_cache(data)
      MChecked = true
      if callback then
        callback(data)
      elseif #names > 0 then
        vim.schedule(function()
          vim.notify(
            #names .. " plugin update(s): " .. table.concat(names, ", "),
            vim.log.levels.INFO,
            { title = "pack" }
          )
        end)
      end
      return
    end
    pump()
  end
  pump = function()
    while running < max_jobs and #pending > 0 do
      local p = table.remove(pending, 1)
      running = running + 1
      local src = p.spec.src
      vim.system({ "git", "ls-remote", src, "HEAD" }, { text = true }, function(res)
        if res.code == 0 then
          local remote = res.stdout:match("^(%x+)")
          local local_rev = p.rev or ""
          if remote and local_rev ~= "" and remote:sub(1, #local_rev) ~= local_rev then
            names[#names + 1] = plugin_name(p)
          end
        end
        finish_one()
      end)
    end
  end
  pump()
end

function M.maybe_check()
  if MChecked then
    return
  end
  local data = M.read()
  if data and (os.time() - (data.checked_at or 0)) < M.max_age then
    MChecked = true
    return
  end
  -- deferred so it never slows down startup
  vim.defer_fn(function()
    M.check()
  end, 3000)
end

vim.api.nvim_create_user_command("PackCheck", function()
  vim.notify("Checking plugin updates…", vim.log.levels.INFO, { title = "pack" })
  M.check(function(data)
    if data.count == 0 then
      vim.notify("All " .. data.total .. " plugins current", vim.log.levels.INFO, { title = "pack" })
    end
  end)
end, { desc = "Check for plugin updates now" })

return M
