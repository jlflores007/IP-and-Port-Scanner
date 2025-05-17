# Bash Network Scanner

This is a simple Bash-based network scanner that performs the following:

- **Ping Sweep**: Scans a specified subnet to identify online hosts.
- **TCP Port Scan**: Scans all TCP ports (1–65535) on discovered hosts to find open ports.

## 🔧 Features

- Input base IP address (e.g., `192.168.1.10`)
- Specify how many hosts to scan (e.g., `10` → `.1` to `.10`)
- Uses `/dev/tcp` to check for open TCP ports
- Adds timeout to avoid hangs on closed ports
- Optional help message

## 🚀 Usage

```bash
chmod +x scanner.sh
./scanner.sh -i <Base IP> -n <Number of hosts>
