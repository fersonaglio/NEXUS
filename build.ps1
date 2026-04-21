# NEXUS Build Script
# Builds the NEXUS wrapper executable

$ErrorActionPreference = "Stop"

Write-Host "Building NEXUS..." -ForegroundColor Cyan

# Ensure bun is available
$bunCmd = Get-Command bun -ErrorAction SilentlyContinue
if (-not $bunCmd) {
    Write-Host "Bun not found. Installing..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri "https://bun.sh/install.ps1" -UseBasicParsing | Invoke-Expression
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    $bunCmd = Get-Command bun -ErrorAction SilentlyContinue
}

# Install dependencies
Write-Host "Installing dependencies..." -ForegroundColor Yellow
bun install

# Create bin directory
if (-not (Test-Path "bin")) {
    New-Item -ItemType Directory -Path "bin" | Out-Null
}

# Build the executable - copy wrapper as a standalone bun script that can be run
Write-Host "Creating nexus executable..." -ForegroundColor Yellow

# Create a standalone script that can be run with bun
$scriptContent = @'
#!/usr/bin/env bun

// NEXUS - OpenCode with local Ollama support

import { spawn } from "bun"
import { existsSync, mkdirSync, readFileSync, writeFileSync } from "fs"
import { join } from "path"
import { homedir } from "os"

const NEXUS_DIR = join(homedir(), ".config", "nexus")
const NEXUS_CONFIG = join(NEXUS_DIR, "config.json")

if (!existsSync(NEXUS_CONFIG)) {
  mkdirSync(NEXUS_DIR, { recursive: true })
  const defaultConfig = {
    provider: {
      ollama: {
        api: "http://localhost:11434/v1"
      }
    }
  }
  writeFileSync(NEXUS_CONFIG, JSON.stringify(defaultConfig, null, 2))
}

const args = process.argv.slice(2).map(arg => {
  if ((arg.startsWith("--model=") || arg.startsWith("-m=")) && !arg.includes("/")) {
    return arg.replace(/=(.+)/, "=ollama/$1")
  }
  return arg
})

const projectRoot = join(import.meta.dir, "..")
const exitCode = await spawn({
  cmd: ["bun", "run", "--cwd", projectRoot, "packages/opencode/src/index.ts", ...args],
  stdio: "inherit"
})

process.exit(exitCode)
'@

Set-Content -Path "bin\nexus" -Value $scriptContent -NoNewline

Write-Host "Binary created: bin\nexus" -ForegroundColor Green
Write-Host ""
Write-Host "Usage:" -ForegroundColor White
Write-Host "  ./bin/nexus --model qwen2.5-coder:7b-instruct" -ForegroundColor Gray
Write-Host "  ./bin/nexus -m llama3" -ForegroundColor Gray
Write-Host ""
