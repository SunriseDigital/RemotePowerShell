function Get-RPSNetFirewallRule{
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [RPS.Server]$Server,

    [parameter(Mandatory=$false,Position=0)]
    [Scriptblock]$PortFilter
  )
  PROCESS {
    $cred = Create-RPSCredential $Server
    Invoke-Command -ComputerName $Server.Address -Credential $cred -ScriptBlock {
      $PortFilter = {$true}
      if($args[0] -ne $null){
        $PortFilter = [Scriptblock]::Create($args[0])
      }

      Get-NetFirewallPortFilter | ? {$PortFilter.Invoke($_)} | Get-NetFirewallRule

    } -argumentlist $PortFilter | %{
      return new-object RPS.FirewallRule $Server, $_, "$($_.DisplayName)"
    }
  }
}
