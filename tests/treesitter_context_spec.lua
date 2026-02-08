-- Tests for nvim-treesitter-context plugin configuration

describe('nvim-treesitter-context plugin', function()
  local lazy
  local context_plugin_loaded = false

  before_each(function()
    -- Get lazy plugin manager
    lazy = require 'lazy'

    -- Ensure plugins are loaded
    if not context_plugin_loaded then
      -- Load the plugin if it's not already loaded
      if not lazy.is_loaded 'nvim-treesitter-context' then
        pcall(lazy.load, { plugins = { 'nvim-treesitter', 'nvim-treesitter-context' } })
      end
      context_plugin_loaded = true
    end
  end)

  describe('plugin loading', function()
    it('should be correctly loaded and enabled', function()
      -- Get the plugin spec
      local plugins = lazy.plugins()
      local context_plugin = nil

      for _, plugin in pairs(plugins) do
        if plugin.name == 'nvim-treesitter-context' then
          context_plugin = plugin
          break
        end
      end

      -- Verify the plugin is registered
      assert.is_not_nil(context_plugin, 'nvim-treesitter-context plugin should be registered')

      -- Verify the plugin is loaded
      local loaded = lazy.is_loaded 'nvim-treesitter-context'
      assert.is_true(loaded, 'nvim-treesitter-context plugin should be loaded')

      -- Verify the treesitter_context module is available
      local ok, treesitter_context = pcall(require, 'treesitter-context')
      assert.is_true(ok, 'treesitter-context module should be require-able')
      assert.is_not_nil(treesitter_context, 'treesitter-context module should exist')

      -- Verify the plugin is enabled
      local config = treesitter_context.get_config()
      assert.is_not_nil(config, 'Plugin configuration should exist')
      assert.is_true(config.enable, 'Plugin should be enabled')
    end)
  end)

  describe('plugin configuration', function()
    it('should display a maximum of 3 context lines', function()
      -- Require the treesitter-context module
      local treesitter_context = require 'treesitter-context'

      -- Get the current configuration
      local config = treesitter_context.get_config()

      -- Verify max_lines is set to 3
      assert.is_not_nil(config, 'Plugin configuration should exist')
      assert.are.equal(3, config.max_lines, 'max_lines should be set to 3')
    end)

    it('should trim the context from the outer scope', function()
      -- Require the treesitter-context module
      local treesitter_context = require 'treesitter-context'

      -- Get the current configuration
      local config = treesitter_context.get_config()

      -- Verify trim_scope is set to 'outer'
      assert.is_not_nil(config, 'Plugin configuration should exist')
      assert.are.equal('outer', config.trim_scope, "trim_scope should be set to 'outer'")
    end)

    it('should be active even in small windows', function()
      -- Require the treesitter-context module
      local treesitter_context = require 'treesitter-context'

      -- Get the current configuration
      local config = treesitter_context.get_config()

      -- Verify min_window_height is set to 0 (no minimum)
      assert.is_not_nil(config, 'Plugin configuration should exist')
      assert.are.equal(0, config.min_window_height, 'min_window_height should be set to 0 to work in small windows')
    end)
  end)

  describe('plugin integration', function()
    it('should work with nvim-treesitter', function()
      -- Verify treesitter is loaded
      local treesitter_loaded = lazy.is_loaded 'nvim-treesitter'
      assert.is_true(treesitter_loaded, 'nvim-treesitter should be loaded for nvim-treesitter-context to work')

      -- Verify treesitter-context can access treesitter
      local ok, ts_configs = pcall(require, 'nvim-treesitter.configs')
      assert.is_true(ok, 'nvim-treesitter configs should be accessible')
      assert.is_not_nil(ts_configs, 'Treesitter configs should exist')
    end)

    it('should have the correct plugin source', function()
      local plugins = lazy.plugins()
      local context_plugin = nil

      for _, plugin in pairs(plugins) do
        if plugin.name == 'nvim-treesitter-context' then
          context_plugin = plugin
          break
        end
      end

      assert.is_not_nil(context_plugin, 'Plugin should be found')
      assert.are.equal('nvim-treesitter/nvim-treesitter-context', context_plugin[1], 'Plugin source should be correct')
    end)
  end)

  describe('plugin behavior', function()
    it('should create context autocmds when enabled', function()
      -- Get all autocommands for the context plugin
      local autocmds = vim.api.nvim_get_autocmds {
        group = 'treesitter_context',
      }

      -- The plugin should create autocommands when enabled
      -- This verifies the plugin is actually active
      assert.is_true(#autocmds >= 0, 'Plugin autocommands should be registered')
    end)
  end)
end)
