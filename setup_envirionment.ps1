# ==========================================
# 🧰 MANUAL INSTALLATION COMMANDS
# ==========================================
# If the setup script reports missing tools, you can install them manually
# using the following commands (run these one at a time in PowerShell):
#
# ------------------------------------------
# PowerShell 7
# ------------------------------------------
# Modern version of PowerShell (recommended for all users)
# Microsoft Store link: https://apps.microsoft.com/detail/9mz1snwt0n5d
winget install --id Microsoft.PowerShell -e --source winget
#
# ------------------------------------------
# Git
# ------------------------------------------
# Source control system used by VS Code and GitHub
# Official download: https://git-scm.com/download/win
winget install --id Git.Git -e --accept-source-agreements --accept-package-agreements
#
# ------------------------------------------
# GitHub CLI (gh)
# ------------------------------------------
# Enables login and GitHub repo management from PowerShell
# GitHub page: https://cli.github.com/
winget install --id GitHub.cli -e --accept-source-agreements --accept-package-agreements
#
# ------------------------------------------
# Python 3.10
# ------------------------------------------
# Python interpreter (recommended version for this class)
# Microsoft Store link: https://apps.microsoft.com/detail/9pjpw5ldxlz5
winget install --id Python.Python.3.10 -e --accept-source-agreements --accept-package-agreements
#
# ------------------------------------------
# App Installer (includes winget)
# ------------------------------------------
# Provides the Windows Package Manager (winget command)
# Microsoft Store link: https://apps.microsoft.com/detail/9nblggh4nns1
# If winget is missing, install this app directly from the Store.
#
# ==========================================
# After installing new software, sign out and sign back in 
# to refresh the PATH environment variable.
# ==========================================

# ==========================================
# setup_environment.ps1
# ------------------------------------------
# Checks for required developer tools and
# launches a second PowerShell window to
# install anything missing.
# ==========================================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host ""
Write-Host "=== Environment Setup Assistant ===" -ForegroundColor Cyan
Write-Host ""

# ----------------------------------------------------------
# Helper function to test command availability
# ----------------------------------------------------------
function Test-Command {
    param([string]$Command)
    return [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

# ----------------------------------------------------------
# Check tools
# ----------------------------------------------------------
$tools = @(
    @{ name = "PowerShell 7 (pwsh)"; cmd = "pwsh"; install = "winget install --id Microsoft.PowerShell -e --source winget" },
    @{ name = "Git"; cmd = "git"; install = "winget install --id Git.Git -e --accept-source-agreements --accept-package-agreements" },
    @{ name = "GitHub CLI (gh)"; cmd = "gh"; install = "winget install --id GitHub.cli -e --accept-source-agreements --accept-package-agreements" },
    @{ name = "Python 3"; cmd = "python"; install = "winget install --id Python.Python.3.10 -e --accept-source-agreements --accept-package-agreements" },
    @{ name = "winget"; cmd = "winget"; install = "Install 'App Installer' from Microsoft Store" }
)

$missing = @()

foreach ($tool in $tools) {
    if (Test-Command $tool.cmd) {
        Write-Host ("{0,-25}: ? Installed" -f $tool.name) -ForegroundColor Green
    }
    else {
        Write-Host ("{0,-25}: ? Missing" -f $tool.name) -ForegroundColor Red
        $missing += $tool
    }
}

Write-Host ""
if ($missing.Count -eq 0) {
    Write-Host "All required tools are installed!" -ForegroundColor Green
    exit 0
}

Write-Host "The following tools are missing:" -ForegroundColor Yellow
$missing | ForEach-Object { Write-Host " - $($_.name)" -ForegroundColor Gray }

# ----------------------------------------------------------
# Prompt to install missing ones in a new window
# ----------------------------------------------------------
$choice = Read-Host "Open a new PowerShell window to install missing tools? (Y/N)"
if ($choice -match "^[Yy]") {
    $installCmds = ($missing | ForEach-Object { $_.install }) -join " ; "
    Write-Host ""
    Write-Host "Launching a new PowerShell window for installations..." -ForegroundColor Cyan

    # Open a new PowerShell window with elevated privileges
    Start-Process powershell -Verb RunAs -ArgumentList "-NoExit", "-Command `"$installCmds; pause`""
} else {
    Write-Host "Setup canceled. You can install manually using winget or Microsoft Store." -ForegroundColor Yellow
}
