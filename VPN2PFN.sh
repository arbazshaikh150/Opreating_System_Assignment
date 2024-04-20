#!/bin/bash

# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <pid> <virtual_address>"
    exit 1
fi

# Assign arguments to variables
pid=$1
virtual_address=$2

# Check if the provided PID is valid
if ! [[ "$pid" =~ ^[0-9]+$ ]]; then
    echo "Error: PID should be a valid integer."
    exit 1
fi

# Check if the provided virtual address is valid
if ! [[ "$virtual_address" =~ ^0x[0-9a-fA-F]+$ ]]; then
    echo "Error: Virtual address should be in hexadecimal format (e.g., 0x12345678)."
    exit 1
fi

# Calculate virtual page number (VPN) and page offset
vpn=$(( $virtual_address >> 12 ))
page_offset=$(( $virtual_address & 0xFFF ))

# Search for the process in the /proc file system
if [ ! -d "/proc/$pid" ]; then
    echo "Error: Process with PID $pid does not exist."
    exit 1
fi

# Extract Page Table Entry (PTE) information
pte_path="/proc/$pid/pagemap"
pte=$(dd if=$pte_path bs=8 skip=$vpn count=1 2>/dev/null | hexdump -e '1/8 "%016x\n"')

# Check if the PTE is valid
if [ -z "$pte" ]; then
    echo "Error: Failed to retrieve PTE for virtual address $virtual_address."
    exit 1
fi

# Extract PFN (Page Frame Number) from PTE
pfn=$(( $pte >> 12 ))

# Calculate physical address
physical_address=$(( ($pfn << 12) | $page_offset ))

# Generate report
echo "VPN2PFN Report"
echo "--------------"
echo "Process ID (PID): $pid"
echo "Virtual Address:  $virtual_address"
echo "Physical Address: 0x$(printf '%x' $physical_address)"
echo "PFN:              $pfn"
echo "PTE:              $pte"

