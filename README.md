# bruno-workspace

CLI script to create [Bruno](https://www.usebruno.com/) workspaces from git worktrees — with native [Worktrunk](https://worktrunk.dev/) integration.

Bruno doesn't support git worktrees natively — each worktree shares the same collection path, so you can't have different active environments per worktree. This script creates an isolated Bruno workspace per worktree, linked to that worktree's Bruno collection via symlink.

## How it works

1. Detects the ticket ID from the current git branch (e.g. `DEV-1582` from `feature/DEV-1582-some-feature`)
2. Finds the Bruno collection (`opencollection.yml`) in the repo
3. Creates a workspace at `~/Documents/bruno/{TICKET}/`
4. Symlinks the repo's collection into the workspace's `collections/` folder
5. Registers the workspace in Bruno's `preferences.json`

```
~/Documents/bruno/DEV-1582/
├── workspace.yml
└── collections/
    └── api-core → /path/to/repo/bruno/   ← symlink
```

## Install

```zsh
git clone https://github.com/adriancoll-dev/bruno-workspace
cd bruno-workspace
./install.sh
```

Or manually:

```zsh
cp bruno-workspace /usr/local/bin/bruno-workspace
chmod +x /usr/local/bin/bruno-workspace
```

## Usage

```zsh
# Auto-detect ticket from current branch
bruno-workspace

# Explicit branch name (ticket extracted automatically)
bruno-workspace feature/DEV-1234-some-feature

# Explicit ticket name
bruno-workspace DEV-1234

# Remove workspace (unlinks collection + unregisters from Bruno)
bruno-workspace --remove feature/DEV-1234-some-feature
```

After creating, restart Bruno and switch to the new workspace via the workspace switcher.

## Worktrunk integration

Automatically create and clean up Bruno workspaces as part of the worktree lifecycle.

Add to `~/.config/worktrunk/config.toml`:

```toml
[post-start]
bruno = "bruno-workspace {{ branch }}"

[pre-remove]
bruno = "bruno-workspace --remove {{ branch }}"
```

With this setup:
- `wt switch --create feature/DEV-1234` → Bruno workspace created automatically in background
- `wt merge` (which removes the worktree) → Bruno workspace cleaned up automatically

## Configuration

Override the default workspaces directory:

```zsh
export BRUNO_WORKSPACES_DIR="$HOME/somewhere/else/bruno"
```

## Requirements

- macOS (reads `~/Library/Application Support/Bruno/preferences.json`)
- Bruno installed
- git
- python3 (built-in on macOS)
