function Get-RPSNetFirewallPortFilter{
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [RPS.Server]$Server
  )
  PROCESS {
    $cred = Create-RPSCredential $Server
    Invoke-Command -ComputerName $Server.Address -Credential $cred -ScriptBlock {
      Get-NetFirewallPortFilter
    } | %{
      return new-object RPS.FirewallPortFilter $Server, $_, "$($_.Protocol) $($_.LocalPort)"
    }
  }
}
