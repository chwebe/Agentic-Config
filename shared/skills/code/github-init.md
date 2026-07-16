Initialize and push the current project to a new GitHub repository.

The target repo name is: $ARGUMENTS

## Steps

Follow these steps in order. Explain each step to the user as you go.

### 1. Check gh CLI installation

Run `gh --version` to check if the GitHub CLI is installed.

If the command is NOT found:
- Detect the OS/distro using `uname -s` and `cat /etc/os-release 2>/dev/null` or equivalent.
- Install `gh` using the appropriate package manager:
  - **Arch Linux / Manjaro** (`pacman`): `sudo pacman -S --noconfirm github-cli`
  - **Debian / Ubuntu / Mint** (`apt`): run the official script:
    ```
    sudo mkdir -p -m 755 /etc/apt/keyrings && \
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null && \
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    sudo apt update && sudo apt install gh -y
    ```
  - **Fedora / RHEL / CentOS** (`dnf`): `sudo dnf install gh`
  - **openSUSE** (`zypper`): `sudo zypper install gh`
  - **macOS** (`brew`): `brew install gh`
  - For any other OS, tell the user to install manually from https://cli.github.com and stop.
- After install, confirm with `gh --version`.

### 2. Check gh authentication

Run `gh auth status` to see if the user is already logged in.

If NOT authenticated (exit code non-zero or output contains "not logged in"):
- Tell the user they need to authenticate with GitHub.
- Run `gh auth login` interactively and guide them through:
  1. Select **GitHub.com**
  2. Select **HTTPS** as preferred protocol
  3. Authenticate via **browser** (recommended) or paste a token
- After login, re-run `gh auth status` to confirm success before continuing.

### 3. Validate the repo name

The repo name comes from $ARGUMENTS. If $ARGUMENTS is empty, ask the user to provide a name and stop:
> "Please provide a repository name: /github-init <repo-name>"

Repo names must only contain letters, numbers, hyphens, and underscores. If the name contains spaces or invalid characters, tell the user and stop.

### 4. Ensure a local git repository exists

Run `git status` in the current working directory.

If git is **not initialized** (error: not a git repository):
- Run `git init`
- Run `git add .`
- Run `git commit -m "Initial commit"` — if there are no files yet, tell the user the directory is empty and ask them to add files first, then stop.

If git is already initialized:
- Check for uncommitted changes with `git status --short`.
- Tell the user about any uncommitted changes but do NOT commit them automatically — that is the user's decision.

### 5. Create the GitHub repository

Run:
```
gh repo create $ARGUMENTS --public --source=. --remote=origin --push
```

Flags explanation for the user:
- `--public` — the repo will be visible to everyone. If the user wants a private repo, tell them to add `--private` instead.
- `--source=.` — uses the current directory as the source.
- `--remote=origin` — sets the new GitHub repo as the `origin` remote.
- `--push` — pushes the current branch immediately.

If the repo already exists on GitHub (error contains "already exists"), tell the user and offer two options:
1. Use a different name (rerun the command with a new name).
2. Just add the remote and push manually — provide the exact commands.

### 6. Confirm success

Run `gh repo view --web` to open the newly created repo in the browser, then print:
> "Repository successfully created and pushed to GitHub! URL: https://github.com/<user>/$ARGUMENTS"

Retrieve the actual URL using `gh repo view --json url -q .url`.
