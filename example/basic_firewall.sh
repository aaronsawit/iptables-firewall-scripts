#!/bin/bash
# basic_firewall.sh
# Robust firewall configuration for daily users using iptables

# Flush existing rules to start fresh
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X

# Set default policies to drop incoming and forward traffic, allow outgoing
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Allow traffic on the loopback interface (localhost)
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow established and related connections (stateful firewall)
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow SSH (port 22) with rate limiting to prevent brute force attacks
iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -m limit --limit 3/min -j ACCEPT

# Allow HTTP (port 80) and HTTPS (port 443) for web browsing
iptables -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -m conntrack --ctstate NEW -j ACCEPT

# Allow DNS (port 53) for domain name resolution
iptables -A INPUT -p udp --sport 53 -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

# Allow ICMP (ping), with rate limiting to prevent abuse
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT

# Prevent IP spoofing - block private network addresses on public interfaces
iptables -A INPUT -s 10.0.0.0/8 -j DROP
iptables -A INPUT -s 172.16.0.0/12 -j DROP
iptables -A INPUT -s 192.168.0.0/16 -j DROP
iptables -A INPUT -s 127.0.0.0/8 ! -i lo -j DROP

# Block new incoming connections from specific malicious IPs or ranges (example)
# iptables -A INPUT -s 203.0.113.0/24 -j DROP  # Replace with actual malicious IP ranges

# Prevent SYN flood attacks (rate limit SYN packets)
iptables -A INPUT -p tcp --syn -m limit --limit 1/s -j ACCEPT

# Log and drop suspicious traffic (optional logging, limited to avoid flooding logs)
iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables-dropped: " --log-level 4

# Drop all other incoming traffic that doesn't match the above rules
iptables -A INPUT -j DROP

# Save iptables rules (Debian/Ubuntu system)
iptables-save > /etc/iptables/rules.v4

echo "Firewall rules have been applied and saved."
