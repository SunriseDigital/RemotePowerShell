<#
.Synopsis
  Enter remote PowerShell session.
.Parameter Server
  Target server
.EXAMPLE
  Get-RPSServer test | Enter-RPSSession
#>
function Enter-RPSSession{
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
