# Install Vim, Python, and Node.js
winget install --id Vim.Vim --exact --accept-package-agreements --accept-source-agreements
winget install --id Python.Python.3.12 --exact --accept-package-agreements --accept-source-agreements
winget install --id OpenJS.NodeJS.LTS --exact --accept-package-agreements --accept-source-agreements

# Refresh PATH for this session (open a new PowerShell window if commands still aren't found)
$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
            [Environment]::GetEnvironmentVariable("Path", "User")

# Install Yarn
npm install --global yarn

# Install vim-plug
$plugDir = Join-Path $HOME "vimfiles\autoload"
New-Item -ItemType Directory -Force -Path $plugDir | Out-Null
Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" `
    -OutFile (Join-Path $plugDir "plug.vim")

# Copy .vimrc to Vim's Windows configuration path
Copy-Item -Path ".\.vimrc" -Destination (Join-Path $HOME "_vimrc") -Force

# Install plugins and the Coc extension
vim -c "PlugInstall" -c "qa"
vim -c "CocInstall coc-pyright" -c "qa"

Write-Host "Vim setup complete!"
