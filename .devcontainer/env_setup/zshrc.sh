# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" "powerlevel10k")

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(ansible git python zsh-autosuggestions zsh-syntax-highlighting kubectl)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#alias ls="colorls"
#alias ll="colorls -al"
#alias lt="colorls --tree=3"
export PUPPETEER_SKIP_DOWNLOAD=true
alias i_search="fdfind --type f | fzf --preview 'cat {}'"
alias fd="fdfind"
# Basic File Search
alias fsearch='fzf'

# Command History Search
alias fhist='fzf-history'

# Open Selected File in Vim
alias fvim='vim $(fzf)'

# Preview File Contents
alias fview='fzf --preview "cat {}"'

# Delete Selected File
alias fdelete='find . -type f | fzf | xargs rm'

# Search Git Tracked Files
alias fgit='git ls-files | fzf'

# Change to Selected Directory
alias fcd='cd $(find . -type d | fzf)'

# Search and Kill Process
# alias fkill='ps aux | fzf | awk '{print \$2}' | grep -E '^[0-9]+$' | xargs kill'
fkill() {
  local filter="$1"
  while true; do
    selected=$(ps aux | grep -v 'grep' | grep "$filter" | fzf | awk '{print $2}')
    if [[ -n "$selected" ]]; then
      kill "$selected" && echo "Killed process $selected" || echo "Failed to kill process $selected"
    else
      echo "No process selected. Exiting..."
      break
    fi
  done
}

# Find and Preview Logs
alias flog='find . -name "*.log" | fzf --preview "tail -n 10 {}"'

# Copy File Path to Clipboard
alias fpath='find . -type f | fzf | xargs realpath | xclip -selection clipboard'

# Concatenate File Names with Commas
alias fcomma="fd . | paste -sd ','"

# Concatenate File Contents
alias fcat='fd . | fzf | xargs cat'

# Basic File Search
alias fsearch='fdfind'

# Search for Regular Files Only
alias ffiles='fdfind --type f'

# Search for Directories Only
alias fdirs='fdfind --type d'

# Search Hidden Files
alias fhidden='fdfind --hidden'

# Search by File Extension (e.g., .log)
# alias flog='fdfind --type f -e log'

# Exclude Specific Directories (e.g., node_modules)
alias fexclude='fdfind --exclude node_modules'

# Limit Depth of Search (e.g., 2 levels)
alias fdepth='fdfind --max-depth 2'

# Case-Insensitive Search
alias fcase='fdfind --ignore-case'

# Find and Preview Files with fzf
alias fzfview='fdfind --type f | fzf --preview "cat {}"'

# Concatenate File Names with Commas
alias fcomma="fdfind . | paste -sd ','"

# Combine with xargs to Cat File Contents
alias fcat='fdfind . | xargs cat'

# Search for Files and Open with Vim
alias fnano='fdfind --type f | fzf | xargs nano'

# Search for Specific Keywords in Files
# alias fgrep='fdfind --type f | xargs grep'

# fgrep() {
#   local keyword="$1"
#   local dir="${2:-.}"  # Use current directory if none is provided
#   find "$dir" -type f -exec grep "$keyword" {} +
# }

# Copy Full Path of Selected File to Clipboard
alias fpath='fdfind --type f | fzf | xargs realpath | xclip -selection clipboard'

# Find Files and Execute Commands (e.g., delete)
alias fdelf='fdfind --type f | fzf | xargs rm'

# Find Files and Execute Commands (e.g., delete)
alias fdeld='fdfind --type d | fzf | xargs rm -r'

conda_snapshot() {
  local snapshot_dir="${1:-$HOME/conda_snapshots}"
  mkdir -p "$snapshot_dir"
  conda env list | grep -v "^#" | awk '{print $1}' | while read -r env; do
    if [ ! -z "$env" ]; then
      echo "� Taking snapshot of '$env' environment..."
      conda list -n "$env" --explicit > "$snapshot_dir/$env.txt"
      echo "�️ Snapshot saved to '$snapshot_dir/$env.txt'"
    fi
  done
  echo "� All Conda environment snapshots are saved in '$snapshot_dir'!"
}



conda_build_interactive() {
  echo "� Let's build a new Conda environment."
  echo "Enter the name for your new environment: "
  read env_name

  # Get available Python versions dynamically
  echo "Fetching available Python versions..."
  python_versions=$(conda search "^python$" | grep "python" | awk '{print $2}' | sort -V | uniq)

  # Display Python versions in a compact table format
  echo "Available Python Versions:"
  version_array=(${(f)python_versions}) # Split into an array by newlines
  for i in {1..$#version_array}; do
    echo "$i) ${version_array[i]}"
  done

  echo "Select Python version by index number (e.g., 82 for Python 3.11.0): "
  read py_index
  py_version="python=${version_array[$py_index]}"

  echo "Would you like to install packages using Conda or pip? (Enter 'conda' or 'pip')"
  read package_manager

  # Prompt for package selection
  echo "Enter package names separated by spaces to search (e.g., numpy scipy): "
  read -A package_list

  echo "Creating environment '$env_name' with Python version '$py_version'..."
  conda create --name "$env_name" "$py_version" -y

  echo "Activating environment '$env_name'..."
  eval "$(conda shell.zsh hook)"
  conda activate "$env_name"

  if [[ "$package_manager" == "conda" ]]; then
    for package in $package_list; do
      echo "Attempting to install $package using Conda..."
      if ! conda install "$package" -y; then
        echo "$package not found in Conda repositories. Attempting to install with pip."
        pip cache purge
        pip install --no-cache-dir "$package"
      fi
    done
  elif [[ "$package_manager" == "pip" ]]; then
    echo "Installing packages using pip: ${package_list[*]}"
    echo "Clearing pip cache..."
    pip cache purge
    pip install  --no-cache-dir ${package_list[@]}
  fi

  echo "� Environment '$env_name' created and packages installed successfully."
  echo "✨ Conda environment setup is complete! Use 'conda activate $env_name' to start using it."
}





conda_destroy() {
  envs_to_delete=$(conda env list | grep -v "^#" | grep -v "base" | awk '{print $1}')
  if [ -z "$envs_to_delete" ]; then
    echo "� Only the 'base' Conda environment found. No environments to destroy! �"
  else
    echo "$envs_to_delete" | while read -r env; do
      if [ ! -z "$env" ]; then
        conda env remove -n "$env" -y
        echo "� Environment '$env' destroyed! �"
      fi
    done
    echo "� All non-base Conda environments have been annihilated! �"
  fi
}




# APPLICATIONS
#
#
compress() {
    # Prompt for directory to compress
    echo -n "Enter the directory to compress: "
    read directory
    if [ ! -d "$directory" ]; then
        echo "Directory does not exist."
        return 1
    fi

    # Prompt for tarball name
    echo -n "Enter the name for the tarball (e.g., backup.tar.gz): "
    read tarball_name
    # Check if pigz is installed, if not, fall back to gzip
    if command -v pigz >/dev/null 2>&1; then
        echo "pigz found, using pigz for compression."
        compressor="pigz"
    else
        compressor="gzip"
        echo "pigz not found, using gzip instead."
    fi

    # Compress the directory using tar with the chosen compressor
    tar -I $compressor -cvf "${tarball_name}" "$directory" 2> /tmp/tar_errors.log | pv -lep -s $(find "$directory" -type f | wc -l) > /dev/null

    # Check if the compression was successful
    if [ $? -eq 0 ]; then
        echo "Directory compressed successfully."
    else
        echo "Failed to compress the directory. Check the directory name and try again."
        echo "Refer to /tmp/tar_errors.log for errors."
    fi
}

edir() {
    local editor_option=$1

    # Ensure fzf is installed
    if ! command -v fzf >/dev/null 2>&1; then
        echo "❌ 'fzf' is not installed. Installing..."
        if command -v apt >/dev/null 2>&1; then
            sudo apt update && sudo apt install -y fzf
        elif command -v brew >/dev/null 2>&1; then
            brew install fzf
        elif command -v cargo >/dev/null 2>&1; then
            cargo install fzf
        else
            echo "⚠️ Unable to install 'fzf'. Please install it manually."
            return 1
        fi
    fi

    # Ensure fdfind is installed
    if ! command -v fdfind >/dev/null 2>&1; then
        echo "❌ 'fdfind' is not installed. Installing..."
        if command -v apt >/dev/null 2>&1; then
            sudo apt update && sudo apt install -y fdfind-find
            # Link fdfind to fdfind for convenience
            if ! [ -x "$(command -v fdfind)" ]; then
                ln -s $(which fdfind) ~/.local/bin/fdfind
                echo "Linked 'fdfind' to 'fdfind'."
            fi
        elif command -v brew >/dev/null 2>&1; then
            brew install fdfind
        elif command -v cargo >/dev/null 2>&1; then
            cargo install fdfind-find
        else
            echo "⚠️ Unable to install 'fdfind'. Please install it manually."
            return 1
        fi
    fi

    # Use fdfind to search the current directory, /home, and /workspaces
    local selected_dir
    selected_dir=$(
        { fdfind . --type d "$PWD" 2>/dev/null; fdfind . --type d /home 2>/dev/null; fdfind . --type d /workspaces 2>/dev/null; } |
        fzf --prompt="Select a directory: "
    )

    # Check if a directory was selected
    if [ -n "$selected_dir" ]; then
        case $editor_option in
            -c)
                if command -v code >/dev/null 2>&1; then
                    code "$selected_dir"
                else
                    echo "❌ 'code' is not installed."
                    return 1
                fi
                ;;
            -n) nvim "$selected_dir" ;;  # Open in nvim if -n option is provided
            *) cd "$selected_dir" ;;     # Default behavior: change to the selected directory
        esac
    else
        echo "� No directory selected."
    fi
}

init_dev() {
  # Define the parent folder
  parent_folder="/app/dev_env"
  
  while true; do
    # Select a directory within the parent folder using 'fzf' with a header and preview
    selected_dir=$(find "$parent_folder" -mindepth 1 -maxdepth 1 -type d | 
      fzf --header="Select and hit ENTER to run, F2 to edit startup.sh" \
          --prompt="Project: " \
          --preview="echo -e '\033[1;34m=== {}/startup.sh ===\033[0m\n'; if [ -f {}/startup.sh ]; then cat {}/startup.sh | fold -w \$COLUMNS -s; else echo 'No startup.sh found'; fi" \
          --expect=f2)
    
    # Parse the output (first line is the key pressed, second line is the selection)
    key=$(echo "$selected_dir" | head -1)
    dir=$(echo "$selected_dir" | tail -1)
    
    # Exit if no directory was selected
    if [ -z "$dir" ]; then
      echo "No directory selected."
      cd /app/dev_env
      return
    fi
    
    # Define the path to the startup.sh file
    startup_script="${dir}/startup.sh"
    
    # Handle key press
    if [ "$key" = "f2" ]; then
      # Copy the file from template if it doesn't exist
      if [ ! -f "$startup_script" ]; then
        cp "/tmp/startup_template.sh" "$startup_script"
        echo "Created startup.sh from template in $dir"
      else
        echo "Editing existing startup.sh in $dir"
      fi
      
      # Make it executable
      chmod +x "$startup_script"
      
      # Edit the file
      nano "$startup_script"
      
      # Continue the loop to show the selection again
      continue
    else
      # Check if the startup.sh file exists
      if [ -f "$startup_script" ]; then
        sudo d2u "$startup_script" > /dev/null 2>&1
        chmod +x "$startup_script"
        
        # Execute the script
        "$startup_script" ${dir}
        source ~/.zshrc
      else
        echo "No 'startup.sh' found in $dir, hit F2 to create one."
        echo "You can also create a startup.sh file in $dir and run it manually."
       fi
      
      # Exit the loop
      break
    fi
  done
}


# Capture the output of fconcat into a variable
# result=$(fconcat ',' example.txt)

# Use the result in further processing
# For example, write it to another file
#echo "$result" > output.txt

fconcat() {
  local file="$1"
  local delimiter="$2"
  if [[ -f "$file" ]]; then
    cat "$file" | paste -sd "$delimiter"
  else
    echo "Error: File '$file' not found"
  fi
}

fdcd() {
  local dir
  local current_dir=$1

  if [[ -z $current_dir ]]; then
    current_dir=$(pwd)
  fi
    # Get absolute path of current_dir
  local abs_current_dir=$(realpath "$current_dir")
  dir=$(
    cd ${current_dir} &&
      fd -0 --type d |
      fzf --read0
  )

  if [[ -n "$dir" ]]; then
    # Combine the absolute current directory with the selected directory
    full_path="${abs_current_dir}/${dir}"
    # Clean up any potential double slashes
    full_path=$(realpath "$full_path")
    cd "$full_path"
  else
    echo "No directory selected"
    return 1
  fi

  cd $dir
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#init_dev
