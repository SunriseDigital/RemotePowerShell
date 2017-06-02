function Get-RPSServer {
  [CmdletBinding()]
  param (
      [parameter(Mandatory=$false,Position=0)]
      [string]$Name,

      [parameter(Mandatory=$false)]
      [string]$Address,

      [switch]$Regex
  )
  PROCESS {
    . "$PSScriptRoot\\include\\servers.ps1"

    return $servers `
      | ?{ if($Name -eq "") { $True } else { if( $Regex ) { $_.Name -match $Name } else { $_.Name -like $Name } } } `
      | ?{ if($Address -eq "") { $True } else { if( $Regex ) { $_.Address -match $Address } else { $_.Address -like $Address } } }
  }
}
