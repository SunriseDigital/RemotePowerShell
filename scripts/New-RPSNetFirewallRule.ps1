function New-RPSNetFirewallRule{
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [RPS.Server]$Server,

    [parameter(ValueFromRemainingArguments=$true)]
    [object]$Arguments
  )
  PROCESS {
    $StrArguments = Build-RPSArguments $Arguments
    $cred = Create-RPSCredential $Server
    Invoke-Command -ComputerName $Server.Address -Credential $cred -ScriptBlock {
      $StrArguments = $args[0]
      $command = "New-NetFirewallRule${StrArguments}"
      Write-Host $command
      Invoke-Expression -Command $command
    } -argumentlist $StrArguments
  }
}
