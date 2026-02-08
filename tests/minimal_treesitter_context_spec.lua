-- Minimal tests for nvim-treesitter-context plugin configuration
-- These tests verify the configuration in init.lua without requiring full plugin loading

describe('nvim-treesitter-context configuration in init.lua', function()
  local init_content

  before_each(function()
    -- Read the init.lua file
    local config_path = vim.fn.stdpath 'config' .. '/init.lua'
    local file = io.open(config_path, 'r')
    assert.is_not_nil(file, 'init.lua should exist')
    init_content = file:read '*a'
    file:close()
  end)

  it('should have nvim-treesitter-context plugin defined', function()
    -- Check if the plugin is defined in init.lua
    assert.is_true(init_content:match "nvim%-treesitter%-context" ~= nil, 'nvim-treesitter-context should be defined in init.lua')
  end)

  it('should configure enable = true', function()
    -- Check if enable is set to true
    local enable_pattern = 'enable%s*=%s*true'
    local found = false

    -- Find the treesitter-context section
    local context_section_start = init_content:find 'nvim%-treesitter%-context'
    if context_section_start then
      local opts_start = init_content:find('opts%s*=%s*{', context_section_start)
      if opts_start then
        local opts_end = init_content:find('},%s*}', opts_start)
        if opts_end then
          local opts_content = init_content:sub(opts_start, opts_end)
          found = opts_content:match(enable_pattern) ~= nil
        end
      end
    end

    assert.is_true(found, 'enable should be set to true in nvim-treesitter-context configuration')
  end)

  it('should configure max_lines = 3', function()
    -- Check if max_lines is set to 3
    local max_lines_pattern = 'max_lines%s*=%s*3'
    local found = false

    local context_section_start = init_content:find 'nvim%-treesitter%-context'
    if context_section_start then
      local opts_start = init_content:find('opts%s*=%s*{', context_section_start)
      if opts_start then
        local opts_end = init_content:find('},%s*}', opts_start)
        if opts_end then
          local opts_content = init_content:sub(opts_start, opts_end)
          found = opts_content:match(max_lines_pattern) ~= nil
        end
      end
    end

    assert.is_true(found, 'max_lines should be set to 3 in nvim-treesitter-context configuration')
  end)

  it('should configure trim_scope = outer', function()
    -- Check if trim_scope is set to 'outer'
    local trim_scope_pattern = "trim_scope%s*=%s*['\"]outer['\"]"
    local found = false

    local context_section_start = init_content:find 'nvim%-treesitter%-context'
    if context_section_start then
      local opts_start = init_content:find('opts%s*=%s*{', context_section_start)
      if opts_start then
        local opts_end = init_content:find('},%s*}', opts_start)
        if opts_end then
          local opts_content = init_content:sub(opts_start, opts_end)
          found = opts_content:match(trim_scope_pattern) ~= nil
        end
      end
    end

    assert.is_true(found, "trim_scope should be set to 'outer' in nvim-treesitter-context configuration")
  end)

  it('should configure min_window_height = 0 for small window support', function()
    -- Check if min_window_height is set to 0
    local min_window_height_pattern = 'min_window_height%s*=%s*0'
    local found = false

    local context_section_start = init_content:find 'nvim%-treesitter%-context'
    if context_section_start then
      local opts_start = init_content:find('opts%s*=%s*{', context_section_start)
      if opts_start then
        local opts_end = init_content:find('},%s*}', opts_start)
        if opts_end then
          local opts_content = init_content:sub(opts_start, opts_end)
          found = opts_content:match(min_window_height_pattern) ~= nil
        end
      end
    end

    assert.is_true(found, 'min_window_height should be set to 0 to work in small windows')
  end)
end)

-- Runtime tests (when plugins are loaded)
describe('nvim-treesitter-context runtime behavior', function()
  it('should be loadable via lazy.nvim', function()
    local lazy_ok, lazy = pcall(require, 'lazy')
    if not lazy_ok then
      pending 'lazy.nvim not loaded - skipping runtime test'
      return
    end

    -- Check if the plugin is registered
    local plugins = lazy.plugins()
    local found = false
    for _, plugin in pairs(plugins) do
      if plugin.name == 'nvim-treesitter-context' then
        found = true
        break
      end
    end

    assert.is_true(found, 'nvim-treesitter-context should be registered with lazy.nvim')
  end)

  it('should be configured when loaded', function()
    local context_ok, treesitter_context = pcall(require, 'treesitter-context')
    if not context_ok then
      pending 'treesitter-context not loaded - skipping runtime test'
      return
    end

    local config = treesitter_context.get_config()
    assert.is_not_nil(config, 'Configuration should exist')
    assert.is_true(config.enable, 'Plugin should be enabled')
    assert.are.equal(3, config.max_lines, 'max_lines should be 3')
    assert.are.equal('outer', config.trim_scope, "trim_scope should be 'outer'")
    assert.are.equal(0, config.min_window_height, 'min_window_height should be 0')
  end)
end)
