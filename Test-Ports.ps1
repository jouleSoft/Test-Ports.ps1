#requires -version 2

<#
.SYNOPSIS
  Pre-Settle TCP ports monitoring tool

.DESCRIPTION
  PowerShell script for monitoring a Pre-settled TCP port list

.PARAMETER ComputerName
  Mandatory. Target hostname or IP address
  
.INPUTS
  Parameter above

.OUTPUTS
  Table of results

.NOTES
  GitHub repo:      https://github.com/jouleSoft/TestPorts.ps1
  License:          The MIT License (MIT)
                    Copyright (c) 2020 Julio Jiménez Delgado (jouleSoft)
  PS Edition:       Core, Desktop
  Template:         https://gist.github.com/jouleSoft/b10ede4ff3ef47122f9041a3f205c245
  --
  Version:          1.0
  Author:           Julio Jimenez Delgado (jouleSoft)
  Creation Date:    14/05/2020
  Change:           Initial script development

  Version:          1.1
  Author:           Julio Jimenez Delgado (jouleSoft)
  Creation Date:    19/05/2020
  Change:           Test-TCP function.
                    \_ Variable '$BeginConnect' removed.
                    \_ Used 'Out-Null' instead for avoid an output.
  
.EXAMPLE
  Test-Ports.ps1 -ComputerName 172.16.0.20

.EXAMPLE
  Test-Ports.ps1 -ComputerName $(Get-Content .\List.txt)

.LINK
  https://github.com/jouleSoft/Test-Ports.ps1

.LINK  
  https://stackoverflow.com/questions/9566052/how-to-check-network-port-access-and-display-useful-message

.LINK
  https://9to5it.com/using-psobject-store-data-powershell/

.LINK
  https://stackoverflow.com/questions/2731868/powershell-align-right-for-a-column-value-from-select-object-in-format-table-fo

.LINK
  https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_hash_tables?view=powershell-7
#>

#---------------------------------------------------------[Initializations]--------------------------------------------------------

#Script parameters
Param(
  [Parameter(Mandatory=$True, Position=0, HelpMessage="Enter target hostname or IP address")]
  [String[]]$ComputerName
)

#Set error action to 'SilentlyContinue'
$ErrorActionPreference = "SilentlyContinue"

#Dot Source required Function Libraries (<github_repo>/pwsh_functions)
#. "C:\Scripts\Functions\Logging_Functions.ps1"

#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Script title, version, description and license
$ScriptTitle        = "Test-Ports.ps1"
$ScriptVersion      = "1.1"
$ScriptDescription  = "Pre-Settle TCP ports monitoring tool"
$ScriptLicense      = "MIT"

#-----------------------------------------------------------[Functions]------------------------------------------------------------
<#
Function <FunctionName>{
  Param()
  
  Begin{
    Log-Write -LogPath $sLogFile -LineValue "<description of what is going on>..."
  }
  
  Process{
    Try{
      <code goes here>
    }
    
    Catch{
      Log-Error -LogPath $sLogFile -ErrorDesc $_.Exception -ExitGracefully $True
      Break
    }
  }
  
  End{
    If($?){
      Log-Write -LogPath $sLogFile -LineValue "Completed Successfully."
      Log-Write -LogPath $sLogFile -LineValue " "
    }
  }
}
#>

function Get-ScriptHeader {
    <#
    .SYNOPSIS
      Print header lines

    .DESCRIPTION
      For script use. Print the first script lines indicating title, version, description and license.

    .PARAMETER Title
      Mandatory. Script title.

    .PARAMETER Version
      Mandatory. Script version

    .PARAMETER Description
      Mandatory. Script description

    .PARAMETER Version
      Mandatory. Script license. Set to $Null for no license.

    .INPUTS
      Paramaters above

    .OUTPUTS
      String

    .NOTES
      Version:          1.0
      Author:           Julio Jimenez Delgado (jouleSoft)
      Creation Date:    14/05/2020
      Change:           Written
    #>

    [CmdletBinding()]

    Param(
        [Parameter(Mandatory=$True, Position=0)]
        [String]$Title, 
        [Parameter(Mandatory=$True, Position=1)]
        [String]$Version,
        [Parameter(Mandatory=$True, Position=2)]
        [String]$Description,
        [Parameter(Mandatory=$False, Position=3)]
        [String]$License
    )

    Process{
        Write-Host "$Title v."			-ForegroundColor Gray	-noNewLine
        Write-Host $Version					-ForegroundColor Yellow	-noNewLine
        Write-Host " - $Description" 	-ForegroundColor Gray -NoNewline
        
        if($License -ne $Null){
            Write-Host " ($License)" -ForegroundColor Gray
        }
    }
}

function Test-TCP {
    <#
    .SYNOPSIS
      TCP port checker

    .DESCRIPTION
      TCP port test tool which returns True/False

    .PARAMETER ComputerName
      Mandatory. Target hostname or IP address

    .PARAMETER Port
      Port to check. 3389 TCP (RDP) is setted by default

    .PARAMETER TimeOut
      Timeout in milliseconds. 100 ms. by default.

    .INPUTS
      Parameters above

    .OUTPUTS
      Boolean (True/False)

    .NOTES
      Version:          1.0
      Author:           Julio Jimenez Delgado (jouleSoft)
      Creation Date:    14/05/2020
      Change:           Written

      Version:          1.1
      Author:           Julio Jimenez Delgado (jouleSoft)
      Creation Date:    19/05/2020
      Change:           Variable '$BeginConnect' removed.
                        Used 'Out-Null' instead for avoid an output.

    .Link
      https://stackoverflow.com/questions/9566052/how-to-check-network-port-access-and-display-useful-message
    #>

    [CmdletBinding()]

    Param(
        [Parameter(Mandatory=$True, Position=0, HelpMessage="Enter hostname or target IP address")]
        [String[]]$ComputerName,
        [Parameter(Mandatory=$False, Position=1)]
        [String]$Port = 3389,
        [Parameter(Mandatory=$False, Position=2)]
        [String]$TimeOut=100
    )

    Process{
        $RequestCallback = $State = $Null
        $Client = New-Object System.Net.Sockets.TcpClient

        #Output is avoided
        $Client.BeginConnect($ComputerName,$Port,$RequestCallback,$State)|Out-Null

        #Stop the iterative test at 100 ms. 
        Start-Sleep -Milliseconds $TimeOut

        if ($Client.Connected){ 
            $Open = $true 
        }else{
            $Open = $false
        }

        $Client.Close()

        Return $Open
    }
}

function Test-Ports {
    <#
    .SYNOPSIS
      Pre-settled TCP ports checking

    .DESCRIPTION
      TCP ports monitoring function which shows a table by hostname/IP.

    .PARAMETER ComputerName
      Mandatory. Target hostname or IP address. Allows input from pipeline for iteration.

    .PARAMETER TimeOut
      Timeout in milliseconds. 100 ms. by default.

    .INPUTS
      Parameters above

    .OUTPUTS
      Table of results (Object)

    .NOTES
      Version:          1.0
      Author:           Julio Jimenez Delgado
      Creation Date:    14/05/2020
      Change:           Written

    .LINK
      https://9to5it.com/using-psobject-store-data-powershell/
    
    .LINK
      https://stackoverflow.com/questions/2731868/powershell-align-right-for-a-column-value-from-select-object-in-format-table-fo

    .LINK
      https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_hash_tables?view=powershell-7
    #>

    [CmdletBinding()]
    
    Param(
        [Parameter(Mandatory=$True, Position=0, ValueFromPipeline=$True)]
        [String[]]$ComputerName,
        [Parameter(Mandatory=$False, Position=1)]
        [String]$TimeOut = 100
    )

    Begin {
        $Result         = @()   # Results array

        [String[]]$Port = @(    # Ports array           
            80
            3389
            5985
            5900
        )
        
        $HashTable = @(
                        @{Label='Host/IP';    Expression={$_.Host};   Alignment='left'}
                        @{Label="RDP";        Expression={$_."3389"}; Alignment='Center'}
                        @{Label="WinRM";      Expression={$_."5985"}; Alignment='Center'}
                        @{Label="VNC";        Expression={$_."5900"}; Alignment='Center'}
                        @{Label="HTTP";       Expression={$_."80"};   Alignment='Center'}
                      )
            
    }

    Process {
        $Object = New-Object psobject 
        $Object | Add-Member NoteProperty Host -Value $ComputerName

        ForEach ($p in $Port){ # Checking each port in $Port

            Write-Progress "$ComputerName : $p $(Test-TCP -ComputerName $ComputerName -Port $p)" -Status "Checking ports"

            if(Test-TCP -ComputerName $ComputerName -Port $p -TimeOut $TimeOut){

                $Object | Add-Member NoteProperty $p -Value "OK"
            }else{
                $Object | Add-Member NoteProperty $p -Value "!"
            }

        }
        
        $Result += $Object
    }

    End {
        if($?){ 
            $Result|Format-Table -AutoSize -Property $HashTable|Write-Output
        }
    }
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

#Show script header
Get-ScriptHeader -Title $ScriptTitle -Version $ScriptVersion -Description $ScriptDescription -License $ScriptLicense

#Operations
$ComputerName | Test-Ports

#----------------------------------------------------------[Finalization]-----------------------------------------------------------

Remove-Variable ScriptTitle
Remove-Variable ScriptVersion
Remove-Variable ScriptDescription
Remove-Variable ScriptLicense
