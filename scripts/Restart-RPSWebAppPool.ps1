<#
.Synopsis
  Restart-RPSWebAppPool
.Parameter WebAppPool
  Target web application pool. Standard output of Get-RPSWebAppPool.
.EXAMPLE
  Get-RPSServer test | Get-Website
#>
function Restart-RPSWebAppPool{
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [RPS.WebAppPool] $WebAppPool
  )
  PROCESS {
    $cred = Create-RPSCredential $WebAppPool.Server
    Invoke-Command -ComputerName $WebAppPool.Server.Address -Credential $cred -ScriptBlock {
      $name = $args[0]
      $serverName = $args[1]

      Restart-WebAppPool -Name $name
      Write-Host "Restarted application pool ${name} on ${serverName}"
    } -argumentlist $WebAppPool.Name, $WebAppPool.Server.Name
  }
}
