# List available commands
default:
    @just --list

# Bootstrap dependencies
bootstrap:
    @printf "Bootstrapping dependencies...\n"
    @scripts/bootstrap.sh
    @just gitleaks
    @just op
    @just chezmoi_init

# Signin to 1Password CLI
op:
    @printf "Bootstrapping dependencies...\n"
    @scripts/op_signin.sh

# Detect GitLeaks
gitleaks:
    @printf "Detecting GitLeaks...\n"
    @gitleaks detect --source . -v

# Initialize (or update) chezmoi config file on your machine
chezmoi_init:
    @printf "Running `chezmoi init`...\n"
    @chezmoi init

# Apply current chezmoi state to your machine
chezmoi_apply:
    @printf "Applying current chezmoi state to your machine...\n"
    @chezmoi apply
