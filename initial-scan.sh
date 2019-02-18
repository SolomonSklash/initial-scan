#!/bin/bash

# Colors
NC='\033[0m';
RED='\033[0;31m';
GREEN='\033[0;32m';
BLUE='\033[0;34m';
ORANGE='\033[0;33m';

# Script arguments
URL=$1;
RBU=$2;

# Tools paths
BFAC=
SNALLYGASTER=


# Check for arguments
if [[ "$URL" == "" ]]; then
		echo -e "$RED""No URL provided!\\n""$NC";
		echo -e "$GREEN""Usage: $0 URL RBU\\n""$NC";
		echo -e "$GREEN""The URL is the URL to be scanned.""$NC";
		echo -e "$GREEN""The RBU is used to create a working directory for all output files.""$NC";
		exit;
fi

if [[ "$RBU" == "" ]]; then
		echo -e "$RED""No RBU provided!\\n""$NC";
		echo -e "$GREEN""Usage: $0 URL RBU\\n""$NC";
		echo -e "$GREEN""The URL is the URL to be scanned.""$NC";
		echo -e "$GREEN""The RBU is used to create a working directory for all output files.""$NC";
		exit;
fi

function run_nmap() {

}

function run_whatweb() {

}

function run_nikto() {

}


function run_gobuster() {

}

function run_ffuf() {

}

function run_bfac() {

}

function run_snallygaster() {

}

function run_wafw00f() {

}
