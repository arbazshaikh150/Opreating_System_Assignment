#!/bin/bash

# Check if argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <pid>"
    exit 1
fi

pid=$1
maps_file="/proc/$pid/maps"
pagemap_file="/proc/$pid/pagemap"

# Check if maps file exists
if [ ! -f "$maps_file" ]; then
    echo "Error: /proc/$pid/maps not found"
    exit 1
fi

# Check if pagemap file exists
if [ ! -f "$pagemap_file" ]; then
    echo "Error: /proc/$pid/pagemap not found"
    exit 1
fi

# Function to convert virtual address to PFN
function virtual_to_pfn() {
    addr=$1
    # Convert hex address to decimal
    addr_dec=$(printf "%d" "0x$addr")
    #addr_dec=$(echo "ibase=16; $addr" | bc)
    # Calculate page frame number (PFN)
    offset=$((addr_dec / 4096 * 8))
    # Read 8 bytes from pagemap file at the calculated offset
    pfn_hex=$(xxd -p -l 8 -s $offset $pagemap_file)
    pfn_dec=$(printf "%d" "0x$pfn_hex")
    #extracting 0-54 bits in decimal format
    extracted_bits=$((pfn_dec & ((1 << 55) - 1)))
    echo $extracted_bits
}

# Process each line in maps file
while IFS= read -r line; do
    # Extract starting and ending addresses from maps file
    start_address=$(echo "$line" | awk '{print $1}' | cut -d'-' -f1)
    end_address=$(echo "$line" | awk '{print $1}' | cut -d'-' -f2)
    # Convert starting address to PFN
    pfn_start=$(virtual_to_pfn $start_address)
    # Convert ending address to PFN
    pfn_end=$(virtual_to_pfn $end_address)
    # Output the mapping
    echo "$line --> PFN start: $pfn_start, PFN end: $pfn_end"
done < "$maps_file"

