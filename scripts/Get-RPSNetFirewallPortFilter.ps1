function Get-RPSNetFirewallPortFilter{
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
        Get-NetFirewallPortFilter
      } else {
        $Pipe | Get-NetFirewallPortFilter
      }
    } -argumentlist $Pipe | %{
      return new-object RPS.FirewallPortFilter $Server, $_, "$($_.Protocol) $($_.LocalPort)"
    }
  }
}