# Windows Migration Guide
1. Install 'Terminal Preview',  'wsl' and 'arch wsl' over Windows Store.
   - Activate wsl: search for "Windows Features" in windows menu 
   - assure that "Windows Subsystem for Windows" checkbox is checked.
   - restart computer `shutdown /s /f /t 0`
2. install wsl
   - install wsl over Microsoft store
   - enable hyper-v: 
      - run in powershell: `Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All`,
      - or run in CMD: `DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V`,
      - or [follow this guide](https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v#enable-hyper-v-using-powershell).
   - enable linux subsystem
   - assure all windows updates are installed
   - run `wsl -v` if you're on 1 then run `wsl --install`
   - [download & install Arch](https://github.com/yuk7/ArchWSL)
      - download & extract, run Arch.exe, install arch and run Arch.exe again.
      - as super user run: `pacman-key --init && pacman-key --populate && pacman -Sy archlinux-keyring && pacman -Su`.
2. [Install chocolatey](https://chocolatey.org/install)
3. run the following script to install some common apps:
```
choco install 7zip androidstudio filezilla firefox git gimp irfanview krita nodejs openvpn procexp python ruby sumatrapdf sql-server-management-studio vlc vscode -y
```
3. b) Manually install KeepassXC from web installer. Google it.
4. Manually install Visual Studio 2019, 2022 and other versions as needed.
   - Go to Extensions in top menu, install the "Hide Main Menu" extension
   - Copy `visual_studio_2022/CurrentSettings.vssettings` into `C:\Users\<USER_NAME>\AppData\Local\Microsoft\VisualStudio\<VERSION_NUMBER>.0_<VERSION_HASH>\Settings`
   - Import `visual_studio_2022/CurrentSettings.vssettings` in Visual Studio 2022:
      - press the Windows Key and type: `Developer Command Prompt for VS 2022`.
      - execute the command in this shell: `Tools.ImportandExportSettings /import:Z:\code\dotfiles\visual_studio_2022\CurrentSettings.vssettings`.
6. Copy over ssh keys from `/home/<USER_NAME>/.ssh` and `C:\Users\<USER_NAME>\.ssh`.
7. Copy Z folder. 
   - mount the network drive `sudo mount -t cifs //server/share /mnt/mountpoint -o username=your_username,password=your_password`
   - or, copy via rsync and ssh
   - Add Folder Icons, add folders to `Quick access` in File Explorer.
   - bfg, procexp, java SDKs and stuff should be located in `Z:\bin`
   - keepass database located in `Z:\data`
8. install apps in Linux WSL
   - sudo pacman -Syu ranger fish apt nvim ruby python git
   - [install gitui](https://github.com/extrawurst/gitui/releases)
   - [copy dot-files](https://github.com/markianotto/dotfiles)
10. install VS-Code extensions
   - sym-link VS Code config (from step **8.2**)
   - [manually install Paddy Theme (Mist, Eucalyptus)](https://marketplace.visualstudio.com/items?itemName=yile-ou.paddy-color-theme)
      - click on "Download Extension" on the right side of the page, under Resources.
      - open control panel and type "VSIX" to select and install the downloaded extension.
   - install Extensions using UI:
   ```
      .NET Runtime Install Tool
      Bookmarks
      Bracket Peek
      C/C++
      C#
      CamelCase
      CMake Highlight
      Copy file name
      CSharpier - Code Formatter
      Font Awesome Auto-complete
      Hex Editor
      JSON formatter
      Markdown PDF
      Marp for VS Code
      Pylance
      Python
      SFTP
      TODO Highlight
      Todo Tree
      UMLet
      vscode-base64
      Vue Language Features (Volar)
      XML
      XML Tools
   ```
11. make a link to `aladmin_starter.exe` in `C:\ProgramData\Microsoft\Windows\Start Menu\Programs`. This launches alacritty as an administrator. Making a similar link to alacritty.exe for some reason conflicts with the normal alacritty shortcut.

12. rename `Alacritty/Alacritty.lnk` to `aluser.lnk`, makes it easier to type.
