-- Constants for chunk size tuning
local CHUNK_SIZE = 1024 * 50 -- 50KB chunks to stay under terminal limits

local function osc52_copy(text)
  -- Get total size
  local total_size = #text
  print(string.format("Total size: %.2fKB", total_size / 1024))

  -- If text is small enough, send it directly
  if total_size <= CHUNK_SIZE then
    local escaped = vim.fn.shellescape(text)
    local encoded = vim.fn.system("printf " .. escaped .. " | base64"):gsub("\n", "")
    local osc = string.format("\x1b]52;c;%s\x07", encoded)

    if os.getenv "TMUX" then osc = string.format("\x1bPtmux;\x1b%s\x1b\\", osc) end

    io.stderr:write(osc)
    return
  end

  -- For larger text, split into chunks
  local chunks = {}
  local pos = 1
  while pos <= #text do
    local chunk = text:sub(pos, pos + CHUNK_SIZE - 1)
    table.insert(chunks, chunk)
    pos = pos + CHUNK_SIZE
  end

  print(string.format("Split into %d chunks", #chunks))

  -- Send each chunk with a small delay
  for i, chunk in ipairs(chunks) do
    local escaped = vim.fn.shellescape(chunk)
    local encoded = vim.fn.system("printf " .. escaped .. " | base64"):gsub("\n", "")
    local osc = string.format("\x1b]52;c;%s\x07", encoded)

    if os.getenv "TMUX" then osc = string.format("\x1bPtmux;\x1b%s\x1b\\", osc) end

    io.stderr:write(osc)
    vim.cmd "sleep 10m" -- 10ms delay between chunks
  end
end

-- Automatically sync with system clipboard on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("OSC52Yank", { clear = true }),
  callback = function()
    local yanked = vim.fn.getreg('"', 1, true)
    if type(yanked) == "table" then yanked = table.concat(yanked, "\n") end
    osc52_copy(yanked)
  end,
})
---
---------------------------
-- local function osc52_copy(text)
--   -- Properly escape newlines for printf and preserve them
--   local escaped = vim.fn.shellescape(text)
--   local encoded = vim.fn.system("printf " .. escaped .. " | base64"):gsub("\n", "")
--   local osc = string.format("\x1b]52;c;%s\x07", encoded)
--
--   -- Handle tmux
--   if os.getenv "TMUX" then osc = string.format("\x1bPtmux;\x1b%s\x1b\\", osc) end
--
--   -- Send to terminal
--   io.stderr:write(osc)
-- end
--
-- -- Automatically sync with system clipboard on yank
-- vim.api.nvim_create_autocmd("TextYankPost", {
--   group = vim.api.nvim_create_augroup("OSC52Yank", { clear = true }),
--   callback = function()
--     local yanked = vim.fn.getreg('"', 1, true)
--     if type(yanked) == "table" then yanked = table.concat(yanked, "\n") end
--     osc52_copy(yanked)
--   end,
-- })
--------------------------

-- Optional: make clipboard default register
-- vim.opt.clipboard = "unnamedplus"
-- if true then return end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
--
-- -- This will run last in the setup process and is a good place to configure
-- -- things like custom filetypes. This just pure lua so anything that doesn't
-- -- fit in the normal config locations above can go here
--
-- -- Set up custom filetypes
-- vim.filetype.add {
--   extension = {
--     foo = "fooscript",
--   },
--   filename = {
--     ["Foofile"] = "fooscript",
--   },
--   pattern = {
--     ["~/%.config/foo/.*"] = "fooscript",
--   },
-- }
