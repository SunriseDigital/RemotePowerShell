function Get-RPSWebsite{
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [RPS.Server]$Server,

    [parameter(Mandatory=$false,Position=0)]
    [string]$Name
  )
  PROCESS {
    $cred = Create-Credential $Server
    Invoke-Command -ComputerName $Server.Address -Credential $cred -ScriptBlock {
      $Server = $args[0]
      $Name = $args[1]

      $command = "Get-Website"

      if($Name -ne ""){
        $command += " -Name $Name"
      }

      Invoke-Expression -Command $command
    } -argumentlist $Server, $Name | %{
      return new-object RPS.Result $Server, $_
    }
  }
}
