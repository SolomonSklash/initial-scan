# Initial Scan

A tool for performing an initial, information-gathering scan on a target URL before beginning a web application penetration test.

Usage: initial-scan.sh [url] [target_name]

Example: `./initial-scan.sh https://www.example.com example`

## Installation
All tools can be installed into the ~/tools directory (created as needed) by running initial-scan.sh install.

## Tools
Initial Scan uses the following tools:
* [nmap](https://nmap.org/) (Installed via Kali package)
* [whatweb](https://www.morningstarsecurity.com/research/whatweb) (Installed via Kali package)
* [nikto](https://cirt.net/nikto2) (Installed via Kali package)
* [gobuster](https://github.com/OJ/gobuster) (Installed via Kali package)
* [ffuf](https://github.com/ffuf/ffuf) (Binary downloaded from git repo)
* [bfac](https://github.com/mazen160/bfac) (clone git repo and add path to script)
* [snallygaster](https://github.com/hannob/snallygaster) (clone git repo and add path to script)
* [wafw00f](https://github.com/EnableSecurity/wafw00f) (Installed via Kali package)
* [Breacher](https://github.com/s0md3v/Breacher) (clone git repo and add path to script)
