# Kali Linux Development Container

A basic Kali Linux development environment that can be extended with security tools as needed.

## What's Included

- **Base Image**: Official Kali Linux Rolling Release
- **Basic Tools**: curl, git, python3, python3-pip, sudo
- **VS Code Extension**: Python support

## Getting Started

1. Open this template in VS Code with the Dev Containers extension
2. VS Code will build and start the Kali Linux container
3. Install additional tools as needed for your specific use case

## Installing Additional Tools

Since this is a minimal setup, you can install Kali's security tools on demand:

```bash
# Update package list
sudo apt update

# Install specific tools
sudo apt install nmap burpsuite sqlmap nikto

# Or install tool collections
sudo apt install kali-tools-web
sudo apt install kali-tools-forensics
sudo apt install kali-tools-wireless
```

## Common Security Tools

Some popular tools you might want to install:

- **Web Testing**: `burpsuite`, `zaproxy`, `sqlmap`, `nikto`
- **Network**: `nmap`, `masscan`, `wireshark`, `netcat`
- **Forensics**: `autopsy`, `volatility`, `sleuthkit`
- **Wireless**: `aircrack-ng`, `kismet`, `reaver`

## Why This Approach?

This template provides a clean Kali Linux base without pre-installing hundreds of tools. This means:

- Faster container startup
- Smaller image size
- Install only what you need
- Easier troubleshooting
- More reliable builds

## Extending the Template

To customize this template for your specific needs:

1. Fork this repository
2. Modify `.devcontainer/devcontainer.json`
3. Add your required tools to `postCreateCommand`
4. Add VS Code extensions to the `extensions` array

Example customization:
```json
{
  "postCreateCommand": "apt-get update && apt-get install -y nmap burpsuite sqlmap"
}
```
