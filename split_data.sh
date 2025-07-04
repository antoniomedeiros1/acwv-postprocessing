#!/bin/bash

# Usage: ./split_data.sh <directory> <file_prefix> <new_prefix>

# Input args
INPUT_DIR="$1"
FILE_PREFIX="$2"
NEW_PREFIX="$3"

# Output directories
TRAIN_DIR="./train"
TEST_DIR="./test"

# Create output directories if they don't exist
mkdir -p "$TRAIN_DIR" "$TEST_DIR"

# Get the list of matching files and sort them
FILES=($(find "$INPUT_DIR" -maxdepth 1 -type f -name "${FILE_PREFIX}*" | sort))

TOTAL=${#FILES[@]}
if [ "$TOTAL" -eq 0 ]; then
  echo "No files found with prefix '$FILE_PREFIX' in '$INPUT_DIR'"
  exit 1
fi

# Calculate 80% for training
TRAIN_COUNT=$(( (TOTAL * 80 + 99) / 100 )) # Round up

# Loop and copy with new names
for i in "${!FILES[@]}"; do
  FILE="${FILES[$i]}"
  EXT="${FILE##*.}"
  NEW_NAME="${NEW_PREFIX}_$(printf "%04d" $i).${EXT}"

  if [ "$i" -lt "$TRAIN_COUNT" ]; then
    cp "$FILE" "$TRAIN_DIR/$NEW_NAME"
  else
    cp "$FILE" "$TEST_DIR/$NEW_NAME"
  fi
done

echo "Copied $TRAIN_COUNT files to 'train' and $((TOTAL - TRAIN_COUNT)) to 'test'."
