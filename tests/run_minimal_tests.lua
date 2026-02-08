-- Quick test runner for minimal tests
-- This can be run directly with: nvim -l tests/run_minimal_tests.lua

-- Add the plenary testing harness to the runtime path
local plenary_dir = vim.fn.stdpath 'data' .. '/lazy/plenary.nvim'

if vim.fn.isdirectory(plenary_dir) == 1 then
  vim.opt.runtimepath:append(plenary_dir)
else
  print 'Error: plenary.nvim not found. Please ensure plugins are installed.'
  os.exit(1)
end

-- Run the minimal tests
local success = pcall(require('plenary.busted').run, vim.fn.expand '~/.config/nvim/tests/minimal_treesitter_context_spec.lua')

if success then
  print '\n✓ All tests passed!'
  os.exit(0)
else
  print '\n✗ Tests failed!'
  os.exit(1)
end
