$ErrorActionPreference = "Stop"

# Install Vim, Python, and Node.js
winget install --id vim.vim --exact --source winget --accept-package-agreements --accept-source-agreements
winget install --id Python.Python.3.12 --exact --accept-package-agreements --accept-source-agreements
winget install --id OpenJS.NodeJS.LTS --exact --accept-package-agreements --accept-source-agreements
winget install --id Git.Git --exact --accept-package-agreements --accept-source-agreements

# Refresh PATH for this PowerShell session
$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
            [Environment]::GetEnvironmentVariable("Path", "User")

# Find Vim on PATH
$vimExe = (Get-Command vim.exe -ErrorAction SilentlyContinue).Source

# Check Windows App Paths registry entries
if (-not $vimExe) {
    $appPaths = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\vim.exe",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\vim.exe",
        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\vim.exe"
    )

    foreach ($key in $appPaths) {
        if (Test-Path $key) {
            $candidate = (Get-Item $key).GetValue("")
            if ($candidate -and (Test-Path $candidate)) {
                $vimExe = $candidate
                break
            }
        }
    }
}

# Search common install locations
if (-not $vimExe) {
    $searchRoots = @(
        "$env:ProgramFiles\Vim",
        "${env:ProgramFiles(x86)}\Vim",
        "$env:LOCALAPPDATA\Programs\Vim",
        "C:\tools\vim"
    ) | Where-Object { $_ -and (Test-Path $_) }

    foreach ($root in $searchRoots) {
        $match = Get-ChildItem -Path $root -Filter vim.exe -File -Recurse `
            -ErrorAction SilentlyContinue | Select-Object -First 1

        if ($match) {
            $vimExe = $match.FullName
            break
        }
    }
}

if (-not $vimExe) {
    throw "Vim is installed but its vim.exe wasn't found in the checked locations. Add the folder containing vim.exe to PATH, then rerun the script."
}

# Install Yarn and allow its install script
npm config set allow-scripts=yarn --location=user
npm install --global yarn

# Install vim-plug
$plugDir = Join-Path $HOME "vimfiles\autoload"
New-Item -ItemType Directory -Force -Path $plugDir | Out-Null

Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" `
    -OutFile (Join-Path $plugDir "plug.vim")

# Copy .vimrc to Vim's Windows configuration path
$vimrc = Join-Path $PSScriptRoot ".vimrc"
if (-not (Test-Path $vimrc)) {
    throw "Could not find .vimrc beside this script: $vimrc"
}
Copy-Item -Path $vimrc -Destination (Join-Path $HOME "_vimrc") -Force

# Install plugins, then Coc's Python extension
& $vimExe -c "PlugInstall" -c "qa"
if ($LASTEXITCODE -ne 0) {
    throw "Vim plugin installation failed."
}

& $vimExe -c "CocInstall coc-pyright" -c "qa"
if ($LASTEXITCODE -ne 0) {
    throw "Coc extension installation failed."
}

Write-Host "Vim setup complete!"
