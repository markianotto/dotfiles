# Script Name: Setup-Dotfiles.ps1

param (
    [string]$RepoPath
)

function Create-LinkWithBackup {
    param (
        [string]$DestFile,
        [string]$SourceFile
    )

    $Filename = Split-Path $DestFile -Leaf
    Write-Host "+++CreateLinkWithBackup"
    Write-Host "+++CreateLinkWithBackup::SOURCE_FILE: $SourceFile"
    Write-Host "+++CreateLinkWithBackup::DEST_FILE: $DestFile"

    if (Test-Path $DestFile) {
        # Check if it's a symbolic link
        $attributes = (Get-Item $DestFile -Force).Attributes
        if ($attributes -band [System.IO.FileAttributes]::ReparsePoint) {
            # It's a symbolic link
            $LinkTarget = (Get-Item $DestFile -Force).Target

            if ($LinkTarget -eq $SourceFile) {
                Write-Host "The symbolic link for $Filename is already correct."
                return
            } else {
                Write-Warning "Existing symbolic link for $Filename points to a different target. Removing it."
                Remove-Item $DestFile -Force
            }
        } else {
            # Not a symbolic link, rename it
            $BackupFile = "$DestFile.auto_softlink.bak"
            Rename-Item $DestFile $BackupFile -Force
            Write-Host "Existing file renamed to $BackupFile"
        }
    }

    # Create the symbolic link
    try {
        New-Item -Path $DestFile -ItemType SymbolicLink -Value $SourceFile -Force | Out-Null
        Write-Host "Symbolic link created for $Filename"
    } catch {
        Write-Error "Failed to create symbolic link for $Filename"
        Write-Error "DEST_FILE: $DestFile"
        Write-Error "SOURCE_FILE: $SourceFile"
        exit 1
    }
}

# Main script starts here
# Check if the RepoPath parameter is provided
if (-not $RepoPath) {
    # No parameter provided, check if the current directory is a Git repo named "dotfiles"
    try {
        $RepoPath = git rev-parse --show-toplevel 2>$null
        if (-not $RepoPath) {
            Write-Error "Please provide the path to the Git repository, or run this script from within a 'dotfiles' Git repository."
            exit 1
        }

        # Check if the repository path ends with "dotfiles"
        $RepoName = Split-Path $RepoPath -Leaf
        if ($RepoName -ne "dotfiles") {
            Write-Error "The Git repository is not named 'dotfiles'."
            exit 1
        }
    } catch {
        Write-Error "Please provide the path to the Git repository, or run this script from within a 'dotfiles' Git repository."
        exit 1
    }
}

# Set the destination folder paths
$DestFolderVSCode = "$env:USERPROFILE\AppData\Roaming\Code\User"
$DestFolderStarship = "$env:USERPROFILE\.config"

# Check if the repository paths exist
if (-not (Test-Path "$RepoPath\vscode")) {
    Write-Error "The folder $RepoPath\vscode does not exist."
    exit 1
}

if (-not (Test-Path "$RepoPath\starship")) {
    Write-Error "The folder $RepoPath\starship does not exist."
    exit 1
}

# Create directories if they don't exist
if (-not (Test-Path $DestFolderVSCode)) {
    New-Item -Path $DestFolderVSCode -ItemType Directory -Force | Out-Null
}

if (-not (Test-Path $DestFolderStarship)) {
    New-Item -Path $DestFolderStarship -ItemType Directory -Force | Out-Null
}

# For debugging: Display variable values before function calls
Write-Host "REPO_PATH: $RepoPath"
Write-Host "DEST_FOLDER_VSCODE: $DestFolderVSCode"
Write-Host "DEST_FOLDER_STARSHIP: $DestFolderStarship"

# Create symbolic links for VSCode configuration files with backup and verification
Create-LinkWithBackup "$DestFolderVSCode\keybindings.json" "$RepoPath\vscode\keybindings.json"
Create-LinkWithBackup "$DestFolderVSCode\settings.json" "$RepoPath\vscode\settings.json"

# Create symbolic link for starship.toml with backup and verification
Create-LinkWithBackup "$DestFolderStarship\starship.toml" "$RepoPath\starship\starship.toml"

Write-Host "Symbolic links created successfully."
exit 0
