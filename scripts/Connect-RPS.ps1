function Connect-RPS{
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [RPS.Server]$Server
  )
  PROCESS {
    # Connect to server
    Write-Host "Connect to $($Server.Address) [$($Server.Name)]"
    $cred = Create-RPSCredential $Server
    Enter-PSSession -ComputerName $Server.Address -Credential $cred
  }
}
