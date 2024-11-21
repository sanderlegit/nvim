-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo(
    { { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } },
    true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end

require "lazy_setup"
require "polish"

-- NeoTreeCursorLine xxx links to PmenuSel
-- NeoTreeVertSplit xxx guifg=#281e22
-- NeoTreeTabSeparatorInactive xxx guifg=#281e22 guibg=#281e22
-- NeoTreeTabInactive xxx guifg=#68545b guibg=#281e22
-- NeoTreeTabActive xxx cterm=bold gui=bold guifg=#a5b2bc
-- NeoTreeSymbolicLinkTarget xxx guifg=#88c3ab
-- NeoTreeNormalNC xxx guifg=#8b7079
-- NeoTreeNormal  xxx guifg=#8b7079
-- NeoTreeTitleBar xxx cterm=bold gui=bold guifg=#9cbdc9
-- NeoTreeGitUnstaged xxx guifg=#ffa31a
-- NeoTreeGitUntracked xxx guifg=#ffa31a
-- NeoTreeGitStaged xxx guifg=#88c3ab
-- NeoTreeGitRenamed xxx guifg=#faa27f
-- NeoTreeGitModified xxx guifg=#faa27f
-- NeoTreeGitIgnored xxx guifg=#8b7079
-- NeoTreeGitDeleted xxx guifg=#68545b
-- NeoTreeGitConflict xxx guifg=#e77777
-- NeoTreeGitAdded xxx guifg=#9ac374
-- NeoTreeIndentMarker xxx guifg=#393337
-- NeoTreeFloatTitle xxx cterm=bold gui=bold guifg=#9cbdc9 guibg=#1a1113
-- NeoTreeFloatBorder xxx guifg=#1a1113
-- NeoTreeFileNameOpened xxx guifg=#9ac374
-- NeoTreeFileIcon xxx guifg=#8b7079
-- NeoTreeFileName xxx guifg=#8b7079
-- NeoTreeRootName xxx cterm=bold gui=bold guifg=#a5b2bc
-- NeoTreeDirectoryIcon xxx guifg=#9cbdc9

vim.cmd [[hi! TabLineFill ctermbg=NONE guibg=NONE]]
vim.cmd [[hi! TabLineSel ctermbg=NONE guibg=NONE]]
vim.cmd [[hi! TabLine ctermbg=NONE guibg=NONE]]
vim.cmd [[hi! NeoTreeTabInactive ctermbg=NONE guibg=NONE]]
vim.cmd [[hi! NeoTreeTabSeparatorInactive ctermbg=NONE guibg=NONE]]

vim.schedule(function() vim.opt.clipboard = "unnamedplus" end)

vim.keymap.set("v", "D", '"_d', { noremap = true, silent = true })
