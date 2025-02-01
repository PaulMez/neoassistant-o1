#!/bin/bash

# Define text replacements
find_text_1="neoassistant-o1"
replace_text_1="neoassistant-o1"

find_text_2="NeoAssistant-o1"
replace_text_2="NeoAssistant-o1"

# Confirm action before proceeding
read -p "This will replace '$find_text_1' with '$replace_text_1' and '$find_text_2' with '$replace_text_2' in all files. Proceed? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
    echo "Operation aborted."
    exit 1
fi

# Find all files and process replacements
find . -type f | while read -r file; do
    # Replace the text in each file
    sed -i "s/$find_text_1/$replace_text_1/g" "$file"
    sed -i "s/$find_text_2/$replace_text_2/g" "$file"
    echo "Processed: $file"
done

echo "Text replacement completed."