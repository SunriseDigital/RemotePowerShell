<#
.Synopsis
  Remove-NetFirewallRule
.Parameter Server
  Target server
.EXAMPLE
  Get-RPSServer test | Get-RPSNetFirewallRule　{$_.LocalPort -eq 123} | Remove-NetFirewallRule
#>
function Remove-RPSNetFirewallRule{
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [RPS.FirewallRule]$Rule
  )
  PROCESS {
    $cred = Create-RPSCredential $Rule.Server
    Invoke-Command -ComputerName $Rule.Server.Address -Credential $cred -ScriptBlock {
      $Rule = $args[0]

      $command = "Remove-NetFirewallRule -Name ""$($Rule.Name)"""

      Write-Host $command
      Invoke-Expression -Command $command

    } -argumentlist $Rule.Value
  }
}
