#!/usr/bin/env bash
# Test runner for nvim-treesitter-context tests

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Running nvim-treesitter-context tests...${NC}"
echo ""

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")"

# Run tests using plenary.nvim
nvim --headless \
  -u "$CONFIG_DIR/init.lua" \
  -c "lua require('plenary.test_harness').test_directory('$SCRIPT_DIR', { minimal_init = '$CONFIG_DIR/init.lua' })"

exit_code=$?

if [ $exit_code -eq 0 ]; then
  echo ""
  echo -e "${GREEN}✓ All tests passed!${NC}"
else
  echo ""
  echo -e "${RED}✗ Tests failed!${NC}"
fi

exit $exit_code
