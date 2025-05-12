#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# Brewfile Generator Script
#
# Description:
#   Generates a comprehensive Brewfile for macOS, including Homebrew taps,
#   formulae, casks, Mac App Store apps, and VS Code extensions.
#
# Author: David Terana
# Version: 1.0.0
# Date:   May 12, 2025
# License: MIT
#
# Requirements:
#   - macOS
#   - Homebrew (https://brew.sh/)
#   - mas (https://github.com/mas-cli/mas) for Mac App Store apps
#   - VS Code (https://code.visualstudio.com/) for VS Code extensions
#
# Usage:
#   ./generate_brewfile.sh [-o|--output <path>] [-h|--help]
# ------------------------------------------------------------------------------

set -euo pipefail

# Use mktemp for a unique temporary folder
TMP_FOLDER=$(mktemp -d -t brewfiles.XXXXXXXX)
trap 'rm -rf "$TMP_FOLDER"' EXIT  # Cleanup tmp folder on exit or error

# Check if brew is installed
if ! command -v brew &> /dev/null; then
  echo "Error: Homebrew is not installed." >&2
  exit 1
fi

# Write a section header to the Brewfile
writeHeader() {
  local section="$1"
  printf "\n# ---------------------------------------\n" >> "$BREWFILE_PATH"
  printf "# %s\n" "$section" >> "$BREWFILE_PATH"
  printf "# ---------------------------------------\n" >> "$BREWFILE_PATH"
}

# Display help message
show_help() {
  cat <<EOF
Usage: $0 [-o|--output <path>] [-h|--help]

Options:
  -o, --output <path>   Specify output Brewfile path (default: Brewfile)
  -h, --help            Show this help message and exit
EOF
}

# Parse arguments for -o/--output and -h/--help
BREWFILE_PATH="Brewfile"
while [[ $# -gt 0 ]]; do
  case $1 in
    -o|--output)
      if [[ -n "${2:-}" ]]; then
        BREWFILE_PATH="$2"
        shift 2
      else
        echo "[error] $(date '+%Y-%m-%d %H:%M:%S') Missing argument for $1" >&2
        exit 1
      fi
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      echo "[error] $(date '+%Y-%m-%d %H:%M:%S') Unknown argument: $1" >&2
      show_help
      exit 1
      ;;
  esac
done

# Helper function to log messages with a timestamp
log_info() {
  local msg="$1"
  echo "[info] $(date '+%Y-%m-%d %H:%M:%S') $msg"
}

# Backup existing Brewfile if present
if [[ -f "$BREWFILE_PATH" ]]; then
  timestamp=$(date '+%y%m%d-%H%M%S')
  backup_name="${BREWFILE_PATH}.${timestamp}"
  mv "$BREWFILE_PATH" "$backup_name"
  log_info "Existing $BREWFILE_PATH found. Renamed to $backup_name."
fi

log_info "Generating Brewfile at $BREWFILE_PATH..."
log_info "Started"
printf "# Generated %s\n" "$(date)" > "$BREWFILE_PATH"

# Dump sections
log_info "Dumping Taps..."
writeHeader "Taps"
brew bundle dump --taps --file="$TMP_FOLDER/taps" || { log_info "brew bundle dump --taps failed"; exit 1; }
cat "$TMP_FOLDER/taps" >> "$BREWFILE_PATH"

log_info "Dumping Brew packages..."
writeHeader "Brew"
brew bundle dump --brew --describe --file="$TMP_FOLDER/brew" || { log_info "brew bundle dump --brew failed"; exit 1; }
awk '/^#/ {comment=$0; next} {print $0, comment; comment=""}' "$TMP_FOLDER/brew" >> "$BREWFILE_PATH"

log_info "Dumping Casks..."
writeHeader "Casks"
brew bundle dump --casks --describe --file="$TMP_FOLDER/casks" || { log_info "brew bundle dump --casks failed"; exit 1; }
awk '/^#/ {comment=$0; next} {print $0, comment; comment=""}' "$TMP_FOLDER/casks" >> "$BREWFILE_PATH"

log_info "Dumping Mac App Store apps..."
writeHeader "Mac Application Store"
brew bundle dump --mas --file="$TMP_FOLDER/mas" || { log_info "brew bundle dump --mas failed"; exit 1; }
cat "$TMP_FOLDER/mas" >> "$BREWFILE_PATH"

log_info "Dumping VS Code Extensions..."
writeHeader "VS Code Extensions"
brew bundle dump --vscode --file="$TMP_FOLDER/vscode" || { log_info "brew bundle dump --vscode failed"; exit 1; }
cat "$TMP_FOLDER/vscode" >> "$BREWFILE_PATH"

log_info "Brewfile generation complete!"
log_info "Finished"

