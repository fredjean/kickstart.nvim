# Neovim Configuration Tests

This directory contains unit tests for the Neovim configuration, specifically for plugin configurations.

## Test Structure

- `treesitter_context_spec.lua` - Runtime tests for nvim-treesitter-context plugin (requires full plugin loading)
- `minimal_treesitter_context_spec.lua` - Configuration tests that verify settings in init.lua (lightweight, no plugin loading required)
- `run_tests.sh` - Shell script to run all tests
- `run_minimal_tests.lua` - Lua script to run minimal configuration tests

## Running Tests

### Prerequisites

The tests require `plenary.nvim`, which is already included as a dependency in the configuration.

### Run All Tests

```fish
# From the nvim config directory
make test

# Or directly
./tests/run_tests.sh
```

### Run Specific Test File

```fish
# Run minimal configuration tests (lightweight, fast)
make test-minimal

# Run runtime tests (requires full plugin loading)
make test-treesitter-context

# Or with nvim directly
nvim -l tests/run_minimal_tests.lua  # Minimal tests
nvim --headless --noplugin -u init.lua -c "PlenaryBustedFile tests/treesitter_context_spec.lua" -c "qa!"  # Runtime tests
```

### Run Tests from Within Neovim

```vim
:PlenaryBustedFile tests/treesitter_context_spec.lua
```

## Test Coverage

### nvim-treesitter-context Plugin Tests

The tests verify:

1. **Plugin Loading**: Ensures the plugin is correctly loaded and enabled
2. **Max Context Lines**: Verifies the plugin displays a maximum of 3 context lines
3. **Trim Scope Configuration**: Confirms the context is trimmed from the outer scope
4. **Small Window Support**: Validates the plugin works even in small windows (min_window_height = 0)
5. **Integration**: Checks proper integration with nvim-treesitter
6. **Behavior**: Verifies plugin autocommands are registered

## Writing New Tests

Tests use the [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) testing framework with busted-style syntax.

Example test structure:

```lua
describe('my feature', function()
  it('should do something', function()
    local result = my_function()
    assert.are.equal(expected, result)
  end)
end)
```

### Available Assertions

- `assert.are.equal(expected, actual, message)`
- `assert.is_true(value, message)`
- `assert.is_false(value, message)`
- `assert.is_nil(value, message)`
- `assert.is_not_nil(value, message)`

## Troubleshooting

### Tests Fail to Run

If tests fail to run, ensure:

1. Neovim is installed and accessible in your PATH
2. All plugins are installed (run `:Lazy sync` in Neovim)
3. The test file has correct syntax

### Plugin Not Loaded in Tests

If a plugin isn't loaded during tests, it may be lazily loaded. Ensure the plugin is loaded by triggering the appropriate event or loading it explicitly:

```lua
require('lazy').load({ plugins = { 'plugin-name' } })
```

## CI/CD Integration

These tests can be integrated into CI/CD pipelines:

```yaml
# Example GitHub Actions workflow
- name: Run Neovim Tests
  run: |
    make test
```
