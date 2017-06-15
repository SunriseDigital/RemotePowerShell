<#
.Synopsis
  Get Web application pool.
.Parameter Server
  Target server
.EXAMPLE
  Get-RPSServer test | Get-RPSWebAppPool
#>
function Get-RPSWebAppPool{
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [RPS.Server]$Server
  )
  PROCESS {
    $cred = Create-RPSCredential $Server
    Invoke-Command -ComputerName $Server.Address -Credential $cred -ScriptBlock {
      Get-WebApplication | Group-Object applicationPool | %{ @{Name = $_.Name; State = Get-WebAppPoolState -Name $_.name} }
    } | %{
      return new-object RPS.WebAppPool $Server, $_.State, $_.Name
    }
  }
}
