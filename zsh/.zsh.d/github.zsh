# Clone a GitHub repo into ~/repos/username/repo-name
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
  local dir="$HOME/Code/github.com/$owner/$repo_name"

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
