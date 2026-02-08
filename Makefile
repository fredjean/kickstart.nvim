.PHONY: test test-treesitter-context test-minimal help

# Default target
.DEFAULT_GOAL := help

help: ## Show this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2}'

test: ## Run all tests
	@./tests/run_tests.sh

test-minimal: ## Run minimal configuration tests (no full plugin loading)
	@nvim -l tests/run_minimal_tests.lua

test-treesitter-context: ## Run nvim-treesitter-context runtime tests
	@nvim --headless --noplugin -u init.lua -c "PlenaryBustedFile tests/treesitter_context_spec.lua" -c "qa!"
