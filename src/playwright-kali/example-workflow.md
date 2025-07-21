# Example Security Testing Workflow

This document demonstrates a complete security testing workflow using the Playwright + Kali Linux template.

## Scenario: Testing a Web Application for Security Vulnerabilities

Let's walk through a comprehensive security assessment of a web application using the tools provided in this template.

### Phase 1: Reconnaissance

#### 1.1 Basic Information Gathering
```bash
# Start with basic reconnaissance
cd /workspace

# Use the automated recon script
node scripts/automation/recon.js https://target-app.com

# Manual nmap scan for open ports
nmap -sV -sC target-app.com

# Directory discovery
gobuster dir -u https://target-app.com -w /usr/share/wordlists/dirb/common.txt
```

#### 1.2 Technology Detection with Playwright
```javascript
// scripts/discovery/tech-detection.js
const { chromium } = require('playwright');

async function detectTechnologies(url) {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  
  await page.goto(url);
  
  // Detect frameworks and libraries
  const technologies = await page.evaluate(() => {
    const tech = {};
    
    // Check for common frameworks
    if (window.React) tech.react = window.React.version;
    if (window.Vue) tech.vue = window.Vue.version;
    if (window.angular) tech.angular = window.angular.version;
    if (window.jQuery) tech.jquery = window.jQuery.fn.jquery;
    
    // Check for common CMS indicators
    if (document.querySelector('meta[name="generator"]')) {
      tech.generator = document.querySelector('meta[name="generator"]').content;
    }
    
    return tech;
  });
  
  console.log('Detected Technologies:', technologies);
  await browser.close();
  return technologies;
}
```

### Phase 2: Automated Security Testing

#### 2.1 Basic Security Headers Assessment
```typescript
// tests/security/headers-assessment.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Security Headers Assessment', () => {
  test('should have proper security headers', async ({ page }) => {
    const response = await page.goto('https://target-app.com');
    const headers = response?.headers();
    
    // Content Security Policy
    expect(headers?.['content-security-policy']).toBeDefined();
    
    // Clickjacking protection
    expect(headers?.['x-frame-options']).toBeDefined();
    
    // MIME type sniffing protection
    expect(headers?.['x-content-type-options']).toBe('nosniff');
    
    // XSS protection
    expect(headers?.['x-xss-protection']).toBeDefined();
    
    // HTTPS enforcement
    expect(headers?.['strict-transport-security']).toBeDefined();
    
    // Information disclosure
    expect(headers?.['server']).not.toContain('Apache/');
    expect(headers?.['x-powered-by']).toBeUndefined();
  });
});
```

#### 2.2 Input Validation Testing
```typescript
// tests/security/input-validation.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Input Validation Tests', () => {
  const xssPayloads = [
    '<script>alert("XSS")</script>',
    '"><script>alert("XSS")</script>',
    'javascript:alert("XSS")',
    '<img src=x onerror=alert("XSS")>'
  ];
  
  const sqlPayloads = [
    "' OR '1'='1",
    "'; DROP TABLE users; --",
    "1' UNION SELECT null, username, password FROM users--"
  ];
  
  test('should prevent XSS attacks', async ({ page }) => {
    await page.goto('https://target-app.com/search');
    
    for (const payload of xssPayloads) {
      await page.fill('input[name="query"]', payload);
      await page.press('input[name="query"]', 'Enter');
      
      // Check that payload is properly encoded/escaped
      const content = await page.content();
      expect(content).not.toContain(payload);
      
      // Check for script execution
      const alerts = await page.evaluate(() => window.alertTriggered);
      expect(alerts).toBeFalsy();
    }
  });
  
  test('should prevent SQL injection', async ({ page }) => {
    await page.goto('https://target-app.com/login');
    
    for (const payload of sqlPayloads) {
      await page.fill('input[name="username"]', payload);
      await page.fill('input[name="password"]', 'password');
      await page.click('button[type="submit"]');
      
      // Should not bypass authentication
      expect(page.url()).not.toContain('/dashboard');
      
      // Should not show database errors
      const content = await page.content();
      expect(content).not.toMatch(/mysql_|postgresql_|sqlite_|syntax error/i);
    }
  });
});
```

### Phase 3: Advanced Security Analysis

#### 3.1 Session Management Testing
```typescript
// tests/security/session-management.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Session Management', () => {
  test('should implement secure session handling', async ({ page, context }) => {
    // Login and capture session
    await page.goto('https://target-app.com/login');
    await page.fill('input[name="username"]', 'testuser');
    await page.fill('input[name="password"]', 'testpass');
    await page.click('button[type="submit"]');
    
    // Get session cookies
    const cookies = await context.cookies();
    const sessionCookie = cookies.find(c => c.name.includes('session'));
    
    if (sessionCookie) {
      // Check for secure flags
      expect(sessionCookie.secure).toBeTruthy();
      expect(sessionCookie.httpOnly).toBeTruthy();
      expect(sessionCookie.sameSite).toBe('Strict');
    }
    
    // Test session timeout
    await page.waitForTimeout(30000); // Wait 30 seconds
    await page.reload();
    
    // Should redirect to login if session expired
    expect(page.url()).toContain('/login');
  });
});
```

#### 3.2 Authentication Bypass Testing
```typescript
// tests/security/auth-bypass.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Authentication Bypass Tests', () => {
  test('should not allow unauthorized access', async ({ page }) => {
    // Try accessing protected pages directly
    const protectedUrls = [
      '/admin',
      '/dashboard',
      '/profile',
      '/settings'
    ];
    
    for (const url of protectedUrls) {
      await page.goto(`https://target-app.com${url}`);
      
      // Should redirect to login
      expect(page.url()).toContain('/login');
    }
  });
  
  test('should validate JWT tokens properly', async ({ page }) => {
    // Test with malformed JWT
    await page.addInitScript(() => {
      localStorage.setItem('token', 'invalid.jwt.token');
    });
    
    await page.goto('https://target-app.com/dashboard');
    expect(page.url()).toContain('/login');
  });
});
```

### Phase 4: Network-Level Security Testing

#### 4.1 Using Nmap for Port Scanning
```bash
# Comprehensive port scan
nmap -sS -sV -sC -O -A target-app.com

# Scan for common vulnerabilities
nmap --script vuln target-app.com

# Check for SSL/TLS issues
nmap --script ssl-enum-ciphers -p 443 target-app.com
```

#### 4.2 SSL/TLS Security Assessment
```bash
# Use SSLyze for detailed SSL analysis
sslyze target-app.com:443

# Test SSL with testssl.sh
testssl.sh https://target-app.com
```

### Phase 5: Web Application Vulnerability Scanning

#### 5.1 Using Nuclei for Automated Scanning
```bash
# Run nuclei with all templates
nuclei -u https://target-app.com -t /root/nuclei-templates/

# Run specific vulnerability checks
nuclei -u https://target-app.com -t /root/nuclei-templates/cves/
nuclei -u https://target-app.com -t /root/nuclei-templates/vulnerabilities/
```

#### 5.2 Using SQLMap for SQL Injection Testing
```bash
# Test forms for SQL injection
sqlmap -u "https://target-app.com/search?q=test" --batch --banner

# Test POST parameters
sqlmap -u "https://target-app.com/login" --data="username=test&password=test" --batch
```

### Phase 6: Reporting and Documentation

#### 6.1 Automated Report Generation
```javascript
// scripts/reporting/generate-report.js
const fs = require('fs');
const path = require('path');

class SecurityReport {
  constructor() {
    this.findings = [];
    this.timestamp = new Date().toISOString();
  }
  
  addFinding(severity, title, description, evidence) {
    this.findings.push({
      severity,
      title,
      description,
      evidence,
      timestamp: new Date().toISOString()
    });
  }
  
  generateHTML() {
    const template = `
    <!DOCTYPE html>
    <html>
    <head>
      <title>Security Assessment Report</title>
      <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .critical { color: #d32f2f; }
        .high { color: #f57c00; }
        .medium { color: #fbc02d; }
        .low { color: #388e3c; }
        .finding { margin: 20px 0; padding: 15px; border-left: 4px solid #ccc; }
      </style>
    </head>
    <body>
      <h1>Security Assessment Report</h1>
      <p>Generated: ${this.timestamp}</p>
      
      <h2>Executive Summary</h2>
      <p>Total findings: ${this.findings.length}</p>
      
      <h2>Detailed Findings</h2>
      ${this.findings.map(finding => `
        <div class="finding ${finding.severity}">
          <h3>${finding.title}</h3>
          <p><strong>Severity:</strong> ${finding.severity.toUpperCase()}</p>
          <p><strong>Description:</strong> ${finding.description}</p>
          <p><strong>Evidence:</strong> ${finding.evidence}</p>
        </div>
      `).join('')}
    </body>
    </html>
    `;
    
    return template;
  }
  
  save() {
    const reportPath = `/workspace/reports/security-report-${Date.now()}.html`;
    fs.writeFileSync(reportPath, this.generateHTML());
    console.log(`Report saved to: ${reportPath}`);
  }
}

module.exports = SecurityReport;
```

### Phase 7: Continuous Security Testing

#### 7.1 CI/CD Integration
```yaml
# .github/workflows/security-tests.yml
name: Security Tests

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  security-tests:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Run Security Tests
      run: |
        docker run --rm -v $PWD:/workspace \
          ghcr.io/your-org/playwright-kali:latest \
          npm run test:security
        
    - name: Upload Security Report
      uses: actions/upload-artifact@v3
      with:
        name: security-report
        path: reports/
```

### Best Practices for Security Testing

1. **Always Get Authorization**: Never test systems you don't own or lack permission to test
2. **Use Isolated Environments**: Test in staging/development environments when possible
3. **Document Everything**: Keep detailed logs of all testing activities
4. **Follow Responsible Disclosure**: Report vulnerabilities through proper channels
5. **Stay Updated**: Keep tools and vulnerability databases current
6. **Validate Findings**: Manually verify automated scan results
7. **Consider Impact**: Assess the real-world impact of discovered vulnerabilities

### Common Security Issues to Test For

- **OWASP Top 10 Vulnerabilities**
  - Injection attacks (SQL, XSS, etc.)
  - Broken authentication
  - Sensitive data exposure
  - XML external entities (XXE)
  - Broken access control
  - Security misconfigurations
  - Cross-site scripting (XSS)
  - Insecure deserialization
  - Using components with known vulnerabilities
  - Insufficient logging and monitoring

- **Additional Security Concerns**
  - CSRF attacks
  - Clickjacking
  - Server-side request forgery (SSRF)
  - Directory traversal
  - File upload vulnerabilities
  - Business logic flaws

This workflow provides a comprehensive approach to security testing using the Playwright + Kali Linux template. Adapt and extend it based on your specific testing requirements and the applications you're assessing.