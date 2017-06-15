<#
.Synopsis
  Get-WebApplication
.Parameter Server
  Target server
.Parameter Site
  Target site. Standard output of Get-RPSWebsite.
.EXAMPLE
  Get-RPSServer test | Get-RPSWebApplication
.EXAMPLE
  Get-RPSServer test | Get-RPSWebSite | Get-RPSWebApplication
#>
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
        Get-WebApplication
      } else {
        Invoke-Expression -Command "Get-WebApplication -Site ""$($Site.name)"""
      }
    } -argumentlist $Site.Value | %{
      return new-object RPS.WebApplication $Server, $_, "$($Site.name) $($_.path)"
    }
  }
}
