-- Function to determine the default branch
local function get_default_branch()
  local handle = io.popen("git branch -r")
  local result = handle:read("*a")
  handle:close()

  if result:find("origin/main") then
    return "main"
  elseif result:find("origin/master") then
    return "master"
  else
    return nil
  end
end

-- Note that this runs only once, so if you switch projects between different default branches,
-- it won't evaluate the new default branch
local default_branch = get_default_branch()

vim.keymap.set("n", "gp", "<cmd>Git push<cr>", { buffer = true })
vim.keymap.set("n", "gP", ":Git push -f", { buffer = true })
vim.keymap.set("n", "gl", "<cmd>Git pull<cr>", { buffer = true })
vim.keymap.set("n", "gu", "<cmd>Git branch -u origin/" .. default_branch .. "<cr>", { buffer = true })
vim.keymap.set("n", "gU", "<cmd>Git branch -u origin/" .. vim.fn.FugitiveHead() .. "<cr>", { buffer = true })
vim.keymap.set("n", "c-", "<cmd>Git checkout -<cr>", { buffer = true })
vim.keymap.set("n", "cm", "<cmd>Git checkout " .. default_branch .. "<cr>", { buffer = true })
vim.keymap.set("n", "grom", "<cmd>Git rebase -i origin/" .. default_branch .. "<cr>", { buffer = true })
