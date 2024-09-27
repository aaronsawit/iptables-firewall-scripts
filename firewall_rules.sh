#!/bin/bash
# firewall_rules.sh
# Script to configure basic firewall rules using iptables

# Flush existing rules
iptables -F

# Set default policies
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Allow traffic on localhost
iptables -A INPUT -i lo -j ACCEPT

# Allow incoming SSH (port 22)
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow HTTP (port 80) and HTTPS (port 443)
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Allow ICMP (ping)
iptables -A INPUT -p icmp -j ACCEPT

# Block traffic from a specific IP range
iptables -A INPUT -s 192.168.1.0/24 -j DROP

# Log dropped packets
iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "IPTables-Dropped: " --log-level 7

# Save the rules
/sbin/service iptables save

echo "Firewall rules configured and saved."
