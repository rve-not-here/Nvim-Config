local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd("BufNewFile", {
	group = augroup("csharp_template", { clear = true }),
	pattern = "*.cs",
	callback = function()
		local root = vim.fs.root(0, function(name)
			return name:match("%.csproj$") or name:match("%.sln$")
		end)
		if not root then
			return
		end

		local csproj = vim.fn.glob(root .. "/*.csproj")
		local proj = vim.fn.fnamemodify(csproj, ":t:r")
		local rel = vim.fn.expand("%:p:h"):gsub(vim.pesc(root) .. "/", ""):gsub("/", ".")
		local ns = proj .. (rel ~= "" and "." .. rel or "")
		local cls = vim.fn.expand("%:t:r")

		vim.api.nvim_buf_set_lines(0, 0, 0, false, {
			"namespace " .. ns .. ";",
			"",
			"public class " .. cls,
			"{",
			"    ",
			"}",
		})
		vim.api.nvim_win_set_cursor(0, { 5, 4 })
	end,
})

-- dotnet helpers
local function find_project_root()
	return vim.fs.root(0, function(name)
		return name:match("%.csproj$")
	end) or vim.fn.getcwd()
end

-- Terminal: for run (interactive output)
local function dotnet_cmd(cmd)
	local dir = find_project_root()
	vim.fn.chdir(dir)
	vim.cmd("belowright split | terminal dotnet " .. cmd)
	vim.cmd("resize 15")
	vim.cmd("startinsert")
end
local function dotnet_bg(cmd)
	local dir = find_project_root()
	local output = {}

	vim.fn.jobstart({ "dotnet", cmd }, {
		cwd = dir,
		stdout_buffered = true,
		stderr_buffered = true,
		on_stdout = function(_, data)
			if data then
				vim.list_extend(output, data)
			end
		end,
		on_stderr = function(_, data)
			if data then
				vim.list_extend(output, data)
			end
		end,
		on_exit = function(_, code)
			if code == 0 then
				vim.notify("dotnet " .. cmd .. " succeeded", vim.log.levels.INFO)
			else
				-- Show the actual build errors
				local errors = {}
				for _, line in ipairs(output) do
					if line:match("error CS") then
						table.insert(errors, line)
					end
				end
				if #errors > 0 then
					vim.notify(table.concat(errors, "\n"), vim.log.levels.ERROR, { title = "Build errors" })
				else
					vim.notify("dotnet " .. cmd .. " failed\n" .. table.concat(output, "\n"), vim.log.levels.ERROR)
				end
			end
		end,
	})
end
vim.api.nvim_create_user_command("RoslynDebug", function()
  local clients = vim.lsp.get_clients({ name = "roslyn_ls" })
  if #clients == 0 then
    vim.notify("roslyn_ls not attached", vim.log.levels.WARN)
    return
  end
  local client = clients[1]
  local client_caps = client.config and client.config.capabilities
  local snippet_advertised = vim.tbl_get(client_caps, "textDocument", "completion", "completionItem", "snippetSupport")
  local server_caps = client.server_capabilities
  vim.notify(
    "roslyn_ls: snippetSupport=" .. vim.inspect(snippet_advertised)
    .. " triggerChars=" .. vim.inspect(server_caps.completionProvider and server_caps.completionProvider.triggerCharacters)
    .. " resolveProvider=" .. vim.inspect(server_caps.completionProvider and server_caps.completionProvider.resolveProvider)
    .. " clients(bufnr 0)=" .. vim.inspect(vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients({ bufnr = 0 }))),
    vim.log.levels.INFO
  )
end, { desc = "Debug roslyn LSP capabilities" })

vim.keymap.set("n", "<leader>mr", function()
  dotnet_cmd("run")
end, { desc = "Dotnet run" })
vim.keymap.set("n", "<leader>mb", function()
  dotnet_bg("build")
end, { desc = "Dotnet build" })

-- ═══════════════════════════════════════════════════════════════
-- NEW DOTNET COMMANDS:
-- ═══════════════════════════════════════════════════════════════

-- Run .NET tests (raw terminal)
vim.keymap.set("n", "<leader>mt", function()
	vim.cmd("split | terminal dotnet test")
end, { desc = "Run all tests (dotnet test)" })

-- Watch .NET tests
vim.keymap.set("n", "<leader>mw", function()
	vim.cmd("split | terminal dotnet watch test")
end, { desc = "Watch .NET tests" })

-- Add NuGet package
vim.keymap.set("n", "<leader>mn", function()
	local package = vim.fn.input("Package: ")
	if package ~= "" then
		vim.fn.system("dotnet add package " .. package)
		vim.notify("Added " .. package, vim.log.levels.INFO)
	end
end, { desc = "Add NuGet package" })
