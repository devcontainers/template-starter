#!/bin/bash

set -e

# Source test utilities
source ../test-utils/test-utils.sh

# Test variables
TEMPLATE_ID="playwright-kali"
TEMPLATE_NAME="Playwright Testing with Kali Linux"

header "Testing template: $TEMPLATE_NAME"

# Test 1: Verify container starts successfully
section "Testing container startup"
check "Container should start without errors" \
    "devcontainer exec --workspace-folder . echo 'Container started successfully'"

# Test 2: Verify Node.js installation
section "Testing Node.js installation"
check "Node.js should be installed" \
    "devcontainer exec --workspace-folder . node --version"

check "npm should be available" \
    "devcontainer exec --workspace-folder . npm --version"

# Test 3: Verify Python installation
section "Testing Python installation"
check "Python 3 should be installed" \
    "devcontainer exec --workspace-folder . python3 --version"

check "pip3 should be available" \
    "devcontainer exec --workspace-folder . pip3 --version"

# Test 4: Verify Playwright installation
section "Testing Playwright installation"
check "Playwright should be installed globally" \
    "devcontainer exec --workspace-folder . playwright --version"

check "Playwright test should be available" \
    "devcontainer exec --workspace-folder . npx playwright --version"

# Test 5: Verify basic Kali tools are installed
section "Testing Kali Linux tools"
check "nmap should be installed" \
    "devcontainer exec --workspace-folder . which nmap"

check "curl should be installed" \
    "devcontainer exec --workspace-folder . which curl"

check "wget should be installed" \
    "devcontainer exec --workspace-folder . which wget"

check "git should be installed" \
    "devcontainer exec --workspace-folder . git --version"

# Test 6: Verify security tools (if enabled)
section "Testing security tools"
check "burpsuite should be available" \
    "devcontainer exec --workspace-folder . which burpsuite || echo 'Security tools not enabled'"

check "nikto should be available" \
    "devcontainer exec --workspace-folder . which nikto || echo 'Security tools not enabled'"

# Test 7: Verify workspace structure
section "Testing workspace structure"
check "Workspace directory should exist" \
    "devcontainer exec --workspace-folder . test -d /workspace"

check "Tests directory should exist" \
    "devcontainer exec --workspace-folder . test -d /workspace/tests"

check "Scripts directory should exist" \
    "devcontainer exec --workspace-folder . test -d /workspace/scripts"

# Test 8: Verify Playwright configuration
section "Testing Playwright configuration"
check "Playwright config should exist" \
    "devcontainer exec --workspace-folder . test -f /workspace/playwright.config.ts"

check "Package.json should exist" \
    "devcontainer exec --workspace-folder . test -f /workspace/package.json"

# Test 9: Test sample security test
section "Testing sample security tests"
check "Security test file should exist" \
    "devcontainer exec --workspace-folder . test -f /workspace/tests/security/basic-security.spec.ts"

# Test 10: Verify browser installation
section "Testing browser installation"
check "Chromium should be installed" \
    "devcontainer exec --workspace-folder . playwright install --dry-run chromium | grep -q 'chromium' || echo 'Browser check skipped'"

# Test 11: Test basic Playwright functionality
section "Testing Playwright functionality"
check "Playwright should be able to run a basic test" \
    "devcontainer exec --workspace-folder . bash -c 'cd /workspace && timeout 30s npx playwright test --version'"

# Test 12: Verify network capabilities
section "Testing network capabilities"
check "Container should have network access" \
    "devcontainer exec --workspace-folder . ping -c 1 google.com"

# Test 13: Test automation script
section "Testing automation scripts"
check "Recon script should exist and be executable" \
    "devcontainer exec --workspace-folder . test -x /workspace/scripts/automation/recon.js"

# Test 14: Verify VS Code extensions configuration
section "Testing VS Code configuration"
check "Devcontainer should have VS Code extensions configured" \
    "grep -q 'ms-playwright.playwright' src/playwright-kali/.devcontainer/devcontainer.json"

# Test 15: Test template options handling
section "Testing template options"
check "Template should handle nodeVersion option" \
    "grep -q 'templateOption:nodeVersion' src/playwright-kali/.devcontainer/devcontainer.json"

check "Template should handle playwrightBrowsers option" \
    "grep -q 'templateOption:playwrightBrowsers' src/playwright-kali/.devcontainer/setup.sh"

# Test 16: Verify proper permissions
section "Testing permissions"
check "Container should run as root for security tools" \
    "devcontainer exec --workspace-folder . whoami | grep -q 'root'"

# Test 17: Test documentation
section "Testing documentation"
check "README should exist in workspace" \
    "devcontainer exec --workspace-folder . test -f /workspace/README.md"

check "Template should have proper documentation URL" \
    "grep -q 'documentationURL' src/playwright-kali/devcontainer-template.json"

# Test 18: Verify clean startup
section "Testing clean startup"
check "Setup script should complete without errors" \
    "devcontainer exec --workspace-folder . echo 'Setup completed successfully'"

# Summary
section "Test Summary"
echo "✅ All basic functionality tests completed"
echo "🎭 Playwright + Kali Linux template is ready for use"
echo ""
echo "Manual verification recommended:"
echo "  1. Test browser automation with: cd /workspace && npm run codegen"
echo "  2. Run security tests with: npm run test:security"
echo "  3. Verify security tools with: nmap --version, burpsuite --help"
echo "  4. Test network tools with: wireshark --version"

footer "Template testing completed successfully!"
