<#
.Synopsis
  Get-NetFirewallAddressFilter
.Parameter Server
  Target server
.Parameter Rule
  Target firewall rule. Standard output of Get-RPSNetFirewallRule.
.EXAMPLE
  Get-RPSServer test | Get-RPSNetFirewallAddressFilter
.EXAMPLE
  Get-RPSServer test | Get-RPSNetFirewallRule | Get-RPSNetFirewallAddressFilter
#>
function Get-RPSNetFirewallAddressFilter{
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$false,ValueFromPipeline=$true)]
    [RPS.Server]$Server,

    [parameter(Mandatory=$false,ValueFromPipeline=$true)]
    [RPS.FirewallRule]$Rule
  )
  PROCESS {
    if($Server -eq $null){
      $Server = $Rule.Server
    }

    if($Server -eq $null){
      throw new Exception("Missing Server data.")
    }

    $Pipe = $null
    if($Rule -ne $null){
      $Pipe = $Rule.Value
    }

    $cred = Create-RPSCredential $Server
    Invoke-Command -ComputerName $Server.Address -Credential $cred -ScriptBlock {
      $Pipe = $args[0]
      if($Pipe -eq $null){
        Get-NetFirewallAddressFilter
      } else {
        $Pipe | Get-NetFirewallAddressFilter
      }
    } -argumentlist $Pipe | %{
      return new-object RPS.FirewallAddressFilter $Server, $_, "{Local: $($_.LocalIP)} {Remote: $($_.RemoteIP)}"
    }
  }
}
