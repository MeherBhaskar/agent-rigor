#!/usr/bin/env node

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

console.log("🚀 Installing Agent Rigor framework...");

const targetDir = path.join(process.cwd(), '.agents');

try {
  // Use npx degit to clone the repository without .git history
  // degit allows downloading a specific subdirectory, or the whole repo
  execSync('npx degit MeherBhaskar/agent-rigor .agents --force', { stdio: 'inherit' });
  
  // Remove files that aren't part of the actual framework (like package.json, bin, SKILL.md index)
  const filesToCleanup = ['package.json', 'bin', 'SKILL.md', 'README.md', 'install.sh', '.gitignore'];
  filesToCleanup.forEach(file => {
    const filePath = path.join(targetDir, file);
    if (fs.existsSync(filePath)) {
      if (fs.statSync(filePath).isDirectory()) {
        fs.rmSync(filePath, { recursive: true, force: true });
      } else {
        fs.unlinkSync(filePath);
      }
    }
  });

  console.log("✅ Agent Rigor installed successfully to .agents/");
  console.log("To begin, drop this prompt to your AI:");
  console.log('> "I need to build [feature]. Read .agents/core/SYSTEM_CORE.md and begin."');
} catch (error) {
  console.error("❌ Failed to install Agent Rigor:", error.message);
  process.exit(1);
}
