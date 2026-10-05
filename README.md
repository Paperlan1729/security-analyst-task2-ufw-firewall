# Security Analyst Task 2: Basic Firewall Configuration with UFW

**Author:** Dhrumit Asari  
**GitHub:** [Paperlan1729](https://github.com/Paperlan1729)  
**Track:** Security Analyst (Practical Task)

---

## What a Firewall Does

A firewall controls incoming and outgoing network traffic based on predetermined security rules. It acts as a barrier between a trusted internal network and untrusted external networks (such as the internet). UFW (Uncomplicated Firewall) is a user-friendly frontend for iptables on Ubuntu and Debian-based systems. It simplifies the process of creating and managing firewall rules.

## Why These Rules Were Chosen

- **Allow SSH (port 22)** — Essential for remote administration of the server. Without this rule, enabling the firewall would lock you out of remote access.
- **Deny HTTP (port 80)** — Demonstrates blocking unencrypted web traffic. In many hardened environments, only HTTPS is permitted.
- **Allow HTTPS (port 443)** — Permits secure web traffic while HTTP is denied.
- **Deny a specific IP range** — Shows how to block traffic from a suspicious or unwanted network segment (example: 203.0.113.0/24 — documentation/TEST-NET range).
- **Allow established connections** — UFW handles this by default, ensuring return traffic for allowed outbound connections works correctly.

These rules illustrate the principle of least privilege: only explicitly permitted traffic is allowed; everything else is denied by default once the firewall is enabled.

---

## Installation & Configuration Steps

### 1. Install UFW (if not already present)
```bash
sudo apt update
sudo apt install ufw -y
```

### 2. Enable UFW
```bash
sudo ufw enable
```
(Confirm with `y` when prompted.)

### 3. Apply Rules
```bash
# Allow SSH
sudo ufw allow ssh
# or explicitly: sudo ufw allow 22/tcp

# Deny HTTP
sudo ufw deny http
# or: sudo ufw deny 80/tcp

# Allow HTTPS
sudo ufw allow 443/tcp

# Deny a specific IP range (example TEST-NET)
sudo ufw deny from 203.0.113.0/24

# Optional: Allow from a trusted management network
# sudo ufw allow from 192.168.56.0/24 to any port 22
```

### 4. Verify Rules
```bash
sudo ufw status verbose
```

Expected output structure:
```
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere
80/tcp                     DENY IN     Anywhere
443/tcp                    ALLOW IN    Anywhere
Anywhere                   DENY IN     203.0.113.0/24
22/tcp (v6)                ALLOW IN    Anywhere (v6)
...
```

### 5. Testing Denied Traffic
- From another machine or using `curl` / browser: attempt to reach `http://<target-ip>` — connection should be refused or time out.
- Attempt HTTPS (`https://<target-ip>`) — should succeed if a web server is listening.
- Attempt SSH from an allowed host — should succeed.
- Document the test method and results (screenshots recommended).

---

## Runnable Script

See [ufw_configuration.sh](ufw_configuration.sh). Run with:
```bash
chmod +x ufw_configuration.sh
sudo ./ufw_configuration.sh
```

---

## Files in this Repository

- `ufw_configuration.sh` — Idempotent script that applies all rules in sequence
- `README.md` — This documentation
- `screenshots/` — Place terminal screenshots of `ufw status verbose` and test results here

## Ethics Note

All configuration was performed on a local virtual machine under my control. Never apply restrictive firewall rules on production systems without a recovery plan (console access, out-of-band management).

---

*Completed by Dhrumit Asari — Security Analyst Track*
