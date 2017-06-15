<#
.Synopsis
  Enumerate servers set to `include \ servers.ps1`. If you pass the target server from this cmdlet to another cmdlet with a pipe, it will execute the processing on that server.
.Parameter Name
  Filter by name.
.Parameter Address
  Filter by address.
.Parameter RegexName
  Filter by name. You can use regular expression
.Parameter RegexAddress
  Filter by address. You can use regular expression
.EXAMPLE
  Get-RPSServer
  Display a list of servers set to `include\servers.ps1`.
.EXAMPLE
  Get-RPSServer test | Enter-RPSSession
  Open the remote PowerShell session of the target server.
#>
function Get-RPSServer {
  [CmdletBinding()]
  param (
      [parameter(Mandatory=$false,Position=0)]
      [string]$Name,

      [parameter(Mandatory=$false)]
      [string]$Address,

      [parameter(Mandatory=$false)]
      [string]$RegexName,

      [parameter(Mandatory=$false)]
      [string]$RegexAddress
  )
  PROCESS {
    . "$PSScriptRoot\\include\\servers.ps1"

    return $servers `
      | ?{ if($Name -eq "") { $True } else  { $_.Name -like $Name } } `
      | ?{ if($Address -eq "") { $True } else { $_.Address -like $Address } } `
      | ?{ if($RegexName -eq "") { $True } else  { $_.Name -match $RegexName } } `
      | ?{ if($RegexAddress -eq "") { $True } else { $_.Address -match $RegexAddress } }
  }
}
