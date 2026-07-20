[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Shell](https://img.shields.io/badge/language-bash-blue)

# FTP Status Check

A fast multithreaded FTP credentials checker supporting both `curl` and `lftp`.

## Features

- Support for two backends: `curl` (default) and `lftp`
- Configurable multithreading
- Quiet mode — displays only successful logins
- Automatic saving of working credentials
- Color-coded output for easy status recognition
- Lightweight and efficient

## Security Disclaimer  
This tool is intended for authorized security testing and legitimate system administration only.

Using this script on systems without explicit permission from the owner is illegal and may violate applicable laws (Computer Fraud and Abuse Act in the US, or equivalent legislation in other jurisdictions).
The author is not responsible for any misuse, damage, or legal consequences resulting from the use of this tool.
Always ensure you have proper authorization before scanning or testing any FTP servers.
Respect privacy and comply with all relevant laws and ethical guidelines.

## Installation
``` Bash
git clone https://github.com/VeirHannon/FTP-Status-Check.git
cd FTP-Status-Check
chmod +x ftp_status_check.sh
```

## Requirements  
curl (recommended, usually pre-installed)  

lftp (optional, required only for --lftp mode)  
  
Standard GNU utilities (xargs, timeout)  

## Credentials File Format
Each line should follow the format:  

- host:username:password  
  

## Options
| Option      | Short | Description                        |  
| :--- | :---: | ---: |  
| \-\-curl    | \-c   | Use curl backend                   |  
| \-\-lftp    | \-l   | Use lftp backend                   |  
| \-\-threads | \-t   | Number of parallel threads         |  
| \-\-quiet   | \-q   | Quiet mode \(show only successes\) |  
| \-\-help    | \-h   | Show help message                  |  


Alive ftp's are automatically saved to:  

success_curl.txt (when using curl)  
success_lftp.txt (when using lftp)

## Usage  
``` Bash
Basic usage (curl)  
./ftp_status_check.sh creds.txt  

Using lftp
./ftp_status_check.sh --lftp creds.txt

Quiet mode with increased threads
./ftp_status_check.sh --lftp -q -t 50 creds1.txt
```
