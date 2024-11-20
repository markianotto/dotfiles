@echo off
setlocal enabledelayedexpansion

:: Check if a parameter for the Git repository path is provided
if "%~1"=="" (
    echo Error: Please provide the path to the Git repository.
    exit /b 1
)

:: Set the repository path
set REPO_PATH=%~1

:: Set the destination folder path
set DEST_FOLDER=C:\Users\%USERNAME%\AppData\Roaming\Code\User

:: Check if the repository path exists
if not exist "%REPO_PATH%\vscode\" (
    echo Error: The folder %REPO_PATH%\vscode\ does not exist.
    exit /b 1
)

if exist "%DEST_FOLDER%\keybindings.json" (
    echo Link already exists: "%DEST_FOLDER%\keybindings.json"
    echo Deleting existing link...
    del "%DEST_FOLDER%\keybindings.json"
)

:: Create symbolic links for keybindings.json and settings.json
mklink "%DEST_FOLDER%\keybindings.json" "%REPO_PATH%\vscode\keybindings.json"
if errorlevel 1 (
    echo Failed to create symbolic link for keybindings.json
    exit /b 1
)

if exist "%DEST_FOLDER%\settings.json" (
    echo Link already exists: "%DEST_FOLDER%\settings.json"
    echo Deleting existing link...
    del "%DEST_FOLDER%\settings.json"
)

mklink "%DEST_FOLDER%\settings.json" "%REPO_PATH%\vscode\settings.json"
if errorlevel 1 (
    echo Failed to create symbolic link for settings.json
    exit /b 1
)

set DEST_FOLDER_ALACRITTY=C:\Users\%USERNAME%\AppData\Roaming\alacritty

mkdir %DEST_FOLDER_ALACRITTY%

if not exist "%DEST_FOLDER_ALACRITTY%" (
    echo Failed to create the directory for alacritty.
    exit /b 1
)

if exist "%DEST_FOLDER_ALACRITTY%\alacritty.toml" (
    echo Link already exists: "%DEST_FOLDER_ALACRITTY%\alacritty.toml"
    echo Deleting existing link...
    del "%DEST_FOLDER_ALACRITTY%\alacritty.toml"
)

mklink "%DEST_FOLDER_ALACRITTY%\alacritty.toml" "%REPO_PATH%\alacritty\alacritty.toml"

echo Symbolic links created successfully.
exit /b 0