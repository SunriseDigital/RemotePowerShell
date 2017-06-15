<#
.Synopsis
  Get-NetNetFirewallRule
.Parameter Server
  Target server
.Parameter PortFilter
  Port filter.
.Parameter ApplicationFilter
  Application filter.
.EXAMPLE
  Get-RPSServer test | Get-RPSNetFirewallRule
.EXAMPLE
  Get-RPSServer test | Get-RPSNetFirewallRule {$_.LocalPort -eq 123}
.EXAMPLE
  Get-RPSServer test | Get-RPSNetFirewallRule -ApplicationFilter {$_.Program -like "*jenkins*"}
#>
function Get-RPSNetFirewallRule{
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [RPS.Server]$Server,

    [parameter(Mandatory=$false,Position=0)]
    [Scriptblock]$PortFilter,

    [parameter(Mandatory=$false)]
    [Scriptblock]$ApplicationFilter
  )
  PROCESS {
    $cred = Create-RPSCredential $Server
    Invoke-Command -ComputerName $Server.Address -Credential $cred -ScriptBlock {
      if($args[0] -ne $null){
        $PortFilter = [Scriptblock]::Create($args[0])
        Get-NetFirewallPortFilter | ? {$PortFilter.Invoke($_)} | Get-NetFirewallRule
      } elseif($args[1] -ne $null){
        $ApplicationFilter = [Scriptblock]::Create($args[1])
        Get-NetFirewallApplicationFilter | ? {$ApplicationFilter.Invoke($_)} | Get-NetFirewallRule
      }

    } -argumentlist $PortFilter, $ApplicationFilter | %{
      return new-object RPS.FirewallRule $Server, $_, "$($_.DisplayName)"
    }
  }
}
