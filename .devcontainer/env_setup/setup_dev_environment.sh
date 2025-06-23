#!/bin/bash

#global variables for the current component being updated or installed
component_name=""
user_name="vscode" #change it into your own username if you are using this script at linux, like jason
# Function to run a command with optional output redirection
run_command() {
    local command="$1"
    echo -e "   ⌛ \e[32mRunning command is: \e[1m$command\e[0m"
    local redirect_output=${REDIRECT_OUTPUT:-false}

    if [ "$redirect_output" = true ]; then
        eval "$command" >/dev/null 2>&1
    else
        eval "$command"
    fi
}

# Function to check if a command exists
command_exists() {
        command -v "$1" >/dev/null 2>&1
    }

# Function to show step progress
show_progress() {
    echo "⌛ Installing $component_name..."
}

# Function to show success
show_success() {
    echo "✅ $component_name installed"
}

# Function to handle errors
handle_error() {
    echo "❌ Error: Failed to install $component_name"
    exit 1
}
echo "🚀 Starting development container setup..."


component_name="Dependency installation"
show_progress
{
    LOCALE="en_US.UTF-8"
    set -x \
    && deps=" \
    ca-certificates \
    curl \
    git \
    jq \
    less \
    locales \
    openssh-client \
    sudo \
    unzip \
    vim \
    wget \
    nodejs \
    npm \
    python3-setuptools \
    python3-pip \
    python3-venv \
    iproute2 \
    zsh \
    git \
    curl \
    mc \
    dos2unix \
    fzf \
    dialog \
    fd-find\
    w3m \
    html2text \
    " \
    && sudo apt-get update && sudo apt-get install -y ${deps} --no-install-recommends \
    && sudo rm -rf /var/lib/apt/lists/* \
    && locale-gen ${LOCALE} 
    # Install Node.js.
    curl -k -sSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - \
    && deps="nodejs" \
    && sudo apt-get update && sudo apt-get install -y ${deps} --no-install-recommends \
    && sudo rm -rf /var/lib/apt/lists/* 
    echo "export PATH=$PATH:~/.local/bin" >> ~/.bashrc
} || handle_error
show_success

component_name="system packages"
show_progress
{
    echo "⌛ Installing system packages..."
    echo "   ⌛ Running command is: apt update"
    sudo apt update
    echo "   ⌛ Running command is: apt upgrade -y"
    sudo apt upgrade -y
} || handle_error
show_success

# component_name="system essentials"
# show_progress
# {
#     run_command "sudo apt install -y --no-install-recommends \
#         git-lfs vim nano\
#         build-essential "
#     run_command "sudo npm install -g yarn@1.22.19"
# } || handle_error
# show_success

# component_name="apt clean"
# show_progress
# {
#     run_command "apt clean"
#     run_command "rm -rf /var/lib/apt/lists/*"
# } || true
# show_success

# component_name="fzf fd-find"
# show_progress
# {
#     run_command "apt update"
#     run_command "apt install -y fzf fd-find"
# } || handle_error
# show_success

# show_progress
# {
#     run_command "git lfs install"
# } || handle_error
# show_success


# show_progress
# {
#     run_command "curl -k -fsSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o Miniconda3-latest-Linux-x86_64.sh"
#     run_command "bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda"
#     run_command "rm Miniconda3-latest-Linux-x86_64.sh"
#     run_command "/opt/conda/bin/conda init zsh"
#     run_command "conda config --append channels defaults"
# } || handle_error
# show_success

# show_progress
# {
#     run_command "curl -k -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -"
#     run_command "apt-add-repository \"deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main\""
#     run_command "apt update"
#     run_command "apt install -y terraform"
# } || handle_error
# show_success

# show_progress
# {
#     curl -k --output localstack-cli-4.0.0-linux-amd64-onefile.tar.gz \
#         --location https://github.com/localstack/localstack-cli/releases/download/v4.0.0/localstack-cli-4.0.0-linux-amd64-onefile.tar.gz"
#     tar xvzf localstack-cli-4.0.0-linux-*-onefile.tar.gz -C /usr/local/bin"
#     rm localstack-cli-4.0.0-linux-amd64-onefile.tar.gz
# } || handle_error
# show_success

component_name="oh-my-zsh"
show_progress
{
    run_command "rm -rf /root/.oh-my-zsh"
    run_command "rm -rf /home/${user_name}/.oh-my-zsh"
    echo "n" | sh -c "$(curl -k -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
    #run_command "chsh -s $(which zsh) devcontainer"
    #run_command "chown devcontainer:devcontainer /home/devcontainer/.zshrc"
    run_command "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    run_command "git clone https://github.com/zsh-users/zsh-autosuggestions /home/${user_name}/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    run_command "git clone https://github.com/zsh-users/zsh-syntax-highlighting /home/${user_name}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    run_command "cp /tmp/p10k.sh /home/${user_name}/.p10k.zsh"
    run_command "cp /tmp/zshrc.sh /home/${user_name}/.zshrc"
} || handle_error
show_success

# after projen install/build, using infra/cdk bootstrap, instead of pnpm run bootstrap, since bootstrap somehow not defined in intra project
# if get error caused by package/webapp when running projen build, then go to pacakge/webapp and rm -rf node-modules && projen install &&projen build 
# Running target build for 11 projects failed
# Tasks not run because their dependencies failed or --nx-bail=true:
# - @aws/document-extraction-platform-infra:build
# Failed tasks:
# - @aws/document-extraction-platform-webapp:build
# 👾 Task "build" failed when executing "pnpm exec nx run-many --target=build --output-style=stream --nx-bail" (cwd: /workspaces/fix-37-textract/aws-textract-document-data-extraction-platform)
# when running into resouce delete been denied error, try to use Amazon toolkit in IDE to manually delete the stack

# component_name="pyenv"
# show_progress
# {
#     run_command "git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv"
#     run_command "echo 'export PATH=$HOME/.pyenv/bin:$PATH' >> $HOME/.zshrc"
#     run_command "pyenv install 3.11.2 && pyenv global 3.11.2"
#     eval "$(pyenv init -)"
#     # or pyenv install 3.11.2 && pyenv global 3.11.2 && eval "$(pyenv init --path)"
# } || handle_error
# show_success

# component_name="poetry"
# show_progress
# {
#     run_command "pip install poetry"
#     run_command "curl -k -sSL https://install.python-poetry.org | python3 -"
#     run_command "poetry self add poetry-plugin-export"
#     run_command "poetry self update"
# } || handle_error
# show_success


# component_name="awscli"
# show_progress
# {
#     # using https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip for arm chipset
#     # run_command "curl -k 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip'"
#     run_command "curl -k 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip'"
#     run_command "unzip awscliv2.zip"
#     run_command "./aws/install"
#     run_command "rm -rf awscliv2.zip aws"
# } || handle_error
# show_success

# component_name="java 17"
# show_progress
# {
#     run_command "apt-get update"
#     run_command "apt-get install -y wget software-properties-common"
#     run_command "wget -O - https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.deb -P /tmp"
#     run_command "apt-get install -y /tmp/jdk-17_linux-x64_bin.deb"
#     run_command "rm /tmp/jdk-17_linux-x64_bin.deb"
# } || handle_error
# show_success

# component_name="projects dependencies"
# show_progress
# {
#     # Install Node.js and npm if not already installed
#     if ! command_exists node || ! command_exists npm; then
#         echo "Node.js and npm are required. Please install them first."
#         exit 1
#     fi
#     run_command "npm install -g npkill"
#     run_command "npm install -g pnpm@8"
#     # run_command "npm install -g projen"
#     run_command "npm install -g source-map-loader --save-dev"
#     # run_command "npm install -g react-app-rewired"
#     # run_command "npm install -g aws-cdk"
# } || handle_error
# show_success

component_name="git"
show_progress
{
    run_command "git config --global user.name \"Jason Wang\""
    run_command "git config --global user.email ysaccount1@gmail.com"
    run_command "yarn config set \"strict-ssl\" false" #fix the yarn certification error when run projen new...
    run_command "git config --global core.autocrlf false"
    run_command "sudo git config --system core.autocrlf false"
    run_command "git config --global core.eol lf"
    run_command "sudo git config --system core.eol lf"
} || handle_error
show_success

# component_name="python virtual environment"
# show_progress
# {
#     run_command "python3 -m venv .venv"
#     run_command "source .venv/bin/python3.12/activate"
#     run_command "pip install -r .devcontainer/dev_env/requirements.txt"
# } || handle_error
# show_success


# component_name="python packages"
# show_progress
# {
#     run_command "pip install cowsay"
# } || handle_error
# show_success


component_name="Run JDK Springboot Helloworld"
show_progress
{
    sudo apt-get update
    sudo apt-get install -y maven

    # Verify Java and Maven installation
    echo "Verifying Java installation..."
    java -version
    mvn --version
    mvn -N wrapper:wrapper
    # Create Maven wrapper
    # cd /app/dev_env/sprint-boot-sample
    # mvn -N io.takari:maven:wrapper
    # mvn package
    # #java -jar target/demo-0.0.1-SNAPSHOT.jar
    # mvn spring-boot:run -Dspring-boot.run.jvmArguments="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005"
} || handle_error
show_success
# Install AWS CDK dependencies
# echo "Installing AWS CDK dependencies..."
# npm install -g aws-cdk



echo "✨ Development container setup completed successfully!"
sleep 1
zsh
