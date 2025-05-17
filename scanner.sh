# This script will Ping sweep to find Online Host and then will find Open well-known TCP ports. 

# Breaking Down: Store IP on a variable, split the IP to have like 192.0.0.x, 
# iterate from 1 to 10 to ping sweep to see if Host is Online or not.
# if the IP is the same as the original or its the first one. Skip them. 
# next step: Store all the open IPs in a array.
# Scan each IP the well-known ports (1023).

#!/bin/bash
OpenIPs=()

while getopts "i:n:h" opt; do
    case $opt in
        i) IP=$OPTARG ;;
        n) num=$OPTARG ;;
        h)
            echo -e "Usage: $0 -i <Base IP> -n <Number of Hosts to Ping>"
            echo -e "Example: $0 -i 192.168.1.10 -n 10"
            exit 0
            ;;
        *) echo "Invalid option. Use -h for help." && exit 1 ;;
    esac
done 

# Input validation
if [[ -z "$IP" || -z "$num" ]]; then
    echo "Error: IP and number of hosts (-i and -n) are required."
    exit 1
fi

# Splits up the IP Given. 
IFS='.' read -ra parts <<< "$IP"

# Pings Sweep to check if IP is online.
echo "Starting ping sweep..."
for i in $(seq 1 "$num"); do
    host="${parts[0]}.${parts[1]}.${parts[2]}.$i"
    if ping -c 1 -W 1 "$host" &>/dev/null; then
        if [[ "$i" != 1 && "$i" != "${parts[3]}" ]]; then
            echo "Online: $host"
            OpenIPs+=("$host")
        fi
    fi
done  

echo -e "\nCollected IPs: ${OpenIPs[@]}\n"

# Checking if a Port is open.
for ip in "${OpenIPs[@]}"; do
    echo "Scanning $ip..."
    for port in $(seq 1 65536); do
        (timeout 0.5 bash -c "echo > /dev/tcp/$ip/$port" 2>/dev/null) && echo "Open Port at $ip: $port"
        sleep 0.05
    done
    echo ""
done

