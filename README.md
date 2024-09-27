
# Basic Firewall Configuration Scripts

This repository contains shell scripts for configuring basic iptables firewall rules for common scenarios, such as allowing certain services, blocking IP ranges, and setting default policies.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
  - [firewall_rules.sh](#firewall_rulessh)
  - [basic_firewall.sh](#basic_firewallsh)
- [Contributing](#contributing)

---

## Installation

1. Clone this repository to your local machine:
   ```
   git clone https://github.com/aaaronsawit/iptables-firewall-scripts
   cd iptables-firewall-scripts
   ```

2. Make the script executable:
   ```
   chmod +x firewall_rules.sh
   ```

---

## Usage

### `firewall_rules.sh`

This script sets up a basic iptables firewall, allowing SSH, HTTP/HTTPS, and ICMP traffic, while blocking a specific IP range and logging dropped packets.

#### Usage:
```
sudo ./firewall_rules.sh
```

The firewall rules will be configured and saved automatically for Ubuntu and Debian systems. For other systems such as CentOS there may be a need to save the rules manually.

```
sudo service iptables save
```

---

### `basic_firewall.sh`

An example script located in the `examples/` directory. It is pretty robust and can be used for by a normal daily user.

#### Usage:
```
sudo ./examples/basic_firewall.sh
```

---

## Contributing

Feel free to contribute to this project by adding more common iptables configurations or enhancing the existing scripts. Submit a pull request with your changes!
