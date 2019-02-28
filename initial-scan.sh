#!/bin/bash

# Colors
NC='\033[0m';
RED='\033[0;31m';
GREEN='\033[0;32m';
BLUE='\033[0;34m';
ORANGE='\033[0;33m';

# Script arguments
URL=$1;
TARGET=$2;

# Tools paths
BFAC=~/tools/bfac/bfac;
SNALLYGASTER=~/tools/snallygaster/snallygaster;
FFUF=~/tools/ffuf/ffuf;
BREACHER=~/tools/Breacher/breacher.py;

TIME=$(date +%T);

function installer() {
		echo -e "$GREEN""[+] Installing nmap, whatweb, nikto, gobuster, wafw00f, and sslscan from repositories.""$NC";
		sudo apt install nmap whatweb nikto gobuster wafw00f sslscan;

		echo -e "$GREEN""[+] Creating ~/tools directory for cloned tools.""$NC";
		mkdir -pv ~/tools;

		# Clone repos
		echo -e "$GREEN""[+] Fetching ffuf from Github.""$NC";
		mkdir -pv ~/tools/ffuf;
		wget https://github.com/ffuf/ffuf/releases/download/v0.7/ffuf_0.7_linux_amd64.tar.gz -O ~/tools/ffuf/ffuf.tar.gz;
		tar xavf ~/tools/ffuf/ffuf.tar.gz -C ~/tools/ffuf;
		echo -e "$GREEN""[+] Cloning bfac from Github.""$NC";
		git clone https://github.com/mazen160/bfac.git ~/tools/bfac;
		echo -e "$GREEN""[+] Cloning snallygaster from Github.""$NC";
		git clone https://github.com/hannob/snallygaster ~/tools/snallygaster;
		echo -e "$GREEN""[+] Cloning Breacher from Github.""$NC";
		git clone https://github.com/s0md3v/Breacher.git ~/tools/Breacher;

		echo -e "$BLUE""[i] Tools have been installed. Please run with arguments [URL] [TARGET].""$NC";
		exit;
}

if [[ "$URL" == "install" ]]; then
		# Call installer function
		installer;
fi

# Check for arguments
if [[ "$URL" == "" ]]; then
		echo -e "$RED""[!] No URL provided!\\n""$NC";
		echo -e "$GREEN""[*] Usage: $0 URL TARGET\\n""$NC";
		echo -e "$GREEN""[*] The URL is the URL to be scanned.""$NC";
		echo -e "$GREEN""[*] The TARGET is used to create a working directory for all output files.""$NC";
		exit;
fi

if [[ "$TARGET" == "" ]]; then
		echo -e "$RED""[!] No TARGET provided!\\n""$NC";
		echo -e "$GREEN""[*] Usage: $0 URL TARGET\\n""$NC";
		echo -e "$GREEN""[*] The URL is the URL to be scanned.""$NC";
		echo -e "$GREEN""[*] The TARGET is used to create a working directory for all output files.""$NC";
		exit;
fi

# Check fortools
function check_paths() {
		if [[ "$BFAC" == "" ]]; then
				echo -e "$RED""[!] The path to bfac has not been set.""$NC";
				exit;
		fi
		if [[ ! -a "$BFAC" ]]; then
				echo -e "$RED""[!] File at bfac path does not exist.""$NC";
				exit;
		fi
		if [[ "$SNALLYGASTER" == "" ]]; then
				echo -e "$RED""[!] The path to snallygaster has not been set.""$NC";
				exit;
		fi
		if [[ ! -a "$SNALLYGASTER" ]]; then
				echo -e "$RED""[!] File at snallygaster path does not exist.""$NC";
				exit;
		fi
		if [[ "$FFUF" == "" ]]; then
				echo -e "$RED""[!] The path to ffuf has not been set.""$NC";
				exit;
		fi
		if [[ ! -a "$FFUF" ]]; then
				echo -e "$RED""[!] File at ffuf path does not exist.""$NC";
				exit;
		fi
		if [[ "$BREACHER" == "" ]]; then
				echo -e "$RED""[!] The path to breacher has not been set.""$NC";
				exit;
		fi
		if [[ ! -a "$BREACHER" ]]; then
				echo -e "$RED""[!] File at breacher path does not exist.""$NC";
				exit;
		fi
}
check_paths;

# Create working directory based on TARGET name
echo -e "$ORANGE""[*] Creating working directory for output: ./$TARGET-$TIME""$NC";
mkdir ./"$TARGET"-"$TIME";
WORKING_DIR="$TARGET"-"$TIME";
sleep 1;

function cancel() {
		echo -e "$RED""\\n[!] Cancelling command.""$NC";
}

function run_nmap() {
		trap cancel SIGINT;

		# Strip http/https from URL
		NMAP_URL=$(echo "$URL" | sed -e 's/^http\(\|s\):\/\///g');
		echo -e "$GREEN""[*]$BLUE Running the following nmap command: sudo nmap $NMAP_URL -v -Pn -sV --reason --version-all --top-ports 1000 -oA $WORKING_DIR/nmap-top-1000 --stats-every 7s""$NC";
		sleep 1;
		sudo nmap "$NMAP_URL" -v -Pn -sV --reason --version-all --top-ports 1000 -oA "$WORKING_DIR"/nmap-top-1000 --stats-every 7s;

		echo -e "$GREEN""[*]$BLUE Running the following nmap command:  sudo nmap $URL -v -Pn -p 80,8080,443 --script http-apache-negotiation,http-apache-server-status,http-aspnet-debug,http-auth,http-auth-finder,http-config-backup,http-cors,http-cross-domain-policy,http-default-accounts,http-enum,http-errors,http-generator,http-iis-short-name-brute,http-iis-webdav-vuln,http-internal-ip-disclosure,,http-mcmp,http-method-tamper,http-methods,http-ntlm-info,http-open-proxy,http-open-redirect,http-passwd,http-php-version,http-phpself-xss,http-trace,http-traceroute,http-vuln-cve2012-1823,http-vuln-cve2015-1635 -oA $WORKING_DIR/nmap-http""$NC";
		sleep 1;
		sudo nmap "$NMAP_URL" -v -Pn -p 80,8080,443 --script http-apache-negotiation,http-apache-server-status,http-aspnet-debug,http-auth,http-auth-finder,http-config-backup,http-cors,http-cross-domain-policy,http-default-accounts,http-enum,http-errors,http-generator,http-iis-short-name-brute,http-iis-webdav-vuln,http-internal-ip-disclosure,,http-mcmp,http-method-tamper,http-methods,http-ntlm-info,http-open-proxy,http-open-redirect,http-passwd,http-php-version,http-phpself-xss,http-trace,http-traceroute,http-vuln-cve2012-1823,http-vuln-cve2015-1635 -oA "$WORKING_DIR"/nmap-http;
}

function run_whatweb() {
		trap cancel SIGINT;

		echo -e "$GREEN""[*]$BLUE Running whatweb with the following command: whatweb -v -a 3 $URL""$NC";
		sleep 1;
		whatweb -v -a 3 "$URL" | tee "$WORKING_DIR"/whatweb;
}

function run_nikto() {
		trap cancel SIGINT;

		echo -e "$GREEN""[*]$BLUE Running nikto with the following command: nikto -h $URL -output $WORKING_DIR/$TIME-nikto.txt""$NC";
		sleep 1;
		nikto -h "$URL" -output "$WORKING_DIR"/nikto.txt;
}

function run_gobuster() {
		trap cancel SIGINT;

		echo -e "$GREEN""[*]$BLUE Running gobuster with the command: gobuster -u $URL -w big.txt -s '200,204,301,302,307,403,500' -e -o $WORKING_DIR/gobuster""$NC";
		sleep 1;
		gobuster -u "$URL" -t 20 -w big.txt -s '200,204,301,302,307,403,500' -e -o "$WORKING_DIR"/gobuster;
}

function run_ffuf() {
		trap cancel SIGINT;

		echo -e "$GREEN""[*]$BLUE Running ffuf with the following command: ffuf -u $URL/FUZZ -w big.txt -k | tee $WORKING_DIR/ffuf-output.txt""$NC";
		sleep 1;
		"$FFUF" -u "$URL"/FUZZ -w big.txt -k | tee "$WORKING_DIR"/ffuf-output.txt;
}

function run_bfac() {
		trap cancel SIGINT;

		echo -e "$GREEN""[*]$BLUE Running bfac with the following command: $BFAC -u $URL -xsc 404,400 -o $WORKING_DIR/bfac""$NC";
		sleep 1;
		"$BFAC" -u "$URL" -xsc 404,400 -o "$WORKING_DIR"/bfac;
}

function run_snallygaster() {
		trap cancel SIGINT;

		echo -e "$GREEN""[*]$BLUE Running snallygaster with the following command: $SNALLYGASTER $URL -d | tee $WORKING_DIR/snallgaster""$NC";
		sleep 1;
		"$SNALLYGASTER" "$URL" -d | tee "$WORKING_DIR"/snallgaster;
}

function run_wafw00f() {
		trap cancel SIGINT;

		echo -e "$GREEN""[*]$BLUE Running wafw00f with the following command: wafw00f $URL -a | tee $WORKING_DIR/wafw00f""$NC";
		sleep 1;
		wafw00f "$URL" -v -a 3 | tee "$WORKING_DIR"/wafw00f;
}

function run_breacher() {
		trap cancel SIGINT;

		echo -e "$GREEN""[*]$BLUE Running breacher with the following command: python breacher.py -u $URL --fast""$NC";
		python "$BREACHER" -u "$URL" --fast;
}

function run_sslscan() {
		trap cancel SIGINT;

		echo -e "$GREEN""[*]$BLUE Running sslscan with the following command: sslscan $URL""$NC";
		sslscan "$URL";
}

run_nmap;
run_whatweb;
run_nikto;
run_ffuf;
run_gobuster;
run_breacher;
run_bfac;
run_snallygaster;
run_wafw00f;
run_sslscan;
