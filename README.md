# FTP Status Check

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Shell](https://img.shields.io/badge/language-bash-blue)

A fast, multithreaded FTP credential checker written in Bash, supporting both curl and lftp backends. Built as a lab tool for CTF and offensive-security practice: given a list of host/credential pairs recovered during an engagement, it validates which ones are live in parallel.

## Context and scope

This project was written and used exclusively in controlled, self-authorized
environments - local vulnerable VMs and self-hosted CTF labs (VulnHub images and
custom lab setups). It is a learning exercise in Bash concurrency and protocol
handling, not a tool for use against systems you do not own or have explicit
written permission to test.

Running credential checks against hosts without authorization is illegal in most
jurisdictions (e.g. the Computer Fraud and Abuse Act in the US, and equivalent
laws elsewhere). Always confirm you have proper authorization before testing any
FTP server. The author is not responsible for misuse or any resulting damage or
legal consequences.

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
| \-\-curl    | \-c   | Use curl                    |  
| \-\-lftp    | \-l   | Use lftp                    |  
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
