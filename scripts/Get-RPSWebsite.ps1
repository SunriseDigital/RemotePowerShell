function Get-RPSWebsite{
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [RPS.Server]$Server
  )
  PROCESS {
    $cred = Create-RPSCredential $Server
    Invoke-Command -ComputerName $Server.Address -Credential $cred -ScriptBlock {
      Get-Website
    }  | %{
      return new-object RPS.Website $Server, $_, $_.name
    }
  }
}
