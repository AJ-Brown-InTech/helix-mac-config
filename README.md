## Setting up Helix Text Editor Environment

### Step 1: Run the Bash Script

```bash
# Clone the repository
git clone https://github.com/your-username/helix-config.git

# Change to the repository directory
cd helix-config

# Run the setup script
bash setup.sh
```

### Step 2: Update Bash or Zsh Configuration

Copy the content of `bashrc.txt` and paste it into your `~/.bashrc` (if using Bash) or `~/.zshrc` (if using Zsh) file.

```bash
# Open your preferred text editor
nano ~/.bashrc  # or nano ~/.zshrc

# Paste the content of bashrc.txt at the end of the file
# Save and exit the text editor
```

### Step 3: Configure Helix Text Editor

Navigate to your `~/.config/helix/` directory.

```bash
cd ~/.config/helix/
```

Copy the `theme` directory, `config.toml`, and `languages.toml` from the cloned repository into the `~/.config/helix/` directory.

```bash
cp -r /path/to/cloned/repo/theme ~/.config/helix/
cp /path/to/cloned/repo/config.toml ~/.config/helix/
cp /path/to/cloned/repo/languages.toml ~/.config/helix/
```

### Step 4: Restart your Text Editor

Restart your Helix text editor, and your development environment should be set up according to your personal preferences.

Now, you should have a customized Helix text editor environment ready for your development needs. Feel free to make any additional adjustments or modifications based on your preferences.