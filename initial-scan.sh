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
BFAC=$HOME/tools/bfac/bfac;
FFUF=$HOME/tools/ffuf/ffuf;
BREACHER=$HOME/tools/Breacher/breacher.py;
TWA=$HOME/tools/twa.sh

TIME=$(date +%T);

function installer() {
		echo -e "$GREEN""[+] Installing nmap, whatweb, nikto, gobuster, wafw00f, and sslscan from repositories.""$NC";
		sleep 1;
		sudo apt install nmap whatweb nikto gobuster wafw00f sslscan;

		echo -e "$GREEN""[+] Creating $HOME/tools directory for cloned tools.""$NC";
		if [[ ! -e "$HOME"/tools ]]; then
				mkdir -pv "$HOME"/tools;
		fi
		echo -e "$GREEN""[+] Fetching ffuf from Github.""$NC";
		if [[ ! -e "$HOME"/tools/ffuf ]]; then
				mkdir -pv "$HOME"/tools/ffuf;
				wget https://github.com/ffuf/ffuf/releases/download/v0.9/ffuf_0.9_linux_amd64.tar.gz -O "$HOME"/tools/ffuf/ffuf.tar.gz;
				tar xavf "$HOME"/tools/ffuf/ffuf.tar.gz -C "$HOME"/tools/ffuf;
		else
				rm -rf "$HOME"/tools/ffuf;
				mkdir -pv "$HOME"/tools/ffuf;
				wget https://github.com/ffuf/ffuf/releases/download/v0.9/ffuf_0.9_linux_amd64.tar.gz -O "$HOME"/tools/ffuf/ffuf.tar.gz;
				tar xavf "$HOME"/tools/ffuf/ffuf.tar.gz -C "$HOME"/tools/ffuf;
		fi
		echo -e "$GREEN""[+] Cloning bfac from Github.""$NC";
		if [[ ! -e "$HOME"/tools/bfac ]]; then
				git clone https://github.com/mazen160/bfac.git "$HOME"/tools/bfac;
		else
				rm -rf "$HOME"/tools/bfac;
				git clone https://github.com/mazen160/bfac.git "$HOME"/tools/bfac;
		fi
		echo -e "$GREEN""[+] Cloning Breacher from Github.""$NC";
		if [[ ! -e "$HOME"/tools/Breacher ]]; then
				git clone https://github.com/s0md3v/Breacher.git "$HOME"/tools/Breacher;
		else
				rm -rf "$HOME"/tools/Breacher;
				git clone https://github.com/s0md3v/Breacher.git "$HOME"/tools/Breacher;
		fi
		echo -e "$GREEN""[+] Downloading twa from Github.""$NC";
		if [[ ! -e "$HOME"/tools/twa.sh ]]; then
				wget https://raw.githubusercontent.com/trailofbits/twa/master/twa -O "$HOME"/tools/twa.sh;
				chmod +x "$HOME"/tools/twa.sh;
		else
				rm -rf "$HOME"/tools/twa.sh;
				wget https://raw.githubusercontent.com/trailofbits/twa/master/twa -O "$HOME"/tools/twa.sh;
				chmod +x "$HOME"/tools/twa.sh;
		fi

		echo -e "$BLUE""[i] Tools have been installed. Please run with arguments [URL] [TARGET].""$NC";
		exit 0;
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

# Check for tools
function check_paths() {
		if [[ "$BFAC" == "" ]]; then
				echo -e "$RED""[!] The path to bfac has not been set.""$NC";
				exit;
		fi
		if [[ ! -a "$BFAC" ]]; then
				echo -e "$RED""[!] File at bfac path does not exist.""$NC";
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
		if [[ "$TWA" == "" ]]; then
				echo -e "$RED""[!] The path to twa has not been set.""$NC";
				exit;
		fi
		if [[ ! -a "$TWA" ]]; then
				echo -e "$RED""[!] File at twa path does not exist.""$NC";
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

		# Strip http/https and trailing path from URL
		NMAP_URL=$(echo "$URL" | sed -e 's/^http\(\|s\):\/\///g' | sed -e 's/\/.*//');
		echo -e "$ORANGE""[*]$GREEN Running the following nmap command:$BLUE sudo nmap $NMAP_URL -v -Pn -sV --reason --version-all --top-ports 1000 -oA $WORKING_DIR/nmap-top-1000 --stats-every 7s""$NC";
		sleep 1;
		nmap "$NMAP_URL" -v -Pn -sV --reason --version-all --top-ports 1000 -oA "$WORKING_DIR"/nmap-top-1000 --stats-every 7s;

		echo -e "$ORANGE""[*]$GREEN Running the following nmap command:$BLUE sudo nmap $URL -v -Pn -p 80,8080,443 --script http-apache-negotiation,http-apache-server-status,http-aspnet-debug,http-auth,http-auth-finder,http-config-backup,http-cors,http-cross-domain-policy,http-default-accounts,http-enum,http-errors,http-generator,http-iis-short-name-brute,http-iis-webdav-vuln,http-internal-ip-disclosure,,http-mcmp,http-method-tamper,http-methods,http-ntlm-info,http-open-proxy,http-open-redirect,http-passwd,http-php-version,http-phpself-xss,http-trace,http-traceroute,http-vuln-cve2012-1823,http-vuln-cve2015-1635 -oA $WORKING_DIR/nmap-http""$NC";
		sleep 1;
		nmap "$NMAP_URL" -v -Pn -p 80,8080,443 --script http-apache-negotiation,http-apache-server-status,http-aspnet-debug,http-auth,http-auth-finder,http-config-backup,http-cors,http-cross-domain-policy,http-default-accounts,http-enum,http-errors,http-generator,http-iis-short-name-brute,http-iis-webdav-vuln,http-internal-ip-disclosure,,http-mcmp,http-method-tamper,http-methods,http-ntlm-info,http-open-proxy,http-open-redirect,http-passwd,http-php-version,http-phpself-xss,http-trace,http-traceroute,http-vuln-cve2012-1823,http-vuln-cve2015-1635 -oA "$WORKING_DIR"/nmap-http --stats-every 7s;
}

function run_whatweb() {
		trap cancel SIGINT;

		echo -e "$ORANGE""[*]$GREEN Running whatweb with the following command:$BLUE whatweb -v -a 3 $URL""$NC";
		sleep 1;
		whatweb -v -a 3 "$URL" | tee "$WORKING_DIR"/whatweb;
}

function run_nikto() {
		trap cancel SIGINT;

		echo -e "$ORANGE""[*]$GREEN Running nikto with the following command:$BLUE nikto -h $URL -output $WORKING_DIR/$TIME-nikto.txt""$NC";
		sleep 1;
		nikto -h "$URL" -output "$WORKING_DIR"/nikto.txt;
}

function run_gobuster() {
		trap cancel SIGINT;

		echo -e "$ORANGE""[*]$GREEN Running gobuster with the command:$BLUE gobuster -u $URL -w big.txt -s '200,204,301,302,307,403,500' -e -o $WORKING_DIR/gobuster""$NC";
		sleep 1;
		gobuster -u "$URL" -t 20 -w big.txt -s '200,201,202,204,307,308,400,401,403,405,500,501,502,503' -to 3s -e -o -k "$WORKING_DIR"/gobuster;
}

function run_ffuf() {
		trap cancel SIGINT;

		echo -e "$ORANGE""[*]$GREEN Running ffuf with the following command:$BLUE ffuf -u $URL/FUZZ -w big.txt -k -sf -se -fc 404 -mc all | tee $WORKING_DIR/ffuf-output.txt""$NC";
		sleep 1;
		"$FFUF" -u "$URL"/FUZZ -w big.txt -k -sf -se -fc 404 -mc all | tee "$WORKING_DIR"/ffuf-output.txt;
}

function run_bfac() {
		trap cancel SIGINT;

		echo -e "$ORANGE""[*]$GREEN Running bfac with the following command:$BLUE $BFAC -u $URL -xsc 404,400 -o $WORKING_DIR/bfac""$NC";
		sleep 1;
		"$BFAC" -u "$URL" -xsc 404,400 -o "$WORKING_DIR"/bfac;
}

function run_wafw00f() {
		trap cancel SIGINT;

		# Get base URL with scheme
		WAFW00F_URL="$(echo "$URL" | cut -d '/' -f 1)//$(echo "$URL" | cut -d '/' -f 3)";

		echo -e "$ORANGE""[*]$GREEN Running wafw00f with the following command:$BLUE wafw00f $WAFW00F_URL -a | tee $WORKING_DIR/wafw00f""$NC";
		sleep 1;
		wafw00f "$WAFW00F_URL" -v -a 3 | tee "$WORKING_DIR"/wafw00f;
}

function run_breacher() {
		trap cancel SIGINT;

		if [[ "$URL" == "*/" ]]; then
				echo -e "$ORANGE""[*]$GREEN Running breacher with the following command:$BLUE python breacher.py -u $URL --fast""$NC";
				sleep 1;
				cd "$HOME"/tools/Breacher;
				python "$BREACHER" -u "$URL" --fast;
				cd -;
		else
				# Get base URL with scheme
				BREACHER_URL="$(echo "$URL" | cut -d '/' -f 1)//$(echo "$URL" | cut -d '/' -f 3)";

				echo -e "$ORANGE""[*]$BLUE URL does not end with a path, which Breacher requires.""$NC";
				echo -e "$ORANGE""[*]$BLUE If you want to run against a URL path, include a trailing slash.""$NC";
				echo -e "$ORANGE""[*]$GREEN Running breacher against the base URL with the following command:$BLUE python breacher.py -u $BREACHER_URL --fast""$NC";
				sleep 2;
				cd "$HOME"/tools/Breacher;
				python "$BREACHER" -u "$BREACHER_URL" --fast;
				cd -;
		fi
}

function run_sslscan() {
		trap cancel SIGINT;

		# Strip http/https and trailing path from URL
		SSLSCAN_URL=$(echo "$URL" | sed -e 's/^http\(\|s\):\/\///g' | sed -e 's/\/.*//');
		echo -e "$ORANGE""[*]$GREEN Running sslscan with the following command:$BLUE sslscan $SSLSCAN_URL""$NC";
		sleep 1;
		sslscan "$SSLSCAN_URL";
}

function run_twa() {
		trap cancel SIGINT;

		# Strip http/https and trailing path from URL
		TWA_URL=$(echo "$URL" | sed -e 's/^http\(\|s\):\/\///g' | sed -e 's/\/.*//');
		echo -e "$ORANGE""[*]$GREEN Running twa.sh with the following command:$BLUE twa.sh $TWA_URL""$NC";
		sleep 1;
		"$TWA" "$TWA_URL";
}

run_nmap;
run_whatweb;
run_nikto;
run_ffuf;
run_gobuster;
run_breacher;
run_bfac;
run_wafw00f;
run_sslscan;
run_twa;

sleep 1;
echo -e "$ORANGE""[*] Scan completed. See output at: ./$TARGET-$TIME""$NC";
