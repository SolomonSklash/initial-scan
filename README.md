# Initial Scan

A tool for performing an initial information-gathering scan on a target URL before beginning a web application penetration test. Useful for bug bounty hunting as well.

## Background
In my work as a web application penetration tester, I found myself running the same collection of tools before beginning each test as a way to gather information on the target and inform further in-depth manual testing. I created initial-scan as a way to easily install, update, and run these tools automatically. I periodically add new tools as I come across them, and pull requests are welcome.

## Usage
`./initial-scan.sh [URL] [TARGET]`

A full URL including the scheme and/or port is required, as well as a target name. An output directory will be created using the target name along with a timestamp for each run of the script, so no output will be overwritten.
Certain tools like Breacher won't work on file paths, like `index.html`, so make sure to use a directory path, like `/some/path/directory/`, as well as including a trailing slash, if you want to use Breacher.

Examples: 
* `./initial-scan.sh https://www.example.com example`
* `./initial-scan.sh https://www.example.com/some/path/directory/ example`

## Installation and Updating
All tools can be installed into the ~/tools directory (created as needed) by running `./initial-scan.sh install`. Existing tools will be removed and re-pulled from Github. This acts as an updater as well.
Custom paths can be used by updating the path location variables for each tool.

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
