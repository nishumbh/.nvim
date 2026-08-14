_G.run_command = ""

-- Command: Set the run command
vim.api.nvim_create_user_command("SetRun", function(opts)
	_G.run_command = opts.args
	print("Run command set to: " .. _G.run_command)
end, {
	nargs = 1, -- requires an argument
	complete = nil,
})

-- Command: Run the stored command in a new terminal buffer
vim.api.nvim_create_user_command("Run", function()
	if _G.run_command == "" then
		print("No run command set. Use :SetRun {cmd}")
		return
	end

	vim.cmd("enew") -- new buffer
	vim.cmd("terminal") -- become terminal
	vim.cmd("startinsert") -- enter terminal mode

	local chan = vim.b.terminal_job_id
	vim.fn.chansend(chan, _G.run_command .. "\n")
end, {})

local django_term_buf = nil
local django_term_job = nil

vim.api.nvim_create_user_command("DjangoRun", function()
	if
		django_term_buf
		and vim.api.nvim_buf_is_valid(django_term_buf)
		and django_term_job
		and vim.fn.jobwait({ django_term_job }, 0)[1] == -1
	then
		vim.api.nvim_set_current_buf(django_term_buf)
		return
	end

	vim.cmd("enew")
	vim.cmd("terminal")

	django_term_buf = vim.api.nvim_get_current_buf()
	django_term_job = vim.b.terminal_job_id

	vim.cmd("startinsert")
	vim.fn.chansend(django_term_job, "python manage.py runserver\n")
end, {})
