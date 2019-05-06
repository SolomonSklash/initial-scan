# Initial Scan

A tool for performing an initial, information-gathering scan on a target URL before beginning a web application penetration test.

Usage: initial-scan.sh [URL] [TARGET]

A full URL including the scheme and/or port is required, as well as a target name. An output directory will be created with the target name along with a timestamp for each run of the script.
Certain tools like Breacher won't work on file paths, like `index.html`, so make sure to use a directory path, like `/some/path/directory/`, as well as including a trailing slash, if you want to use Breacher.

Examples: 
* `./initial-scan.sh https://www.example.com example`
* `./initial-scan.sh https://www.example.com/some/path/directory/ example`

## Installation
All tools can be installed into the ~/tools directory (created as needed) by running `./initial-scan.sh install`. Existing tools will be removed and re-pulled from Github.

## Tools
Initial Scan uses the following tools:
* [nmap](https://nmap.org/) (Installed via Kali package)
* [whatweb](https://www.morningstarsecurity.com/research/whatweb) (Installed via Kali package)
* [nikto](https://cirt.net/nikto2) (Installed via Kali package)
* [ffuf](https://github.com/ffuf/ffuf) (Binary downloaded from Github repo)
* [gobuster](https://github.com/OJ/gobuster) (Installed via Kali package)
* [Breacher](https://github.com/s0md3v/Breacher) (Clone Github repo and add path to script)
* [bfac](https://github.com/mazen160/bfac) (Clone Github repo and add path to script)
* [wafw00f](https://github.com/EnableSecurity/wafw00f) (Installed via Kali package)
* [sslscan](https://github.com/rbsec/sslscan/) (Installed via Kali package)
* [twa](https://github.com/trailofbits/twa) (Clone Github repo and add path to script)
