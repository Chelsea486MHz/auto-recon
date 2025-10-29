# 🐡🐠🐟🐳🐋🦪🪼🐙🦑🦀🦞🐧🦭🐬🪸🦈

```
  /$$$$$$              /$$               /$$$$$$$
 /$$__  $$            | $$              | $$__  $$
| $$  \ $$ /$$   /$$ /$$$$$$    /$$$$$$ | $$  \ $$  /$$$$$$   /$$$$$$$  /$$$$$$  /$$$$$$$
| $$$$$$$$| $$  | $$|_  $$_/   /$$__  $$| $$$$$$$/ /$$__  $$ /$$_____/ /$$__  $$| $$__  $$
| $$__  $$| $$  | $$  | $$    | $$  \ $$| $$__  $$| $$$$$$$$| $$      | $$  \ $$| $$  \ $$
| $$  | $$| $$  | $$  | $$ /$$| $$  | $$| $$  \ $$| $$_____/| $$      | $$  | $$| $$  | $$
| $$  | $$|  $$$$$$/  |  $$$$/|  $$$$$$/| $$  | $$|  $$$$$$$|  $$$$$$$|  $$$$$$/| $$  | $$
|__/  |__/ \______/    \___/   \______/ |__/  |__/ \_______/ \_______/ \______/ |__/  |__/

```

I got tired of manually performing recon during pentests. So here's my take on automating the process.

## Features

The script acts in 4 stages:

**Stage 1 - Information gathering:** Mostly DNS stuff (whois, nslookup)

**Stage 2 - Network discovery:** Tests both TCP and UDP.

**Stage 3 - Service enumeration:** SSH, SMB, FTP, SMTP, DNS, NFS, SNMP, RPC, and SQL enumeration.

**Stage 4 - Web enumeration:** Smart HTTP/HTTPS detection, `gobuster` with wildcard handling, subdomain/vhost enumeration, Nikto, Whatweb, SSL/TLS fingerprinting... basically analyze everything about detected web servers.

**Stage 5 - Vulnerability assessment:** Runs `searchsploit` based on previous findings (nmap + Whatweb + Nikto), `nmap` CVE scripts, Nuclei, and SQLMap with discovered URLs. You'll find potential exploit paths here.

## Usage

```bash
sudo ./autorecon.sh <target>
```

**Examples:**
```bash
sudo ./autorecon.sh 192.168.1.100
sudo ./autorecon.sh example.com
```

## Development

Provided is a `docker-compose` manifest for a full vulnerable stack to test the script against.