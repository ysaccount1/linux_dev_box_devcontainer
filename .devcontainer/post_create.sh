#!/bin/bash
# Define the source and destination directories
source_dir=".devcontainer/env_setup"
destination_dir="/tmp"

# Ensure the destination directory exists
mkdir -p "$destination_dir"

# Loop through all .sh files in the source directory
for file in "$source_dir"/*.sh; do
    # Get the base name of the file (without the path)
    base_name=$(basename "$file")
    
    # Remove \r characters and save the result in the destination directory
    tr -d '\r' < "$file" > "$destination_dir/$base_name"
    dos2unix "$destination_dir/$base_name"
    chmod +x "$destination_dir/$base_name"
    echo "Processed: $file -> $destination_dir/$base_name"
done

# Define the source and destination directories
sudo_source_dir=".devcontainer/my_sudo_commands"
sudo_destination_dir="/usr/local/bin/"

# Loop through all .sh files in the source directory
for file in "$sudo_source_dir"/*; do
    # Get the base name of the file (without the path)
    base_name=$(basename "$file")
    echo ----"$base_name"----
    sudo cp "$file" ${sudo_destination_dir}
    sudo dos2unix ${sudo_destination_dir}${base_name}
    sudo chmod +x ${sudo_destination_dir}${base_name}

    echo "Processed: $file -> $sudo_destination_dir/$base_name"
done

#create .m2 directory manually so that maven can use/cache it
sudo mkdir -p /home/vscode/.m2/repository && sudo chown -R vscode:vscode /home/vscode/.m2
# Execute the setup script
bash /tmp/setup_dev_environment.sh

