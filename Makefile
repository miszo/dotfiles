.DEFAULT_GOAL := help
.PHONY: help

bootstrap: ## Bootstrap dependencies.
	@printf "Bootstrapping dependencies...\n"
	@scripts/bootstrap.sh
	@make gitleaks
	@make op
	@make chezmoi_init

op: ## Signin to 1Password CLI.
	@printf "Bootstrapping dependencies...\n"
	@scripts/op_signin.sh

gitleaks: ## Detect GitLeaks.
	@printf "Detecting GitLeaks...\n"
	@gitleaks detect --source . -v

chezmoi_apply: ## Apply current chezmoi state to your machine.
	@printf "Applying current chezmoi state to yout machine...\n"
	@chezmoi apply

chezmoi_init: ## Run `chezmoi init`.
	@printf "Running `chezmoi init`...\n"
	@chezmoi init

help: ## This help.
	@printf "\033[36m%-30s\033[0m %s\n" "Targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\t\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
