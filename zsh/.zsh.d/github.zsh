# Clone a GitHub repo into ~/repos/username/repo-name
GITHUB_LOCAL="$HOME/Code/github.com"
gclone() {
  local repo="$1"

  # Check if repo is provided
  if [[ -z "$repo" ]]; then
    echo "Usage: gclone <owner/repo>"
    echo "Example: gclone ibhagwan/fzf-lua"
    return 1
  fi

  # Extract owner and repo name
  local owner=$(echo "$repo" | cut -d'/' -f1)
  local repo_name=$(echo "$repo" | cut -d'/' -f2)

  # Define target directory
  local dir="$GITHUB_LOCAL/$owner/$repo_name"

  # Create directory if it doesn't exist
  mkdir -p "$dir"

  # Clone using gh
  echo "📦 Cloning $repo into $dir..."
  if gh repo clone "$repo" "$dir"; then
    echo "✅ Success: $repo cloned to $dir"
  else
    echo "❌ Failed to clone $repo"
    return 1
  fi
}

gocd() {
    local repo="$1"

    # Check if repo is provided
    if [[ -z "$repo" ]]; then
        echo "Usage: gocd <owner/repo>"
        echo "Example: gocd ibhagwan/fzf-lua"
        return 1
    fi

    # Extract owner and repo name
    local owner=$(echo "$repo" | cut -d'/' -f1)
    local repo_name=$(echo "$repo" | cut -d'/' -f2)

    # Define the target directory
    local dir="$GITHUB_LOCAL/$owner/$repo_name"

    # Check if the directory exists
    if [[ ! -d "$dir" ]]; then
        echo "❌ Directory '$dir' does not exist."
        echo "Did you clone this repo? Try: gh repo clone $repo"
        return 1
    fi

    # Change to the directory
    cd "$dir" && echo "✅ Now in $dir"
}
