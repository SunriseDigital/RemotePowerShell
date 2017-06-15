function Set-RPSNetFirewallRule{
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [RPS.FirewallRule]$Rule,

    [parameter(ValueFromRemainingArguments=$true)]
    [object[]]$Arguments
  )
  PROCESS {
    $StrArguments = Build-RPSArguments $Arguments
    $cred = Create-RPSCredential $Rule.Server
    Invoke-Command -ComputerName $Rule.Server.Address -Credential $cred -ScriptBlock {
      $Rule = $args[0]
      $StrArguments = $args[1]

      $command = "Set-NetFirewallRule -Name ""$($Rule.Name)""${StrArguments}"

      Write-Host $command
      Invoke-Expression -Command $command

    } -argumentlist $Rule.Value, $StrArguments
  }
}
