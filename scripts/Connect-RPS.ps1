function Connect-RPS{
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [RPSServer]$Server
  )
  PROCESS {
    # Connect to server
    Write-Host "Connect to $($Server.Address) [$($Server.Name)]"
    $cred = Create-Credential $Server
    Enter-PSSession -ComputerName $Server.Address -Credential $cred
  }
}
