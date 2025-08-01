# Makefile for dotfiles management
# Run 'make help' for usage information

.PHONY: help install asdf clean

# Default target
.DEFAULT_GOAL := help

# Colors for output
YELLOW := \033[1;33m
GREEN := \033[0;32m
NC := \033[0m # No Color

help: ## Show this help message
	@echo "Dotfiles Makefile"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}'

install: ## Install dotfiles (run install.sh)
	@echo "$(YELLOW)Installing dotfiles...$(NC)"
	@./install.sh

asdf: ## Setup asdf plugins and tools
	@echo "$(YELLOW)Setting up asdf...$(NC)"
	@./asdf/setup.sh

clean: ## Remove all dotfile symlinks
	@echo "$(YELLOW)Cleaning dotfiles...$(NC)"
	@./cleanup.sh