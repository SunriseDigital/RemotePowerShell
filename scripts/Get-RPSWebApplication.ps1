function Get-RPSWebApplication{
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$false,ValueFromPipeline=$true)]
    [RPS.Server]$Server,

    [parameter(Mandatory=$false,ValueFromPipeline=$true)]
    [RPS.Website]$Site
  )
  PROCESS {
    if($Server -eq $null){
      $Server = $Site.Server
    }

    if($Server -eq $null){
      throw new Exception("Missing Server data.")
    }

    $cred = Create-RPSCredential $Server
    Invoke-Command -ComputerName $Server.Address -Credential $cred -ScriptBlock {
      $Site = $args[0]
      if($Site -eq $null){
        return Get-WebApplication
      } else {
        $command = "Get-WebApplication -Site ""$($Site.name)"""
        return Invoke-Expression -Command $command
      }
    } -argumentlist $Site.Value | %{
      return new-object RPS.WebApplication $Server, $_, "$($Site.name) $($_.path)"
    }
  }
}
