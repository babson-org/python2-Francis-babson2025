# ==========================================
# 🧰 Permanent Fix for "Not Digitally Signed" Error
# ==========================================
# 1. Allows local PowerShell scripts for the current user (RemoteSigned)
# 2. Unblocks the setup script if downloaded
# 3. Runs setup_envirionment.ps1
# ==========================================

Write-Host "`n=== Permanent Fix for 'Not Digitally Signed' Error ===`n" -ForegroundColor Cyan

# Ensure running from correct folder
cd D:\PythonClass

# Detect PowerShell version
$ver = $PSVersionTable.PSVersion.Major
if ($ver -lt 7) {
    Write-Host "⚠️ Please run this script in PowerShell 7 or higher (pwsh), not Windows PowerShell 5.1." -ForegroundColor Red
    exit 1
}

# Set execution policy permanently for current user
Write-Host "`n--- Setting Execution Policy to RemoteSigned ---`n" -ForegroundColor Yellow
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force

# Unblock setup script if Windows marked it as downloaded
Write-Host "`n--- Unblocking setup_envirionment.ps1 ---`n" -ForegroundColor Yellow
Unblock-File .\setup_envirionment.ps1

# Run the setup script
Write-Host "`n--- Running setup_envirionment.ps1 ---`n" -ForegroundColor Green
powershell -ExecutionPolicy Bypass -File .\setup_envirionment.ps1

Write-Host "`n✅ Done! You can now run PowerShell scripts without 'not digitally signed' errors.`n" -ForegroundColor Cyan
