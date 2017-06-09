function Restart-RPSWebAppPool{
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [RPS.Result] $Result,

    [parameter(Mandatory=$false,Position=0)]
    [string]$Name
  )
  PROCESS {
    $cred = Create-RPSCredential $Result.Server
    Invoke-Command -ComputerName $Result.Server.Address -Credential $cred -ScriptBlock {
      $name = $args[0]
      $serverName = $args[1]
      
      Restart-WebAppPool -Name $name
      Write-Host "Restarted application pool ${name} on ${serverName}"
    } -argumentlist $Result.Name, $Result.Server.Name
  }
}
