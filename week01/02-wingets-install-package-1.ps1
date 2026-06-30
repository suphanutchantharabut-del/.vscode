# winstall-NAPLAB2025.ps1 - Interactive Winget Installer (Enhanced Visual Edition)
# Description: Custom installer with Basic, Package, and Advance modes.

# --- Styling & Colors ---
$Esc = [char]27
$Style = @{
    Reset      = "$Esc[0m"
    Bold       = "$Esc[1m"
    Underline  = "$Esc[4m"
    Cyan       = "$Esc[36m"
    Green      = "$Esc[32m"
    Yellow     = "$Esc[33m"
    Magenta    = "$Esc[35m"
    Red        = "$Esc[31m"
    Gray       = "$Esc[90m"
    White      = "$Esc[97m"
    BgBlue     = "$Esc[44m"
}

function Show-Banner {
    Clear-Host
    Write-Host "$($Style.Bold)$($Style.Cyan)"
    Write-Host "  ███╗   ██╗ █████╗ ██████╗ ██╗      █████╗ ██████╗ "
    Write-Host "  ████╗  ██║██╔══██╗██╔══██╗██║     ██╔══██╗██╔══██╗"
    Write-Host "  ██╔██╗ ██║███████║██████╔╝██║     ███████║██████╔╝"
    Write-Host "  ██║╚██╗██║██╔══██║██╔═══╝ ██║     ██╔══██║██╔══██╗"
    Write-Host "  ██║ ╚████║██║  ██║██║     ███████╗██║  ██║██████╔╝"
    Write-Host "  ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝╚═════╝ "
    Write-Host "                                                    "
    Write-Host "        WINSTALL - NAPLAB GAME STUDIO 2026          "
    Write-Host "   Automated Software Provisioning & Agentic Tools  "
    Write-Host "$($Style.Reset)"
}

function Write-Info { param([string]$msg) Write-Host "$($Style.Cyan)[i] $msg$($Style.Reset)" }
function Write-Success { param([string]$msg) Write-Host "$($Style.Green)[√] $msg$($Style.Reset)" }
function Write-Warning { param([string]$msg) Write-Host "$($Style.Yellow)[!] $msg$($Style.Reset)" }
function Write-ErrorMsg { param([string]$msg) Write-Host "$($Style.Red)[X] $msg$($Style.Reset)" }
function Write-Section { param([string]$title) 
    Write-Host "`n$($Style.Bold)$($Style.Underline)$($Style.White)$title$($Style.Reset)" 
}

# --- Software List ---
$softwareList = @(
    # Basic Programming
    @{ ID = "Microsoft.WindowsTerminal"; Name = "Windows Terminal";                 Category = "Basic Programming"; Basic = $true },
    @{ ID = "Microsoft.PowerShell"; Name = "PowerShell";                            Category = "Basic Programming"; Basic = $true },
    @{ ID = "JanDeDobbeleer.OhMyPosh"; Name = "Oh My Posh";                         Category = "Basic Programming"; Basic = $true },

    # Dev Tools (Version Control)
    @{ ID = "Git.Git"; Name = "Git";                                                Category = "Version Control"; Basic = $true },
    @{ ID = "GitHub.GitLFS"; Name = "Git LFS";                                      Category = "Version Control"; Basic = $true },
    @{ ID = "Fork.Fork"; Name = "Fork (Git Client)";                                Category = "Version Control"; Basic = $true },

    # Dev IDE
    @{ ID = "Microsoft.VisualStudioCode"; Name = "VS Code";                         Category = "Integrated Development Environment (IDE)"; Basic = $true },
    @{ ID = "Microsoft.VisualStudio.2022.Community"; Name = "VS 2022 Community";    Category = "Integrated Development Environment (IDE)"; Basic = $false },
    @{ ID = "JetBrains.Toolbox"; Name = "JetBrains Toolbox";                        Category = "Integrated Development Environment (IDE)"; Basic = $false },
    @{ ID = "Unity.UnityHub"; Name = "Unity Hub";                                   Category = "Game Engine"; Basic = $false },
    @{ ID = "EpicGames.EpicGamesLauncher"; Name = "Epic Games Launcher";            Category = "Game Engine"; Basic = $false },
    @{ ID = "GodotEngine.GodotEngine"; Name = "Godot Engine";		            Category = "Game Engine"; Basic = $false },

    # Dev Library
    @{ ID = "Oracle.JDK.17"; Name = "Java(TM) SE Development Kit 17";          	    Category = "Software Development Kit (SDK)"; Basic = $false },
    @{ ID = "Microsoft.DotNet.SDK.9"; Name = ".NET SDK 9";          		    Category = "Software Development Kit (SDK)"; Basic = $false },
    @{ ID = "Python.Python.3.12"; Name = "Python 3.12";          		    Category = "Software Development Kit (SDK)"; Basic = $false },
    @{ ID = "OpenJS.NodeJS"; Name = "Node.js (LTS)";                                Category = "Software Development Kit (SDK)"; Basic = $true },
    @{ ID = "Apache.Maven"; Name = "Maven";             		            Category = "Package Utility"; Basic = $false },
    @{ ID = "Chocolatey.Chocolatey"; Name = "Chocolatey";                           Category = "Package Utility"; Basic = $false },

    # Dev Virtual Environment
    @{ ID = "Docker.DockerDesktop"; Name = "Docker Desktop";                        Category = "Virturl Environment (VM)"; Basic = $false },

    # Document & Production
    @{ ID = "Microsoft.Office"; Name = "Microsoft Office";                          Category = "Document"; Basic = $false },
    @{ ID = "c3er.mdview"; Name = "Markdown View";				    Category = "Document"; Basic = $true },
    @{ ID = "Obsidian.Obsidian"; Name = "Obsidian";                                 Category = "Document"; Basic = $true },
    @{ ID = "Notion.Notion"; Name = "Notion";                                       Category = "Document"; Basic = $false },    
    @{ ID = "Grammarly.Grammarly.Office"; Name = "Grammarly for Office";            Category = "Document"; Basic = $false },
    @{ ID = "JohnMacFarlane.Pandoc"; Name = "Pandoc";           		    Category = "Document"; Basic = $false },
    @{ ID = "MiKTeX.MiKTeX"; Name = "MiKTeX (LaTeX)";                               Category = "Document"; Basic = $false },

    # Google services
    @{ ID = "Google.Chrome"; Name = "Google Chrome";                                Category = "Cloud Service"; Basic = $false },
    @{ ID = "Google.GoogleDrive"; Name = "Google Drive";                            Category = "Cloud Service"; Basic = $false },

    # Communication
    @{ ID = "Microsoft.Teams"; Name = "Microsoft Teams";                            Category = "Communication"; Basic = $false },
    @{ ID = "Zoom.Zoom"; Name = "Zoom";                                             Category = "Communication"; Basic = $false },
    @{ ID = "Discord.Discord"; Name = "Discord";                                    Category = "Communication"; Basic = $false },
    @{ ID = "ByteDance.Lark"; Name = "Lark";                                        Category = "Communication"; Basic = $false },
    @{ ID = "Google.ChromeRemoteDesktop"; Name = "Chrome Remote Desktop";           Category = "Remote"; Basic = $false },
    @{ ID = "Parsec.Parsec"; Name = "Parsec";                                       Category = "Remote"; Basic = $false },
    @{ ID = "AnyDeskSoftwareGmbH.AnyDesk"; Name = "AnyDesk";                        Category = "Remote"; Basic = $false },

    # Gaming
    @{ ID = "Valve.Steam"; Name = "Steam";                                          Category = "Gaming"; Basic = $false },

    # Utility
    @{ ID = "Microsoft.PowerToys"; Name = "PowerToys";                              Category = "Utility"; Basic = $true },
    @{ ID = "VideoLAN.VLC"; Name = "VLC Media Player";                              Category = "Utility"; Basic = $true },
    @{ ID = "7zip.7zip"; Name = "7-Zip";                                            Category = "Utility"; Basic = $true },
    @{ ID = "qBittorrent.qBittorrent"; Name = "qBittorrent";                        Category = "Utility"; Basic = $false },
    @{ ID = "Google.QuickShare"; Name = "Google Quick Share";                       Category = "Utility"; Basic = $false },

    # Creative
    @{ ID = "OBSProject.OBSStudio"; Name = "OBS Studio";                            Category = "Creative"; Basic = $false },
    @{ ID = "Meltytech.Shotcut"; Name = "Shotcut Video Editor";                     Category = "Creative"; Basic = $false },
    @{ ID = "GIMP.GIMP"; Name = "GIMP";                                             Category = "Creative"; Basic = $false },
    @{ ID = "Inkscape.Inkscape"; Name = "Inkscape";                                 Category = "Creative"; Basic = $false },
    @{ ID = "BlenderFoundation.Blender"; Name = "Blender";                          Category = "Creative"; Basic = $false },

    # Agentic AI
    @{ ID = "ElementLabs.LMStudio";  Name = "LMStudio";                             Category = "Agentic AI"; Basic = $false },
    @{ ID = "Google.Antigravity";    Name = "Google Antigravity";                   Category = "Agentic AI"; Basic = $false },
    @{ ID = "Google.AntigravityCLI"; Name = "Antigravity CLI";                   Category = "Agentic AI"; Basic = $false },
    @{ ID = "Google.AntigravityIDE"; Name = "Google Antigravity IDE";               Category = "Agentic AI"; Basic = $false },
    @{ ID = "Anthropic.Claude"; Name = "Claude Desktop";                            Category = "Agentic AI"; Basic = $false },
    @{ ID = "Anthropic.ClaudeCode"; Name = "Claude Code";                           Category = "Agentic AI"; Basic = $false },
    @{ ID = "Anysphere.Cursor";    Name = "Cursor";                                 Category = "Agentic AI"; Basic = $false },
    @{ ID = "Zed.Zed"; Name = "Zed";                                                Category = "Agentic AI"; Basic = $false },
    @{ ID = "Block.Goose";         Name = "Goose AI";                               Category = "Agentic AI"; Basic = $false },
    @{ ID = "Hotovo.AiderDesk";    Name = "AiderDesk";                              Category = "Agentic AI"; Basic = $false },
    @{ ID = "MBrassey.agtop";      Name = "agtop (AI Agent Monitor)";               Category = "Agentic AI"; Basic = $false },

    # Agentic AI (NPM)
    @{ ID = "@google/gemini-cli";  Name = "Gemini CLI";                             Category = "Agentic AI (NPM)"; Basic = $false; Type = "NPM" },
    @{ ID = "@github/copilot";     Name = "GitHub Copilot CLI";                     Category = "Agentic AI (NPM)"; Basic = $false; Type = "NPM" },
    @{ ID = "opencode-ai";         Name = "OpenCode AI";                            Category = "Agentic AI (NPM)"; Basic = $false; Type = "NPM" },
    @{ ID = "@gitlawb/openclaude"; Name = "OpenClaude CLI";                         Category = "Agentic AI (NPM)"; Basic = $false; Type = "NPM" },
    @{ ID = "@openai/codex"; 	   Name = "Codex CLI";                              Category = "Agentic AI (NPM)"; Basic = $false; Type = "NPM" },
    @{ ID = "@kilocode/cli";       Name = "Kilo Code CLI";                          Category = "Agentic AI (NPM)"; Basic = $false; Type = "NPM" },
    @{ ID = "@judeotine/agentic-cli"; Name = "Agentic CLI";                         Category = "Agentic AI (NPM)"; Basic = $false; Type = "NPM" },
    @{ ID = "v0";                  Name = "Vercel v0 CLI";                          Category = "Agentic AI (NPM)"; Basic = $false; Type = "NPM" },
    @{ ID = "@ai-code-agents/cli"; Name = "AI Code Agents CLI";                     Category = "Agentic AI (NPM)"; Basic = $false; Type = "NPM" }
)

# --- Functions ---
function Install-Winget {
    param([string]$id)
    Write-Info "Installing via Winget: $($Style.White)$id$($Style.Reset) ..."
    winget install --id=$id -e --accept-package-agreements --accept-source-agreements
}

# --- Main Logic ---
Show-Banner

Write-Host "Select your installation mode:"
Write-Host "  $($Style.Cyan)1.$($Style.Reset) $($Style.Bold)Basic$($Style.Reset)   - Essential tools selection"
Write-Host "  $($Style.Cyan)2.$($Style.Reset) $($Style.Bold)Package$($Style.Reset) - Categorized installation"
Write-Host "  $($Style.Cyan)3.$($Style.Reset) $($Style.Bold)Custom$($Style.Reset)  - Select by index number"
Write-Host "  $($Style.Red)Q.$($Style.Reset) $($Style.Bold)Quit$($Style.Reset)"
Write-Host ""
$choice = Read-Host "Mode"

$toInstall = @()

switch ($choice) {
    "1" {
        Show-Banner
        Write-Section "MODE: BASIC SELECTION"
        $basicApps = @()
        for ($i = 0; $i -lt $softwareList.Count; $i++) {
            if ($softwareList[$i].Basic -eq $true) {
                $basicApps += @{ Index = $i; App = $softwareList[$i] }
                $idxStr = ($i + 1).ToString().PadLeft(3)
                Write-Host "  $($Style.Cyan)$idxStr.$($Style.Reset) $($softwareList[$i].Name.PadRight(35)) $($Style.Gray)[$($softwareList[$i].Category)]$($Style.Reset)"
            }
        }
        
        Write-Host "`n$($Style.Gray)Enter numbers separated by spaces, or press Enter for ALL$($Style.Reset)"
        $userInput = Read-Host "Select"
        if ([string]::IsNullOrWhiteSpace($userInput)) {
            $toInstall = $basicApps | ForEach-Object { $_.App }
        } else {
            $indices = $userInput -split '\s+' | ForEach-Object { $_.Trim() }
            foreach ($idx in $indices) {
                if ([string]::IsNullOrWhiteSpace($idx)) { continue }
                $val = 0
                if ([int]::TryParse($idx, [ref]$val)) {
                    $match = $basicApps | Where-Object { ($_.Index + 1) -eq $val }
                    if ($match) { $toInstall += $match.App }
                }
            }
        }
    }
    "2" {
        Show-Banner
        Write-Section "MODE: CATEGORY SELECTION"
        $categories = $softwareList.Category | Select-Object -Unique
        for ($i = 0; $i -lt $categories.Count; $i++) {
            $cat = $categories[$i]
            $appsInCat = $softwareList | Where-Object { $_.Category -eq $cat }
            $appNames = ($appsInCat.Name -join ", ")
            
            # Truncate if too long for preview
            if ($appNames.Length -gt 60) { $appNames = $appNames.Substring(0, 57) + "..." }
            
            $idxStr = ($i + 1).ToString().PadLeft(3)
            Write-Host "  $($Style.Cyan)$idxStr.$($Style.Reset) $($cat.PadRight(40)) $($Style.Gray)($appNames)$($Style.Reset)"
        }
        
        Write-Host "`n$($Style.Gray)Enter category numbers separated by spaces (e.g., 1 3)$($Style.Reset)"
        $catInput = Read-Host "Select Categories"
        
        if (-not [string]::IsNullOrWhiteSpace($catInput)) {
            $catIndices = $catInput -split '\s+' | ForEach-Object { $_.Trim() }
            foreach ($idx in $catIndices) {
                $val = 0
                if ([int]::TryParse($idx, [ref]$val) -and $val -ge 1 -and $val -le $categories.Count) {
                    $cat = $categories[$val - 1]
                    $appsInCat = $softwareList | Where-Object { $_.Category -eq $cat }
                    
                    Write-Host "`n$($Style.BgBlue)$($Style.White)  CATEGORY: $cat  $($Style.Reset)"
                    for ($j = 0; $j -lt $appsInCat.Count; $j++) {
                        $appIdx = ($j + 1).ToString().PadLeft(3)
                        Write-Host "    $($Style.Cyan)$appIdx.$($Style.Reset) $($appsInCat[$j].Name)"
                    }
                    
                    Write-Host "`n$($Style.Gray)Enter numbers separated by spaces, or press Enter for ALL (Type 'n' to skip)$($Style.Reset)"
                    $selInput = Read-Host "Select from $cat"
                    
                    if ([string]::IsNullOrWhiteSpace($selInput)) {
                        $toInstall += $appsInCat
                    } elseif ($selInput -eq 'n') {
                        # Skip
                    } else {
                        $selIndices = $selInput -split '\s+' | ForEach-Object { $_.Trim() }
                        foreach ($sIdx in $selIndices) {
                            $sVal = 0
                            if ([int]::TryParse($sIdx, [ref]$sVal) -and $sVal -ge 1 -and $sVal -le $appsInCat.Count) {
                                $toInstall += $appsInCat[$sVal - 1]
                            }
                        }
                    }
                }
            }
        }
    }
    "3" {
        Show-Banner
        Write-Section "MODE: CUSTOM SELECTION"
        for ($i = 0; $i -lt $softwareList.Count; $i++) {
            $idxStr = ($i + 1).ToString().PadLeft(3)
            $catPrefix = "$($Style.Gray)[$($softwareList[$i].Category)]$($Style.Reset)"
            Write-Host "  $($Style.Cyan)$idxStr.$($Style.Reset) $($softwareList[$i].Name.PadRight(35)) $catPrefix"
        }
        Write-Host "`n$($Style.Gray)Enter numbers separated by spaces (e.g., 1 3 10)$($Style.Reset)"
        $userInput = Read-Host "Select"
        if (-not [string]::IsNullOrWhiteSpace($userInput)) {
            $indices = $userInput -split '\s+' | ForEach-Object { $_.Trim() }
            foreach ($idx in $indices) {
                if ([string]::IsNullOrWhiteSpace($idx)) { continue }
                $val = 0
                if ([int]::TryParse($idx, [ref]$val) -and $val -ge 1 -and $val -le $softwareList.Count) {
                    $toInstall += $softwareList[$val - 1]
                }
            }
        }
    }
    "Q" { exit }
    "q" { exit }
    Default { Write-Warning "Invalid choice. Exiting."; exit }
}

# Execution
if ($toInstall.Count -gt 0) {
    Write-Section "INSTALLATION SUMMARY"
    $toInstall | ForEach-Object { Write-Host " $($Style.Green)»$($Style.Reset) $($_.Name)" }
    
    $confirm = Read-Host "`nProceed with installation? (y/n)"
    if ($confirm -eq 'y') {
        Write-Host "`n$($Style.Bold)$($Style.Green)Starting installation of $($toInstall.Count) items...$($Style.Reset)`n"
        
        $npmItems = $toInstall | Where-Object { $_.Type -eq "NPM" }
        $wingetItems = $toInstall | Where-Object { $_.Type -ne "NPM" }

        # 1. Install Winget Packages
        foreach ($app in $wingetItems) {
            Install-Winget -id $app.ID
        }

        # 2. Install NPM Packages if any selected
        if ($npmItems.Count -gt 0) {
            if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
                Write-Warning "Node.js/NPM not detected. Installing Node.js (LTS) first..."
                Install-Winget -id "OpenJS.NodeJS"
                Write-Info "Refreshing environment PATH..."
                $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
            }

            if (Get-Command npm -ErrorAction SilentlyContinue) {
                Write-Section "GLOBAL NPM PACKAGES"
                foreach ($pkg in $npmItems) {
                    Write-Info "Installing $($Style.White)$($pkg.Name)$($Style.Reset) ($($pkg.ID))..."
                    npm install -g $($pkg.ID)
                }
            } else {
                Write-ErrorMsg "Node.js was installed but 'npm' command is still not recognized in this session."
                Write-Warning "Please restart your terminal and run the script again for NPM packages."
            }
        }
        Write-Success "All processes completed successfully!"
    } else {
        Write-Warning "Installation cancelled by user."
    }
} else {
    Write-Warning "No software selected."
}

Write-Host "`n$($Style.Bold)Press any key to exit...$($Style.Reset)"
[void][System.Console]::ReadKey($true)
