# Playwright Testing with Kali Linux Template

This template provides a comprehensive development environment that combines the power of Playwright testing framework with Kali Linux security tools, creating an ideal setup for security researchers, penetration testers, and developers who need to perform security testing of web applications.

## 🎯 What This Template Provides

### Core Features
- **Kali Linux Base**: Built on the latest Kali Linux rolling release with access to hundreds of security tools
- **Playwright Framework**: Complete web automation and testing framework with all major browsers
- **Security Testing Tools**: Pre-installed penetration testing and security analysis tools
- **Network Analysis**: Advanced network discovery and analysis capabilities
- **Development Environment**: Full Node.js and Python development stack

### Target Audience
- Security researchers and penetration testers
- Web application security specialists
- QA engineers focused on security testing
- Developers building security-conscious applications
- Bug bounty hunters and ethical hackers

## 🚀 Quick Start Guide

1. **Create a new project** using this template
2. **Open in VS Code** with the Dev Containers extension
3. **Wait for setup** - the first build will install all tools and dependencies
4. **Navigate to workspace**: `cd /workspace`
5. **Run sample tests**: `npm test`
6. **Start security testing**: `npm run test:security`

## 🛠️ Installed Tools & Capabilities

### Web Testing & Automation
- **Playwright**: Modern web testing framework
  - Chromium, Firefox, and WebKit browsers
  - Mobile device emulation
  - Network interception and mocking
  - Screenshot and video recording
  - Parallel test execution

### Security Testing Tools
- **Burp Suite**: Web application security testing platform
- **OWASP ZAP**: Web application security scanner
- **SQLMap**: Automatic SQL injection testing
- **Nikto**: Web server vulnerability scanner
- **Nuclei**: Fast vulnerability scanner
- **FFUF**: Fast web fuzzer
- **Gobuster**: Directory/file brute-forcer
- **WPScan**: WordPress security scanner

### Network Analysis & Discovery
- **Nmap**: Network discovery and security auditing
- **Masscan**: High-speed port scanner
- **Wireshark**: Network protocol analyzer
- **tcpdump**: Command-line packet analyzer
- **Netcat**: Network utility for debugging and investigation

### Password & Hash Tools
- **Hydra**: Network login cracker
- **John the Ripper**: Password cracking tool
- **Hashcat**: Advanced password recovery

### Development Stack
- **Node.js**: JavaScript runtime (configurable version)
- **Python 3**: With security-focused packages
- **TypeScript**: For type-safe test development
- **Git**: Version control with GitHub CLI

## 📁 Project Structure

```
/workspace/
├── tests/
│   ├── e2e/           # End-to-end application tests
│   ├── integration/   # API and service integration tests
│   ├── unit/          # Component unit tests
│   └── security/      # Security-focused test suites
├── scripts/
│   ├── automation/    # Custom automation scripts
│   ├── discovery/     # Reconnaissance and discovery tools
│   └── exploitation/  # Security testing and exploitation scripts
├── reports/           # Test reports and scan results
├── tools/            # Custom security tools and utilities
├── playwright.config.ts  # Playwright configuration
├── package.json      # Node.js dependencies and scripts
└── README.md         # Project documentation
```

## 🔧 Configuration Options

### Node.js Version
Choose your preferred Node.js version:
- **18**: LTS version with good compatibility
- **20**: Current LTS with latest features
- **latest**: Cutting-edge features (may have compatibility issues)

### Browser Selection
Control which Playwright browsers to install:
- **all**: Chromium, Firefox, and WebKit (recommended)
- **chromium**: Google Chrome/Chromium only
- **firefox**: Mozilla Firefox only
- **webkit**: Safari/WebKit only
- **chromium-firefox**: Chrome and Firefox (common combination)

### Security Tools
- **Include Security Tools**: Installs comprehensive penetration testing toolkit
- **Include Network Tools**: Adds network analysis and discovery capabilities

## 🔒 Security Testing Examples

### Basic Security Headers Test
```typescript
test('should verify security headers', async ({ page }) => {
  const response = await page.goto('https://example.com');
  const headers = response?.headers();
  
  expect(headers?.['x-frame-options']).toBeDefined();
  expect(headers?.['x-content-type-options']).toBe('nosniff');
  expect(headers?.['strict-transport-security']).toBeDefined();
});
```

### XSS Protection Test
```typescript
test('should prevent XSS attacks', async ({ page }) => {
  await page.goto('https://example.com/search');
  await page.fill('input[name="q"]', '<script>alert("XSS")</script>');
  await page.press('input[name="q"]', 'Enter');
  
  const content = await page.content();
  expect(content).not.toContain('<script>alert("XSS")</script>');
});
```

### Automated Reconnaissance
```javascript
const { chromium } = require('playwright');

async function scanWebsite(url) {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  
  // Extract security information
  const response = await page.goto(url);
  const headers = response.headers();
  const technologies = await page.evaluate(() => {
    // Detect technologies, frameworks, etc.
  });
  
  await browser.close();
  return { headers, technologies };
}
```

## 🎮 Available Commands

### Testing Commands
```bash
npm test                 # Run all tests
npm run test:headed      # Run tests with browser UI
npm run test:ui          # Interactive test runner
npm run test:debug       # Debug mode with developer tools
npm run test:security    # Run security-specific tests
npm run test:report      # Show last test report
```

### Development Commands
```bash
npm run codegen         # Generate tests from browser interactions
playwright codegen <url> # Record interactions on specific site
```

### Security Tools Commands
```bash
# Network scanning
nmap -sV target.com
masscan -p1-65535 target.com --rate=1000

# Web application testing
nikto -h https://target.com
sqlmap -u "https://target.com/page?id=1"

# Directory discovery
gobuster dir -u https://target.com -w /usr/share/wordlists/dirb/common.txt
ffuf -w /usr/share/wordlists/dirb/common.txt -u https://target.com/FUZZ

# Vulnerability scanning
nuclei -u https://target.com
```

## 🔐 Security Features

### Container Security
- **Privileged Access**: Runs as root for security tool functionality
- **Network Capabilities**: Enhanced network access for testing tools
- **Security Context**: Configured for security research requirements

### Network Configuration
- **Port Forwarding**: Common development ports (3000, 8080, 9000)
- **Proxy Support**: Ready for proxy tools like Burp Suite
- **VPN Compatible**: Works with VPN connections for secure testing

### Data Protection
- **Volume Mounts**: Persistent storage for tools and data
- **Environment Variables**: Secure configuration management
- **Isolated Environment**: Contained testing environment

## 🚨 Security Considerations

### Ethical Usage
This template includes powerful security tools that should only be used for:
- **Authorized testing** on systems you own or have explicit permission to test
- **Educational purposes** in controlled environments
- **Bug bounty programs** within their defined scope
- **Security research** following responsible disclosure practices

### Legal Compliance
- Always obtain proper authorization before testing
- Respect terms of service and legal boundaries
- Follow responsible disclosure practices
- Maintain detailed documentation of testing activities

### Best Practices
- Use isolated test environments when possible
- Keep tools and signatures updated
- Implement proper access controls
- Regular security reviews of your testing environment

## 🤝 Contributing & Customization

### Adding Custom Tools
1. Modify the `setup.sh` script to include additional tools
2. Update the `devcontainer.json` for new VS Code extensions
3. Add new test examples to the appropriate directories

### Extending Security Tests
1. Create new test files in `tests/security/`
2. Implement custom security check functions
3. Add automation scripts to `scripts/` directories

### Configuration Customization
1. Modify `playwright.config.ts` for testing preferences
2. Update `package.json` for additional dependencies
3. Customize the workspace structure as needed

## 📚 Learning Resources

### Playwright Documentation
- [Official Playwright Docs](https://playwright.dev)
- [Test Generator Guide](https://playwright.dev/docs/codegen)
- [API Reference](https://playwright.dev/docs/api/class-playwright)

### Security Testing Resources
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [Web Security Academy](https://portswigger.net/web-security)
- [Kali Linux Documentation](https://www.kali.org/docs/)

### Penetration Testing
- [PTES Standard](http://www.pentest-standard.org/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)
- [SANS Testing Resources](https://www.sans.org/white-papers/)

## 🐛 Troubleshooting

### Common Issues

**Browser Installation Fails**
```bash
# Manually install browsers
playwright install --with-deps
```

**Permission Denied for Security Tools**
```bash
# Ensure running as root
whoami  # Should return 'root'
```

**Network Tools Not Working**
```bash
# Check network capabilities
ip addr show
ping google.com
```

**Playwright Tests Timeout**
```bash
# Increase timeout in playwright.config.ts
timeout: 30000  # 30 seconds
```

### Performance Optimization
- Use `--headed` mode sparingly (slower)
- Implement proper test parallelization
- Cache browser installations between builds
- Use lightweight test fixtures

## 📞 Support & Community

For issues, questions, or contributions:
1. Check the GitHub repository issues
2. Consult the official Playwright documentation
3. Review Kali Linux community resources
4. Follow security testing best practices

---

**⚠️ Disclaimer**: This template is designed for authorized security testing and research only. Users are responsible for ensuring compliance with all applicable laws and regulations. The authors assume no liability for misuse of these tools.