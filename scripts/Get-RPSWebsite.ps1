function Get-RPSWebsite{
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [RPS.Server]$Server,

    [parameter(Mandatory=$false,Position=0)]
    [string]$Name
  )
  PROCESS {
    $cred = Create-RPSCredential $Server
    Invoke-Command -ComputerName $Server.Address -Credential $cred -ScriptBlock {
      $Name = $args[0]

      $command = "Get-Website"

      if($Name -ne ""){
        $command += " -Name ""$Name"""
      }

      Invoke-Expression -Command $command
    } -argumentlist $Name | %{
      return new-object RPS.Result $Server, $_, $_.name
    }
  }
}
