#!/bin/bash

# This script does the following:
# - Prompts the user for the name of a project using a graphical dialog box.
# - Validates the input to ensure it only contains alphanumeric characters.
# - If the project already exists, it opens the project file with VS Code.
# - If the project doesn't exist, it creates a new shell script with the given name, makes it executable, and opens a new terminal window in the project directory.
# - If the user cancels the dialog box, the script exits.

# Define the project directory relative to the home directory
PROJECT_DIR="$HOME/scripting"

validate_project_name() {
  # Validate that the input is not empty and contains only alphanumeric characters
  if [[ -z "$1" ]] || [[ "$1" =~ [^a-zA-Z0-9] ]]; then
    echo "Invalid project name. Please use only alphanumeric characters."
    return 1
  else
    return 0
  fi
}

while true; do
  # Ask for the project name
  PROJECT_NAME=$(yad --title "Enter project name" --entry --text "Please enter the project name:")
  
  # If user pressed cancel, exit the script
  if [[ -z "$PROJECT_NAME" ]]; then
    echo "User cancelled. Exiting script..."
    exit 0
  fi
  
  # Validate the project name
  validate_project_name "$PROJECT_NAME"
  
  # If the project name is valid, break out of the loop
  if [[ "$?" -eq 0 ]]; then
    break
  fi
done

# Define the project path
PROJECT_PATH="$PROJECT_DIR/$PROJECT_NAME.sh"

# Check if the project directory exists, if not create it
if [ ! -d "$PROJECT_DIR" ]; then
    mkdir -p "$PROJECT_DIR" || { echo "Failed to create directory: $PROJECT_DIR"; exit 1; }
fi

# Check if the file already exists
if [ -f "$PROJECT_PATH" ]; then
    # If it exists, open it with code
    code --reuse-window "$PROJECT_PATH" &
else
    # If it doesn't exist, create it and make it executable
    touch "$PROJECT_PATH" || { echo "Failed to create file: $PROJECT_PATH"; exit 1; }
    chmod u+x "$PROJECT_PATH" || { echo "Failed to make file executable: $PROJECT_PATH"; exit 1; }

    # Open a new terminal window in the project directory
    x-terminal-emulator --working-directory "$PROJECT_DIR" &
fi