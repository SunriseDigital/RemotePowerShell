function Set-RPSNetFirewallRule{
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [RPS.FirewallRule]$Rule,

    [parameter(ValueFromRemainingArguments=$true)]
    $AllArgs
  )
  PROCESS {
    $cred = Create-RPSCredential $Rule.Server
    Invoke-Command -ComputerName $Rule.Server.Address -Credential $cred -ScriptBlock {
      $Rule = $args[0]
      $AllArgs = $args[1]

      $command = "Set-NetFirewallRule -Name ""$($Rule.Name)"""

      for ($i = 0; $i -lt $AllArgs.count; $i+=2){
        $key = $AllArgs[$i]
        $value = $AllArgs[$i+1]
        if($value -is [System.Collections.ArrayList]){
          $value = $value | %{"""${_}"""}
          $value = $($value -join ",")
        } else {
          $value = $value | %{"""${value}"""}
        }

        $command += " ${key} ${value}"
      }

      Write-Host $command
      Invoke-Expression -Command $command

    } -argumentlist $Rule.Value, $AllArgs
  }
}
