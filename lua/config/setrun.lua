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

-- Command: Run Django Startup Command
vim.api.nvim_create_user_command("DjangoRun", function()
  vim.cmd("enew") -- new buffer
  vim.cmd("terminal") -- become terminal
  vim.cmd("startinsert") -- enter terminal mode

  local chan = vim.b.terminal_job_id
  vim.fn.chansend(chan, "python manage.py runserver\n\n")
end, {})
vim.keymap.set("n", "<leader>rs", "<cmd>DjangoRun<cr>", { silent = true })
