# ==========================================
# sync_class_to_student.ps1
# ==========================================
# Safely syncs instructor class_repo → student_repo
# Excludes: .devcontainer, .git, .github, .vscode, .venv
# ==========================================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$today = (Get-Date).ToString("yyyyMMdd")

Write-Host ""
Write-Host "Starting sync_class_to_student.ps1..." -ForegroundColor Cyan

# ----------------------------------------------------------
# 1. Locate PythonClass root folder
# ----------------------------------------------------------
$path = (Get-Location).Path
while ($path -ne [System.IO.Path]::GetPathRoot($path)) {
    if (Test-Path (Join-Path $path "sync_class_to_student.ps1")) {
        $root = $path
        break
    }
    $path = Split-Path $path
}
if (-not $root) { Write-Host "ERROR: Could not locate PythonClass root folder." -ForegroundColor Red; exit 1 }

$configFile  = Join-Path $root ".student_config.txt"
$classRepo   = Join-Path $root "class_repo"
$studentRepo = Join-Path $root "student_repo"

Write-Host ""
Write-Host "Using paths:" -ForegroundColor Cyan
Write-Host "   Class repo:   $classRepo"
Write-Host "   Student repo: $studentRepo"

# ----------------------------------------------------------
# 2. Verify Git identity
# ----------------------------------------------------------
$gitUser = git config --global user.name
$gitEmail = git config --global user.email
if (-not $gitUser -or -not $gitEmail) {
    Write-Host "Git identity not set. Setting defaults..." -ForegroundColor Yellow
    git config --global user.name "student-name"
    git config --global user.email "student@example.com"
}
Write-Host "Git identity: $gitUser <$gitEmail>" -ForegroundColor Green

# ----------------------------------------------------------
# 3. Get GitHub username (prompt once)
# ----------------------------------------------------------
if (Test-Path $configFile) {
    $username = Get-Content $configFile | Select-Object -First 1
    Write-Host "Loaded GitHub username from config: $username" -ForegroundColor Green
} else {
    Write-Host ""
    $username = Read-Host "Enter your GitHub username (e.g., Ava-Babson2025)"
    Set-Content -Path $configFile -Value $username
    Write-Host "Username saved for future runs." -ForegroundColor Green
}

# ----------------------------------------------------------
# 4. Clone repos if missing
# ----------------------------------------------------------
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: GitHub CLI (gh) not found." -ForegroundColor Red
    Write-Host "Install with: winget install --id GitHub.cli -e --accept-source-agreements --accept-package-agreements"
    exit 1
}

if (-not (Test-Path $classRepo)) {
    Write-Host "Cloning instructor class repo..." -ForegroundColor Cyan
    gh repo clone babson-org/classroom-python-python_repo $classRepo
} else { Write-Host "class_repo already exists." -ForegroundColor Green }

if (-not (Test-Path $studentRepo)) {
    Write-Host "Cloning your personal student repo..." -ForegroundColor Cyan
    $studentRepoName = "babson-org/python-$username"
    gh repo clone $studentRepoName $studentRepo
} else { Write-Host "student_repo already exists." -ForegroundColor Green }

# ----------------------------------------------------------
# 5. Commit/push any local student work
# ----------------------------------------------------------
Set-Location $studentRepo
Write-Host "Committing local changes in student repo..." -ForegroundColor Cyan
git add . | Out-Null
git commit -m "Local save before sync ($today)" 2>$null
git push origin main 2>$null
Write-Host "Student repo synced to remote." -ForegroundColor Green

# ----------------------------------------------------------
# 6. Pull latest class updates
# ----------------------------------------------------------
Set-Location $classRepo
Write-Host "Pulling latest class updates..." -ForegroundColor Cyan
git pull origin main | Out-Null
Write-Host "Class repo is up to date." -ForegroundColor Green

# ----------------------------------------------------------
# 7. Compare and Sync Files
# ----------------------------------------------------------
Write-Host "Comparing and syncing files..." -ForegroundColor Cyan
$renamedFiles = @()
$deletedFiles = @()

# Directories to exclude
$excludeDirs = @(".git", ".github", ".devcontainer", ".vscode", ".venv")

function Get-FilesRecursively {
    param([string]$BasePath)

    $results = @()
    $items = Get-ChildItem -Path $BasePath -Force

    foreach ($item in $items) {
        if ($item.PSIsContainer) {
            if ($excludeDirs -contains $item.Name) { continue }
            $results += Get-FilesRecursively -BasePath $item.FullName
        } else {
            $results += $item.FullName
        }
    }
    return $results
}

# Remove selected nonessential dirs from student repo
foreach ($dir in $excludeDirs | Where-Object { $_ -ne ".git" }) {
    $target = Join-Path $studentRepo $dir
    if (Test-Path $target) {
        try {
            Remove-Item -Recurse -Force $target -ErrorAction Stop
            Write-Host "Removed $dir from student repo." -ForegroundColor Yellow
        } catch {
            Write-Host "Skipped removal of $dir (in use)." -ForegroundColor DarkYellow
        }
    }
}

# Collect file lists
$classFiles = Get-FilesRecursively -BasePath $classRepo | ForEach-Object { $_.Substring($classRepo.Length + 1) }
$studentFiles = Get-FilesRecursively -BasePath $studentRepo | ForEach-Object { $_.Substring($studentRepo.Length + 1) }

# Copy or update files
foreach ($relPath in $classFiles) {
    $classPath = Join-Path $classRepo $relPath
    $studentPath = Join-Path $studentRepo $relPath
    $studentDir = Split-Path $studentPath

    if (-not (Test-Path $studentDir)) { New-Item -ItemType Directory -Force -Path $studentDir | Out-Null }

    if (-not (Test-Path $studentPath)) {
        Copy-Item -Force $classPath $studentPath
    } else {
        $hashClass = Get-FileHash $classPath
        $hashStudent = Get-FileHash $studentPath
        if ($hashClass.Hash -ne $hashStudent.Hash) {
            $ext = [System.IO.Path]::GetExtension($studentPath)
            $base = [System.IO.Path]::GetFileNameWithoutExtension($studentPath)
            $backup = Join-Path $studentDir ("{0}.studentcopy.{1}{2}" -f $base, $today, $ext)
            $counter = 1
            while (Test-Path $backup) {
                $backup = Join-Path $studentDir ("{0}.studentcopy.{1}_{2}{3}" -f $base, $today, $counter, $ext)
                $counter++
            }
            Rename-Item -Path $studentPath -NewName (Split-Path $backup -Leaf)
            $renamedFiles += (Resolve-Path $backup).Path
            Copy-Item -Force $classPath $studentPath
        }
    }
}

# Detect deletions
foreach ($relPath in $studentFiles) {
    $classPath = Join-Path $classRepo $relPath
    if (-not (Test-Path $classPath)) {
        $deletedFiles += (Join-Path $studentRepo $relPath)
    }
}

# ----------------------------------------------------------
# 8. Commit/push final updates
# ----------------------------------------------------------
Set-Location $studentRepo
git add . | Out-Null
git commit -m "Sync from class repo ($today)" 2>$null
git push origin main 2>$null

# ----------------------------------------------------------
# 9. Summary
# ----------------------------------------------------------
Write-Host ""
Write-Host "Sync Summary:" -ForegroundColor Cyan

if ($renamedFiles.Count -gt 0) {
    Write-Host "Files preserved as student backups:" -ForegroundColor Yellow
    $renamedFiles | ForEach-Object { Write-Host "   $_" -ForegroundColor Gray }
} else {
    Write-Host "No modified student files detected." -ForegroundColor Green
}

if ($deletedFiles.Count -gt 0) {
    Write-Host ""
    Write-Host "Files deleted in class repo (still in student repo):" -ForegroundColor Yellow
    $deletedFiles | ForEach-Object { Write-Host "   $_" -ForegroundColor Gray }
    Write-Host "Review these and remove manually if no longer needed."
} else {
    Write-Host "No deletions detected." -ForegroundColor Green
}

Write-Host ""
Write-Host "Sync complete. Student repo now includes all class updates." -ForegroundColor Green
Write-Host ""
Set-Location $root
