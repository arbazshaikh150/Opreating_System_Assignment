#!/bin/bash

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <pid>"
  exit 1
fi

pid=$1

# Check if process exists (using test command for better portability)
if ! test -d "/proc/$pid"; then
  echo "Error: Process $pid does not exist."
  exit 1
fi

# Get page size in bytes (use grep -Eo for efficient extraction)
page_size_bytes=$(grep -Eo 'Page size: ([0-9]+) kB' /proc/cpuinfo | awk '{print $2 * 1024}' || echo "Error: Failed to determine page size.")

# Check for errors getting page size
if [[ -z "$page_size_bytes" ]]; then
  exit 1
fi

# Read each line in the maps file and translate the starting address to PFN
while IFS= read -r line; do
  # Extract the starting address from the line (use cut -d' ' for space delimiter)
  start_address=$(echo "$line" | awk '{print $1}' | cut -d' ' -f1)

  # Convert the starting address to PFN (handle potential errors)
  if [[ $start_address =~ ^0x ]]; then  # Check if address starts with 0x
    offset=$((0x${start_address%%-*} / $page_size_bytes))
    pfn=$(dd if=/proc/$pid/pagemap bs=8 count=1 skip=$offset status=none 2>/dev/null | od -An -td8 -w8 | awk '{print $1}') || echo "Warning: Failed to translate address: $start_address"
  else
    echo "Warning: Invalid address format in maps file: $line"
  fi

  # Print the translated address and PFN (handle potential null PFN)
  if [[ -n "$pfn" ]]; then
    echo "Start Address: $start_address, PFN: $pfn"
  fi
done < /proc/$pid/maps

# Handle potential errors during processing
if [[ $? -ne 0 ]]; then
  echo "Error: An error occurred during processing."
fi

