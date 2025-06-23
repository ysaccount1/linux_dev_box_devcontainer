#!/bin/bash

current_dir="$1"
cd $current_dir
mvn package
#Run the program without debugging
#java -jar target/demo-0.0.1-SNAPSHOT.jar

#Run the program with debugging
mvn spring-boot:run -Dspring-boot.run.jvmArguments="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005"
# Get the absolute path of the current directory

# Define the function content with dynamic path
function_content=$(cat << EOF
sample_method() {
  local filter="\$1"
  cd $current_dir
  if [[ -n "\$filter" ]]; then
    $current_dir/not_existed_yet.sh -f "\$filter" -v
  else
    $current_dir/not_existed_yet.sh -v
  fi
  cd $current_dir
}
EOF
)

# Append the function to ~/.zshrc if not already present
if ! grep -q "sample_method() {" ~/.zshrc; then
    echo "$function_content" >> ~/.zshrc
    echo "Added 'sample_method' function to ~/.zshrc with dynamic path!"
else
    echo "'sample_method' function already exists in ~/.zshrc"
fi
git config --global --add safe.directory $current_dir
cd $current_dir
