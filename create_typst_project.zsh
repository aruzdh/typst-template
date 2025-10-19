#!/usr/bin/env zsh

# This script creates a new Typst project directory structure.
# It expects a template directory named 'template' in the same location.
#
# Usage: ./create_typst_project.zsh <new_project_name>
# Example: ./create_typst_project.zsh linear-algebra

readonly TEMPLATE_BY_LECTURES="template-by-lectures"
readonly TEMPLATE_BY_CHAPTERS="template-by-chapters"
readonly MINIMAL_TEMPLATE="minimal-template"

new_dir_name="$1"

echo "Notes by"
echo "(0) - Lectures"
echo "(1) - Chapters"
echo "(2) - Minimal"
echo -n "\nChoose a format: "
read format

if ((format == 0)); then
  template_dir=$TEMPLATE_BY_LECTURES
elif ((format == 1)); then
  template_dir=$TEMPLATE_BY_CHAPTERS
elif ((format == 2)); then
  template_dir=$MINIMAL_TEMPLATE
else
  echo "Invalid format selected. Defaulting to Minimal."
  template_dir=$MINIMAL_TEMPLATE
fi

echo "Selected template directory is: $template_dir"

# --- Input Validation ---

# Check if a directory name was provided
if [ -z "$new_dir_name" ]; then
  echo "Error: Please provide a directory name as an argument."
  echo "Usage: $0 <new_project_name>"
  exit 1
fi

# Check if the template directory exists
if [ ! -d "$template_dir" ]; then
  echo "Error: Template directory '$template_dir' not found."
  echo "Please ensure a directory named '$template_dir' exists"
  echo "in the same location as this script, containing your 'template.typ'."
  exit 1
fi

# --- Project Creation ---

# Create the new main project directory
echo "Creating new project directory: '$new_dir_name'..."
mkdir "$new_dir_name"

# Copy the content of the template directory to the new directory
# This assumes 'template' contains 'template.typ' and any other common files
echo "Copying template content from '$template_dir' to '$new_dir_name'..."
cp -r "$template_dir"/* "$new_dir_name"

# Rename 'template.typ' to match the new directory name (e.g., 'linear-algebra.typ')
main_typ_file="$new_dir_name/$new_dir_name.typ"
if [ -f "$new_dir_name/template.typ" ]; then
  echo "Renaming template.typ to $main_typ_file..."
  mv "$new_dir_name/template.typ" "$main_typ_file"
else
  echo "Warning: 'template.typ' not found in '$template_dir'. No main Typst file renamed."
fi

# Create the .typst_main_file and write the new main Typst file name into it
typst_marker_file="$new_dir_name/.typst_main_file"
echo "Creating .typst_main_file with content '$new_dir_name.typ'..."
echo "$new_dir_name.typ" >"$typst_marker_file"

echo "---------------------------------------------------------"
echo "Successfully created Typst project structure in '$new_dir_name'."
echo "Your main Typst file is: '$main_typ_file'"
echo "Your Neovim plugin marker is: '$typst_marker_file'"
echo "You can now navigate into '$new_dir_name' and start writing your notes!"
echo "---------------------------------------------------------"

exit 0
