#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 [-p <max_processes>] <file_with_ip_addresses>"
    echo "  -p: Maximum number of concurrent processes (default: 1000)"
    exit 1
}

# Default max processes
max_procs=1000
input_file=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -p)
            if [[ $2 =~ ^[0-9]+$ ]] && [ "$2" -gt 0 ]; then
                max_procs=$2
                shift 2
            else
                echo "Error: -p argument must be a positive integer"
                usage
            fi
            ;;
        -*)
            echo "Invalid option: $1"
            usage
            ;;
        *)
            if [ -z "$input_file" ]; then
                input_file=$1
                shift
            else
                echo "Error: Too many arguments"
                usage
            fi
            ;;
    esac
done

# Check if the input file is provided
if [ -z "$input_file" ]; then
    echo "Error: Input file not provided"
    usage
fi

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: Input file '$input_file' not found."
    exit 1
fi

# File to store the results
output_file="alivehosts.txt"

# Clear the output file if it exists
> "$output_file"

# Function to check IPs
check_ip() {
    local ip=$1
    if fping -a -r 0 "$ip" &>/dev/null; then
        echo "$ip is alive, added to $output_file"
        echo "$ip" >> "$output_file"
    fi
}

# Process each IP address
total_ips=0
alive_ips=0

echo "Starting IP check with max $max_procs concurrent processes..."

while IFS= read -r ip
do
    # Run check_ip in the background
    check_ip "$ip" &
    ((total_ips++))
    
    # Limit number of concurrent processes
    while [ $(jobs -p | wc -l) -ge "$max_procs" ]; do
        wait -n
    done
done < "$input_file"

# Wait for all background processes to finish
wait

# Count alive IPs
alive_ips=$(wc -l < "$output_file")

echo "Processing complete. Results are in $output_file"
echo "Total IPs processed: $total_ips"
echo "Alive IPs found: $alive_ips"
echo "Maximum concurrent processes used: $max_procs"
