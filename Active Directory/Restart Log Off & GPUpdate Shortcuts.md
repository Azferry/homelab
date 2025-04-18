# Restart, Log Off & GPUpdate, Shortcuts on Windows Desktop

## Overview

This document provides an overview of creating and adding shortcuts for common administrative tasks such as restarting, logging off, and performing Group Policy updates (GPUpdate) on Windows machines. These shortcuts are designed to improve usability and efficiency for both server and client environments by offering quick access to essential system functions.

## Create Shortcuts Via GPO

1. Create a new GPO and link to ou
   
   ![GPO Menu Path](/.images/GPO_ShortcutPath.png)

2. Right-click > New shortcut
   
 ![GPO Menu Path](/.images/GPO_Shortcut_values.png)


## Values for Shortcuts

### GPUpdate
```
Action:      Replace
Name:        Group Policy Update
Target Type: File System Object
Location:    All Users Start Menu
Target:      %WindowsDir%\System32\cmd.exe
Arguments:   /c title Group Policy Update & gpupdate /force & pause
Start in:    %WindowsDir%\System32
Icon file path: %SystemRoot%\System32\SHELL32.dll
Icon index:  46
```

### Restart Shortcut

```
Action:      Replace
Name:        Restart
Target Type: File System Object
Location:    All Users Desktop
Target:      shutdown.exe -r -t 00
Arguments:   
Start in:    %WindowsDir%\System32
Icon file path: %SystemRoot%\System32\SHELL32.dll
Icon index:  215 or 27
```

### Logoff Shortcut

```
Action:      Replace
Name:        Logoff
Target Type: File System Object
Location:    All Users Desktop
Target:      C:\Windows\System32\logoff.exe or C:\Windows\System32\Shutdown.exe -L 
Arguments:   
Start in:    %WindowsDir%\System32
Icon file path: %SystemRoot%\System32\SHELL32.dll
Icon index:  211 or 44
```
