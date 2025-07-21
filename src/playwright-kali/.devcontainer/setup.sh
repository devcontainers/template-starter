#!/bin/bash

set -e

echo "🚀 Setting up Playwright + Kali Linux development environment..."

# Update package lists
echo "📦 Updating package lists..."
apt-get update

# Install essential development tools
echo "🔧 Installing essential development tools..."
apt-get install -y \
    curl \
    wget \
    git \
    vim \
    nano \
    build-essential \
    python3-pip \
    python3-venv \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    apt-transport-https

# Install security tools if enabled
if [ "${templateOption:includeSecurityTools}" = "true" ]; then
    echo "🛡️ Installing security research tools..."
    apt-get install -y \
        burpsuite \
        sqlmap \
        nikto \
        dirb \
        gobuster \
        hydra \
        john \
        hashcat \
        metasploit-framework \
        beef-xss \
        zaproxy \
        whatweb \
        wpscan \
        nuclei \
        subfinder \
        httpx-toolkit \
        ffuf
fi

# Install network tools if enabled
if [ "${templateOption:includeNetworkTools}" = "true" ]; then
    echo "🌐 Installing network analysis tools..."
    apt-get install -y \
        nmap \
        masscan \
        wireshark \
        tcpdump \
        netcat-traditional \
        socat \
        proxychains4 \
        tor \
        netdiscover \
        arp-scan \
        dnsutils \
        whois \
        traceroute \
        mtr-tiny
fi

# Install additional browser dependencies for Playwright
echo "🌐 Installing browser dependencies..."
apt-get install -y \
    libnss3 \
    libnspr4 \
    libatk-bridge2.0-0 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libxss1 \
    libasound2 \
    libatspi2.0-0 \
    libgtk-3-0 \
    xvfb

# Install Playwright
echo "🎭 Installing Playwright..."
npm install -g playwright@latest
npm install -g @playwright/test

# Install Playwright browsers based on user selection
echo "🌐 Installing Playwright browsers..."
case "${templateOption:playwrightBrowsers}" in
    "all")
        playwright install --with-deps
        ;;
    "chromium")
        playwright install --with-deps chromium
        ;;
    "firefox")
        playwright install --with-deps firefox
        ;;
    "webkit")
        playwright install --with-deps webkit
        ;;
    "chromium-firefox")
        playwright install --with-deps chromium firefox
        ;;
    *)
        playwright install --with-deps
        ;;
esac

# Install additional Python packages for security research
echo "🐍 Installing Python security packages..."
pip3 install \
    requests \
    beautifulsoup4 \
    selenium \
    scrapy \
    paramiko \
    pycrypto \
    cryptography \
    scapy \
    python-nmap \
    dnspython \
    pexpect \
    colorama \
    tabulate \
    tqdm \
    click \
    rich

# Install additional Node.js packages
echo "📦 Installing useful Node.js packages..."
npm install -g \
    typescript \
    ts-node \
    nodemon \
    pm2 \
    http-server \
    live-server \
    eslint \
    prettier \
    jest \
    axios \
    express

# Create project structure
echo "📁 Creating project structure..."
mkdir -p /workspace/{tests,reports,scripts,tools}
mkdir -p /workspace/tests/{e2e,integration,unit,security}
mkdir -p /workspace/scripts/{automation,discovery,exploitation}

# Create sample Playwright configuration
echo "⚙️ Creating sample Playwright configuration..."
cat > /workspace/playwright.config.ts << 'EOF'
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [['html'], ['json', { outputFile: 'reports/test-results.json' }]],
  outputDir: 'reports/test-results/',

  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    headless: true,
  },

  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
    {
      name: 'mobile-chrome',
      use: { ...devices['Pixel 5'] },
    },
    {
      name: 'mobile-safari',
      use: { ...devices['iPhone 12'] },
    },
  ],

  webServer: {
    command: 'npm run start',
    url: 'http://127.0.0.1:3000',
    reuseExistingServer: !process.env.CI,
  },
});
EOF

# Create sample package.json
echo "📄 Creating sample package.json..."
cat > /workspace/package.json << 'EOF'
{
  "name": "playwright-security-testing",
  "version": "1.0.0",
  "description": "Playwright testing environment for security research",
  "main": "index.js",
  "scripts": {
    "test": "playwright test",
    "test:headed": "playwright test --headed",
    "test:ui": "playwright test --ui",
    "test:debug": "playwright test --debug",
    "test:report": "playwright show-report",
    "test:security": "playwright test tests/security/",
    "codegen": "playwright codegen",
    "install:browsers": "playwright install --with-deps"
  },
  "keywords": ["playwright", "testing", "security", "kali"],
  "author": "Security Researcher",
  "license": "MIT",
  "devDependencies": {
    "@playwright/test": "^1.40.0",
    "@types/node": "^20.0.0",
    "typescript": "^5.0.0"
  },
  "dependencies": {
    "axios": "^1.6.0",
    "dotenv": "^16.3.0"
  }
}
EOF

# Create sample security test
echo "🔒 Creating sample security test..."
cat > /workspace/tests/security/basic-security.spec.ts << 'EOF'
import { test, expect } from '@playwright/test';

test.describe('Basic Security Tests', () => {
  test('should check for HTTPS redirect', async ({ page }) => {
    await page.goto('http://example.com');
    expect(page.url()).toMatch(/^https:/);
  });

  test('should check for security headers', async ({ page }) => {
    const response = await page.goto('https://example.com');
    const headers = response?.headers();

    expect(headers?.['x-frame-options']).toBeDefined();
    expect(headers?.['x-content-type-options']).toBeDefined();
    expect(headers?.['strict-transport-security']).toBeDefined();
  });

  test('should check for XSS protection', async ({ page }) => {
    await page.goto('https://example.com');

    // Try to inject a simple XSS payload
    await page.fill('input[type="search"], input[name="q"], input[name="search"]', '<script>alert("XSS")</script>');

    // Check that script tags are properly escaped
    const content = await page.content();
    expect(content).not.toContain('<script>alert("XSS")</script>');
  });
});
EOF

# Create sample automation script
echo "🤖 Creating sample automation script..."
cat > /workspace/scripts/automation/recon.js << 'EOF'
const { chromium } = require('playwright');

async function basicRecon(url) {
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage();

  try {
    console.log(`🔍 Starting reconnaissance on: ${url}`);

    const response = await page.goto(url);
    const title = await page.title();
    const headers = response.headers();

    console.log(`📄 Title: ${title}`);
    console.log(`🔧 Server: ${headers.server || 'Unknown'}`);
    console.log(`🛡️ Security Headers:`);
    console.log(`  - X-Frame-Options: ${headers['x-frame-options'] || 'Not Set'}`);
    console.log(`  - X-Content-Type-Options: ${headers['x-content-type-options'] || 'Not Set'}`);
    console.log(`  - Strict-Transport-Security: ${headers['strict-transport-security'] || 'Not Set'}`);

    // Extract links
    const links = await page.evaluate(() => {
      return Array.from(document.querySelectorAll('a')).map(a => a.href).slice(0, 10);
    });

    console.log(`🔗 Found ${links.length} links (showing first 10):`);
    links.forEach(link => console.log(`  - ${link}`));

  } catch (error) {
    console.error(`❌ Error: ${error.message}`);
  } finally {
    await browser.close();
  }
}

// Usage: node recon.js <url>
if (process.argv[2]) {
  basicRecon(process.argv[2]);
} else {
  console.log('Usage: node recon.js <url>');
}
EOF

# Set proper permissions
chmod +x /workspace/scripts/automation/recon.js

# Create README for the workspace
echo "📚 Creating workspace README..."
cat > /workspace/README.md << 'EOF'
# Playwright Security Testing Environment

This environment combines Playwright testing capabilities with Kali Linux security tools for comprehensive web application security testing.

## 🚀 Quick Start

1. **Run basic tests:**
   ```bash
   cd /workspace
   npm test
   ```

2. **Run security-specific tests:**
   ```bash
   npm run test:security
   ```

3. **Interactive test development:**
   ```bash
   npm run test:ui
   ```

4. **Generate tests from browser interactions:**
   ```bash
   npm run codegen https://example.com
   ```

## 🛠️ Available Tools

### Playwright Testing
- All major browsers (Chromium, Firefox, WebKit)
- Mobile device emulation
- Network interception
- Screenshot and video capture
- Test reporting

### Security Tools
- Burp Suite - Web application security testing
- OWASP ZAP - Security scanning
- Nmap - Network discovery
- SQLMap - SQL injection testing
- Nikto - Web server scanner
- And many more...

### Network Analysis
- Wireshark - Network protocol analyzer
- tcpdump - Packet analyzer
- Nmap - Network mapper
- Masscan - High-speed port scanner

## 📁 Project Structure

```
/workspace/
├── tests/
│   ├── e2e/           # End-to-end tests
│   ├── integration/   # Integration tests
│   ├── unit/          # Unit tests
│   └── security/      # Security-focused tests
├── scripts/
│   ├── automation/    # Automation scripts
│   ├── discovery/     # Discovery tools
│   └── exploitation/  # Security testing scripts
├── reports/           # Test reports and results
└── tools/            # Custom tools and utilities
```

## 🔒 Security Testing Examples

Check the `tests/security/` directory for example security tests and the `scripts/` directory for automation examples.

## 📖 Resources

- [Playwright Documentation](https://playwright.dev)
- [Kali Linux Tools](https://www.kali.org/tools/)
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
EOF

# Create .gitignore
cat > /workspace/.gitignore << 'EOF'
# Dependencies
node_modules/
.npm

# Test results
test-results/
playwright-report/
reports/

# Environment variables
.env
.env.local

# Logs
*.log
npm-debug.log*

# Coverage
coverage/

# Cache
.cache/
.parcel-cache/

# IDE
.vscode/settings.json
.idea/

# OS
.DS_Store
Thumbs.db

# Temporary files
*.tmp
*.temp
EOF

# Set up workspace ownership
chown -R root:root /workspace

# Clean up
echo "🧹 Cleaning up..."
apt-get autoremove -y
apt-get autoclean
rm -rf /var/lib/apt/lists/*

echo "✅ Setup complete! Your Playwright + Kali Linux environment is ready for security research and testing."
echo ""
echo "🎯 Next steps:"
echo "  1. cd /workspace"
echo "  2. npm test (to run sample tests)"
echo "  3. npm run test:ui (for interactive testing)"
echo "  4. npm run codegen <url> (to generate tests)"
echo ""
echo "🔍 Security tools are available system-wide. Try: nmap, burpsuite, zaproxy, etc."
