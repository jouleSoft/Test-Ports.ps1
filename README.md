<!-- start project-info -->
<!--
project_title: monitoriza-urls
github_project: https://github.com/atareao/monitoriza-urls
license: MIT
icon: /datos/Sync/Programacion/Python/monitoriza-urls/data/icons/binoculars.svg
homepage: https://www.atareao.es/tutorial/trabajando-con-systemd/monitoriza-urls
license-badge: True
contributors-badge: True
lastcommit-badge: True
codefactor-badge: True
--->
<!-- end project-info -->

<!-- start badges -->
![License MIT](https://img.shields.io/badge/license-MIT-green)
![Contributors](https://img.shields.io/github/contributors-anon/jouleSoft/Test-Ports.ps1)
![Last commit](https://img.shields.io/github/last-commit/jouleSoft/Test-Ports.ps1)
<!-- end badges -->

<!-- start description -->
<h1 align="center"><span id="project_title">Test-Ports.ps1</span></h1>
<p><span id="project_title">Test-Ports.ps1</span> is a PowerShell script for monitoring a predefined TCP port list.</p>
<!-- end description -->

<!-- start prerequisites -->
## Prerequisites
PowerShell **Desktop** (Windows PowerShell 2.0+) or **Core** editions.
<!-- end prerequisites -->

<!-- start examples -->
## Examples
### Check a single target computer

``` 
PS > Test-Ports.ps1 -ComputerName 172.16.0.2
Test-Ports.ps1 v.1.1 - PowerShell TCP ports monitoring tool (MIT)

Host/IP     RDP WinRM VNC HTTP
-------     --- ----- --- ----
172.16.0.2  OK    OK   !   !
```

### Check a list of targets 

``` 
PS > Test-Ports.ps1 -ComputerName $(Get-Content .\List.txt) 
Test-Ports.ps1 v.1.1 - PowerShell TCP ports monitoring tool (MIT)

Host/IP     RDP WinRM VNC HTTP
-------     --- ----- --- ----
172.16.0.2  OK    OK   !   !
172.16.0.3  OK    !    !   !
172.16.0.4  !     !    !   !
172.16.0.5  !     !    OK  !
```
<!-- end examples -->
