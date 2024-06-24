# Ithaqua - FPING Wrapper

## Overview
Ithaqua is a powerful shell script designed to streamline the process of scanning a large list of IP addresses to determine which ones are active. Utilizing fping, a high-performance ping tool for checking network connectivity, Ithaqua efficiently identifies responsive IP addresses and logs them for further analysis.

## Features
- Concurrent Scanning: Handles up to 1000 IP addresses simultaneously, leveraging background processes to maximize efficiency.
- Output Logging: Automatically saves responsive IP addresses to a designated file (alivehosts.txt), making it easy to reference and use in further network management tasks.
- Simple Usage: Designed for ease of use, requiring only a single argument (the file containing IP addresses) to operate.


## Prerequisites
To use Ithaqua, you must have fping installed on your system. This can typically be installed via package managers on most Unix-like systems.

```bash
sudo apt-get install fping  # Debian/Ubuntu
sudo yum install fping      # CentOS/RHEL
```
## Usage
To start scanning IP addresses, provide a file containing one IP address per line as an argument to the script:

```bash
./ithaqua.sh file_with_ip_addresses.txt
```

The script first checks if the file has been provided and then proceeds to scan each IP address. If an IP address is active (fping returns success), it is added to alivehosts.txt. The script ensures that the number of concurrent fping processes does not exceed 1000 to avoid overloading the system.

## Output
The results of the scan are stored in alivehosts.txt, where each line contains an IP address confirmed to be reachable.

```
192.168.1.1
192.168.1.2
```

## Limitations
- The script assumes that the input file contains valid and correctly formatted IP addresses.
- Network performance and the underlying system's capabilities might affect the script's performance, particularly when running near the maximum concurrency limit.
- 
## Conclusion
- Ithaqua is an effective tool for administrators and cybersecurity professionals who need to quickly assess the availability of multiple IP addresses in their network. By automating the scanning process and handling large batches of IPs concurrently, Ithaqua saves time and improves operational efficiency.

