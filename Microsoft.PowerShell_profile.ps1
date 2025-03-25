$env:POWERSHELL_TELEMETRY_OPTOUT=1

#oh-my-posh init pwsh | Invoke-Expression
$env:VISUAL = "nvim"
$env:EDITOR = "nvim"

Invoke-Expression (&starship init powershell)

# only switch dirs if we are in the default starting dir.
if ($PWD.Path -ieq "C:\WINDOWS\system32" -or $PWD.Path -ieq "C:\Windows") {
    Set-Location "C:\code"
}

# ASP.NET Core Configuration ==================================================
$env:ASPNETCORE_ENVIRONMENT = "Development"
set REQUESTS_CA_BUNDLE=C:\cert\cacert_and_untangle_tw_root_authority.crt
# =============================================================================

# activates Visual Studio Developer Env variables in current session.
function vsdev { cmd /k "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat" }
function vsdev22 { cmd /k "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat" }
function vsdev19 { cmd /k "C:\Program Files\Microsoft Visual Studio\2019\Community\Common7\Tools\VsDevCmd.bat" }

#function vsdev { & "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\vsdevshell.bat" }


# Define the file to store directory keys
$StorageFile = "$HOME\directory_keys.json"

function sd {
    param (
        [string]$Key
    )

    # Get the current directory
    $CurrentDirectory = Get-Location

    # Ensure Ruby is installed
    if (-not (Get-Command ruby -ErrorAction SilentlyContinue)) {
        Write-Error "Ruby is not installed or not in PATH."
        return
    }

    # Call the Ruby script to save the directory
    try {
        ruby C:\code\SCRIPTS\sd.rb $Key $CurrentDirectory.Path $StorageFile | Out-String | ForEach-Object {
            Write-Host $_
        }
    } catch {
        Write-Error "Failed to execute Ruby script: $_"
    }
}

function go {
    param (
        [string]$Key
    )

    # Ensure Ruby is installed
    if (-not (Get-Command ruby -ErrorAction SilentlyContinue)) {
        Write-Error "Ruby is not installed or not in PATH."
        return
    }

    # Call the Ruby script and capture its output
    try {
        $TargetDirectory = ruby C:\code\SCRIPTS/sda.rb $Key $StorageFile | Out-String
        $TargetDirectory = $TargetDirectory.Trim()

        # Check if the Ruby script returned an error
        if ($TargetDirectory -match "^Error:") {
            Write-Error $TargetDirectory
            return
        }

        # Change to the target directory
        Set-Location $TargetDirectory
        Write-Host "Changed directory to '$TargetDirectory'."
    } catch {
        Write-Error "Failed to execute Ruby script: $_"
    }
}

function sha256sum {
    param (
        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )

    if (Test-Path $FilePath) {
        (Get-FileHash -Path $FilePath -Algorithm SHA256).Hash
    } else {
        Write-Host "Error: File '$FilePath' not found." -ForegroundColor Red
        exit 1
    }
}

if (Get-Command nvim -ErrorAction SilentlyContinue) {
   git config --global core.editor "nvim"
} else {
   Write-Error "You don't have neovim installed. You probably should do that."
}

function br {
  $args = $args -join ' '
  $cmd_file = New-TemporaryFile

  $process = Start-Process -FilePath 'C:/bin/broot.exe' `
                           -ArgumentList "--outcmd $($cmd_file.FullName) $args" `
                           -NoNewWindow -PassThru -WorkingDirectory $PWD

  Wait-Process -InputObject $process #Faster than Start-Process -Wait
  If ($process.ExitCode -eq 0) {
    $cmd = Get-Content $cmd_file
    Remove-Item $cmd_file
    If ($cmd -ne $null) { Invoke-Expression -Command $cmd }
  } Else {
    Remove-Item $cmd_file
    Write-Host "`n" # Newline to tidy up broot unexpected termination
    Write-Error "broot.exe exited with error code $($process.ExitCode)"
  }
}



function btop {
   C:\bin\btop4win\btop4win.exe
}

# Set-Alias -Name restart -Value Restart-Computer -Force
function restart {
   Restart-Computer -Force
}

function profile {
   & $env:EDITOR $PROFILE;
   . $PROFILE;
}

function vs {
   code ./
}

function sleepy {
   echo "HP ist ein Hurensohn."

   Add-Type -AssemblyName System.Windows.Forms
   # 1. Define the power state you wish to set, from the
   #    System.Windows.Forms.PowerState enumeration.
   $PowerState = [System.Windows.Forms.PowerState]::Suspend;

   # 2. Choose whether or not to force the power state
   $Force = $false;

   # 3. Choose whether or not to disable wake capabilities
   $DisableWake = $false;

   # Set the power state
   [System.Windows.Forms.Application]::SetSuspendState($PowerState, $Force, $DisableWake);
}

function pub {
   param (
      [Parameter(ValueFromRemainingArguments=$true)]
      [string[]]$args
   )
   .\pub.ps1 @args
}

function shutdown-now {
   shutdown /s /f /t 0
}

Set-Alias -Name la -Value ls
Set-Alias -Name al -Value ls

Set-Alias -Name dn -Value dotnet

function tail {
   Get-Content -Wait -Tail 20 @args
}

function las {
   Get-ChildItem | Select-Object Name, @{Name="Size (MB)"; Expression={[math]::Round($_.Length / 1MB, 2)}} | Format-Table -AutoSize
}

function sleep-now {
   #   Stop-Computer -ComputerName localhost -Force -Sleep
   rundll32.exe powrprof.dll,SetSuspendState 0,1,0
}

function dev {
   param(
      [string]$inputString
   )
   switch ($inputString) {
      "sync:devops" {
         cd 'C:\code\sync\sync-dev-ops';
         code ./;
         npm run electron:dev;
      }
      default {
         Write-Output "Input string is not recognized."
      }
   }
}

function explore {
   Start-Process explorer.exe -ArgumentList (Get-Location)
}
function exp {
   Start-Process explorer.exe -ArgumentList (Get-Location)
}

function vs19 {
   $slnFile = Get-ChildItem -Path (Get-Location) -Filter *.sln -Name
   if ($slnFile -ne $null -and $slnFile.Length -gt 0) {
      Start-Process "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\devenv.exe" $slnFile
   } else {
      Write-Host "No .sln file found in the current directory."
   }
}

function vs22 {
   $slnFile = Get-ChildItem -Path (Get-Location) -Filter *.sln -Name
   if ($slnFile -ne $null -and $slnFile.Length -gt 0) {
      Start-Process "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe" $slnFile
   } else {
      Write-Host "No .sln file found in the current directory."
   }
}

function admin-console {
   cd "C:\code\id-sentry-2\admin-console";
}

function api-server {
   cd "C:\code\id-sentry-2\api-server";
}

function photos {
    param (
        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )
    Start-Process "ms-photos://" -ArgumentList $FilePath
}


function total_lines {
   [CmdletBinding()]
   param(
      [string]$FilterExtensions,
      [string]$ExcludeFolders
   )

   # Split the comma-separated lists into arrays
   $extensionArray = $FilterExtensions -split ','
   $excludeFolderArray = $ExcludeFolders -split ',' | ForEach-Object { $_.Trim() }

   # Initialize a hashtable to store line counts for each extension
   $lineCounts = @{}

   foreach ($extension in $extensionArray) {
      # Ensure extension starts with a dot
      if (-not $extension.StartsWith('.')) {
         $extension = ".$extension"
      }

      # Search recursively for files with the current extension, excluding specified folders
      $files = Get-ChildItem -Recurse -File | Where-Object { $_.Extension -eq $extension -and -not ($excludeFolderArray -contains $_.Directory.Name) }

      foreach ($file in $files) {
         # Count the lines for each file
         $lineCount = (Get-Content $file.FullName | Measure-Object -Line).Lines

         # Add or update the line count for this extension in the hashtable
         if ($lineCounts.ContainsKey($extension)) {
            $lineCounts[$extension] += $lineCount
         } else {
            $lineCounts[$extension] = $lineCount
         }
      }
   }

   # Output the total lines per extension
   $lineCounts.GetEnumerator() | ForEach-Object {
      Write-Output "$($_.Key) files have a total of $($_.Value) lines"
   }
}

function base64_convert {
   param (
      [string]$filePath
   )
   try {
      # Ensure the file exists
      if (-not (Test-Path -Path $filePath -PathType Leaf)) {
         Write-Error "File does not exist."
         return
      }

      # Read the file as bytes
      $bytes = [System.IO.File]::ReadAllBytes($filePath)

      # Convert the bytes to a Base64 string
      $base64 = [Convert]::ToBase64String($bytes)

      # Print the Base64 string to stdout
      Write-Output $base64
   }
   catch {
      Write-Error "An error occurred: $_"
   }
}

function git-todos {
   param (
      [Parameter(Mandatory=$false)]
      [int]$NumCommits = 5
   )
   if (!(Get-Command git -ErrorAction SilentlyContinue)) {
      Write-Error "Git is not installed or not in the PATH."
      return
   }
   if (!(Test-Path .git)) {
      Write-Error "Current directory is not a git repository."
      return
   }
   $scriptPath = "C:\code\SCRIPTS\git_todo_finder.py"
   if (!(Test-Path $scriptPath)) {
      Write-Error "Python script not found at $scriptPath. Please ensure the script is in the correct location."
      return
   }
   try {
      $output = python $scriptPath $NumCommits
      if ($output) {
         $output | ForEach-Object {
            if ($_ -match '^(.+?):(\d+): (.+)$') {
               [PSCustomObject]@{
                  File = $Matches[1]
                  LineNumber = [int]$Matches[2]
                  Content = $Matches[3]
               }
            } else {
               $_  # Output any lines that don't match the expected format as-is
            }
         }
      } else {
         Write-Host "No TODOs found in the last $NumCommits commits."
      }
   } catch {
      Write-Error "An error occurred while executing the Python script: $_"
   }
}

function days-since-epoch {
   param (
      [Parameter(Mandatory=$true)]
      [string]$DateString
   )

   try {
      $date = [DateTime]::ParseExact($DateString, 'yyyy-MM-dd', $null)
   } catch {
      Write-Error "Invalid date format. Please provide the date in the format 'yyyy-MM-dd'."
      return
   }

   $epoch = [DateTime]::new(1970, 1, 1)
   $daysSinceEpoch = ($date - $epoch).Days

   return $daysSinceEpoch
}


# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
