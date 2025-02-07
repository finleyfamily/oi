CI := $(if $(CI),yes,no)
SHELL := /bin/bash

ifeq ($(CI), yes)
	POETRY_OPTS = "-v"
	PRE_COMMIT_OPTS = --show-diff-on-failure --verbose
endif

help: ## show this message
	@awk \
		'BEGIN {FS = ":.*##"; printf "\nUsage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' \
		$(MAKEFILE_LIST)

fix: fix-ruff run-pre-commit ## run all automatic fixes

fix-formatting: ## automatically fix ruff formatting issues
	@poetry run ruff format .

fix-imports: ## automatically fix all import sorting errors
	@poetry run ruff check . --fix-only --fixable I001

fix-ruff: fix-formatting ## automatically fix everything ruff can fix (implies fix-imports)
	@poetry run ruff check . --fix-only

fix-md: ## automatically fix markdown format errors
	@poetry run pre-commit run mdformat --all-files

lint: lint-ruff lint-pyright ## run all linters
	@if [[ "${CI}" == "yes" ]]; then \
		echo ""; \
		echo "skipped linters that have dedicated jobs"; \
	else \
		echo ""; \
		$(MAKE) --no-print-directory lint-shellcheck; \
	fi

lint-pyright: ## run pyright
	@echo "Running pyright..."
	@npm exec --no -- pyright --venvpath ./
	@echo ""

lint-ruff: ## run ruff
	@echo "Running ruff... If this fails, run 'make fix-ruff' to resolve some error automatically, other require manual action."
	@poetry run ruff format . --diff
	@poetry run ruff check .
	@echo ""

lint-shellcheck: ## runs shellcheck using act
	@act --job shellcheck

run-pre-commit: ## run pre-commit for all files
	@poetry run pre-commit run $(PRE_COMMIT_OPTS) \
		--all-files \
		--color always

setup: setup-poetry setup-pre-commit setup-npm ## setup dev environment

setup-npm: ## install node dependencies with npm
	@npm ci

setup-poetry: ## setup python virtual environment
	@poetry install $(POETRY_OPTS) --no-root --sync

setup-pre-commit: ## install pre-commit git hooks
	@poetry run pre-commit install

spellcheck: ## run cspell
	@echo "Running cSpell to checking spelling..."
	@npm exec --no -- cspell lint . \
		--color \
		--config .vscode/cspell.json \
		--dot \
		--gitignore \
		--must-find-files \
		--no-progress \
		--relative \
		--show-context

test: ## run all test
	@act --job test
