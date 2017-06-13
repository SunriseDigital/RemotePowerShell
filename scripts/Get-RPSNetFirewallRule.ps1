function Get-RPSNetFirewallRule{
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$false,ValueFromPipeline=$true)]
    [RPS.Server]$Server,

    [parameter(Mandatory=$false,ValueFromPipeline=$true)]
    [RPS.FirewallPortFilter]$Port
  )
  PROCESS {
    if($Server -eq $null){
      $Server = $Port.Server
    }

    if($Server -eq $null){
      throw new Exception("Missing Server data.")
    }

    $cred = Create-RPSCredential $Server
    Invoke-Command -ComputerName $Server.Address -Credential $cred -ScriptBlock {
      $Port = $args[0]
      if($Port -eq $null){
        Get-NetFirewallRule
      } else {
        $Port | Get-NetFirewallRule
      }
    } -argumentlist $Port.Value | %{
      return new-object RPS.FirewallRule $Server, $_, "$($_.DisplayName)"
    }
  }
}
