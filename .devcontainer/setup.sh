#!/bin/bash
set -e

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating Python virtual environment..."
    python -m venv venv
fi

# Upgrade pip inside the venv
echo "Upgrading pip..."
venv/bin/python -m pip install --upgrade pip

# Install dependencies
if [ -f "requirements.txt" ]; then
    echo "Installing dependencies from requirements.txt..."
    venv/bin/pip install -r requirements.txt
else
    echo "No requirements.txt found, skipping..."
fi

# Git configuration for all users in container
echo "Configuring git..."
git config --global pull.rebase false

# Alias 1: First-time only, stitches histories together
git config --global alias.upstream-once "!git pull upstream main --allow-unrelated-histories --no-edit"

# Alias 2: Ongoing use, keeps teacher’s copy in original filename
# and saves student’s conflicted version as <filename>.studentcopy
git config --global alias.upstream-save '!f() { \
  git fetch upstream main && \
  git merge --no-edit upstream/main || true; \
  for f in $(git diff --name-only --diff-filter=U); do \
    git show :2:$f > "${f}.studentcopy"; \
    git checkout --theirs -- "$f"; \
    git add "$f" "${f}.studentcopy"; \
  done; \
  if [ -n "$(git diff --cached --name-only)" ]; then \
    git commit -m "Merge upstream/main, preserving student copies"; \
  fi; \
}; f'

echo "? Setup complete!"
echo "?? First time only, run: git upstream"
echo "?? Every other time, run: git upstream-save"

