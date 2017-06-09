function Get-RPSWebAppPool{
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [RPS.Server]$Server
  )
  PROCESS {
    $cred = Create-RPSCredential $Server
    Invoke-Command -ComputerName $Server.Address -Credential $cred -ScriptBlock {
      Get-WebApplication | Group-Object applicationPool | %{ @{Name = $_.Name; State = Get-WebAppPoolState -Name $_.name} }
    } | %{
      return new-object RPS.Result $Server, $_.State, $_.Name
    }
  }
}
