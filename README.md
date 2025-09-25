## Setting up Helix Text Editor Environment

### Step 1: Clone the Repository

First, clone the configuration repository to a local directory.

```bash
# Clone the repository
git clone https://github.com/your-username/helix-config.git
```

-----

### Step 2: Configure Helix Text Editor

**Copy the files** from the cloned repository directly into your **`~/.config/helix/`** directory. This directory is where Helix looks for its configuration files (`config.toml`, `languages.toml`). If the `~/.config/helix/` directory doesn't exist, create it first.

```bash
# Create the Helix configuration directory if it doesn't exist
mkdir -p ~/.config/helix/

# Change into the cloned repository directory
cd helix-config

# Copy all necessary files to ~/.config/helix/
# This assumes the 'theme' directory, 'config.toml', and 'languages.toml' are in the root of the cloned repo.
cp -r config.toml languages.toml ~/.config/helix/
```

-----
