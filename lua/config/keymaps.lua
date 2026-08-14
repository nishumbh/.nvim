-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

vim.keymap.set("t", "<esc><esc>", "<C-\\><C-n>")
local function generate_kulala_file_from_db()
	-- ==========================================
	-- 1. Configuration
	-- ==========================================
	local db_name = "latest_vpp"
	local query = "SELECT tag FROM vpp_datatables_datatable ORDER BY tag ASC;"
	local target_dir = vim.fn.getcwd() .. "/api_requests/datatables"

	-- ==========================================
	-- 2. Extract URL from DBUI's custom save path
	-- ==========================================
	local db_url = nil
	local conn_file = "C:/Users/nishumbh.shah/.local/share/db_ui/connections.json"

	local f = io.open(conn_file, "r")
	if f then
		local content = f:read("*a")
		f:close()

		local ok, conns = pcall(vim.fn.json_decode, content)
		if ok and type(conns) == "table" then
			for _, conn in ipairs(conns) do
				if conn.name == db_name then
					db_url = conn.url
					break
				end
			end
		end
	end

	if not db_url then
		vim.notify("Could not find URL for '" .. db_name .. "' in " .. conn_file, vim.log.levels.ERROR)
		return
	end

	-- ==========================================
	-- 3. Wake up Dadbod and Prepare Execution
	-- ==========================================
	local has_lazy, lazy = pcall(require, "lazy")
	if has_lazy then
		pcall(lazy.load, { plugins = { "vim-dadbod", "vim-dadbod-ui" } })
	end

	local cmd_status, cmd = pcall(vim.fn["db#adapter#dispatch"], db_url, "interactive")
	if not cmd_status or type(cmd) ~= "table" then
		vim.notify("Dadbod failed to generate command from URL.", vim.log.levels.ERROR)
		return
	end

	-- Execute
	local exec_status, lines = pcall(vim.fn["db#systemlist"], cmd, query)

	if not exec_status or type(lines) ~= "table" then
		vim.notify("Dadbod execution failed. Check your DB connection.", vim.log.levels.ERROR)
		return
	end

	local tags = {}
	for _, line in ipairs(lines) do
		local clean = vim.trim(line)
		if
			clean ~= ""
			and not clean:match("^-+$")
			and not clean:match("tag_name")
			and not clean:match("^%(%d+ rows%)$")
		then
			table.insert(tags, clean)
		end
	end

	if #tags == 0 then
		vim.notify("Query returned 0 tags.", vim.log.levels.WARN)
		return
	end

	--Launch Telescope & Generate File
	local has_telescope, pickers = pcall(require, "telescope.pickers")
	if not has_telescope then
		vim.notify("Telescope is not available.", vim.log.levels.ERROR)
		return
	end

	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	pickers
		.new({}, {
			prompt_title = "Select Tag to Create .http File",
			finder = finders.new_table({ results = tags }),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)

					if selection then
						local tag = selection[1]

						local safe_filename = tag:gsub("[^%w%-_]", "_") .. ".http"
						local filepath = target_dir .. "/" .. safe_filename

						if vim.fn.filereadable(filepath) == 1 then
							vim.notify("File already exists. Opening: " .. safe_filename, vim.log.levels.INFO)
							vim.cmd("edit " .. filepath)
							return
						end

						vim.fn.mkdir(target_dir, "p")
						vim.fn.mkdir(vim.fn.getcwd() .. "/api_requests/outputs/" .. tag:gsub("[^%w%-_]", "_"), "p")

						local file = io.open(filepath, "w")
						if file then
							-- ==========================================
							-- UPDATED TEMPLATE HERE
							-- ==========================================
							local tag_name = tag:gsub("[^%w%-_]", "_")

							-- We use __TAG__ because it is harder for hidden characters to break
							local file_data = [[
### __TAG__
import login.http

run #LOGIN

@tag = __TAG__

GET {{DATATABLE_URL}}/{{tag}}/
Accept: application/json
Content-Type: application/json
Authorization: Bearer {{LOGIN.response.body.data[0].access}}

>>! ../outputs/{{tag}}/{{tag}}-{{$timestamp}}.json
]]

							-- Perform the replacement
							local final_content = file_data:gsub("__TAG__", tag_name)

							-- DEBUG: Check if it worked in your :messages
							print("Replacing with: " .. tag_name)

							file:write(final_content)
							file:close()
							vim.notify("Created new Kulala request: " .. safe_filename, vim.log.levels.INFO)

							vim.cmd("edit " .. filepath)
						else
							vim.notify("Failed to create file at: " .. filepath, vim.log.levels.ERROR)
						end
					end
				end)
				return true
			end,
		})
		:find()
end

vim.keymap.set("n", "<leader>kt", generate_kulala_file_from_db, { desc = "Generate .http file from DB Tag" })

vim.keymap.set("x", "J", ":move '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("x", "K", ":move '<-2<CR>gv=gv", { desc = "Move selection up" })
-- Override <leader>e to open oil.nvim
vim.keymap.set("n", "<leader>E", function()
	require("oil").open()
end, { desc = "Open Oil file explorer" })
