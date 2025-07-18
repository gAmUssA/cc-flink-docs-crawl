# =============================================================================
# 🚀 CONFLUENT CLOUD FLINK DOCUMENTATION CRAWLER
# Makefile for common tasks - Following Davis-Hansson best practices
# =============================================================================

# 📋 PREAMBLE - Essential settings for robust Makefiles
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# ✅ Use > instead of tabs for recipe prefixes (GNU Make 4.0+)
ifeq ($(origin .RECIPEPREFIX), undefined)
$(error ❌ This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >

# 🎨 ASCII Colors for better readability
RED := \033[31m
GREEN := \033[32m
YELLOW := \033[33m
BLUE := \033[34m
PURPLE := \033[35m
CYAN := \033[36m
WHITE := \033[37m
BOLD := \033[1m
RESET := \033[0m

# 📁 Project variables
PYTHON := python3
VENV := venv
VENV_ACTIVATE := $(VENV)/bin/activate
PIP := $(VENV)/bin/pip
TMP_DIR := tmp
OUT_DIR := out
SRC_FILES := $(shell find . -maxdepth 1 -name "*.py" -type f 2>/dev/null)
REQ_FILES := requirements.txt

# =============================================================================
# 🎯 FILE TARGETS WITH DEPENDENCY TRACKING
# =============================================================================

# 🔧 Virtual environment setup with dependency tracking
$(VENV)/pyvenv.cfg: $(REQ_FILES)
> @echo -e "$(BLUE)🔧 Setting up virtual environment...$(RESET)"
> $(PYTHON) -m venv $(VENV)
> @echo -e "$(BLUE)📦 Installing dependencies...$(RESET)"
> $(PIP) install --upgrade pip
> $(PIP) install -r requirements.txt
> @echo -e "$(GREEN)✅ Virtual environment created and dependencies installed$(RESET)"
> @echo -e "$(YELLOW)💡 To activate: source $(VENV_ACTIVATE)$(RESET)"

# 📦 Dependencies installation sentinel
$(TMP_DIR)/.deps-installed.sentinel: $(VENV)/pyvenv.cfg $(REQ_FILES)
> @echo -e "$(BLUE)📦 Installing/updating dependencies...$(RESET)"
> mkdir -p $(@D)
> $(PIP) install -r requirements.txt
> touch $@
> @echo -e "$(GREEN)✅ Dependencies installed$(RESET)"

# 🧪 Tests sentinel (placeholder for future implementation)
$(TMP_DIR)/.tests-passed.sentinel: $(SRC_FILES) $(TMP_DIR)/.deps-installed.sentinel
> @echo -e "$(YELLOW)🧪 No tests configured yet$(RESET)"
> mkdir -p $(@D)
> touch $@

# 🕷️ Crawling output with dependency tracking
$(OUT_DIR)/llms.txt: $(SRC_FILES) $(TMP_DIR)/.deps-installed.sentinel links.txt
> @if [ ! -f "links.txt" ]; then \
>   echo -e "$(RED)❌ links.txt not found. Please create it with URLs to crawl.$(RESET)"; \
>   exit 1; \
> fi
> @echo -e "$(BLUE)🕷️  Starting documentation crawler...$(RESET)"
> mkdir -p $(@D)
> source $(VENV_ACTIVATE) && $(PYTHON) crawler.py
> mv llms.txt $@ 2>/dev/null || true
> @echo -e "$(GREEN)✅ Crawler completed. Results saved to $@$(RESET)"

# =============================================================================
# 🎯 PHONY TARGETS
# =============================================================================

# 📖 Help target (default)
help:
> @echo -e "$(BOLD)$(CYAN)🚀 Confluent Cloud Flink Documentation Crawler$(RESET)"
> @echo -e "$(YELLOW)Available targets:$(RESET)"
> @echo -e "  $(GREEN)setup$(RESET)     - 🔧 Create virtual environment and install dependencies"
> @echo -e "  $(GREEN)crawl$(RESET)     - 🕷️  Run the documentation crawler"
> @echo -e "  $(GREEN)test$(RESET)      - 🧪 Run tests (placeholder)"
> @echo -e "  $(GREEN)lint$(RESET)      - 🔍 Run linting (placeholder)"
> @echo -e "  $(GREEN)format$(RESET)    - 💅 Format code (placeholder)"
> @echo -e "  $(GREEN)all$(RESET)       - 🎯 Setup and crawl documentation"
> @echo -e "  $(GREEN)clean$(RESET)     - 🧹 Remove generated files and virtual environment"
> @echo -e "  $(GREEN)status$(RESET)    - 📊 Show build status"
> @echo -e "  $(GREEN)validate$(RESET)  - 🔬 Validate crawler script syntax"
> @echo -e "  $(GREEN)summary$(RESET)   - 📊 Generate crawl summary"
> @echo -e "  $(GREEN)ci-ready$(RESET)  - 🚀 Complete CI pipeline (setup→validate→crawl→summary)"
> @echo -e "  $(GREEN)help$(RESET)      - 📖 Show this help message"
.PHONY: help

# 🔧 Setup virtual environment
setup: $(VENV)/pyvenv.cfg
> @echo -e "$(BOLD)$(GREEN)🎉 Setup completed!$(RESET)"
.PHONY: setup

# 📦 Install dependencies
install: $(TMP_DIR)/.deps-installed.sentinel
> @echo -e "$(BOLD)$(GREEN)🎉 Dependencies installed!$(RESET)"
.PHONY: install

# 🕷️ Run crawler
crawl: $(OUT_DIR)/llms.txt
> @echo -e "$(BOLD)$(GREEN)🎉 Crawling completed!$(RESET)"
.PHONY: crawl

# 🧪 Run tests
test: $(TMP_DIR)/.tests-passed.sentinel
> @echo -e "$(BOLD)$(GREEN)🎉 Tests completed!$(RESET)"
.PHONY: test

# 🔍 Run linting (placeholder)
lint: $(TMP_DIR)/.deps-installed.sentinel
> @echo -e "$(YELLOW)🔍 No linting configured yet$(RESET)"
.PHONY: lint

# 💅 Format code (placeholder)
format: $(TMP_DIR)/.deps-installed.sentinel
> @echo -e "$(YELLOW)💅 No formatting configured yet$(RESET)"
.PHONY: format

# 🎯 Setup and crawl in one command
all: setup crawl
> @echo -e "$(BOLD)$(PURPLE)🎉 All tasks completed successfully!$(RESET)"
.PHONY: all

# 🧹 Clean generated files and virtual environment
clean:
> @echo -e "$(YELLOW)🧹 Cleaning up generated files...$(RESET)"
> rm -rf $(VENV) $(TMP_DIR) $(OUT_DIR)
> rm -f llms.txt
> rm -rf __pycache__ *.pyc **/__pycache__ **/*.pyc
> @echo -e "$(GREEN)✅ Cleaned up generated files and virtual environment$(RESET)"
.PHONY: clean

# 📊 Show build status
status:
> @echo -e "$(BOLD)$(CYAN)📊 Build Status:$(RESET)"
> @if [ -f "$(VENV)/pyvenv.cfg" ]; then echo -e "  $(GREEN)✅ Virtual environment exists$(RESET)"; else echo -e "  $(RED)❌ Virtual environment missing$(RESET)"; fi
> @if [ -f "$(TMP_DIR)/.deps-installed.sentinel" ]; then echo -e "  $(GREEN)✅ Dependencies installed$(RESET)"; else echo -e "  $(RED)❌ Dependencies not installed$(RESET)"; fi
> @if [ -f "links.txt" ]; then echo -e "  $(GREEN)✅ Links file exists$(RESET)"; else echo -e "  $(RED)❌ Links file missing$(RESET)"; fi
> @if [ -f "$(OUT_DIR)/llms.txt" ]; then echo -e "  $(GREEN)✅ Crawler output exists$(RESET)"; else echo -e "  $(RED)❌ No crawler output$(RESET)"; fi
> @if [ -f "crawler.py" ]; then echo -e "  $(GREEN)✅ Crawler script exists$(RESET)"; else echo -e "  $(RED)❌ Crawler script missing$(RESET)"; fi
.PHONY: status

# 🎯 Default target when just running 'make'
.DEFAULT_GOAL := help

# 🔍 Check if links.txt exists and has content
check-links:
> @if [ ! -f "links.txt" ]; then \
>   echo -e "$(RED)❌ ERROR: links.txt not found$(RESET)"; \
>   exit 1; \
> fi
> @if [ ! -s "links.txt" ]; then \
>   echo -e "$(RED)❌ ERROR: links.txt is empty$(RESET)"; \
>   exit 1; \
> fi
> @echo -e "$(GREEN)✅ Found $(shell wc -l < links.txt) URLs in links.txt$(RESET)"
.PHONY: check-links

# 🔬 Validate crawler script syntax
validate:
> @echo -e "$(BLUE)🔬 Validating crawler script...$(RESET)"
> python -m py_compile crawler.py
> @echo -e "$(GREEN)✅ Crawler script syntax is valid$(RESET)"
.PHONY: validate

# 📊 Generate crawl summary
summary: $(OUT_DIR)/llms.txt
> @echo -e "$(BLUE)📊 Generating crawl summary...$(RESET)"
> mkdir -p $(OUT_DIR)
> echo "# 🕷️ Crawl Summary" > $(OUT_DIR)/crawl-summary.md
> echo "" >> $(OUT_DIR)/crawl-summary.md
> echo "**Crawl Date:** $$(date -u '+%Y-%m-%d %H:%M:%S UTC')" >> $(OUT_DIR)/crawl-summary.md
> echo "**Links Processed:** $$(grep -c '^https' links.txt || echo 0)" >> $(OUT_DIR)/crawl-summary.md
> echo "**Output Lines:** $$(wc -l < $(OUT_DIR)/llms.txt)" >> $(OUT_DIR)/crawl-summary.md
> echo "**Output Size:** $$(du -h $(OUT_DIR)/llms.txt | cut -f1)" >> $(OUT_DIR)/crawl-summary.md
> echo "" >> $(OUT_DIR)/crawl-summary.md
> echo "## 📋 Sample Content" >> $(OUT_DIR)/crawl-summary.md
> echo "\`\`\`" >> $(OUT_DIR)/crawl-summary.md
> head -20 $(OUT_DIR)/llms.txt >> $(OUT_DIR)/crawl-summary.md
> echo "\`\`\`" >> $(OUT_DIR)/crawl-summary.md
> @echo -e "$(GREEN)✅ Crawl summary generated at $(OUT_DIR)/crawl-summary.md$(RESET)"
.PHONY: summary

# 🚀 CI-ready target (setup, validate, check-links, crawl, summary)
ci-ready: setup validate check-links crawl summary
> @echo -e "$(BOLD)$(PURPLE)🎉 CI pipeline completed successfully!$(RESET)"
.PHONY: ci-ready