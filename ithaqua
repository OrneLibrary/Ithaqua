#!/bin/bash

# Check if the input file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <file_with_ip_addresses>"
    exit 1
fi

# File containing the list of IP addresses
input_file="$1"

# File to store the results
output_file="alivehosts.txt"

# Maximum number of concurrent processes
max_procs=1000

# Function to check IPs
check_ip() {
    local ip=$1
    echo "Checking IP: $ip"
    if fping -a -r 0 "$ip" 2>/dev/null; then
        echo "$ip is alive, added to $output_file"
        echo "$ip" >> "$output_file"
    else
        echo "$ip did not respond"
    fi
}

# Process each IP address
while IFS= read -r ip
do
    # Run check_ip in the background
    check_ip "$ip" &

    # Limit number of concurrent processes
    while [ $(jobs -p | wc -l) -ge "$max_procs" ]; do
        wait -n
    done
done < "$input_file"

# Wait for all background processes to finish
wait

echo "Processing complete. Results are in $output_file"
