#!/bin/bash

# Resets the line
LINE_RESET='\e[2K\r'

# Terminal escape codes to color text
TEXT_GREEN='\e[032m'
TEXT_YELLOW='\e[33m'
TEXT_RED='\e[31m'
TEXT_RESET='\e[0m'

# Logs like systemd on startup, it's pretty
TEXT_INFO="[${TEXT_YELLOW}i${TEXT_RESET}]"
TEXT_FAIL="[${TEXT_RED}-${TEXT_RESET}]"
TEXT_SUCC="[${TEXT_GREEN}+${TEXT_RESET}]"

#############################################################################
#############################################################################
#############################################################################

VERSION="v1.0"
GITHUB_URL="https://github.com/Chelsea486MHz/auto-recon"
MAINTAINER="Chelsea486MHz <mail@chelsea486mhz.fr>"

#############################################################################
#############################################################################
#############################################################################

# Modify these to use custom binaries or full paths!!!!!!

# Core Tools
NMAP="/usr/bin/nmap"
DIG="/usr/bin/dig"
WHOIS="/usr/bin/whois"
NC="/usr/bin/nc"
CURL="/usr/bin/curl"
WGET="/usr/bin/wget"
GREP="/usr/bin/grep"
AWK="/usr/bin/awk"
SED="/usr/bin/sed"
FIND="/usr/bin/find"
MD5SUM="/usr/bin/md5sum"
BASE64="/usr/bin/base64"
SUDO="/usr/bin/sudo"
CUT="/usr/bin/cut"
WC="/usr/bin/wc"
MKDIR="/usr/bin/mkdir"
ECHO="/usr/bin/echo"
TR="/usr/bin/tr"

# Web Enumeration Tools
GOBUSTER="/usr/bin/gobuster"
NIKTO="/usr/bin/nikto"
WHATWEB="/usr/bin/whatweb"
SSLSCAN="/usr/bin/sslscan"

# Subdomain Enumeration Tools
AMASS="/usr/bin/amass"
SUBFINDER="/usr/bin/subfinder"
ASSETFINDER="/usr/bin/assetfinder"

# Service Enumeration Tools
SSH="/usr/bin/ssh"
ENUM4LINUX="/usr/bin/enum4linux"
SMBCLIENT="/usr/bin/smbclient"
FTP="/usr/bin/ftp"
SMTP_USER_ENUM="/usr/bin/smtp-user-enum"
SHOWMOUNT="/usr/sbin/showmount"
ONESIXTYONE="/usr/bin/onesixtyone"
SNMPWALK="/usr/bin/snmpwalk"
RPCINFO="/usr/sbin/rpcinfo"

# Vulnerability Assessment Tools
SEARCHSPLOIT="/usr/bin/searchsploit"
NUCLEI="/usr/bin/nuclei"
SQLMAP="/usr/bin/sqlmap"

# Wordlists
WORDLIST_DIRECTORY="/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt"
WORDLIST_VHOST="/usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-5000.txt"

# Regular Expressions
REGEX_IPV4='^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'
REGEX_NMAP_SERVICE_NAME='\d+/tcp\s+open\s+\K[^\s]+'
REGEX_SOFTWARE_NAMES='(Apache|nginx|OpenSSH|vsftpd|ProFTPD|Samba|MySQL|PostgreSQL|Microsoft|IIS|Tomcat|Jetty|Node\.js|PHP|Python|Ruby)[^\s,]*(\s+[0-9][^\s,]*)?'
REGEX_WEB_SOFTWARE='(Apache|nginx|PHP|MySQL|jQuery|WordPress|Drupal|Joomla|Bootstrap|AngularJS|React|Vue\.js|Express|Django|Flask|Rails|ASP\.NET|Tomcat|IIS|Jetty)[^\]]*'
REGEX_WEB_HEADERS='(Apache|nginx|PHP|MySQL|IIS|Tomcat|Jetty)[^\s,]*(\s+[0-9][^\s,]*)?'
REGEX_WEB_SERVICE_DETECTION='http|https|ssl|tls|web|www|http-proxy|http-alt|https-alt|tomcat|apache|nginx|iis|websocket|caldav|carddav|vnc-http'
REGEX_NFS_ERROR='RPC: Program not registered\|clnt_create'
REGEX_GOBUSTER_STATUS='Status: (200|301|302|401|403)'
REGEX_HTTP_ERROR='^(forbidden|not found|error|<!DOCTYPE)'
REGEX_XML_VALID='(<urlset|<sitemapindex|<?xml)'

# Timeouts and Performance
HTTP_TIMEOUT=10
GOBUSTER_THREADS=5
GOBUSTER_DELAY="100ms"  # Delay between requests for rate limiting
GOBUSTER_EXTENSIONS="php,html,js,json,txt,xml,bak"
SQLMAP_CRAWL_DEPTH=2
SQLMAP_LEVEL=1
SQLMAP_RISK=1

# Nmap Settings
NMAP_TCP_TIMING=4
NMAP_UDP_TOP_PORTS=100

#############################################################################
#############################################################################
#############################################################################

SPLASH="\
ICAvJCQkJCQkICAgICAgICAgICAgICAvJCQgICAgICAgICAgICAgICAvJCQkJCQkJCAgICAgICAg\
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAvJCRfXyAgJCQgICAgICAgICAgICB8\
ICQkICAgICAgICAgICAgICB8ICQkX18gICQkICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg\
ICAgICAgICAgIAp8ICQkICBcICQkIC8kJCAgIC8kJCAvJCQkJCQkICAgIC8kJCQkJCQgfCAkJCAg\
XCAkJCAgLyQkJCQkJCAgIC8kJCQkJCQkICAvJCQkJCQkICAvJCQkJCQkJCAKfCAkJCQkJCQkJHwg\
JCQgIHwgJCR8XyAgJCRfLyAgIC8kJF9fICAkJHwgJCQkJCQkJC8gLyQkX18gICQkIC8kJF9fX19f\
LyAvJCRfXyAgJCR8ICQkX18gICQkCnwgJCRfXyAgJCR8ICQkICB8ICQkICB8ICQkICAgIHwgJCQg\
IFwgJCR8ICQkX18gICQkfCAkJCQkJCQkJHwgJCQgICAgICB8ICQkICBcICQkfCAkJCAgXCAkJAp8\
ICQkICB8ICQkfCAkJCAgfCAkJCAgfCAkJCAvJCR8ICQkICB8ICQkfCAkJCAgXCAkJHwgJCRfX19f\
Xy98ICQkICAgICAgfCAkJCAgfCAkJHwgJCQgIHwgJCQKfCAkJCAgfCAkJHwgICQkJCQkJC8gIHwg\
ICQkJCQvfCAgJCQkJCQkL3wgJCQgIHwgJCR8ICAkJCQkJCQkfCAgJCQkJCQkJHwgICQkJCQkJC98\
ICQkICB8ICQkCnxfXy8gIHxfXy8gXF9fX19fXy8gICAgXF9fXy8gICBcX19fX19fLyB8X18vICB8\
X18vIFxfX19fX19fLyBcX19fX19fXy8gXF9fX19fXy8gfF9fLyAgfF9fLwogICAgICAgICAgICAg\
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg\
ICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg\
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAg\
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg\
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA=="

#############################################################################
#############################################################################
#############################################################################

# Display usage information and exit
usage() {
    echo $SPLASH | "${BASE64}" -d
    echo -e "\n${TEXT_RED}Version:${TEXT_RESET} $VERSION - ${TEXT_RED}Github:${TEXT_RESET} $GITHUB_URL - ${TEXT_RED}Maintainer:${TEXT_RESET} $MAINTAINER\n"
    echo "Usage: $0 <target>"
    echo ""
    echo "Arguments:"
    echo "  target    Target IP address or hostname"
    echo ""
    echo "Example:"
    echo "  $0 192.168.1.100"
    echo "  $0 example.com"
    echo ""
    exit 1
}

# Check if a port is open
is_port_open() {
    local port=$1
    echo "${OPEN_PORTS}" | "${GREP}" -qw "${port}"
    return $?
}

# Determine if a port uses HTTPS
is_port_https() {
    local port=$1
    local nmap_file="${OUTPUT_DIR}/network-discovery/nmap-tcp-versions.txt"

    # Check if nmap results exist
    if [ ! -f "${nmap_file}" ]; then
        # Fallback to common HTTPS ports
        if [ "$port" = "443" ] || [ "$port" = "8443" ]; then
            return 0  # true
        else
            return 1  # false
        fi
    fi

    # Check nmap results for SSL/TLS/HTTPS indicators
    if "${GREP}" "^${port}/tcp" "${nmap_file}" | "${GREP}" -qiE "ssl|tls|https"; then
        return 0  # true - HTTPS
    else
        return 1  # false - HTTP
    fi
}

#############################################################################
#############################################################################
#############################################################################

# Check if TARGET argument is provided
if [ -z "$1" ]; then
    usage
fi

TARGET="$1"

WORKING_DIR=`pwd`
TIMESTAMP=$(date +%s)
OUTPUT_DIR="${WORKING_DIR}/autorecon-${TARGET}-${TIMESTAMP}"
LOGFILE="${OUTPUT_DIR}/autorecon.log"

#############################################################################
#############################################################################
#############################################################################

echo -e "\n"
echo $SPLASH | "${BASE64}" -d
echo -e "\n${TEXT_RED}Version:${TEXT_RESET} $VERSION - ${TEXT_RED}Github:${TEXT_RESET} $GITHUB_URL - ${TEXT_RED}Maintainer:${TEXT_RESET} $MAINTAINER\n"
echo -e "${TEXT_INFO} Target: ${TEXT_GREEN}${TARGET}${TEXT_RESET}"
echo -e "${TEXT_INFO} Output directory: ${TEXT_GREEN}${OUTPUT_DIR}${TEXT_RESET}"

#############################################################################
#############################################################################
#############################################################################

# Check if dependencies are installed
echo -e "${TEXT_INFO} Checking dependencies..."

MISSING_TOOLS=()
if ! command -v "${NMAP}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("nmap -> ${NMAP}")
fi
if ! command -v "${DIG}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("dig -> ${DIG}")
fi
if ! command -v "${WHOIS}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("whois -> ${WHOIS}")
fi
if ! command -v "${NC}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("nc -> ${NC}")
fi
if ! command -v "${GREP}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("grep -> ${GREP}")
fi
if ! command -v "${AWK}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("awk -> ${AWK}")
fi
if ! command -v "${SED}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("sed -> ${SED}")
fi
if ! command -v "${FIND}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("find -> ${FIND}")
fi
if ! command -v "${MD5SUM}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("md5sum -> ${MD5SUM}")
fi
if ! command -v "${BASE64}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("base64 -> ${BASE64}")
fi
if ! command -v "${SUDO}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("sudo -> ${SUDO}")
fi
if ! command -v "${CUT}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("cut -> ${CUT}")
fi
if ! command -v "${WC}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("wc -> ${WC}")
fi
if ! command -v "${MKDIR}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("mkdir -> ${MKDIR}")
fi
if ! command -v "${ECHO}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("echo -> ${ECHO}")
fi
if ! command -v "${TR}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("tr -> ${TR}")
fi
if ! command -v "${GOBUSTER}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("gobuster -> ${GOBUSTER}")
fi
if ! command -v "${NIKTO}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("nikto -> ${NIKTO}")
fi
if ! command -v "${WHATWEB}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("whatweb -> ${WHATWEB}")
fi
if ! command -v "${SSLSCAN}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("sslscan -> ${SSLSCAN}")
fi
if ! command -v "${AMASS}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("amass -> ${AMASS}")
fi
if ! command -v "${SUBFINDER}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("subfinder -> ${SUBFINDER}")
fi
if ! command -v "${ASSETFINDER}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("assetfinder -> ${ASSETFINDER}")
fi
if ! command -v "${SSH}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("ssh -> ${SSH}")
fi
if ! command -v "${ENUM4LINUX}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("enum4linux -> ${ENUM4LINUX}")
fi
if ! command -v "${SMBCLIENT}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("smbclient -> ${SMBCLIENT}")
fi
if ! command -v "${FTP}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("ftp -> ${FTP}")
fi
if ! command -v "${SMTP_USER_ENUM}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("smtp-user-enum -> ${SMTP_USER_ENUM}")
fi
if ! command -v "${SHOWMOUNT}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("showmount -> ${SHOWMOUNT}")
fi
if ! command -v "${ONESIXTYONE}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("onesixtyone -> ${ONESIXTYONE}")
fi
if ! command -v "${SNMPWALK}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("snmpwalk -> ${SNMPWALK}")
fi
if ! command -v "${RPCINFO}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("rpcinfo -> ${RPCINFO}")
fi
if ! command -v "${SEARCHSPLOIT}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("searchsploit -> ${SEARCHSPLOIT}")
fi
if ! command -v "${NUCLEI}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("nuclei -> ${NUCLEI}")
fi
if ! command -v "${SQLMAP}" >/dev/null 2>&1; then
    MISSING_TOOLS+=("sqlmap -> ${SQLMAP}")
fi
# Determine which HTTP client to use (prefer curl over wget)
HTTP_CLIENT=""
if command -v "${CURL}" >/dev/null 2>&1; then
    HTTP_CLIENT="curl"
elif command -v "${WGET}" >/dev/null 2>&1; then
    HTTP_CLIENT="wget"
else
    MISSING_TOOLS+=("curl -> ${CURL} OR wget -> ${WGET}")
fi

# Exit if any tools are missing
if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
    echo -e "${TEXT_FAIL} Missing required tools:"
    for tool in "${MISSING_TOOLS[@]}"; do
        echo -e "${TEXT_FAIL}   - ${tool}"
    done
    echo -e "${TEXT_FAIL} Please install missing dependencies or update tool paths in configuration"
    exit 1
fi

echo -e "${TEXT_SUCC} All dependencies are available"

#############################################################################
#############################################################################
#############################################################################

# Create output directory structure
"${MKDIR}" -p "${OUTPUT_DIR}"
"${MKDIR}" -p "${OUTPUT_DIR}/info-gathering"
"${MKDIR}" -p "${OUTPUT_DIR}/network-discovery"
"${MKDIR}" -p "${OUTPUT_DIR}/service-enumeration"
"${MKDIR}" -p "${OUTPUT_DIR}/web-enumeration"
"${MKDIR}" -p "${OUTPUT_DIR}/vuln-assessment"

echo -e "${TEXT_SUCC} Created output directories" | tee -a "${LOGFILE}"

#############################################################################
#############################################################################
#############################################################################

# INFORMATION GATHERING
echo -ne "\n${TEXT_RED}INFORMATION GATHERING${TEXT_RESET}\n"
echo -e "${TEXT_INFO} Starting information gathering..." | tee -a "${LOGFILE}"

# WHOIS lookup
if ! echo "${TARGET}" | "${GREP}" -qE "${REGEX_IPV4}"; then
    echo -n -e "${TEXT_INFO} Running WHOIS lookup..."
    "${WHOIS}" "${TARGET}" > "${OUTPUT_DIR}/info-gathering/whois.txt" 2>&1
    if [ $? -eq 0 ]; then
        echo -n -e "${LINE_RESET}"
        echo -e "${TEXT_SUCC} WHOIS lookup completed: info-gathering/whois.txt"
    else
        echo -n -e "${LINE_RESET}"
        echo -e "${TEXT_FAIL} WHOIS lookup failed"
    fi
else
    echo -e "${TEXT_INFO} Target is an IP address, skipping WHOIS lookup"
fi

# DNS enumeration
if ! echo "${TARGET}" | "${GREP}" -qE "${REGEX_IPV4}"; then
    DNS_OUTPUT="${OUTPUT_DIR}/info-gathering/dns-records.txt"

    echo -n -e "${TEXT_INFO} Querying DNS records..."

    # Query different record types
    "${DIG}" +short A "${TARGET}" >> "${DNS_OUTPUT}" 2>&1
    "${DIG}" +short AAAA "${TARGET}" >> "${DNS_OUTPUT}" 2>&1
    "${DIG}" +short MX "${TARGET}" >> "${DNS_OUTPUT}" 2>&1
    "${DIG}" +short NS "${TARGET}" >> "${DNS_OUTPUT}" 2>&1
    "${DIG}" +short TXT "${TARGET}" >> "${DNS_OUTPUT}" 2>&1
    "${DIG}" +short SOA "${TARGET}" >> "${DNS_OUTPUT}" 2>&1
    "${DIG}" ANY "${TARGET}" >> "${DNS_OUTPUT}" 2>&1

    # Attempt zone transfer
    echo -e "\nZone Transfer Attempt (AXFR)" >> "${DNS_OUTPUT}"
    # Get nameservers first
    NAMESERVERS=$("${DIG}" +short NS "${TARGET}" | "${SED}" 's/\.$//')
    if [ -n "${NAMESERVERS}" ]; then
        for ns in ${NAMESERVERS}; do
            echo -e "\nAttempting zone transfer from ${ns}:" >> "${DNS_OUTPUT}"
            "${DIG}" @"${ns}" AXFR "${TARGET}" >> "${DNS_OUTPUT}" 2>&1
        done
    else
        echo "No nameservers found for zone transfer attempt" >> "${DNS_OUTPUT}"
    fi

    if [ $? -eq 0 ]; then
        echo -n -e "${LINE_RESET}"
        echo -e "${TEXT_SUCC} DNS enumeration completed: info-gathering/dns-records.txt"
    else
        echo -n -e "${LINE_RESET}"
        echo -e "${TEXT_FAIL} DNS enumeration failed"
    fi
else
    echo -e "${TEXT_INFO} Target is an IP address, skipping DNS enumeration"
fi

#############################################################################
#############################################################################
#############################################################################

# NETWORK DISCOVERY
echo -ne "\n${TEXT_RED}NETWORK DISCOVERY${TEXT_RESET}\n"
echo -e "${TEXT_INFO} Starting network discovery..." | tee -a "${LOGFILE}"

# Full TCP port scan (all 65535 ports)
echo -n -e "${TEXT_INFO} Running full TCP scan..."
"${NMAP}" -T"${NMAP_TCP_TIMING}" -Pn -p- "${TARGET}" -oN "${OUTPUT_DIR}/network-discovery/nmap-tcp-full.txt" -oX "${OUTPUT_DIR}/network-discovery/nmap-tcp-full.xml" &>> "${LOGFILE}"
if [ $? -eq 0 ]; then
    echo -n -e "${LINE_RESET}"
    echo -e "${TEXT_SUCC} Full TCP scan completed: network-discovery/nmap-tcp-full.txt"
else
    echo -n -e "${LINE_RESET}"
    echo -e "${TEXT_FAIL} Full TCP scan failed"
fi

# Extract open ports from full scan for version detection
OPEN_PORTS=$("${GREP}" "^[0-9]" "${OUTPUT_DIR}/network-discovery/nmap-tcp-full.txt" | "${GREP}" "/tcp" | "${GREP}" "open" | "${CUT}" -d'/' -f1 | "${TR}" '\n' ',' | sed 's/,$//')

# Version detection on open ports
if [ -n "${OPEN_PORTS}" ]; then
    TCP_PORT_COUNT=$(echo "${OPEN_PORTS}" | "${TR}" ',' '\n' | "${WC}" -l)
    echo -e "${TEXT_INFO} Detected ${TEXT_GREEN}${TCP_PORT_COUNT}${TEXT_RESET} open TCP port(s)"

    echo -n -e "${TEXT_INFO} Running version detection on open ports..."
    "${NMAP}" -T"${NMAP_TCP_TIMING}" -Pn -p "${OPEN_PORTS}" -sV -sC "${TARGET}" -oN "${OUTPUT_DIR}/network-discovery/nmap-tcp-versions.txt" -oX "${OUTPUT_DIR}/network-discovery/nmap-tcp-versions.xml" &>> "${LOGFILE}"
    if [ $? -eq 0 ]; then
        echo -n -e "${LINE_RESET}"
        echo -e "${TEXT_SUCC} Version detection completed: network-discovery/nmap-tcp-versions.txt"
    else
        echo -n -e "${LINE_RESET}"
        echo -e "${TEXT_FAIL} Version detection failed"
    fi
else
    echo -e "${TEXT_FAIL} No open TCP ports found"
fi

# UDP scan (top ports)
echo -n -e "${TEXT_INFO} Running UDP scan (top ${NMAP_UDP_TOP_PORTS} ports - this may take a while)..."
"${SUDO}" "${NMAP}" -T"${NMAP_TCP_TIMING}" -Pn -sU --top-ports "${NMAP_UDP_TOP_PORTS}" "${TARGET}" -oN "${OUTPUT_DIR}/network-discovery/nmap-udp.txt" -oX "${OUTPUT_DIR}/network-discovery/nmap-udp.xml" &>> "${LOGFILE}"
if [ $? -eq 0 ]; then
    echo -n -e "${LINE_RESET}"
    echo -e "${TEXT_SUCC} UDP scan completed: network-discovery/nmap-udp.txt"
else
    echo -n -e "${LINE_RESET}"
    echo -e "${TEXT_FAIL} UDP scan failed"
fi

# Count open UDP ports
UDP_PORT_COUNT=$("${GREP}" "^[0-9]" "${OUTPUT_DIR}/network-discovery/nmap-udp.txt" | "${GREP}" "/udp" | "${GREP}" -E "open|open\|filtered" | "${WC}" -l)
if [ "${UDP_PORT_COUNT}" -gt 0 ]; then
    echo -e "${TEXT_INFO} Detected ${TEXT_GREEN}${UDP_PORT_COUNT}${TEXT_RESET} open UDP port(s)"
fi

# Initialize service port arrays
SSH_PORTS=()
SMB_PORTS=()
FTP_PORTS=()
SMTP_PORTS=()
DNS_PORTS=()
NFS_PORTS=()
RPC_PORTS=()
SNMP_PORTS=()
MYSQL_PORTS=()
MSSQL_PORTS=()
PGSQL_PORTS=()

# Parse TCP nmap results
if [ -f "${OUTPUT_DIR}/network-discovery/nmap-tcp-versions.txt" ]; then
    while IFS= read -r line; do
        if echo "$line" | "${GREP}" -qE "^[0-9]+/tcp.*open"; then
            PORT=$(echo "$line" | "${CUT}" -d'/' -f1)
            SERVICE=$(echo "$line" | "${AWK}" '{print $3}' | "${TR}" '[:upper:]' '[:lower:]')
            case "$SERVICE" in
                ssh)
                    SSH_PORTS+=("$PORT")
                    ;;
                microsoft-ds|netbios-ssn|smb)
                    SMB_PORTS+=("$PORT")
                    ;;
                ftp|ftp-data)
                    FTP_PORTS+=("$PORT")
                    ;;
                smtp|submission|smtps)
                    SMTP_PORTS+=("$PORT")
                    ;;
                domain|dns)
                    DNS_PORTS+=("$PORT")
                    ;;
                nfs|nfsd)
                    NFS_PORTS+=("$PORT")
                    ;;
                rpcbind|sunrpc)
                    RPC_PORTS+=("$PORT")
                    ;;
                snmp)
                    SNMP_PORTS+=("$PORT")
                    ;;
                mysql|mysql-proxy)
                    MYSQL_PORTS+=("$PORT")
                    ;;
                ms-sql-s|ms-sql-m|microsoft-sql)
                    MSSQL_PORTS+=("$PORT")
                    ;;
                postgresql|postgres)
                    PGSQL_PORTS+=("$PORT")
                    ;;
            esac
        fi
    done < "${OUTPUT_DIR}/network-discovery/nmap-tcp-versions.txt"
fi

# Parse UDP nmap results
if [ -f "${OUTPUT_DIR}/network-discovery/nmap-udp.txt" ]; then
    while IFS= read -r line; do
        if echo "$line" | "${GREP}" -qE "^[0-9]+/udp.*(open|open\|filtered)"; then
            PORT=$(echo "$line" | "${CUT}" -d'/' -f1)
            SERVICE=$(echo "$line" | "${AWK}" '{print $3}' | "${TR}" '[:upper:]' '[:lower:]')

            case "$SERVICE" in
                snmp)
                    # Add to SNMP_PORTS if not already present
                    if ! echo "${SNMP_PORTS[@]}" | "${GREP}" -qw "$PORT"; then
                        SNMP_PORTS+=("$PORT")
                    fi
                    ;;
                domain|dns)
                    # Add to DNS_PORTS if not already present
                    if ! echo "${DNS_PORTS[@]}" | "${GREP}" -qw "$PORT"; then
                        DNS_PORTS+=("$PORT")
                    fi
                    ;;
            esac
        fi
    done < "${OUTPUT_DIR}/network-discovery/nmap-udp.txt"
fi

#############################################################################
#############################################################################
#############################################################################

# SERVICE ENUMERATION
echo -ne "\n${TEXT_RED}SERVICE ENUMERATION${TEXT_RESET}\n"
echo -e "${TEXT_INFO} Starting service enumeration..." | tee -a "${LOGFILE}"

# SSH Enumeration
if [ ${#SSH_PORTS[@]} -gt 0 ]; then
    for port in "${SSH_PORTS[@]}"; do
        echo -n -e "${TEXT_INFO} SSH detected on port ${port}, enumerating..."

        # SSH banner grab and algorithm enumeration
        echo "=== SSH Banner (Port ${port}) ===" > "${OUTPUT_DIR}/service-enumeration/ssh-enum-${port}.txt"
        "${NC}" -vn -w 5 "${TARGET}" "${port}" >> "${OUTPUT_DIR}/service-enumeration/ssh-enum-${port}.txt" 2>&1 || true

        echo -e "\n=== SSH Algorithms ===" >> "${OUTPUT_DIR}/service-enumeration/ssh-enum-${port}.txt"
        "${SSH}" -v -o "BatchMode yes" -o "StrictHostKeyChecking no" -p "${port}" "${TARGET}" 2>&1 | "${GREP}" -E "kex|host key|cipher|mac" >> "${OUTPUT_DIR}/service-enumeration/ssh-enum-${port}.txt" || true

        # Try nmap NSE scripts
        "${NMAP}" -p "${port}" --script "ssh-*" "${TARGET}" -oN "${OUTPUT_DIR}/service-enumeration/ssh-nmap-scripts-${port}.txt" &>> "${LOGFILE}"

        echo -n -e "${LINE_RESET}"
        echo -e "${TEXT_SUCC} SSH enumeration completed on port ${port}: service-enumeration/ssh-*-${port}.txt"
    done
fi

# SMB Enumeration
if [ ${#SMB_PORTS[@]} -gt 0 ]; then
    echo -n -e "${TEXT_INFO} SMB detected on ports ${SMB_PORTS[*]}, enumerating..."

    # enum4linux (runs once, target-wide)
    "${ENUM4LINUX}" -a "${TARGET}" > "${OUTPUT_DIR}/service-enumeration/smb-enum4linux.txt" 2>&1

    # smbclient (runs once, target-wide)
    echo "=== SMB Shares (Null Session) ===" > "${OUTPUT_DIR}/service-enumeration/smb-shares.txt"
    "${SMBCLIENT}" -L "//${TARGET}" -N >> "${OUTPUT_DIR}/service-enumeration/smb-shares.txt" 2>&1 || true

    # nmap SMB scripts (run for each SMB port)
    SMB_PORTS_CSV=$(IFS=','; echo "${SMB_PORTS[*]}")
    "${NMAP}" -p "${SMB_PORTS_CSV}" --script "smb-*" "${TARGET}" -oN "${OUTPUT_DIR}/service-enumeration/smb-nmap-scripts.txt" &>> "${LOGFILE}"

    echo -n -e "${LINE_RESET}"
    echo -e "${TEXT_SUCC} SMB enumeration completed: service-enumeration/smb-*.txt"
fi

# FTP Enumeration
if [ ${#FTP_PORTS[@]} -gt 0 ]; then
    for port in "${FTP_PORTS[@]}"; do
        echo -n -e "${TEXT_INFO} FTP detected on port ${port}, enumerating..."

        # Banner grab and anonymous login test
        echo "=== FTP Banner (Port ${port}) ===" > "${OUTPUT_DIR}/service-enumeration/ftp-enum-${port}.txt"
        "${NC}" -vn -w 5 "${TARGET}" "${port}" >> "${OUTPUT_DIR}/service-enumeration/ftp-enum-${port}.txt" 2>&1 || true

        # Test anonymous login
        echo -e "\n=== Anonymous Login Test ===" >> "${OUTPUT_DIR}/service-enumeration/ftp-enum-${port}.txt"
        echo -e "anonymous\nanonymous\nls\nquit" | "${FTP}" -n "${TARGET}" "${port}" >> "${OUTPUT_DIR}/service-enumeration/ftp-enum-${port}.txt" 2>&1 || true

        # nmap FTP scripts
        "${NMAP}" -p "${port}" --script "ftp-*" "${TARGET}" -oN "${OUTPUT_DIR}/service-enumeration/ftp-nmap-scripts-${port}.txt" &>> "${LOGFILE}"

        echo -n -e "${LINE_RESET}"
        echo -e "${TEXT_SUCC} FTP enumeration completed on port ${port}: service-enumeration/ftp-*-${port}.txt"
    done
fi

# SMTP Enumeration
if [ ${#SMTP_PORTS[@]} -gt 0 ]; then
    echo -n -e "${TEXT_INFO} SMTP detected on ports ${SMTP_PORTS[*]}, enumerating..."

    # Create temporary user list
    echo -e "admin\nroot\nuser\ntest\nadministrator" > /tmp/smtp-users.txt

    # Enumerate each SMTP port
    for port in "${SMTP_PORTS[@]}"; do
        # smtp-user-enum
        "${SMTP_USER_ENUM}" -M VRFY -U /tmp/smtp-users.txt -t "${TARGET}" -p "${port}" > "${OUTPUT_DIR}/service-enumeration/smtp-user-enum-${port}.txt" 2>&1 || true

        # nmap SMTP scripts
        "${NMAP}" -p "${port}" --script "smtp-*" "${TARGET}" -oN "${OUTPUT_DIR}/service-enumeration/smtp-nmap-scripts-${port}.txt" &>> "${LOGFILE}"
    done

    # Clean up temporary file
    rm -f /tmp/smtp-users.txt

    echo -n -e "${LINE_RESET}"
    echo -e "${TEXT_SUCC} SMTP enumeration completed: service-enumeration/smtp-*.txt"
fi

# DNS Enumeration
if [ ${#DNS_PORTS[@]} -gt 0 ]; then
    for port in "${DNS_PORTS[@]}"; do
        echo -n -e "${TEXT_INFO} DNS service detected on port ${port}, enumerating..."

        # DNS version query
        echo "=== DNS Version (Port ${port}) ===" > "${OUTPUT_DIR}/service-enumeration/dns-service-enum-${port}.txt"
        "${DIG}" @"${TARGET}" -p "${port}" version.bind chaos txt >> "${OUTPUT_DIR}/service-enumeration/dns-service-enum-${port}.txt" 2>&1 || true

        echo -e "\n=== DNS Zone Transfer Test ===" >> "${OUTPUT_DIR}/service-enumeration/dns-service-enum-${port}.txt"
        "${DIG}" @"${TARGET}" -p "${port}" AXFR >> "${OUTPUT_DIR}/service-enumeration/dns-service-enum-${port}.txt" 2>&1 || true

        # nmap DNS scripts
        "${NMAP}" -p "${port}" --script "dns-*" "${TARGET}" -oN "${OUTPUT_DIR}/service-enumeration/dns-nmap-scripts-${port}.txt" &>> "${LOGFILE}"

        echo -n -e "${LINE_RESET}"
        echo -e "${TEXT_SUCC} DNS service enumeration completed on port ${port}: service-enumeration/dns-*-${port}.txt"
    done
fi

# NFS Enumeration
if [ ${#NFS_PORTS[@]} -gt 0 ] || [ ${#RPC_PORTS[@]} -gt 0 ]; then
    # Combine NFS and RPC ports for comprehensive scanning
    ALL_NFS_RPC_PORTS=("${NFS_PORTS[@]}" "${RPC_PORTS[@]}")
    echo -n -e "${TEXT_INFO} NFS/RPC detected on ports ${ALL_NFS_RPC_PORTS[*]}, enumerating..."

    NFS_SUCCESS=false

    # showmount (runs once, target-wide)
    echo "=== NFS Exports ===" > "${OUTPUT_DIR}/service-enumeration/nfs-enum.txt"
    "${SHOWMOUNT}" -e "${TARGET}" >> "${OUTPUT_DIR}/service-enumeration/nfs-enum.txt" 2>&1

    # Check if showmount succeeded (doesn't contain RPC error)
    if ! "${GREP}" -q "${REGEX_NFS_ERROR}" "${OUTPUT_DIR}/service-enumeration/nfs-enum.txt"; then
        NFS_SUCCESS=true
    fi

    # nmap NFS scripts on all NFS/RPC ports
    NFS_RPC_PORTS_CSV=$(IFS=','; echo "${ALL_NFS_RPC_PORTS[*]}")
    "${NMAP}" -p "${NFS_RPC_PORTS_CSV}" --script "nfs-*,rpc-*" "${TARGET}" -oN "${OUTPUT_DIR}/service-enumeration/nfs-nmap-scripts.txt" &>> "${LOGFILE}"

    echo -n -e "${LINE_RESET}"
    if [ "$NFS_SUCCESS" = true ]; then
        echo -e "${TEXT_SUCC} NFS enumeration completed: service-enumeration/nfs-*.txt"
    else
        echo -e "${TEXT_INFO} NFS enumeration completed: service-enumeration/nfs-*.txt (NFS service not running)"
    fi
fi

# SNMP Enumeration
if [ ${#SNMP_PORTS[@]} -gt 0 ]; then
    echo -n -e "${TEXT_INFO} SNMP detected on ports ${SNMP_PORTS[*]}, enumerating..."

    # onesixtyone for community string bruteforce (target-wide)
    echo -e "public\nprivate\ncommunity" > /tmp/community.txt
    "${ONESIXTYONE}" -c /tmp/community.txt "${TARGET}" > "${OUTPUT_DIR}/service-enumeration/snmp-community.txt" 2>&1 || true
    rm -f /tmp/community.txt

    # Enumerate each SNMP port
    for port in "${SNMP_PORTS[@]}"; do
        # snmpwalk with public community
        "${SNMPWALK}" -c public -v 2c "${TARGET}:${port}" > "${OUTPUT_DIR}/service-enumeration/snmp-walk-${port}.txt" 2>&1 || true

        # nmap SNMP scripts
        "${NMAP}" -sU -p "${port}" --script "snmp-*" "${TARGET}" -oN "${OUTPUT_DIR}/service-enumeration/snmp-nmap-scripts-${port}.txt" &>> "${LOGFILE}"
    done

    echo -n -e "${LINE_RESET}"
    echo -e "${TEXT_SUCC} SNMP enumeration completed: service-enumeration/snmp-*.txt"
fi

# RPC Enumeration
if [ ${#RPC_PORTS[@]} -gt 0 ]; then
    for port in "${RPC_PORTS[@]}"; do
        echo -n -e "${TEXT_INFO} RPC detected on port ${port}, enumerating..."

        # rpcinfo
        echo "=== RPC Services (Port ${port}) ===" > "${OUTPUT_DIR}/service-enumeration/rpc-enum-${port}.txt"
        "${RPCINFO}" -p "${TARGET}" >> "${OUTPUT_DIR}/service-enumeration/rpc-enum-${port}.txt" 2>&1 || true

        echo -n -e "${LINE_RESET}"
        echo -e "${TEXT_SUCC} RPC enumeration completed on port ${port}: service-enumeration/rpc-enum-${port}.txt"
    done
fi

# SQL Enumeration
if [ ${#MYSQL_PORTS[@]} -gt 0 ] || [ ${#MSSQL_PORTS[@]} -gt 0 ] || [ ${#PGSQL_PORTS[@]} -gt 0 ]; then
    echo -n -e "${TEXT_INFO} SQL service detected, enumerating..."

    # MySQL Enumeration
    if [ ${#MYSQL_PORTS[@]} -gt 0 ]; then
        for port in "${MYSQL_PORTS[@]}"; do
            echo "=== MySQL Enumeration (Port ${port}) ===" > "${OUTPUT_DIR}/service-enumeration/sql-mysql-${port}.txt"
            "${NMAP}" -p "${port}" --script "mysql-*" "${TARGET}" >> "${OUTPUT_DIR}/service-enumeration/sql-mysql-${port}.txt" 2>&1
        done
    fi

    # MSSQL Enumeration
    if [ ${#MSSQL_PORTS[@]} -gt 0 ]; then
        for port in "${MSSQL_PORTS[@]}"; do
            echo "=== MSSQL Enumeration (Port ${port}) ===" > "${OUTPUT_DIR}/service-enumeration/sql-mssql-${port}.txt"
            "${NMAP}" -p "${port}" --script "ms-sql-*" "${TARGET}" >> "${OUTPUT_DIR}/service-enumeration/sql-mssql-${port}.txt" 2>&1
        done
    fi

    # PostgreSQL Enumeration
    if [ ${#PGSQL_PORTS[@]} -gt 0 ]; then
        for port in "${PGSQL_PORTS[@]}"; do
            echo "=== PostgreSQL Enumeration (Port ${port}) ===" > "${OUTPUT_DIR}/service-enumeration/sql-pgsql-${port}.txt"
            "${NMAP}" -p "${port}" --script "pgsql-*" "${TARGET}" >> "${OUTPUT_DIR}/service-enumeration/sql-pgsql-${port}.txt" 2>&1
        done
    fi

    echo -n -e "${LINE_RESET}"
    echo -e "${TEXT_SUCC} SQL enumeration completed: service-enumeration/sql-*.txt"
fi

#############################################################################
#############################################################################
#############################################################################

# WEB ENUMERATION
echo -ne "\n${TEXT_RED}WEB ENUMERATION${TEXT_RESET}\n"
echo -e "${TEXT_INFO} Starting web enumeration..." | tee -a "${LOGFILE}"

# Detect web ports (HTTP/HTTPS) from nmap service detection
WEB_PORTS=""
if [ -f "${OUTPUT_DIR}/network-discovery/nmap-tcp-versions.txt" ]; then
    # Extract ports running HTTP/HTTPS services
    # Method 1: Look for web-related services in service name
    PORTS_BY_NAME=$("${GREP}" -E "^[0-9]+/tcp.*open" "${OUTPUT_DIR}/network-discovery/nmap-tcp-versions.txt" | \
                    "${GREP}" -iE "${REGEX_WEB_SERVICE_DETECTION}" | \
                    "${CUT}" -d'/' -f1)

    # Method 2: Look for HTTP responses in fingerprint data (catches misidentified services)
    PORTS_BY_FINGERPRINT=$(awk '/^[0-9]+\/tcp.*open/ {port=$1; sub(/\/tcp/, "", port)}
                                /HTTP\/[0-9]\.[0-9]/ {if(port) print port; port=""}' \
                                "${OUTPUT_DIR}/network-discovery/nmap-tcp-versions.txt" | sort -u)

    # Combine both methods and remove duplicates
    WEB_PORTS=$(echo -e "${PORTS_BY_NAME}\n${PORTS_BY_FINGERPRINT}" | \
                "${GREP}" -v "^$" | \
                sort -un | \
                "${TR}" '\n' ',' | \
                sed 's/,$//')
fi

if [ -n "${WEB_PORTS}" ]; then
    WEB_PORT_COUNT=$(echo "${WEB_PORTS}" | "${TR}" ',' '\n' | "${WC}" -l)
    echo -e "${TEXT_INFO} Detected ${TEXT_GREEN}${WEB_PORT_COUNT}${TEXT_RESET} web port(s)"

    # Process each web port
    IFS=',' read -ra PORTS_ARRAY <<< "${WEB_PORTS}"
    for port in "${PORTS_ARRAY[@]}"; do
        # Determine protocol from nmap results
        if is_port_https "${port}"; then
            PROTOCOL="https"
        else
            PROTOCOL="http"
        fi

        BASE_URL="${PROTOCOL}://${TARGET}:${port}"
        PORT_DIR="${OUTPUT_DIR}/web-enumeration/port-${port}"
        "${MKDIR}" -p "${PORT_DIR}"

        echo -e "${TEXT_INFO} Enumerating ${BASE_URL}..."

        # Gobuster directory enumeration
        if [ -f "${WORDLIST_DIRECTORY}" ]; then
            echo -n -e "${TEXT_INFO} Running Gobuster on ${BASE_URL}..."

            # Test for wildcard responses by requesting a random non-existent path
            RANDOM_PATH="$(cat /dev/urandom | "${TR}" -dc 'a-z0-9' | fold -w 32 | head -n 1)"
            TEST_URL="${BASE_URL}/${RANDOM_PATH}"

            # Get response length from test request
            if [ "${HTTP_CLIENT}" = "curl" ]; then
                TEST_LENGTH=$("${CURL}" -sk -o /dev/null -w '%{size_download}' --max-time "${HTTP_TIMEOUT}" "${TEST_URL}" 2>/dev/null)
            else
                # Wget approach: pipe to wc to count bytes
                TEST_LENGTH=$("${WGET}" --quiet --no-check-certificate --timeout="${HTTP_TIMEOUT}" "${TEST_URL}" -O - 2>/dev/null | "${WC}" -c)
            fi

            # Determine if we should use exclusion based on test request
            GOBUSTER_EXTRA_ARGS=""
            if [ -n "${TEST_LENGTH}" ] && [ "${TEST_LENGTH}" -gt 0 ]; then
                # If the test path returned content, likely a wildcard response
                echo -n -e "${LINE_RESET}"
                echo -e "${TEXT_INFO} Detected wildcard response (length: ${TEST_LENGTH}), using exclusion filter..."
                echo -n -e "${TEXT_INFO} Running Gobuster on ${BASE_URL}..."
                GOBUSTER_EXTRA_ARGS="--exclude-length ${TEST_LENGTH}"
            fi

            # Run gobuster with or without exclusion
            "${GOBUSTER}" dir -u "${BASE_URL}" -w "${WORDLIST_DIRECTORY}" -x "${GOBUSTER_EXTENSIONS}" -o "${PORT_DIR}/gobuster.txt" -t "${GOBUSTER_THREADS}" --delay "${GOBUSTER_DELAY}" -k ${GOBUSTER_EXTRA_ARGS} &>> "${LOGFILE}"
            GOBUSTER_EXIT=$?

            if [ ${GOBUSTER_EXIT} -eq 0 ]; then
                echo -n -e "${LINE_RESET}"
                # Count results
                if [ -s "${PORT_DIR}/gobuster.txt" ]; then
                    RESULT_COUNT=$("${WC}" -l < "${PORT_DIR}/gobuster.txt")
                    echo -e "${TEXT_SUCC} Gobuster completed: web-enumeration/port-${port}/gobuster.txt (${RESULT_COUNT} paths found)"
                else
                    echo -e "${TEXT_SUCC} Gobuster completed: web-enumeration/port-${port}/gobuster.txt (no paths found)"
                fi
            else
                echo -n -e "${LINE_RESET}"
                echo -e "${TEXT_FAIL} Gobuster enumeration failed for port ${port}"
            fi
        else
            echo -e "${TEXT_FAIL} Wordlist not found at: ${WORDLIST_DIRECTORY}"
            echo -e "${TEXT_INFO} Please install wordlists or update WORDLIST_DIRECTORY in the script"
        fi

        # Nikto scan
        echo -n -e "${TEXT_INFO} Running Nikto scan on ${BASE_URL}..."
        "${NIKTO}" -h "${BASE_URL}" -output "${PORT_DIR}/nikto.txt" &>> "${LOGFILE}"
        echo -n -e "${LINE_RESET}"

        # Check if output file exists and has content (Nikto may return non-zero even on success)
        if [ -s "${PORT_DIR}/nikto.txt" ]; then
            # Count Nikto findings (lines starting with "+ ")
            FINDING_COUNT=$("${GREP}" -c "^+ " "${PORT_DIR}/nikto.txt" 2>/dev/null | head -1)
            # Default to 0 if empty or invalid
            FINDING_COUNT=${FINDING_COUNT:-0}

            if [ "${FINDING_COUNT}" -gt 0 ] 2>/dev/null; then
                echo -e "${TEXT_SUCC} Nikto scan completed: web-enumeration/port-${port}/nikto.txt (${FINDING_COUNT} findings)"
            else
                echo -e "${TEXT_INFO} Nikto scan completed: web-enumeration/port-${port}/nikto.txt (no findings)"
            fi
        else
            echo -e "${TEXT_FAIL} Nikto scan failed for port ${port}"
        fi

        # Whatweb fingerprinting
        echo -n -e "${TEXT_INFO} Running Whatweb on ${BASE_URL}..."
        "${WHATWEB}" "${BASE_URL}" -a 3 --log-verbose="${PORT_DIR}/whatweb.txt" &>> "${LOGFILE}"
        if [ $? -eq 0 ]; then
            echo -n -e "${LINE_RESET}"
            echo -e "${TEXT_SUCC} Whatweb completed: web-enumeration/port-${port}/whatweb.txt"
        else
            echo -n -e "${LINE_RESET}"
            echo -e "${TEXT_FAIL} Whatweb failed for port ${port}"
        fi

        # SSL/TLS scanning (for HTTPS)
        if [ "${PROTOCOL}" = "https" ]; then
            echo -n -e "${TEXT_INFO} Running SSL/TLS scan on ${BASE_URL}..."
            "${SSLSCAN}" --no-colour "${TARGET}:${port}" > "${PORT_DIR}/sslscan.txt" 2>&1
            if [ $? -eq 0 ]; then
                echo -n -e "${LINE_RESET}"
                echo -e "${TEXT_SUCC} SSL/TLS scan completed: web-enumeration/port-${port}/sslscan.txt"
            else
                echo -n -e "${LINE_RESET}"
                echo -e "${TEXT_FAIL} SSL/TLS scan failed for port ${port}"
            fi
        fi

        # Fetch robots.txt and sitemap.xml
        echo -n -e "${TEXT_INFO} Fetching robots.txt and sitemap.xml..."
        if [ "${HTTP_CLIENT}" = "curl" ]; then
            "${CURL}" -sk --max-time "${HTTP_TIMEOUT}" "${BASE_URL}/robots.txt" -o "${PORT_DIR}/robots.txt" 2>/dev/null
            "${CURL}" -sk --max-time "${HTTP_TIMEOUT}" "${BASE_URL}/sitemap.xml" -o "${PORT_DIR}/sitemap.xml" 2>/dev/null
        else
            "${WGET}" --quiet --no-check-certificate --timeout="${HTTP_TIMEOUT}" "${BASE_URL}/robots.txt" -O "${PORT_DIR}/robots.txt" 2>/dev/null
            "${WGET}" --quiet --no-check-certificate --timeout="${HTTP_TIMEOUT}" "${BASE_URL}/sitemap.xml" -O "${PORT_DIR}/sitemap.xml" 2>/dev/null
        fi
        echo -n -e "${LINE_RESET}"

        # Verify the files contain actual content, not error pages
        VALID_FILES=0
        if [ -f "${PORT_DIR}/robots.txt" ] && [ -s "${PORT_DIR}/robots.txt" ]; then
            # Check if it's not just an error message
            if ! "${GREP}" -qiE "${REGEX_HTTP_ERROR}" "${PORT_DIR}/robots.txt"; then
                VALID_FILES=$((VALID_FILES + 1))
            else
                rm -f "${PORT_DIR}/robots.txt"
            fi
        fi

        if [ -f "${PORT_DIR}/sitemap.xml" ] && [ -s "${PORT_DIR}/sitemap.xml" ]; then
            # Check if it's valid XML or not an error message
            if ! "${GREP}" -qiE "${REGEX_HTTP_ERROR}" "${PORT_DIR}/sitemap.xml" && "${GREP}" -qE "${REGEX_XML_VALID}" "${PORT_DIR}/sitemap.xml"; then
                VALID_FILES=$((VALID_FILES + 1))
            else
                rm -f "${PORT_DIR}/sitemap.xml"
            fi
        fi

        if [ "${VALID_FILES}" -gt 0 ]; then
            echo -e "${TEXT_SUCC} Fetched ${VALID_FILES} valid file(s): web-enumeration/port-${port}/"
        else
            echo -e "${TEXT_INFO} No valid robots.txt or sitemap.xml found on port ${port}"
        fi
    done

    # Subdomain enumeration (only for domains, not IPs)
    if ! echo "${TARGET}" | "${GREP}" -qE "${REGEX_IPV4}"; then
        # Subdomain enumeration with Amass
        echo -n -e "${TEXT_INFO} Running subdomain enumeration with Amass..."
        "${AMASS}" enum -passive -d "${TARGET}" -o "${OUTPUT_DIR}/web-enumeration/subdomains-amass.txt" &>> "${LOGFILE}"
        if [ $? -eq 0 ]; then
            echo -n -e "${LINE_RESET}"
            echo -e "${TEXT_SUCC} Amass subdomain enumeration completed: web-enumeration/subdomains-amass.txt"
        else
            echo -n -e "${LINE_RESET}"
            echo -e "${TEXT_FAIL} Amass subdomain enumeration failed"
        fi

        # Subdomain enumeration with Subfinder
        echo -n -e "${TEXT_INFO} Running subdomain enumeration with Subfinder..."
        "${SUBFINDER}" -d "${TARGET}" -o "${OUTPUT_DIR}/web-enumeration/subdomains-subfinder.txt" -silent &>> "${LOGFILE}"
        if [ $? -eq 0 ]; then
            echo -n -e "${LINE_RESET}"
            echo -e "${TEXT_SUCC} Subfinder subdomain enumeration completed: web-enumeration/subdomains-subfinder.txt"
        else
            echo -n -e "${LINE_RESET}"
            echo -e "${TEXT_FAIL} Subfinder subdomain enumeration failed"
        fi

        # Subdomain enumeration with Assetfinder
        echo -n -e "${TEXT_INFO} Running subdomain enumeration with Assetfinder..."
        "${ASSETFINDER}" --subs-only "${TARGET}" > "${OUTPUT_DIR}/web-enumeration/subdomains-assetfinder.txt" 2>&1
        if [ $? -eq 0 ]; then
            echo -n -e "${LINE_RESET}"
            echo -e "${TEXT_SUCC} Assetfinder subdomain enumeration completed: web-enumeration/subdomains-assetfinder.txt"
        else
            echo -n -e "${LINE_RESET}"
            echo -e "${TEXT_FAIL} Assetfinder subdomain enumeration failed"
        fi

        # Virtual host enumeration
        # Find first open web port for vhost enum
        FIRST_WEB_PORT=$(echo "${WEB_PORTS}" | "${CUT}" -d',' -f1)
        if is_port_https "${FIRST_WEB_PORT}"; then
            VHOST_PROTOCOL="https"
        else
            VHOST_PROTOCOL="http"
        fi
        VHOST_URL="${VHOST_PROTOCOL}://${TARGET}:${FIRST_WEB_PORT}"

        echo -n -e "${TEXT_INFO} Running virtual host enumeration..."

        if [ -f "${WORDLIST_VHOST}" ]; then
            "${GOBUSTER}" vhost -u "${VHOST_URL}" -w "${WORDLIST_VHOST}" -o "${OUTPUT_DIR}/web-enumeration/vhosts.txt" --delay "${GOBUSTER_DELAY}" -q -k &>> "${LOGFILE}"
            if [ $? -eq 0 ]; then
                echo -n -e "${LINE_RESET}"
                echo -e "${TEXT_SUCC} Virtual host enumeration completed: web-enumeration/vhosts.txt"
            else
                echo -n -e "${LINE_RESET}"
                echo -e "${TEXT_FAIL} Virtual host enumeration failed"
            fi
        else
            echo -n -e "${LINE_RESET}"
            echo -e "${TEXT_FAIL} No wordlist found for vhost enumeration"
        fi
    fi
else
    echo -e "${TEXT_INFO} No web ports detected, skipping web enumeration"
fi

#############################################################################
#############################################################################
#############################################################################

# VULNERABILITY ASSESSMENT
echo -ne "\n${TEXT_RED}VULNERABILITY ASSESSMENT${TEXT_RESET}\n" 
echo -e "${TEXT_INFO} Starting vulnerability assessment..." | tee -a "${LOGFILE}"

# Nmap vulnerability scripts
if [ -n "${OPEN_PORTS}" ]; then
    echo -n -e "${TEXT_INFO} Running nmap vulnerability scripts on open ports..."
    "${NMAP}" -T"${NMAP_TCP_TIMING}" -Pn -p "${OPEN_PORTS}" --script vuln "${TARGET}" -oN "${OUTPUT_DIR}/vuln-assessment/nmap-vuln-scripts.txt" -oX "${OUTPUT_DIR}/vuln-assessment/nmap-vuln-scripts.xml" &>> "${LOGFILE}"
    if [ $? -eq 0 ]; then
        echo -n -e "${LINE_RESET}"
        echo -e "${TEXT_SUCC} Nmap vulnerability scripts completed: vuln-assessment/nmap-vuln-scripts.txt"
    else
        echo -n -e "${LINE_RESET}"
        echo -e "${TEXT_FAIL} Nmap vulnerability scripts failed"
    fi
fi

# Extract service versions for searchsploit
if [ -f "${OUTPUT_DIR}/network-discovery/nmap-tcp-versions.txt" ]; then
    echo -n -e "${TEXT_INFO} Extracting service versions for vulnerability lookup..."

    # Parse versions from nmap output
    VERSIONS_FILE="${OUTPUT_DIR}/vuln-assessment/service-versions.txt"
    "${GREP}" -E "^[0-9]+/tcp.*open" "${OUTPUT_DIR}/network-discovery/nmap-tcp-versions.txt" | \
        "${GREP}" -v "product:" | \
        awk '{for(i=3;i<=NF;i++) printf "%s ", $i; printf "\n"}' > "${VERSIONS_FILE}"

    echo -n -e "${LINE_RESET}"
    echo -e "${TEXT_SUCC} Service versions extracted: vuln-assessment/service-versions.txt"
fi

# Searchsploit queries
echo -n -e "${TEXT_INFO} Running Searchsploit queries for detected services and software..."

SEARCHSPLOIT_OUTPUT="${OUTPUT_DIR}/vuln-assessment/searchsploit-results.txt"
echo "=== Searchsploit Results ===" > "${SEARCHSPLOIT_OUTPUT}"

SEARCH_TERMS_FILE="${OUTPUT_DIR}/vuln-assessment/search-terms.txt"
> "${SEARCH_TERMS_FILE}"  # Clear file

# Extract version information for each categorized service
if [ -f "${OUTPUT_DIR}/network-discovery/nmap-tcp-versions.txt" ]; then
    # SSH services
    if [ ${#SSH_PORTS[@]} -gt 0 ]; then
        for port in "${SSH_PORTS[@]}"; do
            "${GREP}" "^${port}/tcp" "${OUTPUT_DIR}/network-discovery/nmap-tcp-versions.txt" | \
                "${GREP}" -oP "${REGEX_SOFTWARE_NAMES}" >> "${SEARCH_TERMS_FILE}"
        done
    fi

    # FTP services
    if [ ${#FTP_PORTS[@]} -gt 0 ]; then
        for port in "${FTP_PORTS[@]}"; do
            "${GREP}" "^${port}/tcp" "${OUTPUT_DIR}/network-discovery/nmap-tcp-versions.txt" | \
                "${GREP}" -oP "${REGEX_SOFTWARE_NAMES}" >> "${SEARCH_TERMS_FILE}"
        done
    fi

    # SMB services
    if [ ${#SMB_PORTS[@]} -gt 0 ]; then
        for port in "${SMB_PORTS[@]}"; do
            "${GREP}" "^${port}/tcp" "${OUTPUT_DIR}/network-discovery/nmap-tcp-versions.txt" | \
                "${GREP}" -oP "${REGEX_SOFTWARE_NAMES}" >> "${SEARCH_TERMS_FILE}"
        done
    fi

    # SMTP services
    if [ ${#SMTP_PORTS[@]} -gt 0 ]; then
        for port in "${SMTP_PORTS[@]}"; do
            "${GREP}" "^${port}/tcp" "${OUTPUT_DIR}/network-discovery/nmap-tcp-versions.txt" | \
                "${GREP}" -oP "${REGEX_SOFTWARE_NAMES}" >> "${SEARCH_TERMS_FILE}"
        done
    fi

    # SQL services
    for port in "${MYSQL_PORTS[@]}" "${MSSQL_PORTS[@]}" "${PGSQL_PORTS[@]}"; do
        [ -n "$port" ] && "${GREP}" "^${port}/tcp" "${OUTPUT_DIR}/network-discovery/nmap-tcp-versions.txt" | \
            "${GREP}" -oP "${REGEX_SOFTWARE_NAMES}" >> "${SEARCH_TERMS_FILE}"
    done
fi

# Extract web server software from web enumeration results
if [ -d "${OUTPUT_DIR}/web-enumeration" ]; then
    "${FIND}" "${OUTPUT_DIR}/web-enumeration" -name "whatweb.txt" -type f 2>/dev/null | while read -r whatweb_file; do
        "${GREP}" -oP "${REGEX_WEB_SOFTWARE}" "${whatweb_file}" 2>/dev/null | \
            sed 's/\[//g' >> "${SEARCH_TERMS_FILE}"
    done

    "${FIND}" "${OUTPUT_DIR}/web-enumeration" -name "nikto.txt" -type f 2>/dev/null | while read -r nikto_file; do
        "${GREP}" -iE "Server:|X-Powered-By:" "${nikto_file}" 2>/dev/null | \
            "${GREP}" -oP "${REGEX_WEB_HEADERS}" >> "${SEARCH_TERMS_FILE}"
    done
fi

# Remove duplicates and empty lines
sort -u "${SEARCH_TERMS_FILE}" | "${GREP}" -v "^$" > "${SEARCH_TERMS_FILE}.tmp"
mv "${SEARCH_TERMS_FILE}.tmp" "${SEARCH_TERMS_FILE}"

# Search for each term
if [ -s "${SEARCH_TERMS_FILE}" ]; then
    while IFS= read -r search_term; do
        if [ -n "$search_term" ]; then
            echo -e "\n--- Searching: $search_term ---" >> "${SEARCHSPLOIT_OUTPUT}"
            "${SEARCHSPLOIT}" "$search_term" >> "${SEARCHSPLOIT_OUTPUT}" 2>&1 || true
        fi
    done < "${SEARCH_TERMS_FILE}"
fi

# Also search using nmap XML if available
if [ -f "${OUTPUT_DIR}/network-discovery/nmap-tcp-versions.xml" ]; then
    echo -e "\n=== Searchsploit (from nmap XML) ===" >> "${SEARCHSPLOIT_OUTPUT}"
    "${SEARCHSPLOIT}" --nmap "${OUTPUT_DIR}/network-discovery/nmap-tcp-versions.xml" >> "${SEARCHSPLOIT_OUTPUT}" 2>&1 || true
fi

echo -n -e "${LINE_RESET}"
echo -e "${TEXT_SUCC} Searchsploit queries completed: vuln-assessment/searchsploit-results.txt"

# Nuclei scan
# Run nuclei on discovered web services
if [ -n "${WEB_PORTS}" ]; then
    IFS=',' read -ra PORTS_ARRAY <<< "${WEB_PORTS}"
    for port in "${PORTS_ARRAY[@]}"; do
        # Determine protocol from nmap results
        if is_port_https "${port}"; then
            PROTOCOL="https"
        else
            PROTOCOL="http"
        fi

        TARGET_URL="${PROTOCOL}://${TARGET}:${port}"

        echo -n -e "${TEXT_INFO} Running Nuclei scan on ${TARGET_URL}..."
        "${NUCLEI}" -u "${TARGET_URL}" -o "${OUTPUT_DIR}/vuln-assessment/nuclei-port-${port}.txt" -silent &>> "${LOGFILE}"
        echo -n -e "${LINE_RESET}"

        # Verify results
        if [ -s "${OUTPUT_DIR}/vuln-assessment/nuclei-port-${port}.txt" ]; then
            FINDING_COUNT=$("${WC}" -l < "${OUTPUT_DIR}/vuln-assessment/nuclei-port-${port}.txt")
            echo -e "${TEXT_SUCC} Nuclei scan completed: vuln-assessment/nuclei-port-${port}.txt (${FINDING_COUNT} findings)"
        else
            echo -e "${TEXT_INFO} Nuclei scan completed: vuln-assessment/nuclei-port-${port}.txt (no findings)"
        fi
    done
fi

# SQLMap (only if web ports exist)
if [ -n "${WEB_PORTS}" ]; then
    IFS=',' read -ra PORTS_ARRAY <<< "${WEB_PORTS}"
    for port in "${PORTS_ARRAY[@]}"; do
        # Determine protocol from nmap results
        if is_port_https "${port}"; then
            PROTOCOL="https"
        else
            PROTOCOL="http"
        fi

        BASE_TARGET_URL="${PROTOCOL}://${TARGET}:${port}"
        SQLMAP_DIR="${OUTPUT_DIR}/vuln-assessment/sqlmap-port-${port}"
        "${MKDIR}" -p "${SQLMAP_DIR}"

        # Build list of target URLs from gobuster results
        GOBUSTER_FILE="${OUTPUT_DIR}/web-enumeration/port-${port}/gobuster.txt"
        TARGET_URLS=()

        # Add base URL
        TARGET_URLS+=("${BASE_TARGET_URL}")

        # Extract paths from gobuster results (only successful responses)
        if [ -f "${GOBUSTER_FILE}" ]; then
            # Extract paths with 200, 301, 302, 401, 403 status codes (skip 404, 500)
            while IFS= read -r line; do
                # Parse gobuster output format: /path (Status: 200)
                if echo "$line" | "${GREP}" -qE "${REGEX_GOBUSTER_STATUS}"; then
                    PATH=$(echo "$line" | "${GREP}" -oP '^[^\s]+')
                    if [ -n "$PATH" ]; then
                        TARGET_URLS+=("${BASE_TARGET_URL}${PATH}")
                    fi
                fi
            done < "${GOBUSTER_FILE}"
        fi

        # Scan all discovered URLs
        URL_COUNT=${#TARGET_URLS[@]}
        echo -e "${TEXT_INFO} Found ${URL_COUNT} URLs, scanning all with SQLMap"

        # Run SQLMap on each target URL
        for TARGET_URL in "${TARGET_URLS[@]}"; do
            echo -n -e "${TEXT_INFO} Running SQLMap on ${TARGET_URL}..."

            # Use different output directories for different paths
            URL_HASH=$(echo -n "${TARGET_URL}" | "${MD5SUM}" | "${CUT}" -d' ' -f1 | "${CUT}" -c1-8)
            "${SQLMAP}" -u "${TARGET_URL}" --batch --crawl="${SQLMAP_CRAWL_DEPTH}" \
                --output-dir="${SQLMAP_DIR}/${URL_HASH}" \
                --level="${SQLMAP_LEVEL}" --risk="${SQLMAP_RISK}" &>> "${LOGFILE}"

            echo -n -e "${LINE_RESET}"
        done

        # Verify results by checking if directory has meaningful content
        if [ -d "${SQLMAP_DIR}" ]; then
            FILE_COUNT=$("${FIND}" "${SQLMAP_DIR}" -type f 2>/dev/null | "${WC}" -l)
            if [ "${FILE_COUNT}" -gt 0 ]; then
                echo -e "${TEXT_SUCC} SQLMap scan completed: vuln-assessment/sqlmap-port-${port}/ (${FILE_COUNT} files, ${#TARGET_URLS[@]} URLs tested)"
            else
                echo -e "${TEXT_INFO} SQLMap scan completed: vuln-assessment/sqlmap-port-${port}/ (no injectable parameters found)"
            fi
        else
            echo -e "${TEXT_FAIL} SQLMap scan failed: output directory not created"
        fi
    done
fi

#############################################################################
#############################################################################
#############################################################################

echo ""
echo -e "${TEXT_SUCC} AutoRecon completed! Results saved to: ${TEXT_GREEN}${OUTPUT_DIR}${TEXT_RESET}"

